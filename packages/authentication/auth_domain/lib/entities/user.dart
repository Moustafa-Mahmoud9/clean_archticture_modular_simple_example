import 'dart:convert';

import 'package:core/core_package.dart';
/// Top-level login API response — wraps status, message, data, and errors.
class LoginResponseEntity {
  final bool? status;
  final String? msg;
  final UserData? data;
  final List<dynamic>? errors;

  LoginResponseEntity({
    required this.status,
    required this.msg,
    required this.data,
    required this.errors,
  });

  Map<String, dynamic> toJson() => {
    'status': status,
    'msg': msg,
    'data': data?.toJson(),
    'errors':
    errors == null ? [] : List<dynamic>.from(errors!.map((x) => x)),
  };
}

/// The `data` object inside [LoginResponseEntity].
class UserData {
  final UserEntity? user;
  final String? token;
  final int? unreadCount;
  final int? unreadAdvertisements;

  UserData({
    required this.user,
    required this.token,
    required this.unreadAdvertisements,
    required this.unreadCount,
  });

  Map<String, dynamic> toJson() => {
    'user': user?.toJson(),
    'token': token,
    'unread_count': unreadCount,
    'unread_advertisements': unreadAdvertisements,
  };

  // Fixed: encode the instance, not the class type
  String toEncodedString() => json.encode(toJson());
}

class UserEntity extends Equatable {
  final String? id;
  final dynamic qrLink;
  final dynamic dataSerialized;
  final String? firstName;
  final String? secondName;
  final String? thirdName;
  final String? lastName;
  final String? countryId;
  final dynamic email;
  String? phone;
  final String? ssn;
  final String? parentId;
  final String? userToken;
  final String? subscriptionDuration;
  final dynamic subscriptionEndAt;
  final String? subscriptionType;
  final String? endFreeSubscription;
  final String? platform;
  final String? passportNumber;
  final String? repassportNumber;
  final String? plPassportNumber;
  final String? idSsn;
  final String? deviceToken;
  final int? nationalityId;
  final int? cityId;
  final String? ssnFile;
  final String? isActive;
  final String? isBlock;
  final dynamic readAt;
  final String? ssnFileBack;
  final dynamic feshPhone;
  final dynamic paidAt;
  final dynamic mobileUuid;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;
  final dynamic cronjob;
  final String? smsAuthType;
  final bool? isPaid;
  final String? name;
  final String? ssnFilePath;
  final String? ssnFileBackPath;
  final bool? isEndFirstTime;
  final bool? isPaymentRequired;
  final bool? isPaymentVisible;
  final UserEntity? parent;
  final List<UserEntity>? children;
  String? password;
  final Reset? reset;
  final String? relationShip;
  final String? gender;

  UserEntity({
    this.id,
    this.countryId,
    this.qrLink,
    this.dataSerialized,
    this.firstName,
    this.gender,
    this.relationShip,
    this.secondName,
    this.thirdName,
    this.lastName,
    this.email,
    this.phone,
    this.ssn,
    this.parentId,
    this.userToken,
    this.subscriptionDuration,
    this.subscriptionEndAt,
    this.subscriptionType,
    this.endFreeSubscription,
    this.platform,
    this.repassportNumber,
    this.passportNumber,
    this.plPassportNumber,
    this.idSsn,
    this.deviceToken,
    this.ssnFile,
    this.isActive,
    this.isBlock,
    this.readAt,
    this.ssnFileBack,
    this.feshPhone,
    this.paidAt,
    this.nationalityId,
    this.cityId,
    this.mobileUuid,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.cronjob,
    this.smsAuthType,
    this.isPaid,
    this.name,
    this.ssnFilePath,
    this.ssnFileBackPath,
    this.isEndFirstTime,
    this.isPaymentRequired,
    this.isPaymentVisible,
    this.parent,
    this.children,
    this.password,
    this.reset,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'country_id': countryId,
    'qr_link': qrLink,
    'data_serialized': dataSerialized,
    'first_name': firstName,
    'second_name': secondName,
    'third_name': thirdName,
    'last_name': lastName,
    'email': email,
    'phone': phone,
    'ssn': ssn,
    'parent_id': parentId,
    'gender': gender,
    'relation_ship': relationShip,
    'nationality_id': nationalityId,
    'city_id': cityId,
    'token': userToken,
    'subscription_duration': subscriptionDuration,
    'subscription_end_at': subscriptionEndAt,
    'subscription_type': subscriptionType,
    'end_free_subscription': endFreeSubscription,
    'passport_number': passportNumber,
    'platform': platform,
    'repassport_number': repassportNumber,
    'pl_passport_number': plPassportNumber,
    'id_ssn': idSsn,
    'device_token': deviceToken,
    'ssn_file': ssnFile,
    'is_active': isActive,
    'is_block': isBlock,
    'read_at': readAt,
    'ssn_file_back': ssnFileBack,
    'fesh_phone': feshPhone,
    'paid_at': paidAt,
    'mobile_uuid': mobileUuid,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
    'deleted_at': deletedAt,
    'cronjob': cronjob,
    'sms_auth_type': smsAuthType,
    'is_paid': isPaid,
    'name': name,
    'ssn_file_path': ssnFilePath,
    'ssn_file_back_path': ssnFileBackPath,
    'is_end_first_time': isEndFirstTime,
    'is_payment_required': isPaymentRequired,
    'is_payment_visible': isPaymentVisible,
    'parent': parent?.toJson(),
    'password': password ?? '',
    'children': children == null
        ? []
        : List<dynamic>.from(children!.map((x) => x.toJson())),
    'reset': reset?.toJson(),
  };

  @override
  List<Object?> get props => [id, name, userToken];
}

class Reset {
  final String? id;
  final String? identifier;
  final String? attemptedAt;
  final int? attempCount;
  final String? createdAt;
  final String? updatedAt;

  Reset({
    required this.id,
    required this.identifier,
    required this.attemptedAt,
    required this.attempCount,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'identifier': identifier,
    'attempted_at': attemptedAt,
    'attemp_count': attempCount,
    'created_at': createdAt,
    'updated_at': updatedAt,
  };
}