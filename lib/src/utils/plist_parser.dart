import 'dart:convert';
import 'dart:typed_data';

import 'package:dfc_flutter/src/models/manifest_model.dart';
import 'package:dfc_flutter/src/requests/requests.dart';
import 'package:xml/xml.dart';

class Plist {
  // ignore: no-object-declaration
  static Object parse(String xml) {
    final doc = XmlDocument.parse(xml);

    return _handleElem(doc.rootElement.children.where(_isElement).first);
  }

  // ignore: no-object-declaration
  static Object _handleElem(XmlNode node) {
    XmlElement element;

    if (_isElement(node)) {
      element = node as XmlElement;

      switch (element.name.local) {
        case 'string':
          return element.value ?? '';
        case 'real':
          return double.parse(element.value ?? '');
        case 'integer':
          return int.parse(element.value ?? '');
        case 'true':
          return true;
        case 'false':
          return false;
        case 'date':
          return DateTime.tryParse(element.value ?? '') ?? DateTime(0);
        case 'data':
          return Uint8List.fromList(base64Decode(element.value ?? ''));
        case 'array':
          return element.children.where(_isElement).map(_handleElem).toList();
        case 'dict':
          return _handleDict(element);
      }
    }

    return 'Not an XmlElement';
  }

  static Map<String, dynamic> _handleDict(XmlElement elem) {
    final children = elem.children.where(_isElement);

    final key = children
        .where((elem) => (elem as XmlElement).name.local == 'key')
        .map((elem) => elem.value ?? '');
    final values = children
        .where((elem) => (elem as XmlElement).name.local != 'key')
        .map(_handleElem);

    return Map<String, dynamic>.fromIterables(key, values);
  }

  static bool _isElement(XmlNode node) => node is XmlElement;
}

// =================================================================
// =================================================================

// get version from iOS manifest file
class ManifestFile {
  static Future<String> version(String url) async {
    try {
      final response = await Requests.get(
        url,
        timeoutSeconds: 30,
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        String xmlString = response.content();

        xmlString = xmlString.replaceAll('bundle-version', 'bundleVersion');
        xmlString =
            xmlString.replaceAll('bundle-identifier', 'bundleIdentifier');
        xmlString =
            xmlString.replaceAll('platform-identifier', 'platformIdentifier');

        final Map<String, dynamic> converted =
            Map<String, dynamic>.from(Plist.parse(xmlString) as Map);

        final manifest = ManifestModel.fromJson(converted);

        return manifest.items.first.metadata.bundleVersion;
      } else {
        print(
          '(get) Request failed with status: ${response.statusCode}. Url: $url',
        );
      }
    } catch (err) {
      print(err);
    }

    return '';
  }
}
