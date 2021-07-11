import 'dart:typed_data';

class SuperImageSource {
  const SuperImageSource({
    this.url,
    this.path,
    this.memory,
  });

  final String? url;
  final String? path;
  final Uint8List? memory;

  bool get isNetworkImage => url != null;
  bool get isFileImage => path != null;
  bool get isMemoryImage => memory != null;
}
