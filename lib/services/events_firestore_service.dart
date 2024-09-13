import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:panda_events/util/enums/events_types_enums.dart';
import 'package:uuid/uuid.dart';

import '../models/event_model.dart';

class EventsFirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  static const collectionName = 'events';

  Future<void> addEvent(Map<String, dynamic> eventData) async {
    // Generate a UUID
    final String id = const Uuid().v4();
    // Add the event with ID to Firestore
    EventModel eventModel = EventModel.fromMap(eventData);

    await _db
        .collection(collectionName)
        .doc(id)
        .set(eventModel.copyWith(id: id).toMap());
  }

  Future<void> updateEvent(String id, Map<String, dynamic> eventData) async {
    await _db.collection(collectionName).doc(id).update(eventData);
  }

  Future<void> deleteEvent(String id) async {
    await _db.collection(collectionName).doc(id).delete();
  }

  Future<EventModel> getEventById(String id) async {
    if (id.isEmpty) {
      return EventModel.newOne(); // Return empty EventModel if ID is empty
    }

    try {
      DocumentSnapshot snapshot =
          await _db.collection(collectionName).doc(id).get();
      if (!snapshot.exists) {
        return EventModel.newOne(); // Return empty EventModel if not found
      }
      return EventModel.fromFirestore(snapshot);
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching event by ID: $e');
      }
      return EventModel.newOne(); // Return empty EventModel on error
    }
  }

  Future<List<EventModel>> getEvents({EventsTypesEnums? eventType}) async {
    Query query = _db.collection(collectionName);

    if (eventType != null) {
      query = query.where('eventType', isEqualTo: eventType.toShortString());
    }

    try {
      QuerySnapshot snapshot = await query.get();
      return EventModel.fromListDocuments(snapshot.docs);
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching events: $e');
      }
      return []; // Return empty list on error
    }
  }

  Stream<EventModel> getEventByIdStream(String id) {
    if (id.isEmpty) {
      return Stream.value(EventModel.newOne());
    }

    return _db.collection(collectionName).doc(id).snapshots().map((snapshot) {
      if (!snapshot.exists) {
        return EventModel.newOne(); // Return empty EventModel if not found
      }
      return EventModel.fromFirestore(snapshot);
    });
  }

  Stream<List<EventModel>> getEventsStream({EventsTypesEnums? eventType}) {
    Query query = _db.collection(collectionName);

    if (eventType != null) {
      query = query.where('eventType', isEqualTo: eventType.toShortString());
    }

    return query.snapshots().map((snapshot) {
      return EventModel.fromListDocuments(snapshot.docs);
    });
  }
}
