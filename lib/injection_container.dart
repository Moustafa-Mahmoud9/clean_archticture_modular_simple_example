import 'dart:io';

import 'package:auth_data/auth_data.dart';
import 'package:auth_domain/auth_domain.dart';
import 'package:auth_presentation/auth_presentation.dart';
import 'package:core/core_package.dart';
import 'package:core_implementation/core_implementation.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile_device_identifier/mobile_device_identifier.dart';

import 'config/app_env.dart';
import 'config/flavor_config.dart';
import 'location_service.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // 1. Storage
  sl.registerLazySingleton<StorageService>(
    () => SecureStorageService.defaultInstance(),
  );

  // 2. Network connectivity
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl.defaultInstance(),
  );

  // 3. Location — fire-and-forget
  sl.registerLazySingleton(() => LocationService());
  sl<LocationService>().initialize();

  // 4. Environment — build-mode switched

  sl.registerLazySingleton<ApiEnvironment>(() {
    final commonHeaders = {'Accept-Language': 'ar'};

    switch (FlavorSetup.current) {
      case AppFlavor.development:
        return DevelopmentEnvironment(
          baseUrl: AppEnv.baseUrl,
          headers: commonHeaders,
        );

      case AppFlavor.staging:
        return StagingEnvironment(
          baseUrl: AppEnv.baseUrl,
          headers: commonHeaders,
        );

      case AppFlavor.production:
        return ProductionEnvironment(
          baseUrl: AppEnv.baseUrl,
          headers: commonHeaders,
        );
    }
  });

  // 5. Token provider — registered under both types so AuthLocalDataSource
  //    can reach saveAccessToken() while DioClient only sees TokenProvider.
  sl.registerLazySingleton<AppTokenProvider>(() {
    // Dedicated plain Dio just for the refresh call.
    // NO interceptors, NO DioClient wrapper → no chance of recursive 401s.
    final refreshDio = Dio(BaseOptions(baseUrl: sl<ApiEnvironment>().baseUrl));

    return AppTokenProvider(
      storage: sl<StorageService>(),
      refreshCall: (refreshToken) async {
        final response = await refreshDio.post<Map<String, dynamic>>(
          '/front-user/refresh',
          data: {'refresh_token': refreshToken},
        );
        return response.data ?? const {};
      },
    );
  });

  sl.registerLazySingleton<TokenProvider>(() => sl<AppTokenProvider>());

  // 6. ApiClient — one Dio, shared across features
  sl.registerLazySingleton<ApiClient>(
    () => DioClient(
      environment: sl<ApiEnvironment>(),
      tokenProvider: sl<TokenProvider>(),
      additionalInterceptors: [
        DeviceMetadataInterceptor(
          getLanguage: () => sl<StorageService>().read(key: 'lang'),
          getDeviceId: () async {
            final uuid = await MobileDeviceIdentifier().getDeviceId();
            if (uuid == null) return null;
            return '${Platform.isIOS ? 'IOS' : 'ANDROID'}-$uuid';
          },
          getLocation: () => sl<LocationService>().getLocation(),
        ),
      ],
    ),
  );

  _initAuth();
}

void _initAuth() {
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(
      storage: sl<StorageService>(),
      tokenProvider: sl<AppTokenProvider>(),
    ),
  );

  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(client: sl<ApiClient>()),
  );

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  sl.registerLazySingleton(() => LoginUser(sl()));
  sl.registerLazySingleton(() => RegisterUser(sl()));
  sl.registerLazySingleton(() => LogoutUser(sl()));
  sl.registerLazySingleton(() => GetCurrentUser(sl()));

  sl.registerFactory(
    () => AuthCubit(
      loginUser: sl(),
      registerUser: sl(),
      logoutUser: sl(),
      getCurrentUser: sl(),
    ),
  );
}
