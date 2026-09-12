class ServerException implements Exception {
  const ServerException({
    this.message = 'Server communication failed.',
    this.statusCode,
  });

  final String message;
  final int? statusCode;

  @override
  String toString() => 'ServerException(message: $message, statusCode: $statusCode)';
}

class CacheException implements Exception {
  const CacheException({
    this.message = 'Failed to read or write local cache.',
  });

  final String message;

  @override
  String toString() => 'CacheException(message: $message)';
}

class NetworkException implements Exception {
  const NetworkException({
    this.message = 'Network request failed due to connectivity.',
  });

  final String message;

  @override
  String toString() => 'NetworkException(message: $message)';
}
