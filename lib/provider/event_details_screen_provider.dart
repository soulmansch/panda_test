import 'package:flutter/material.dart';
import 'package:panda_events/models/event_model.dart';

import '../services/events_firebase_service.dart';

class EventDetailsScreenProvider with ChangeNotifier {
  final EventsFirestoreService _service = EventsFirestoreService();
  late Stream<EventModel?> _eventStream;

  EventDetailsScreenProvider(String eventId) {
    _eventStream = _service.getEventByIdStream(eventId);
  }

  Stream<EventModel?> get eventStream => _eventStream;

  Future<void> deleteEvent(String id) async {
    notifyListeners();
    await _service.deleteEvent(id);
    notifyListeners();
  }
}
