class ApiMeta {
  const ApiMeta({
    required this.requestId,
    required this.timestamp,
    required this.apiVersion,
  });

  final String requestId;
  final DateTime timestamp;
  final String apiVersion;

  factory ApiMeta.fromJson(Map<String, dynamic> json) {
    return ApiMeta(
      requestId: json['requestId'] as String? ?? '',
      timestamp:
          DateTime.tryParse(json['timestamp'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
      apiVersion: json['apiVersion'] as String? ?? 'v1',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'requestId': requestId,
      'timestamp': timestamp.toUtc().toIso8601String(),
      'apiVersion': apiVersion,
    };
  }
}
