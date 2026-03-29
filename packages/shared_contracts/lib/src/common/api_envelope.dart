import 'package:shared_contracts/src/common/api_error_response.dart';
import 'package:shared_contracts/src/common/api_meta.dart';

class ApiEnvelope<T> {
  const ApiEnvelope({this.data, this.error, required this.meta});

  final T? data;
  final ApiErrorResponse? error;
  final ApiMeta meta;

  bool get isSuccess => error == null;

  factory ApiEnvelope.fromJson(
    Map<String, dynamic> json,
    T Function(Object? value) decodeData,
  ) {
    return ApiEnvelope<T>(
      data: json.containsKey('data') ? decodeData(json['data']) : null,
      error: json['error'] is Map<String, dynamic>
          ? ApiErrorResponse.fromJson(json['error'] as Map<String, dynamic>)
          : null,
      meta: ApiMeta.fromJson(json['meta'] as Map<String, dynamic>? ?? const {}),
    );
  }

  Map<String, dynamic> toJson(Object? Function(T value) encodeData) {
    return {
      if (data case final value?) 'data': encodeData(value),
      if (error case final value?) 'error': value.toJson(),
      'meta': meta.toJson(),
    };
  }
}
