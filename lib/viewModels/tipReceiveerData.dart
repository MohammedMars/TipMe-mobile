class TipReceiveerData {
  final String mobileNumber;
  final String? firstName;
  final String? surName;
  final String? id;
  final String? imagePath;
  final bool? isCompleted;
  final String? countryId;
  final String? cityId;

  TipReceiveerData({
    required this.mobileNumber,
    this.firstName,
    this.surName,
    this.id,
    this.imagePath,
    this.isCompleted,
    this.countryId,
    this.cityId,
  });

  factory TipReceiveerData.fromJson(Map<String, dynamic> json) {
    return TipReceiveerData(
      mobileNumber: json['mobileNumber'] as String,
      firstName: json['firstName'] as String?,
      surName: json['surName'] as String?,
      id: json['id'] as String?,
      imagePath: json['imagePath'] as String?,
      isCompleted: json['isCompleted'] as bool?,
      countryId: json['countryId'] as String?,
      cityId: json['cityId'] as String?,
    );
  }
}
