import 'dart:async';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:dfc_flutter/src/extensions/string_ext.dart';
import 'package:dfc_flutter/src/utils/utils.dart';
import 'package:dfc_flutter/src/widgets/list_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DeviceInfoScreen extends StatefulWidget {
  @override
  _DeviceInfoScreenState createState() => _DeviceInfoScreenState();
}

class _DeviceInfoScreenState extends State<DeviceInfoScreen> {
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  List<Map<String, dynamic>>? _dataList = <Map<String, dynamic>>[];

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    late Map<String, dynamic> deviceData;
    List<Map<String, dynamic>>? deviceInfo;

    try {
      if (Platform.isAndroid) {
        deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
      } else if (Platform.isIOS) {
        deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
      }

      // convert array values
      deviceInfo = convertMap(deviceData);
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.',
      };
    }

    if (mounted) {
      setState(() {
        _dataList = deviceInfo;
      });
    }
  }

  int _rankForItem(Map map) {
    switch (map['key'] as String?) {
      case 'product':
        return 0;
      case 'model':
      case 'brand':
      case 'device':
      case 'securityPatch':
      case 'sdkInt':
      case 'manufacturer':
      case 'release':
        return 1;
      default:
        return 10000;
    }
  }

  List<Map<String, dynamic>> convertMap(Map<String, dynamic> map) {
    final List<Map<String, dynamic>> result = <Map<String, dynamic>>[];

    for (final key in map.keys) {
      final dynamic value = map[key];

      if (value is List) {
        for (final item in value) {
          result.add(<String, dynamic>{'key': key, 'value': item});
        }
      } else {
        result.add(<String, dynamic>{'key': key, 'value': value});
      }
    }

    result.sort((Map a, Map b) {
      int res = _rankForItem(a).compareTo(_rankForItem(b));

      if (res == 0) {
        final String aStr = a['key'] as String;
        final String bStr = b['key'] as String;

        res = aStr.compareTo(bStr);
      }

      return res;
    });

    return result;
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'securityPatch': build.version.securityPatch,
      'sdkInt': build.version.sdkInt,
      'release': build.version.release,
      'previewSdkInt': build.version.previewSdkInt,
      'incremental': build.version.incremental,
      'codename': build.version.codename,
      'baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'androidId': build.androidId,
      'systemFeatures': build.systemFeatures,
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Platform.isAndroid ? 'Android Device Info' : 'iOS Device Info',
        ),
      ),
      body: ListView.separated(
        physics: const BouncingScrollPhysics(),
        itemCount: _dataList!.length,
        separatorBuilder: (context, index) {
          return const Divider(height: 1);
        },
        itemBuilder: (context, index) {
          final bool darkMode = Utils.isDarkMode(context);
          final Map<String, dynamic> map = _dataList![index];

          String value = map['value'].toString();

          if (Utils.isEmpty(value)) {
            value = '--';
          }

          return ListRow(
            color: ListRow.backgroundForIndex(
              index: index,
              darkMode: darkMode,
            ),
            leading: const SizedBox(
              height: 50,
              width: 5,
            ),
            title: (map['key'] as String).fromCamelCase(),
            subtitle: value,
          );
        },
      ),
    );
  }
}
