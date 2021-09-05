import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CustomImage extends StatelessWidget {
  String? imageUrl;
  String? initiales;
  double? radius;

  CustomImage(this.imageUrl, this.initiales, this.radius);

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null) {
      return CircleAvatar(
          radius: radius ?? 0.0,
          backgroundColor: Colors.blue,
          child: Text(
            initiales ?? "",
            style: TextStyle(color: Colors.white, fontSize: radius),
          ));
    } else {
      ImageProvider provider = CachedNetworkImageProvider(imageUrl!);
      if (radius == null) {
        // for chat image
        return InkWell(
          child: Image(image: provider, width: 250),
          onTap: () {
            // Montrer l'image en grand
          },
        );
      } else {
        return InkWell(
          child: CircleAvatar(
            radius: radius,
            backgroundImage: provider,
          ),
          onTap: () {},
        );
      }
    }
  }
}
