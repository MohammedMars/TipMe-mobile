class FAQData {
  final String question;
  final String answer;

  FAQData({required this.question, required this.answer});

  factory FAQData.fromJson(Map<String, dynamic> json) {
    return FAQData(
      question: json['question'] ?? '',
      answer: json['answer'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'question': question,
    'answer': answer,
  };
}