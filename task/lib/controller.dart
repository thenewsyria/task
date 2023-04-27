import 'package:flutter/material.dart';
import 'model.dart';

class Controller {
  final TextEditingController textController = TextEditingController();
  final TextEditingController imageController = TextEditingController();

  bool isBadWords = false;
  bool isNudity = false;

  void verifyBadWords() async {
    final text = textController.text;

    if (text.isEmpty) {
      return;
    }

    final result = await Model.verifyBadWords(text);

    if (result) {
      isBadWords = true;
    } else {
      isBadWords = false;
    }
  }

  void verifyNudity() async {
    final imageUrl = imageController.text;

    if (imageUrl.isEmpty) {
      return;
    }

    final result = await Model.verifyNudityContent(imageUrl);

    if (result) {
      isNudity = true;
    } else {
      isNudity = false;
    }
  }
}
