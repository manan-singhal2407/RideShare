import 'package:google_maps_webservice/directions.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'retrofit_service.g.dart';

@RestApi(baseUrl: 'https://maps.googleapis.com/maps/api/')
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @GET('/directions/json')
  Future<DirectionsResponse> getDirectionData(
    @Query('origin') String origin,
    @Query('destination') String destination,
    @Query('key') String googleMapsApiKey,
  );
}
