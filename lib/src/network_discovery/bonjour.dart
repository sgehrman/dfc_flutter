import 'package:bonsoir/bonsoir.dart';
import 'package:dfc_flutter/src/network_discovery/network_client.dart';
import 'package:flutter/material.dart';

class Bonjour extends ChangeNotifier {
  Bonjour({
    this.serviceType = '_path-finder._tcp',
    this.port = 8765,
    this.serviceName = 'Path Finder',
  });

  final String serviceType;
  final int port;
  final String serviceName;

  BonsoirService? broadcastService;
  late BonsoirBroadcast broadcast;
  BonsoirDiscovery? discovery;
  final List<ResolvedBonsoirService> _resolvedServices = [];

  List<NetworkClient> get clients {
    return _resolvedServices.map((x) {
      return NetworkClient(name: x.name, url: 'http://${x.ip}:${x.port}');
    }).toList();
  }

  Future<void> startBroadcast() async {
    if (broadcastService != null) {
      return;
    }

    broadcastService = BonsoirService(
      name: serviceName,
      type: serviceType,
      port: port,
    );

    broadcast = BonsoirBroadcast(service: broadcastService!);
    await broadcast.ready;
    await broadcast.start();
  }

  Future<void> stopBroadcast() async {
    await broadcast.stop();
  }

  Future<void> startDiscovery() async {
    if (discovery != null) {
      return;
    }

    discovery = BonsoirDiscovery(type: serviceType);
    await discovery!.ready;
    await discovery!.start();

    discovery!.eventStream!.listen((event) {
      if (event.type == BonsoirDiscoveryEventType.DISCOVERY_SERVICE_RESOLVED) {
        final ResolvedBonsoirService? service =
            event.service as ResolvedBonsoirService?;

        if (service != null) {
          print('Service found : ${service.toJson()}');
          _resolvedServices.add(service);
          notifyListeners();
        }
      } else if (event.type ==
          BonsoirDiscoveryEventType.DISCOVERY_SERVICE_LOST) {
        _resolvedServices.remove(event.service as ResolvedBonsoirService?);
        notifyListeners();

        print('Service lost : ${event.service!.toJson()}');
      }
    });
  }

  Future<void> stopDiscovery() async {
    await discovery?.stop();

    discovery = null;
  }
}
