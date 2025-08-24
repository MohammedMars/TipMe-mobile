import 'package:tipme_app/enums/support_issue_type.dart';

class CreateSupportIssueDto {
  final String tipReceiverId;
  final SupportIssueType issueType;
  final String description;

  CreateSupportIssueDto(
      {required this.tipReceiverId,
      required this.issueType,
      required this.description});

  Map<String, dynamic> toJson() => {
        'tipReceiverId': tipReceiverId,
        'issueType': issueType.index,
        'description': description,
      };
}
