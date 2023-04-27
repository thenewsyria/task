import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo App',
      home: MyHomePage(
        title: '',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _textEditingController = TextEditingController();
  bool _profanityDetected = false;

  Future<void> _checkProfanity(String text) async {
    // Replace with your own API endpoint and API key
    final url = 'https://api.example.com/check-profanity?text=$text';
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer your_api_key',
    };

    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      setState(() {
        _profanityDetected = result['profanity'];
      });
    }
  }

  Future<void> _checkNudity() async {
    // Show a dialog to prompt the user for an image URL
    final imageUrl = await TextFieldAlertDialog().asyncInputDialog(
      context,
      title: 'Enter image URL',
      labelText: 'Image URL',
    );

    if (imageUrl == null || imageUrl.isEmpty) return;

    // Replace with your own API endpoint and API key
    final url = 'https://api.example.com/check-nudity';
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer your_api_key',
    };
    final body = json.encode({'url': imageUrl});

    final response =
        await http.post(Uri.parse(url), headers: headers, body: body);

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      final nudityDetected = result['nudity'];

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title:
                Text(nudityDetected ? 'Nudity detected' : 'No nudity detected'),
            content: Text('The image has been analyzed.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _textEditingController,
              onChanged: (value) async {
                await _checkProfanity(value);
              },
              decoration: InputDecoration(
                labelText: 'Enter text',
                errorText: _profanityDetected ? 'Profanity detected' : null,
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                await _checkNudity();
              },
              child: Text('Check nudity in image'),
            ),
          ],
        ),
      ),
    );
  }
}
