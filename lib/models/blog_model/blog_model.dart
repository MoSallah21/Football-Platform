class BlogModel{
  String? id;
  late String title;
  late String image;
  late String description ;
  late String dateOfPublish ;
  late String nameOfAuthor ;



  BlogModel.fromJson(Map<String, dynamic>? json) {
    id = json!['id'];
    title = json['title'];
    image = json['image'];
    description = json['description'];
    dateOfPublish = json['date'];
    nameOfAuthor = json['author'];
  }

  BlogModel({
    required this.id,
    required this.title,
    required this.description,
    required this.dateOfPublish,
    required this.nameOfAuthor,

  });
  Map<String, dynamic> toMap() {
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
