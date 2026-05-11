import 'package:dio/dio.dart';

class AppException implements Exception {
  final String message;
  final int? statusCode;

  AppException(this.message, {this.statusCode});

  factory AppException.fromDioError(DioException dioError) {
    switch (dioError.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return AppException('Erreur de connexion : délai dépassé.');
      case DioExceptionType.badResponse:
        return AppException(
            'Erreur serveur : ${dioError.response?.statusCode}',
            statusCode: dioError.response?.statusCode);
      case DioExceptionType.connectionError:
        return AppException('Aucune connexion Internet.');
      default:
        return AppException('Une erreur inattendue est survenue.');
    }
  }

  @override
  String toString() => message;
}
