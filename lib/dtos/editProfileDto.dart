import 'dart:io';

class EditProfileDto {
  final String firstName;
  final String surName;
  final String mobileNumber;
  final File image;

  EditProfileDto({
    required this.firstName,
    required this.surName,
    required this.mobileNumber,
    required this.image,
  });
}