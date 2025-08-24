class DateRangeDto {
  final DateTime from;
  final DateTime to;

  DateRangeDto({
    required this.from,
    required this.to,
  });

  factory DateRangeDto.fromJson(Map<String, dynamic> json) {
    return DateRangeDto(
      from: DateTime.parse(json['from']),
      to: DateTime.parse(json['to']),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'from': from.toIso8601String(),
      'to': to.toIso8601String(),
    };
  }
}
