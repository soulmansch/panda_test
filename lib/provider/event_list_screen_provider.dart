import 'dart:async';

import 'package:flutter/material.dart';
import 'package:panda_events/models/event_model.dart';
import 'package:panda_events/services/events_api_service.dart';
import 'package:panda_events/util/enums/events_types_enums.dart';

class EventListScreenProvider with ChangeNotifier {
  final EventsApiService _service = EventsApiService();
  late final StreamController<List<EventModel>> _eventsController;
  EventsTypesEnums? _selectedEventType;

  Stream<List<EventModel>> get eventsStream => _eventsController.stream;
  EventsTypesEnums? get selectedEventType => _selectedEventType;

  EventListScreenProvider() {
    _eventsController = StreamController<List<EventModel>>.broadcast();
    loadEvents(); // Initialize the stream when the provider is created
  }

  void loadEvents({EventsTypesEnums? eventType}) {
    _selectedEventType = eventType;
    notifyListeners();

    _service.getEventsStream(eventType: _selectedEventType).listen(
      (data) {
        _eventsController.add(data);
      },
      onError: (error) {
        // Handle error appropriately
        _eventsController.addError(error);
      },
    );
  }

  @override
  void dispose() {
    _eventsController.close();
    super.dispose();
  }
}
