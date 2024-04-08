import 'package:url_launcher/url_launcher.dart';

String findLocation(String rawInput) {
  rawInput = rawInput.toLowerCase();
  RegExp regex = RegExp(r'đến\s+(.*)');
  Match? match = regex.firstMatch(rawInput);
  if (match == null) {
    regex = RegExp(r'đi\s+(.*)');
    match = regex.firstMatch(rawInput);
  }

  if (match == null) {
    regex = RegExp(r'way to\s+(.*)');
    match = regex.firstMatch(rawInput);
  }

  if (match == null) {
    regex = RegExp(r'go to\s+(.*)');
    match = regex.firstMatch(rawInput);
  }


  if (match != null) {
    String destination = match.group(1) ?? '';
    return destination;
  } else {
    return rawInput;
  }
}

Future<void> launchGoogleMap(String content) async {
    String destination = findLocation(content);
    final uri = Uri(
        scheme: "google.navigation",
        // host: '"0,0"',  
        queryParameters: {
          'q': destination,
          'mode': 'd',
        });
    
    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $uri');
    }
  }
