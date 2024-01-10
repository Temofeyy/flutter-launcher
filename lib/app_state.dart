import 'package:device_apps/device_apps.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appsProvider = FutureProvider<List<ApplicationWithIcon>>(
  (ref) async {
    final rawApps = await DeviceApps.getInstalledApplications(
      includeAppIcons: true,
      onlyAppsWithLaunchIntent: true,
      includeSystemApps: true,
    );

    final apps = rawApps.cast<ApplicationWithIcon>();
    apps.sort((a,b) => a.appName.compareTo(b.appName));

    return apps;
  }
);
