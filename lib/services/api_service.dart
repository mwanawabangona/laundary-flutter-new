import 'package:dio/dio.dart';
import 'package:laundry_customer/constants/config.dart';
import 'package:laundry_customer/services/interceptor.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

Dio getDio() {
  final Dio dio = Dio();

  // ****** I just added this const called duration and used in in place of 1000 ******
  const duration = Duration(
      days: 0,
      hours: 0,
      minutes: 0,
      seconds: 0,
      milliseconds: 1000,
      microseconds: 0);

  //Basic Configuration
  dio.options.baseUrl = AppConfig.baseUrl;
  dio.options.connectTimeout = duration; // ******Replaced 1000 int value with dration ******
  dio.options.receiveTimeout = duration; // ******Replaced 1000 int value with dration ******

  // _dio.options.headers = {'Content-Type': 'application/json'};
  dio.options.headers = {'Accept': 'application/json'};
  dio.options.headers = {'accept': 'application/json'};
  dio.options.followRedirects = false;

  //for Logging the Request And response
  dio.interceptors.add(
    PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
    ),
  );

  //Intercepts all requests and adds the token to the header and Allows Global Logout
  dio.interceptors.add(ElTanvirInterceptors());

  return dio;
}
