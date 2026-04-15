import 'package:auth_domain/auth_domain.dart';

class LoginModel extends LoginResponseEntity {
  LoginModel({
    super.status,
    super.msg,
    super.data,
    super.errors,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        status: json["status"],
        msg: json["msg"],
        data: json["data"] == null ? null : DataModel.fromJson(json["data"]),
        errors: json["errors"] == null
            ? []
            : List<dynamic>.from(json["errors"]!.map((x) => x)),
      );
}

class DataModel extends UserData {
  DataModel({
    super.user,
    super.token,
    required super.unreadAdvertisements,
    required super.unreadCount,
  });

  factory DataModel.fromJson(Map<String, dynamic> json,
          {bool fromCache = false}) =>
      DataModel(
        user: json["user"] == null
            ? null
            : UserModel.fromJson(json["user"], fromCache: fromCache),
        token: json["token"],
        unreadAdvertisements: json['unread_advertisements'],
        unreadCount: json['unread_count'],
      );
}

class UserModel extends UserEntity {
  UserModel({
    super.id,
    super.countryId,
    super.qrLink,
    super.dataSerialized,
    super.firstName,
    super.secondName,
    super.thirdName,
    super.lastName,
    super.email,
    super.phone,
    super.ssn,
    super.parentId,
    super.userToken,
    super.subscriptionDuration,
    super.subscriptionEndAt,
    super.subscriptionType,
    super.endFreeSubscription,
    super.platform,
    super.repassportNumber,
    super.plPassportNumber,
    super.passportNumber,
    super.idSsn,
    super.deviceToken,
    super.ssnFile,
    super.isActive,
    super.isBlock,
    super.readAt,
    super.ssnFileBack,
    super.feshPhone,
    super.paidAt,
    super.mobileUuid,
    super.createdAt,
    super.updatedAt,
    super.deletedAt,
    super.cronjob,
    super.smsAuthType,
    super.isPaid,
    super.name,
    super.ssnFilePath,
    super.ssnFileBackPath,
    super.isEndFirstTime,
    super.isPaymentRequired,
    super.isPaymentVisible,
    super.parent,
    super.children,
    super.password,
    super.reset,
    super.cityId,
    super.nationalityId,
    super.gender,
    super.relationShip,
  });

  factory UserModel.fromJson(Map<String, dynamic> json,
      {required bool fromCache}) {
    return UserModel(
      id: json["id"].toString(),
      countryId:
          json["country_id"] == null ? "" : json["country_id"].toString(),
      password: (json['password'].runtimeType != Null ||
              json['password'].toString().isNotEmpty)
          ? fromCache
              ? json['password'].toString()
              : json['password']
          : null,
      qrLink: json["qr_link"],
      nationalityId: json["nationality_id"],
      cityId: json["city_id"],
      dataSerialized: json["data_serialized"],
      firstName: json["first_name"],
      secondName: json["second_name"],
      thirdName: json["third_name"],
      lastName: json["last_name"],
      email: json["email"],
      phone: '${json["phone"]}',
      ssn: json["ssn"].toString(),
      parentId: json["parent_id"].runtimeType != Null
          ? json["parent_id"].toString()
          : json["parent_id"].toString(),
      userToken: json["token"],
      gender: json["gender"],
      relationShip: json["relation_ship"],
      subscriptionDuration: json["subscription_duration"].toString(),
      subscriptionEndAt: json["subscription_end_at"],
      subscriptionType: json["subscription_type"],
      endFreeSubscription: json["end_free_subscription"].toString(),
      platform: json["platform"],
      passportNumber: json["passport_number"].runtimeType != int
          ? json["passport_number"]
          : '${json["passport_number"]}',
      repassportNumber: json["repassport_number"].runtimeType != int
          ? json["repassport_number"]
          : '${json["repassport_number"]}',
      plPassportNumber: json["pl_passport_number"].runtimeType != int
          ? json["pl_passport_number"]
          : '${json["pl_passport_number"]}',
      idSsn: json["id_ssn"].runtimeType != int
          ? json["id_ssn"]
          : '${json["id_ssn"]}',
      deviceToken: json["device_token"],
      ssnFile: json["ssn_file"],
      isActive: json["is_active"].toString(),
      isBlock: json["is_block"].toString(),
      readAt: json["read_at"],
      ssnFileBack: json["ssn_file_back"],
      feshPhone: json["fesh_phone"],
      paidAt: json["paid_at"],
      mobileUuid: json["mobile_uuid"],
      createdAt: json["created_at"] == null ? null : null,
      updatedAt: json["updated_at"] == null ? null : null,
      deletedAt: json["deleted_at"],
      cronjob: json["cronjob"],
      smsAuthType: json["sms_auth_type"],
      isPaid: json["is_paid"] ?? false,
      name: json["name"],
      ssnFilePath: json["ssn_file_path"],
      ssnFileBackPath: json["ssn_file_back_path"],
      isEndFirstTime: json["is_end_first_time"],
      isPaymentRequired: json["is_payment_required"],
      isPaymentVisible: json["is_payment_visible"],
      parent: json["parent"].runtimeType != Null
          ? UserModel.fromJson(json["parent"], fromCache: fromCache)
          : null,
      children: json["children"] == null
          ? []
          : List<UserEntity>.from(json["children"]!
              .map((x) => UserModel.fromJson(x, fromCache: fromCache))),
      reset: json["reset"] != null
          ? ResetModel.fromJson(json["reset"], fromCache: fromCache)
          : null,
    );
  }
}

class ResetModel extends Reset {
  ResetModel({
    super.id,
    super.identifier,
    super.attemptedAt,
    super.attempCount,
    super.createdAt,
    super.updatedAt,
  });

  factory ResetModel.fromJson(Map<String, dynamic> json,
      {required bool fromCache}) {
    return ResetModel(
      id: '${json['id']}',
      identifier: '${json['identifier']}',
      attemptedAt: '${json['attempted_at']}',
      attempCount: json['attemp_count'],
      createdAt: '${json['created_at']}',
      updatedAt: '${json['updated_at']}',
    );
  }
}
