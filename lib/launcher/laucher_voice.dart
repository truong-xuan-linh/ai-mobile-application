import 'package:installed_apps/app_info.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:installed_apps/installed_apps.dart';

void main() {
  runApp(const VoiceLauncher());
}

Map<String, String> packages = {
  'maps': 'com.google.android.apps.maps',
  'google maps': 'com.google.android.apps.maps',
  'bản đồ': 'com.google.android.apps.maps',
  'map': 'com.google.android.apps.maps',
  'youtube': 'com.google.android.youtube',
  'facebook': 'com.facebook.katana'
};

class VoiceLauncher extends StatefulWidget {
  const VoiceLauncher({super.key});

  @override
  State<VoiceLauncher> createState() => _VoiceLauncherState();
}

class _VoiceLauncherState extends State<VoiceLauncher> {
  bool _isListening = false;
  SpeechToText _speechToText = SpeechToText();
  String _lastWords = '';
  String fullWords = '';
  String intruction =
      '- Say: open [app name] , or just [app name] \n- Example: "Open Youtube", or just "Youtube"';
  bool _speechEnabled = false;
  var locales;
  late LocaleName localeInformation;
  bool inited = false;

  @override
  void initState() {
    super.initState();
    print(packages);
    _initSpeech().then((value) => null);

    InstalledApps.getInstalledApps(true, true).then((apps) {
      for (AppInfo app in apps) {
        if (!packages.containsKey(app.name.toLowerCase())) {
          packages[app.name.toLowerCase()] = app.packageName.toLowerCase();
        }
      }
    });
  }

  Future _initSpeech() async {
    print("_initSpeech");
    locales = await _speechToText.locales();
    var systemLocal = await _speechToText.systemLocale();
    localeInformation = systemLocal!;
    _speechEnabled = await _speechToText.initialize();

    inited = true;
    setState(() {});
  }

  // SpeechListenOptions listOptions = SpeechListenOptions();
  void _startListening() {
    print("_startListening");
    print(localeInformation.name);
    
    fullWords = '';
    _lastWords = '';

    setState(() {});
    _speechToText.listen(
      onResult: _onSpeechResult,
      localeId: localeInformation.localeId,
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
    setState(() {
      _lastWords = result.recognizedWords;
      fullWords = _lastWords;
    });

    print("_onSpeechResult");
    print(_lastWords);
    print(_speechToText.isNotListening);
    if (_speechToText.isNotListening) {
      if (fullWords != "") {
        launchApp(fullWords);
      }
    }
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
                  'Voice ',
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
          body: inited
              ? Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Flexible(
                            child: Text(
                              'Language: ',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                          Flexible(
                            child: DropdownButton(
                                isExpanded: true,
                                value: localeInformation,
                                items: locales
                                    .map<DropdownMenuItem<LocaleName>>((locale) {
                                  return DropdownMenuItem<LocaleName>(
                                    value: locale,
                                    child: Text(
                                      locale.name,
                                      style: const TextStyle(
                                          fontSize: 16, color: Colors.black),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  localeInformation = value!;
                                  setState(() {
                                    
                                  });
                                },
                              ),
                          ),
                        ],
                      ),

                      Text(
                        _speechToText.isListening ? _lastWords : fullWords=="" ? intruction : fullWords,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                )
              : const Center(
                  child: SizedBox.square(
                    dimension: 20,
                    child: CircularProgressIndicator(
                      color: Color.fromRGBO(150, 133, 255, 1),
                    ),
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

String findApplicationName(String rawInput) {
  rawInput = rawInput.toLowerCase();
  RegExp regex = RegExp(r'ứng dụng\s+(.*)');
  Match? match = regex.firstMatch(rawInput);
  if (match == null) {
    regex = RegExp(r'mở\s+(.*)');
    match = regex.firstMatch(rawInput);
  }

  if (match == null) {
    regex = RegExp(r'open\s+(.*)');
    match = regex.firstMatch(rawInput);
  }

  if (match != null) {
    String appName = match.group(1) ?? '';
    return appName;
  } else {
    return rawInput;
  }
}

Future<void> launchApp(String content) async {
  String appName = findApplicationName(content);
  print(appName);
  if (packages.containsKey(appName)) {
    await LaunchApp.openApp(
      androidPackageName: packages[appName],
    );
  }
}
