import 'dart:io';
import 'dart:typed_data';

class CompleteProfileDto {
  final String firstName;
  final String surName;
  final String birthdate;
  final String nationality;
  final String countryId;
  final String cityId;
  final String mobileNumber;
  final int gender;
  final File image;
  final File frontSideOfDocumentId;
  final File backSideOfDocumentId;
  final Uint8List? frontSideOfDocumentIdBytes;
  final Uint8List? backSideOfDocumentIdBytes;
  final String accountHolderName;
  final String iban;
  final String bankName;
  final String bankCountryId;

  CompleteProfileDto({
    required this.firstName,
    required this.surName,
    required this.birthdate,
    required this.nationality,
    required this.countryId,
    required this.cityId,
    required this.mobileNumber,
    required this.gender,
    required this.image,
    required this.frontSideOfDocumentId,
    required this.backSideOfDocumentId,
    required this.frontSideOfDocumentIdBytes,
    required this.backSideOfDocumentIdBytes,
    required this.accountHolderName,
    required this.iban,
    required this.bankName,
    required this.bankCountryId,
  });  
}
