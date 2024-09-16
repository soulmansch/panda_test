import 'package:flutter/material.dart';
import 'package:panda_events/models/event_model.dart';
import 'package:panda_events/services/events_api_service.dart';
import 'package:panda_events/util/enums/events_types_enums.dart';

import '../services/events_firebase_service.dart';

class CreateEditEventScreenProvider with ChangeNotifier {
  final EventsApiService _serviceAPI = EventsApiService();
  final EventsFirestoreService _serviceFirestore = EventsFirestoreService();
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
        _eventModel = await _serviceFirestore.getEventById(id);
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveEvent(
      BuildContext context, String? id, Map<String, dynamic> eventData) async {
    _isLoading = true;
    notifyListeners();
    bool success = false;
    try {
      if (id == null || id.isEmpty) {
        success = await _serviceAPI.addEvent(eventData);
      } else {
        success = await _serviceAPI.updateEvent(id, eventData);
      }
    } finally {
      try {
        _isLoading = false;
        notifyListeners();
      } catch (e) {
        null;
      }
    }

    if (!success) {
      const snackBar = SnackBar(
        content: Text('Something went wrong'),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.blue,
      );

      // Show the SnackBar
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  void updateEventModel({
    String? title,
    String? description,
    String? location,
    String? organizer,
    EventsTypesEnums? eventType,
    DateTime? date,
    bool notify = false,
  }) {
    _eventModel = _eventModel.copyWith(
      title: title,
      description: description,
      location: location,
      organizer: organizer,
      eventType: eventType,
      date: date,
    );
    if (notify) {
      notifyListeners();
    }
  }
}
