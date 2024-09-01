import 'package:football_platform/features/blogs/domain/entities/blog.dart';

class BlogModel extends Blog{
  BlogModel({
    required super.id,
    required super.title,
    required super.description,
    required super.nameOfAuthor,
    required super.dateOfPublish,
    required super.image
});
  factory BlogModel.fromJson(Map<String, dynamic>? json) {
    return BlogModel(
    id : json!['id'],
    title : json['title'],
    image : json['image'],
    description : json['description'],
    dateOfPublish : json['date'],
    nameOfAuthor : json['author'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'image': image,
      'description':description,
      'date':dateOfPublish,
      'author':nameOfAuthor,
    };
  }
}
