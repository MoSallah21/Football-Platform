import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:football_platform/core/errors/exception.dart';
import 'package:football_platform/features/blogs/data/models/blog_model.dart';
import 'package:football_platform/core/cache/cache_helper.dart';

/// An abstract contract for local data source operations related to blogs.
///
/// Defines methods to cache blog entries and retrieve them from local storage.
abstract class BlogLocalDatasource {
  /// Returns a list of cached [BlogModel] objects.
  ///
  /// Throws an [EmptyCacheException] if there is no data in local storage.
  Future<List<BlogModel>> getCachedBlogs();

  /// Caches a list of [BlogModel] objects in local storage.
  ///
  /// Returns a [Unit] upon successful caching.
  Future<Unit> cacheBlogs(List<BlogModel> blogModels);
}

/// Key constant for storing and retrieving cached blogs in local preferences.
const String CACHED_BLOGS = "CACHED_BLOGS";

/// Concrete implementation of [BlogLocalDatasource], using [CacheHelper].
class BlogLocalDatasourceImpl implements BlogLocalDatasource {
  @override
  Future<Unit> cacheBlogs(List<BlogModel> blogModels) {
    // Convert list of models to JSON-serializable map
    final List<Map<String, dynamic>> jsonList = blogModels
        .map((model) => model.toJson())
        .toList();

    // Persist encoded JSON string under the CACHED_BLOGS key
    CacheHelper.saveData(
      key: CACHED_BLOGS,
      value: json.encode(jsonList),
    );

    // Return a completed Unit future
    return Future.value(unit);
  }

  @override
  Future<List<BlogModel>> getCachedBlogs() {
    final jsonString = CacheHelper.getData(key: CACHED_BLOGS);

    if (jsonString != null) {
      // Decode JSON string into a dynamic list
      final List<dynamic> decoded = json.decode(jsonString);

      // Map each JSON object to a [BlogModel]
      final List<BlogModel> models = decoded
          .map((item) => BlogModel.fromJson(item))
          .toList();

      return Future.value(models);
    } else {
      // Throw if cache is empty
      throw EmptyCacheException();
    }
  }
}
