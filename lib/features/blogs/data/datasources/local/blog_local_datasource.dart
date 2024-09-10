import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:football_platform/core/errors/exception.dart';
import 'package:football_platform/features/blogs/data/models/blog_model.dart';
import 'package:football_platform/core/cache/cache_helper.dart';

abstract class BlogLocalDatasource{
  Future<List<BlogModel>> getCachedBlogs();
  Future<Unit>cacheBlogs(List<BlogModel> blogModels);
}
const String CACHED_BLOGS="CACHED_BLOGS";
class BlogLocalDatasourceImpl implements BlogLocalDatasource{
  @override
  Future<Unit> cacheBlogs(List<BlogModel> blogModels) {
    List blogModelsToJson = blogModels
        .map<Map<String,dynamic>>
      ((blogModels)
    =>blogModels.toJson())
        .toList();
    CacheHelper.saveData(key: CACHED_BLOGS, value: json.encode(blogModelsToJson));
    return Future.value(unit);
  }

  @override
  Future<List<BlogModel>> getCachedBlogs() {
    final jsonString =CacheHelper.getData(key: CACHED_BLOGS);
    if(jsonString!=null) {
      List decodeJsonData= json.decode(jsonString);
      List<BlogModel> jsonToPostModels=decodeJsonData.map<BlogModel>(
              (jsonPostModel)=>BlogModel.fromJson(jsonPostModel)).toList();
      return Future.value(jsonToPostModels);
    }
    else{
      throw EmptyCacheException();
    }

  }
}
