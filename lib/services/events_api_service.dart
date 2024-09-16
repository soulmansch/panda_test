import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../models/event_model.dart';
import '../util/enums/events_types_enums.dart';
import 'package:uuid/uuid.dart';

class EventsApiService {
  final Dio _dio = Dio();
  static const String baseUrl =
      'https://us-central1-privacies.cloudfunctions.net/api';

  Future<bool> addEvent(Map<String, dynamic> eventData) async {
    try {
      final response = await _dio.post(
        '$baseUrl/events',
        data: EventModel.fromMap(eventData)
            .copyWith(id: const Uuid().v4())
            .toMap(),
      );
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
      final response = await _dio.put('$baseUrl/events/$id', data: eventData);
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
      final response = await _dio.delete('$baseUrl/events/$id');
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
      final response = await _dio.get('$baseUrl/events/$id');
      if (response.statusCode == 200) {
        return EventModel.fromMap(response.data);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching event by ID: $e');
      }
    }
    return null;
  }

  Future<List<EventModel>?> getEvents() async {
    try {
      final response = await _dio.get('$baseUrl/events');
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
      final response = await _dio.get(
        '$baseUrl/streams/events/$id',
        options: Options(
          responseType: ResponseType.stream,
        ),
      );

      // Decode and handle the incoming SSE stream
      await for (var data in response.data.stream
          .transform(utf8.decoder)
          .transform(const LineSplitter())) {
        if (data.isNotEmpty) {
          final eventMap = jsonDecode(data);
          if (eventMap.isNotEmpty) {
            yield EventModel.fromMap(eventMap);
          } else {
            yield null; // Send null if the event does not exist
          }
        } else {
          yield null;
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error getting event stream: $e');
      }
      yield null; // Handle errors by yielding null
    }
  }

  Stream<List<EventModel>> getEventsStream(
      {EventsTypesEnums? eventType}) async* {
    try {
      final queryParameters = <String, dynamic>{};
      if (eventType != null) {
        queryParameters['eventType'] = eventType.toShortString();
      }

      final response = await _dio.get(
        '$baseUrl/streams/events',
        queryParameters: queryParameters,
        options: Options(
          responseType: ResponseType.stream,
        ),
      );

      // Decode SSE stream data
      await for (var data in response.data.stream
          .transform(utf8.decoder)
          .transform(const LineSplitter())) {
        if (data.isNotEmpty) {
          final decodedData = jsonDecode(data);
          if (decodedData is List) {
            final eventsList = decodedData
                .map<EventModel>((event) => EventModel.fromMap(event))
                .toList();
            yield eventsList;
          } else {
            yield [];
          }
        } else {
          yield [];
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error getting events stream: $e');
      }
      yield [];
    }
  }
}
