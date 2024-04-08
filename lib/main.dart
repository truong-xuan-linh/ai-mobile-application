import 'package:flutter/material.dart';
import 'launcher/laucher_manual.dart';
import 'launcher/laucher_voice.dart';
import 'translation/main.dart';
import 'maps/main.dart';

void main() {
  runApp(const DemoApp());
}

class DemoApp extends StatelessWidget {
  const DemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false, home: DemoAppEtx());
  }
}

class DemoAppEtx extends StatefulWidget {
  const DemoAppEtx({super.key});

  @override
  State<DemoAppEtx> createState() => _DemoAppEtxState();
}

class _DemoAppEtxState extends State<DemoAppEtx> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'AI ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text(
              'Demo',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(150, 133, 255, 1),
              ),
            )
          ],
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => const TranslationApp(),
                  ),
                );
              },
              label: const Text(
                "Translation",
                style: TextStyle(fontSize: 18),
              ),
              icon: const Icon(Icons.translate),
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(360, 56),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => const MapsLauncher(),
                  ),
                );
              },
              label: const Text(
                "Maps Launcher",
                style: TextStyle(fontSize: 18),
              ),
              icon: const Icon(Icons.map),
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(360, 56),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => const ManualLauncher(),
                  ),
                );
              },
              label: const Text(
                "Manual Launcher",
                style: TextStyle(fontSize: 18),
              ),
              icon: const Icon(Icons.apps),
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(360, 56),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => const VoiceLauncher(),
                  ),
                );
              },
              label: const Text(
                "Voice Launcher",
                style: TextStyle(fontSize: 18),
              ),
              icon: const Icon(Icons.record_voice_over),
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(360, 56),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
          ],
        ),
      ),
    );
  }
}
