class TipReceiveerSettingsData {
  bool notifyOnTipReceived;
  bool notifyOnTipGiven;
  bool notifyOnBankAccountVerification;
  bool notifyOnAnnouncement;
  bool enableBiometricLogin;

  TipReceiveerSettingsData({
    required this.notifyOnTipReceived,
    required this.notifyOnTipGiven,
    required this.notifyOnBankAccountVerification,
    required this.notifyOnAnnouncement,
    required this.enableBiometricLogin,
  });

  factory TipReceiveerSettingsData.fromJson(Map<String, dynamic> json) {
    return TipReceiveerSettingsData(
      notifyOnTipReceived: json['notifyOnTipReceived'] as bool? ?? false,
      notifyOnTipGiven: json['notifyOnTipGiven'] as bool? ?? false,
      notifyOnBankAccountVerification:
          json['notifyOnBankAccountVerification'] as bool? ?? false,
      notifyOnAnnouncement: json['notifyOnAnnouncement'] as bool? ?? false,
      enableBiometricLogin: json['enableBiometricLogin'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notifyOnTipReceived': notifyOnTipReceived,
      'notifyOnTipGiven': notifyOnTipGiven,
      'notifyOnBankAccountVerification': notifyOnBankAccountVerification,
      'notifyOnAnnouncement': notifyOnAnnouncement,
      'enableBiometricLogin': enableBiometricLogin,
    };
  }
}
