import 'package:flutter/material.dart';
import 'controller.dart';

class View extends StatelessWidget {
  final Controller controller = Controller();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Demo App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: controller.textController,
              decoration: InputDecoration(
                labelText: 'Type something...',
              ),
              onChanged: (value) => controller.verifyBadWords(),
            ),
            SizedBox(height: 16.0),
            if (controller.isBadWords)
              Text(
                'Bad words detected!',
                style: TextStyle(color: Colors.red),
              ),
            TextField(
              controller: controller.imageController,
              decoration: InputDecoration(
                labelText: 'Enter image URL...',
              ),
              onChanged: (value) => controller.verifyNudity(),
            ),
            SizedBox(height: 16.0),
            if (controller.isNudity)
              Text(
                'Nudity detected!',
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}
