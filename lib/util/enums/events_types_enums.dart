// Definition of the enum
enum EventsTypesEnums {
  conference,
  workshop,
  webinar,
  other,
}

// Extension to add methods to the enum
extension EventsTypesEnumsExtension on EventsTypesEnums {
  // Convert enum to string
  String toShortString() {
    return toString().split('.').last;
  }

  // Static method to convert string back to enum
  static EventsTypesEnums fromString(String value) {
    switch (value.toLowerCase()) {
      case 'conference':
        return EventsTypesEnums.conference;
      case 'workshop':
        return EventsTypesEnums.workshop;
      case 'webinar':
        return EventsTypesEnums.webinar;
      default:
        return EventsTypesEnums.other; // Return 'other' if no match is found
    }
  }

  // Convert enum to a user-friendly string for display
  String toDisplayString() {
    switch (this) {
      case EventsTypesEnums.conference:
        return 'Conference';
      case EventsTypesEnums.workshop:
        return 'Workshop';
      case EventsTypesEnums.webinar:
        return 'Webinar';
      case EventsTypesEnums.other:
        return 'Other Event';
      default:
        return 'Unknown Event';
    }
  }
}
