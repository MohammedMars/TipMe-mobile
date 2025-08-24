import 'dart:io';
import 'dart:typed_data';

class GenerateQRCodeDto {
  final Uint8List? logo;
  final Uint8List? logoBytes;

  GenerateQRCodeDto({this.logo, this.logoBytes});

  Map<String, dynamic> toJson() => {
        'logo': logo,
        'logoBytes': logoBytes,
      };

  factory GenerateQRCodeDto.fromJson(Map<String, dynamic> json) {
    return GenerateQRCodeDto(
      logo: json['logo'],
      logoBytes: json['logoBytes'],
    );
  }
}
