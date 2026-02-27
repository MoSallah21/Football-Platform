import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:football_platform/features/blogs/domain/entities/blog.dart';
import 'package:football_platform/features/blogs/presentation/pages/blog_description_page.dart';

class BlogCard extends StatelessWidget {
  final Blog blog;
  final int index;

  const BlogCard({
    Key? key,
    required this.blog,
    required this.index,
  }) : super(key: key);

  // Static const colors for better performance
  static const Color _cardColor = Color(0xFF6C5CE7);
  static const Color _textColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _navigateToDetails(context),
        borderRadius: BorderRadius.circular(10),
        child: Card(
          margin: const EdgeInsets.all(16),
          elevation: 4,
          color: _cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildImage(),
              _buildTitle(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    return Hero(
      tag: 'blog_image_${blog.id ?? index}', // Unique hero tag
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
        child: CachedNetworkImage(
          imageUrl: blog.image,
          height: 200,
          fit: BoxFit.cover,
          memCacheWidth: 800, // Limit cache size for performance
          maxHeightDiskCache: 400,
          fadeInDuration: const Duration(milliseconds: 300),
          placeholder: (context, url) => Container(
            height: 200,
            color: Colors.grey[800],
            child: const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            height: 200,
            color: Colors.grey[800],
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.broken_image_outlined,
                  color: Colors.white54,
                  size: 40,
                ),
                SizedBox(height: 8),
                Text(
                  'Image unavailable',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        blog.title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: _textColor,
        ),
        textAlign: TextAlign.center,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  void _navigateToDetails(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            BlogDescriptionScreen(
              title: blog.title,
              date: blog.dateOfPublish,
              author: blog.nameOfAuthor,
              image: blog.image,
              description: blog.description,
            ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOutCubic;

          var tween = Tween(begin: begin, end: end).chain(
            CurveTween(curve: curve),
          );

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }
}

// Optimized BlogTitle widget with const constructor
class BlogTitle extends StatelessWidget {
  final String title;

  const BlogTitle({
    Key? key,
    required this.title,
  }) : super(key: key);

  // Static const for shadow to avoid recreation
  static const List<Shadow> _textShadows = [
    Shadow(
      color: Colors.purple,
      offset: Offset(2, 1),
      blurRadius: 2,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 25,
        shadows: _textShadows,
      ),
    );
  }
}

// Optimized helper function that uses the new widget
Widget blogCard(Blog blog, BuildContext context, {int index = 0}) {
  return BlogCard(blog: blog, index: index);
}