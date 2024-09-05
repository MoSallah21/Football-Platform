import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:football_platform/core/errors/exception.dart';
import 'package:football_platform/features/game/data/models/question_model.dart';

abstract class QuizRemoteDatasource{
  Future<List<QuestionModel>> getAllQuestions(int level);
}
final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final String QUESTION_COLLECTION='questions';
class QuizRemoteDatasourceImp extends QuizRemoteDatasource{
  @override
  Future<List<QuestionModel>> getAllQuestions(int level) async {
    try{
      final query= await _firestore
          .collection(QUESTION_COLLECTION)
          .where('level', isEqualTo: level)
          .get();
      if(query.docs.isNotEmpty){
        return query.docs.map((doc)=> QuestionModel.fromJson(doc.data())).toList();
      }
      else{
        throw Exception("No Questions Found");
      }
    }catch(e){
      throw ServerException();
    }
  }
}