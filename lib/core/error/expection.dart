class ServerException implements Exception {
  String? message;

  ServerException(this.message);
}

class AuthException implements Exception {
  String? message;

  AuthException(this.message);
}

class CacheException implements Exception {

}