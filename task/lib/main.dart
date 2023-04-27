import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:clarifai_flutter/clarifai_flutter.dart';
import 'package:profanity_filter/profanity_filter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo App',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _textController = TextEditingController();
  bool _containsBadWords = false;
  bool _containsNudity = false;

  Future<void> _getImageAndCheckNudity() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final clarifai = Clarifai(apiKey: 'your_api_key');
      final response = await clarifai.predictModel(
        ClarifaiModel.nsfwModel,
        File(pickedFile.path).readAsBytesSync(),
      );
      final concepts = response['outputs'][0]['data']['concepts'];
      setState(() {
        _containsNudity = concepts.any((concept) => concept['name'] == 'nsfw');
      });
    }
  }

  void _checkBadWords(String value) {
    final profanityFilter = ProfanityFilter();
    setState(() {
      _containsBadWords = profanityFilter.hasProfanity(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Demo App'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _textController,
            onChanged: _checkBadWords,
            decoration: InputDecoration(
              labelText: 'Input field',
              errorText: _containsBadWords ? 'Contains bad words' : null,
            ),
          ),
          ElevatedButton(
            onPressed: _getImageAndCheckNudity,
            child: Text('Select Image'),
          ),
          if (_containsNudity)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Image contains nudity',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
