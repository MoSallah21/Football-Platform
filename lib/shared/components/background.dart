import 'package:flutter/material.dart';

class BackGround extends StatelessWidget {
  final Widget child;
  final int img;

  const BackGround({Key? key, required this.child,required this.img}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String>path=['assets/images/petich.jpg','assets/images/petich1.jpg','assets/images/petich2.jpg','assets/images/petich3.jpg','assets/lottie/soccer-field.jpg'
    ];
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(path[img]), // Replace 'background_image.png' with your local image path
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.5), // Adjust opacity as needed
            BlendMode.darken,
          ),
        ),
      ),
      child: child,
    );
  }}
