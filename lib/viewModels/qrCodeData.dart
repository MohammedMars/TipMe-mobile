class QRCodeData {
  final String tipReceiverId;
  final String? qrCodeBase64;
  final String? qrCodeLogoPath;
  final String? id;

  QRCodeData({
    required this.tipReceiverId,
    this.qrCodeBase64,
    this.qrCodeLogoPath,
    this.id,
  });

  factory QRCodeData.fromJson(Map<String, dynamic> json) {
    return QRCodeData(
      tipReceiverId: json['tipReceiverId'] as String,
      qrCodeBase64: json['qrCodeBase64'] as String?,
      qrCodeLogoPath: json['qrCodeLogoPath'] as String?,
      id: json['id'] as String?,
    );
  }
}