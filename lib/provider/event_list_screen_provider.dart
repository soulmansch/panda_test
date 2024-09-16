import 'dart:async';

import 'package:flutter/material.dart';
import 'package:panda_events/models/event_model.dart';
import 'package:panda_events/services/events_api_service.dart';
import 'package:panda_events/util/enums/events_types_enums.dart';

import '../services/events_firebase_service.dart';

class EventListScreenProvider with ChangeNotifier {
  final EventsApiService _serviceAPI = EventsApiService();
  final EventsFirestoreService _serviceFirebase = EventsFirestoreService();
  late final StreamController<List<EventModel>> _eventsControllerApi;
  Stream<List<EventModel>>? _eventsStreamFirebase;
  EventsTypesEnums? _selectedEventType;

  Stream<List<EventModel>> get eventsStreamAPI => _eventsControllerApi.stream;
  Stream<List<EventModel>>? get eventsStreamFirebase => _eventsStreamFirebase;

  EventsTypesEnums? get selectedEventType => _selectedEventType;

  EventListScreenProvider() {
    // _eventsControllerApi = StreamController<List<EventModel>>.broadcast();
    loadEventsFirebase(); // Initialize the stream when the provider is created
  }

  void loadEventsAPI({EventsTypesEnums? eventType}) {
    _selectedEventType = eventType;
    notifyListeners();

    _serviceAPI.getEventsStream(eventType: _selectedEventType).listen(
      (data) {
        _eventsControllerApi.add(data);
      },
      onError: (error) {
        // Handle error appropriately
        _eventsControllerApi.addError(error);
      },
    );
  }

  void loadEventsFirebase({EventsTypesEnums? eventType}) {
    _selectedEventType = eventType;
    notifyListeners();

    _eventsStreamFirebase =
        _serviceFirebase.getEventsStream(eventType: _selectedEventType);
    _eventsStreamFirebase!.listen(
      (data) {
        notifyListeners();
      },
      onDone: () {
        notifyListeners();
      },
      onError: (error) {
        notifyListeners();
      },
    );
  }

  @override
  void dispose() {
    _eventsControllerApi.close();
    _eventsStreamFirebase = null;

    super.dispose();
  }
}
