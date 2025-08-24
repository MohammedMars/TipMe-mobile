import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tipme_app/dtos/completeProfileDto.dart';

class ProfileSetupProvider extends ChangeNotifier {
  String? genderString;
  String? firstName;
  String? surName;
  DateTime? birthdate;
  String? nationality;
  String? countryId;
  String? cityId;
  String? mobileNumber;
  int? gender;
  File? image;
  File? frontSideOfDocumentId;
  File? backSideOfDocumentId;

  // For Web (store bytes instead of File)
  Uint8List? frontSideOfDocumentIdBytes;
  Uint8List? backSideOfDocumentIdBytes;

  String? accountHolderName;
  String? iban;
  String? bankName;
  String? bankCountryId;

  /// Update one or multiple fields at once
  void update({
    String? genderString,
    String? firstName,
    String? surName,
    DateTime? birthdate,
    String? nationality,
    String? countryId,
    String? cityId,
    String? mobileNumber,
    int? gender,
    File? image,
    File? frontSideOfDocumentId,
    File? backSideOfDocumentId,
    Uint8List? frontSideOfDocumentIdBytes,
    Uint8List? backSideOfDocumentIdBytes,
    String? accountHolderName,
    String? iban,
    String? bankName,
    String? bankCountryId,
  }) {
    this.genderString = genderString ?? this.genderString;
    this.firstName = firstName ?? this.firstName;
    this.surName = surName ?? this.surName;
    this.birthdate = birthdate ?? this.birthdate;
    this.nationality = nationality ?? this.nationality;
    this.countryId = countryId ?? this.countryId;
    this.cityId = cityId ?? this.cityId;
    this.mobileNumber = mobileNumber ?? this.mobileNumber;
    this.gender = gender ?? this.gender;
    this.image = image ?? this.image;
    this.frontSideOfDocumentId = frontSideOfDocumentId ?? this.frontSideOfDocumentId;
    this.backSideOfDocumentId = backSideOfDocumentId ?? this.backSideOfDocumentId;
    this.frontSideOfDocumentIdBytes = frontSideOfDocumentIdBytes ?? this.frontSideOfDocumentIdBytes;
    this.backSideOfDocumentIdBytes = backSideOfDocumentIdBytes ?? this.backSideOfDocumentIdBytes;
    this.accountHolderName = accountHolderName ?? this.accountHolderName;
    this.iban = iban ?? this.iban;
    this.bankName = bankName ?? this.bankName;
    this.bankCountryId = bankCountryId ?? this.bankCountryId;

    notifyListeners();
  }

  void reset() {
    genderString = null;
    firstName = null;
    surName = null;
    birthdate = null;
    nationality = null;
    countryId = null;
    cityId = null;
    mobileNumber = null;
    gender = null;
    image = null;
    frontSideOfDocumentId = null;
    backSideOfDocumentId = null;
    frontSideOfDocumentIdBytes = null;
    backSideOfDocumentIdBytes = null;
    accountHolderName = null;
    iban = null;
    bankName = null;
    bankCountryId = null;

    notifyListeners();
  }

  bool isComplete() {
    return firstName != null &&
        surName != null &&
        birthdate != null &&
        mobileNumber != null &&
        (frontSideOfDocumentId != null || frontSideOfDocumentIdBytes != null) &&
        (backSideOfDocumentId != null || backSideOfDocumentIdBytes != null) &&
        iban != null &&
        accountHolderName != null;
  }
    
    FormData toFormData() {
    return FormData.fromMap({
      "FirstName": firstName,
      "SurName": surName,
      "Birthdate": birthdate?.toIso8601String(),
      "Nationality": nationality,
      "CountryId": countryId,
      "CityId": cityId,
      "MobileNumber": mobileNumber,
      "Gender": gender,
      "AccountHolderName": accountHolderName,
      "IBAN": iban,
      "BankName": bankName,
      "BankCountryId": bankCountryId,
      // Files
      if (image != null)
        "Image": MultipartFile.fromFileSync(
          image!.path,
          filename: image!.path.split('/').last,
        ),

      if (frontSideOfDocumentId != null)
        "FrontSideOfDocumentId": MultipartFile.fromFileSync(
          frontSideOfDocumentId!.path,
          filename: frontSideOfDocumentId!.path.split('/').last,
        ),

      if (backSideOfDocumentId != null)
        "BackSideOfDocumentId": MultipartFile.fromFileSync(
          backSideOfDocumentId!.path,
          filename: backSideOfDocumentId!.path.split('/').last,
        ),

      // For Web (bytes only)
      if (frontSideOfDocumentIdBytes != null)
        "FrontSideOfDocumentId": MultipartFile.fromBytes(
          frontSideOfDocumentIdBytes!,
          filename: "front_id.png",
        ),
      if (backSideOfDocumentIdBytes != null)
        "BackSideOfDocumentId": MultipartFile.fromBytes(
          backSideOfDocumentIdBytes!,
          filename: "back_id.png",
        ),
    });
  }
    
}




