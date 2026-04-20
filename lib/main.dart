// lib/main.dart
import 'package:auth_presentation/cubit/auth_cubit.dart';
import 'package:auth_presentation/cubit/auth_state.dart';
import 'package:auth_presentation/pages/home_page.dart';
import 'package:auth_presentation/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:core/core_package.dart';

import 'app_bloc_observer.dart';
import 'app_routes.dart';
import 'app_theme.dart';
import 'injection_container.dart' as di;

/// Shared bootstrap invoked by the three flavor-specific entry points:
/// [main_development.dart], [main_staging.dart], [main_production.dart].
///
/// Do not call this directly — go through one of those entry points so the
/// flavor is configured before DI wiring reads [AppEnv].
Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = AppBlocObserver();
  await di.initDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final showBanner =
        FlavorConfig.instance.variables['showBanner'] as bool? ?? false;

    final app = BlocProvider(
      create: (_) => di.sl<AuthCubit>()..checkAuthStatus(),
      child: MaterialApp(
        title: FlavorConfig.instance.name == 'production'
            ? 'My App'
            : 'My App (${FlavorConfig.instance.name})',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.light,
        onGenerateRoute: AppRoutes.generateRoute,
        home: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            final networkInfo = di.sl<NetworkInfo>();
            networkInfo.onConnectivityChanged.listen((isConnected) {
              if (!isConnected) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('You are offline!')),
                );
              }
            });
            if (state is AuthLoading || state is AuthInitial) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            } else if (state is AuthAuthenticated) {
              return const HomePage();
            } else {
              return const LoginPage();
            }
          },
        ),
      ),
    );

    return showBanner ? FlavorBanner(child: app) : app;
  }
}