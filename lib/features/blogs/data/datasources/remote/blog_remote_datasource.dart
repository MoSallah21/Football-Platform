import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:football_platform/core/errors/exception.dart';
import 'package:football_platform/features/blogs/data/models/blog_model.dart';

/// An abstract contract for remote data source operations related to blogs.
///
/// Defines a method to fetch all blog entries from a remote server.
abstract class BlogRemoteDatasource {
  /// Fetches a list of [BlogModel] objects from a remote source.
  ///
  /// Throws a [ServerException] if the request fails.
  Future<List<BlogModel>> getAllBlogs();
}

/// Firestore instance used for remote operations.
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

/// Name of the Firestore collection for blogs.
const String BLOG_COLLECTION = 'blogs';

/// Concrete implementation of [BlogRemoteDatasource] using Firebase Firestore.
class BlogRemoteDataSourceImp extends BlogRemoteDatasource {
  @override
  Future<List<BlogModel>> getAllBlogs() async {
    try {
      // Retrieve all documents from the 'blogs' collection
      final query = await _firestore.collection(BLOG_COLLECTION).get();

      if (query.docs.isNotEmpty) {
        // Map each document snapshot to a BlogModel
        return query.docs
            .map((doc) => BlogModel.fromJson(doc.data()))
            .toList();
      } else {
        // No documents found in the collection
        throw Exception('No Blogs Found');
      }
    } catch (e) {
      // Wrap any error in a custom ServerException
      throw ServerException();
    }
  }
}