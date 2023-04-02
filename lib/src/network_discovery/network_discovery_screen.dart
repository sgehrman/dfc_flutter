import 'package:dfc_flutter/src/network_discovery/bonjour.dart';
import 'package:dfc_flutter/src/network_discovery/network_client.dart';
import 'package:dfc_flutter/src/utils/utils.dart';
import 'package:flutter/material.dart';

class NetworkDiscoveryScreen extends StatefulWidget {
  @override
  State<NetworkDiscoveryScreen> createState() => _NetworkDiscoveryScreenState();
}

class _NetworkDiscoveryScreenState extends State<NetworkDiscoveryScreen> {
  static const double listInset = 10;
  final Bonjour bonjour = Bonjour();

  @override
  void initState() {
    super.initState();

    bonjour.startDiscovery();

    bonjour.addListener(_listener);
  }

  @override
  void dispose() {
    bonjour.removeListener(_listener);
    super.dispose();
  }

  void _listener() {
    setState(() {});
  }

  Widget _body(BuildContext context) {
    Widget contents;

    if (Utils.isEmpty(bonjour.clients)) {
      contents = const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.info_outline, color: Colors.green, size: 65),
            SizedBox(height: 10),
            Text('Nothing found'),
          ],
        ),
      );
    } else {
      contents = ListView.separated(
        padding: const EdgeInsets.only(left: listInset),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: bonjour.clients.length,
        itemBuilder: (BuildContext context, int index) {
          final NetworkClient client = bonjour.clients[index];

          return ListTile(
            title: Text(client.name ?? '(no name)'),
            subtitle: Text(client.url ?? '(no url)'),
            onTap: () {
              Utils.launchUrl(client.url!);
            },
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const Divider(height: 2);
        },
      );
    }

    return contents;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Network Discovery'),
      ),
      body: _body(context),
    );
  }
}
