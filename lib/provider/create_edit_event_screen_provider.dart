import 'package:flutter/material.dart';
import 'package:panda_events/models/event_model.dart';
import 'package:panda_events/services/events_firestore_service.dart';
import 'package:panda_events/util/enums/events_types_enums.dart';

class CreateEditEventScreenProvider with ChangeNotifier {
  final EventsFirestoreService _service = EventsFirestoreService();
  EventModel _eventModel = EventModel.newOne();
  bool _isLoading = false;

  EventModel get eventModel => _eventModel;
  bool get isLoading => _isLoading;

  Future<void> loadEvent(String? id) async {
    _isLoading = true;
    notifyListeners();

    try {
      if (id == null || id.isEmpty) {
        _eventModel = EventModel.newOne();
      } else {
        _eventModel = await _service.getEventById(id);
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveEvent(String? id, Map<String, dynamic> eventData) async {
    _isLoading = true;
    notifyListeners();

    try {
      if (id == null || id.isEmpty) {
        await _service.addEvent(eventData);
      } else {
        await _service.updateEvent(id, eventData);
      }
    } finally {
      try {
        _isLoading = false;
        notifyListeners();
      } catch (e) {
        null;
      }
      ;
    }
  }

  void updateEventModel({
    String? title,
    String? description,
    String? location,
    String? organizer,
    EventsTypesEnums? eventType,
    bool notify = false,
  }) {
    _eventModel = _eventModel.copyWith(
      title: title,
      description: description,
      location: location,
      organizer: organizer,
      eventType: eventType,
    );
    if (notify) {
      notifyListeners();
    }
  }
}
