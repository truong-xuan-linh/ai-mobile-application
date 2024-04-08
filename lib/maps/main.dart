import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'maps_launcher.dart';

void main() {
  runApp(const MapsLauncher());
}

class MapsLauncher extends StatefulWidget {
  const MapsLauncher({super.key});

  @override
  State<MapsLauncher> createState() => _MapsLauncherState();
}

class _MapsLauncherState extends State<MapsLauncher> {
  bool _isListening = false;
  SpeechToText _speechToText = SpeechToText();
  String _lastWords = '';
  String fullWords = '';
  String intruction = '- Say: I want to go to [destination] , or just [destination] \n- Example: "I want to go to Ha Noi",  or just "Hà Nội"';

  bool _speechEnabled = false;

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  void _initSpeech() async {
    print("_initSpeech");
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  void _startListening() {
    print("_startListening");
    fullWords = '';
    _lastWords = '';
    setState(() {});
    _speechToText.listen(
      onResult: _onSpeechResult,
    );
  }

  void _stopListening() async {
    print("_stopListening");
    await _speechToText.stop();
    // if (fullWords != "") {
    //   await launchGoogleMap(fullWords);
    // }
    setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    print("_onSpeechResult");
    if (_speechToText.isNotListening) {
      if (fullWords != "") {
        launchGoogleMap(fullWords);
      }
    }
    setState(() {
      _lastWords = result.recognizedWords;
      fullWords = _lastWords;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              color: Colors.black,
              icon: const Icon(Icons.arrow_back_ios),
              iconSize: 20.0,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            centerTitle: true,
            title: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Maps ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  'Launcher     ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(150, 133, 255, 1),
                  ),
                )
              ],
            ),
          ),
          body: Container(
            padding: const EdgeInsets.all(16),
            child: Text(
              _speechToText.isListening ? _lastWords : intruction,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: AvatarGlow(
            animate: !_speechToText.isNotListening,
            glowColor: Theme.of(context).primaryColor,
            duration: const Duration(milliseconds: 2000),
            repeat: true,
            glowShape: BoxShape.circle,
            glowCount: 3,
            curve: Curves.fastOutSlowIn,
            child: FloatingActionButton(
              onPressed: _speechToText.isNotListening
                  ? _startListening
                  : _stopListening,
              child: Icon(
                  _speechToText.isNotListening ? Icons.mic : Icons.mic_none),
            ),
          ),
        ));
  }
}
