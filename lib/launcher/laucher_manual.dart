import 'package:flutter/material.dart';
import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';

class ManualLauncher extends StatefulWidget {
  const ManualLauncher({super.key});

  @override
  State<ManualLauncher> createState() => _ManualLauncherState();
}

Future<List<Widget>> _buildGridList() async {
  List apps = await InstalledApps.getInstalledApps(true, true);

  List<Widget> gridList = [];

  for (AppInfo app in apps) {
    gridList.add(Column(
      children: [
        Flexible(
          fit: FlexFit.loose,
          child: IconButton(
            onPressed: () async {
              await LaunchApp.openApp(
                androidPackageName: app.packageName,
              );
            },
            icon: Image.memory(app.icon!),
          ),
        ),
        Text(
          app.name,
          style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
        )
      ],
    ));
  }
  return gridList;
}

class _ManualLauncherState extends State<ManualLauncher> {
  List<Widget> widgetList = [];

  @override
  void initState() {
    super.initState();
    _buildGridList().then((listContainer) {
      setState(() {
        widgetList = List<Widget>.from(listContainer);
      });
      print(widgetList);
    });
    
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            // automaticallyImplyLeading: true,
            leading: IconButton(
              color: Colors.black,
              icon: const Icon(Icons.arrow_back_ios),
              iconSize: 20.0,
              onPressed: () {
                Navigator.pop(context);
              },
            ),

            title: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Manual ',
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
            centerTitle: true,
          ),
          body: widgetList.isNotEmpty
              ? SizedBox(
                  width: double.infinity,
                  child: _buildGrid(),
                )
              : const Center(
                  child: SizedBox.square(
                      dimension: 20,
                      child: CircularProgressIndicator(
                        color: Color.fromRGBO(150, 133, 255, 1),
                      ),
                    ),
              ),
        ));
  }

  Widget _buildGrid() => GridView.count(
      padding: const EdgeInsets.all(4),
      mainAxisSpacing: 6,
      crossAxisSpacing: 6,
      crossAxisCount: 4,
      children: widgetList);
}
