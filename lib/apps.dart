import 'dart:async';

import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_state.dart';
import 'config.dart';

final modeProvider = StateProvider<DisplayMode>((ref) => DisplayMode.Grid);

class AppsPage extends StatefulWidget {
  const AppsPage({super.key});

  @override
  _AppsPageState createState() => _AppsPageState();
}

enum DisplayMode {
  Grid,
  List,
}

class _AppsPageState extends State<AppsPage>
    with AutomaticKeepAliveClientMixin {
  final events = const EventChannel('LockerEvents');
  late final StreamSubscription _sub;
  bool _isLockMode = true;

  void handleLauncherEvents(dynamic event){
    print('Flutter receive $event event from Kotlin');
    switch (event as String){
      case 'Unlock':
        _isLockMode = false;
        setState((){});
        break;
      case 'InvalidPassword':
        break;
      default:
        print('Unsupported LockerEvent event: ${event}');
    }
  }

  @override
  void initState() {
    super.initState();
    _sub = events.receiveBroadcastStream().listen(handleLauncherEvents);
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        elevation: 0,
      ),
      body: Consumer(
        builder: (_, ref, __) {
          final appsInfo = ref.watch(appsProvider);
          return appsInfo.when(
            data: (apps) {
              apps = _isLockMode
                  ? apps.where((e) => e.packageName == AppConfig.launcherPackageName).toList()
                  : apps;
              return _GridView(apps: apps);
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, s) => Container(),
          );
        }
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}



class _ListView extends StatelessWidget {
  final List<Application> apps;
  const _ListView({Key? key, required this.apps}): super(key: key);


  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: apps.length,
      itemBuilder: (_, index) {
        var app = apps[index] as ApplicationWithIcon;
        return ListTile(
          leading: Image.memory(
            app.icon,
            width: 40,
          ),
          title: Text(app.appName),
          onTap: () => DeviceApps.openApp(app.packageName),
        );
      },
    );
  }
}

class _GridView extends StatelessWidget {
  final List<ApplicationWithIcon> apps;
  const _GridView({Key? key, required this.apps}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: apps.length,
      itemBuilder: (_, i) => AppGridItem(application: apps[i]),
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16.0, kToolbarHeight + 16.0, 16.0, 16.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
    );
  }
}

class AppGridItem extends StatelessWidget {
  final ApplicationWithIcon? application;
  const AppGridItem({
    this.application,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => DeviceApps.openApp(application!.packageName),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Image.memory(
              application!.icon,
              fit: BoxFit.contain,
              width: 40,
              cacheWidth: 110,
            ),
          ),
          Text(
            application!.appName,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
