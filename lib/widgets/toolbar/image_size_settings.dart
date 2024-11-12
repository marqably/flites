import 'package:flutter/material.dart';

class ImageSizeSettings extends StatelessWidget {
  const ImageSizeSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text('Image Size'),
        Row(
          children: [
            Text('Width:'),
            SizedBox(width: 8),
            SizedBox(
              width: 100,
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Text('Height:'),
            SizedBox(width: 8),
            SizedBox(
              width: 100,
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
