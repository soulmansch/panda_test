import 'package:flutter/material.dart';
import 'package:panda_events/models/event_model.dart';
import 'package:panda_events/services/events_firestore_service.dart';
import 'package:panda_events/util/enums/events_types_enums.dart';

class EventListScreenProvider with ChangeNotifier {
  final EventsFirestoreService _service = EventsFirestoreService();
  Stream<List<EventModel>>? _eventsStream;
  EventsTypesEnums? _selectedEventType;

  Stream<List<EventModel>>? get eventsStream => _eventsStream;
  EventsTypesEnums? get selectedEventType => _selectedEventType;

  EventListScreenProvider() {
    loadEvents(); // Initialize the stream when the provider is created
  }

  void loadEvents({EventsTypesEnums? eventType}) {
    _selectedEventType = eventType;
    notifyListeners();

    _eventsStream = _service.getEventsStream(eventType: _selectedEventType);
    _eventsStream!.listen(
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
    _eventsStream = null;
    super.dispose();
  }
}
