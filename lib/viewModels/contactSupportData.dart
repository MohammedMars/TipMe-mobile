class ContactSupportData {
  final String phoneNumber;
  final String whatsAppNumber;

  ContactSupportData({required this.phoneNumber, required this.whatsAppNumber});

  factory ContactSupportData.fromJson(Map<String, dynamic> json) {
    return ContactSupportData(
      phoneNumber: json['phoneNumber'] ?? '',
      whatsAppNumber: json['whatsAppNumber'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'phoneNumber': phoneNumber,
        'whatsAppNumber': whatsAppNumber,
      };
}
