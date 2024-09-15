import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../models/event_model.dart';
import '../util/enums/events_types_enums.dart';

class EventsApiService {
  final Dio _dio = Dio();
  static const String baseUrl =
      'https://us-central1-soulei.cloudfunctions.net/api';

  Future<bool> addEvent(Map<String, dynamic> eventData) async {
    try {
      final response = await _dio.post(baseUrl, data: eventData);
      if (response.statusCode == 201) {
        return true;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error adding event: $e');
      }
    }
    return false;
  }

  Future<bool> updateEvent(String id, Map<String, dynamic> eventData) async {
    try {
      final response = await _dio.put('$baseUrl/$id', data: eventData);
      if (response.statusCode == 200) {
        return true;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error updating event: $e');
      }
    }
    return false;
  }

  Future<bool> deleteEvent(String id) async {
    try {
      final response = await _dio.delete('$baseUrl/$id');
      if (response.statusCode == 200) {
        return true;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting event: $e');
      }
    }
    return false;
  }

  Future<EventModel?> getEventById(String id) async {
    try {
      final response = await _dio.get('$baseUrl/$id');
      if (response.statusCode == 200) {
        return EventModel.fromMap(response.data);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching event by ID: $e');
      }
    }
    return null; // Return null if error
  }

  Future<List<EventModel>?> getEvents() async {
    try {
      final response = await _dio.get(baseUrl);
      if (response.statusCode == 200) {
        return (response.data as List)
            .map((event) => EventModel.fromMap(event))
            .toList();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching events: $e');
      }
      return null;
    }
    return [];
  }

  Stream<EventModel?> getEventByIdStream(String id) async* {
    try {
      final response = await Dio().get(
        '$baseUrl/$id/stream',
        options: Options(
          responseType: ResponseType.stream,
        ),
      );

      await for (var data in response.data.stream) {
        final eventMap = data.isEmpty ? null : EventModel.fromMap(data);
        yield eventMap;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error getting event stream: $e');
      }
      yield null; // Return null in case of an error
    }
  }

  Stream<List<EventModel>> getEventsStream(
      {EventsTypesEnums? eventType}) async* {
    try {
      final queryParameters = <String, dynamic>{};
      if (eventType != null) {
        queryParameters['eventType'] = eventType.toShortString();
      }

      final response = await Dio().get(
        '$baseUrl/stream',
        queryParameters: queryParameters,
        options: Options(
          responseType: ResponseType.stream,
        ),
      );

      await for (var data in response.data.stream) {
        final eventsList = data.isEmpty
            ? []
            : (data as List).map((event) => EventModel.fromMap(event)).toList();
        yield eventsList as List<EventModel>;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error getting events stream: $e');
      }
      yield []; // Return an empty list in case of an error
    }
  }
}
