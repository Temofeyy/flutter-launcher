import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_state.dart';

final modeProvider = StateProvider<DisplayMode>((ref) => DisplayMode.Grid);

class AppsPage extends StatefulWidget {
  @override
  _AppsPageState createState() => _AppsPageState();
}

enum DisplayMode {
  Grid,
  List,
}

class _AppsPageState extends State<AppsPage>
    with AutomaticKeepAliveClientMixin {
  final channel = const MethodChannel('LockerEvents');

  bool _isLockMode = true;

  // void onViewModeChanged(WidgetRef ref, DisplayMode mode){
  //   ref.read(modeProvider.notifier).update((state) =>
  //   mode == DisplayMode.Grid
  //       ? DisplayMode.List
  //       : DisplayMode.Grid);
  // }

  Future<void> handleKotlinMethod(MethodCall call) async {
    print('Flutter received an method: ${call.method}');
    switch (call.method){
      case 'Unlock':
        _isLockMode = false;
        setState((){});
        break;
      case 'InvalidPassword':
        print('invalid pass');
        break;
      default:
        print('Unsupported LockerEvent event: ${call.method}');
    }
    return Future.value();
  }

  @override
  void initState() {
    super.initState();
    channel.setMethodCallHandler(handleKotlinMethod);
  }


  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: _isLockMode? Colors.red: Colors.green,
        elevation: 0,
      ),
      body: Consumer(
        builder: (_, ref, __) {
          final appsInfo = ref.watch(appsProvider);
          return appsInfo.when(
            data: (apps) => _GridView(apps: apps, lockMode: _isLockMode,),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, s) => Container(),
          );
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          _isLockMode = !_isLockMode;
          setState(() {});
        },
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
  final List<Application> apps;
  final bool lockMode;
  const _GridView({Key? key, required this.apps, required this.lockMode}): super(key: key);

  @override
  Widget build(BuildContext context) {
    final appsForView = lockMode
        ? apps.where((e) => e.packageName == "com.example.ex")
        : apps.take(10);

    return GridView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
          16.0, kToolbarHeight + 16.0, 16.0, 16.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      children: appsForView
          .map((app) => AppGridItem(application: app as ApplicationWithIcon?))
          .toList(),
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
