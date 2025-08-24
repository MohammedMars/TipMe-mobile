import 'package:intl/intl.dart';

class TipReceiverStatisticsData {
  final String tipReceiverId;
  final DateTime? date;
  final String? dateString;
  final double totalReceivedTips;
  final double totalRedeemed;
  final int numberOfTotalTips;
  final double? avgTipValue;
  final double? maxTipValue;
  final double? minTipValue;

  TipReceiverStatisticsData(
      {required this.tipReceiverId,
      required this.date,
      required this.dateString,
      required this.totalReceivedTips,
      required this.totalRedeemed,
      required this.numberOfTotalTips,
      this.avgTipValue,
      this.maxTipValue,
      this.minTipValue});

  factory TipReceiverStatisticsData.fromJson(Map<String, dynamic> json) {
    return TipReceiverStatisticsData(
      tipReceiverId: json['tipReceiverId'] as String,
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      dateString: json['date'] as String?,
      totalReceivedTips: (json['totalReceivedTips'] as num).toDouble(),
      totalRedeemed: (json['totalRedeemed'] as num).toDouble(),
      numberOfTotalTips: json['numberOfTotalTips'] as int,
      avgTipValue: json['avgTipValue'] != null
          ? (json['avgTipValue'] as num).toDouble()
          : null,
      maxTipValue: json['maxTipValue'] != null
          ? (json['maxTipValue'] as num).toDouble()
          : null,
      minTipValue: json['minTipValue'] != null
          ? (json['minTipValue'] as num).toDouble()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tipReceiverId': tipReceiverId,
      'date': date,
      'dateString': dateString,
      'totalReceivedTips': totalReceivedTips,
      'totalRedeemed': totalRedeemed,
      'numberOfTotalTips': numberOfTotalTips,
      'avgTipValue': avgTipValue,
      'maxTipValue': maxTipValue,
      'minTipValue': minTipValue,
    };
  }

  @override
  String toString() {
    return "{ tipReceiverId: $tipReceiverId, date: ${DateFormat('yyyy-MM-dd').format(date!)}, totalReceivedTips: $totalReceivedTips }";
  }
}
