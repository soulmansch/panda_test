import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:panda_events/util/enums/events_types_enums.dart';

class EventModel extends Equatable {
  final String id;
  final String title;
  final String description;
  final String location;
  final String organizer;
  final EventsTypesEnums eventType;
  final DateTime date;

  const EventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.organizer,
    required this.eventType,
    required this.date,
  });

  @override
  List<Object?> get props => [id]; // Compare based on id only

  // Convert from Map to EventModel
  factory EventModel.fromMap(Map<String, dynamic> map) {
    DateTime parsedDate = DateTime.now();

    // Safely handle date conversion
    if (map['date'] is Timestamp) {
      parsedDate = (map['date'] as Timestamp).toDate();
    } else if (map['date'] is DateTime) {
      parsedDate = map['date'] as DateTime;
    }
    return EventModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      location: map['location'] ?? '',
      organizer: map['organizer'] ?? '',
      eventType: EventsTypesEnumsExtension.fromString(
          map['eventType'] ?? EventsTypesEnums.other.toShortString()),
      date: parsedDate,
    );
  }

  // Convert EventModel to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'location': location,
      'organizer': organizer,
      'eventType': eventType.toShortString(),
      'date': date.toIso8601String(),
    };
  }

  // Convert Firestore Document to EventModel
  factory EventModel.fromFirestore(DocumentSnapshot document) {
    final data = document.data() as Map<String, dynamic>;
    return EventModel.fromMap(data);
  }

  // Convert a list of Firestore Documents to a list of EventModels
  static List<EventModel> fromListDocuments(List<DocumentSnapshot> documents) {
    return documents.map((doc) => EventModel.fromFirestore(doc)).toList();
  }

  // Convert a list of Maps to a list of EventModels
  static List<EventModel> fromListMaps(List<Map<String, dynamic>> maps) {
    return maps.map((map) => EventModel.fromMap(map)).toList();
  }

  // An empty event
  factory EventModel.newOne() {
    return EventModel.fromMap(const {});
  }

  // Copy with updated properties
  EventModel copyWith({
    String? id,
    String? title,
    String? description,
    String? location,
    String? organizer,
    EventsTypesEnums? eventType,
    DateTime? date,
  }) {
    return EventModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      location: location ?? this.location,
      organizer: organizer ?? this.organizer,
      eventType: eventType ?? this.eventType,
      date: date ?? this.date,
    );
  }
}
