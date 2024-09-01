import 'package:equatable/equatable.dart';

class Blog extends Equatable{
  final String id;
  final String title;
  final String image;
  final String description ;
  final String dateOfPublish ;
  final String nameOfAuthor ;

  Blog({required this.id,
    required this.title,
    required this.image,
    required this.description,
    required this.dateOfPublish,
    required this.nameOfAuthor});

  @override
  List<Object?> get props => [id,title,image,description,dateOfPublish,nameOfAuthor];

}