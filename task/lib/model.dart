import 'dart:convert';
import 'package:http/http.dart' as http;

class Model {
  static const String _badWordsUrl =
      'https://raw.githubusercontent.com/LDNOOBW/List-of-Dirty-Naughty-Obscene-and-Otherwise-Bad-Words/master/en';

  static const String _nudityUrl = 'https://api.deepai.org/api/nsfw-detector';

  static Future<bool> verifyBadWords(String text) async {
    final response = await http.get(Uri.parse(_badWordsUrl));

    if (response.statusCode == 200) {
      final badWords = utf8.decode(response.bodyBytes).split('\n');
      final words = text.split(' ');

      for (var word in words) {
        if (badWords.contains(word.toLowerCase())) {
          return true;
        }
      }
    }

    return false;
  }

  static Future<bool> verifyNudityContent(String imageUrl) async {
    final headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'api-key': 'YOUR_API_KEY'
    };
    final body = {'image': imageUrl};

    final response =
        await http.post(Uri.parse(_nudityUrl), headers: headers, body: body);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final output = data['output'];

      if (output['nsfw_score'] > 0.5) {
        return true;
      }
    }

    return false;
  }
}
