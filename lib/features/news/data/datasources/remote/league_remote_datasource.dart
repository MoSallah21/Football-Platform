import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:football_platform/core/errors/exception.dart';
import 'package:football_platform/features/blogs/data/models/blog_model.dart';

abstract class BlogRemoteDatasource{
  Future<List<BlogModel>> getAllBlogs();
}
final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final String BLOG_COLLECTION='blogs';
class BlogRemoteDataSourceImp extends BlogRemoteDatasource{
  @override
  Future<List<BlogModel>> getAllBlogs() async {
    try{
      final query= await _firestore
          .collection(BLOG_COLLECTION)
          .get();
      if(query.docs.isNotEmpty){
        return query.docs.map((doc)=> BlogModel.fromJson(doc.data())).toList();
      }
      else{
        throw Exception("No Blogs Found");
      }
    }catch(e){
      throw ServerException();
    }
  }
}