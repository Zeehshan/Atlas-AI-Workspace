class RefreshSessionRequest {
  const RefreshSessionRequest({required this.refreshToken});

  final String refreshToken;

  factory RefreshSessionRequest.fromJson(Map<String, dynamic> json) {
    return RefreshSessionRequest(
      refreshToken: json['refreshToken'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'refreshToken': refreshToken};
  }
}
