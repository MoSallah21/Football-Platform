class QuestionModel{
  String? id;
  late String question;
  late int level;
  late String correctAnswer;
  List<dynamic>? answers;
  QuestionModel({
    required this.id,
    required this.question,
    required this.level,
    required this.correctAnswer,
    required this.answers,
  });
  QuestionModel.fromJson(Map<String, dynamic>? json) {
    id = json!['id'];
    question = json['question'];
    level=json['level'];
    correctAnswer = json['correctAnswer'];
    answers = json['answers'];

  }


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'question': question,
      'level':level,
      'correctAnswer': correctAnswer,
      'answers':answers
    };
  }
}
