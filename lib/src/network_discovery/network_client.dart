import 'dart:convert' show json;

class NetworkClient {
  const NetworkClient({
    this.url,
    this.name,
  });

  final String? url;
  final String? name;

  NetworkClient copyWith({
    String? url,
    String? name,
  }) {
    return NetworkClient(
      url: url ?? this.url,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'url': url,
      'name': name,
    };
  }

  static NetworkClient? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }

    return NetworkClient(
      url: map['url'] as String?,
      name: map['name'] as String?,
    );
  }

  String toJson() => json.encode(toMap());

  static NetworkClient? fromJson(String source) =>
      fromMap(json.decode(source) as Map<String, dynamic>?);

  @override
  String toString() => 'NetworkClient(url: $url, name: $name)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is NetworkClient && other.url == url && other.name == name;
  }

  @override
  int get hashCode => url.hashCode ^ name.hashCode;
}
