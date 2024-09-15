import 'package:flutter/material.dart';
import 'package:panda_events/util/enums/events_types_enums.dart';
import 'package:provider/provider.dart';
import 'package:panda_events/provider/event_details_screen_provider.dart';

import '../models/event_model.dart';
import '../util/helpers.dart';
import 'create_edit_event_screen.dart';
import 'loading_screen.dart';

class EventDetailScreen extends StatelessWidget {
  final String eventId;

  const EventDetailScreen({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EventDetailsScreenProvider>(
      create: (context) => EventDetailsScreenProvider(eventId),
      child: Consumer<EventDetailsScreenProvider>(
        builder: (context, provider, child) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Event Details'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreateEditEventScreen(
                                eventId: eventId,
                              )),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _deleteEvent(context, provider),
                ),
              ],
            ),
            body: StreamBuilder<EventModel?>(
              stream: provider.eventStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LoadingScreen();
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData) {
                  return const Center(child: Text('No Event Data'));
                }
                if (snapshot.data == null) {
                  return const Center(
                    child: Text("Not found"),
                  );
                }

                final event = snapshot.data!;

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Title: ${event.title}'),
                      const SizedBox(height: 8),
                      Text('Description: ${event.description}'),
                      const SizedBox(height: 8),
                      Text('Location: ${event.location}'),
                      const SizedBox(height: 8),
                      Text('Organizer: ${event.organizer}'),
                      const SizedBox(height: 8),
                      Text('Event Type: ${event.eventType.toDisplayString()}'),
                      const SizedBox(height: 8),
                      Text('Date: ${getFormattedDate(event.date)}'),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Future<void> _deleteEvent(
      BuildContext context, EventDetailsScreenProvider provider) async {
    final bool? confirmed = await _showDeleteConfirmationDialog(context);
    if (!context.mounted) return;

    if (confirmed == true) {
      await provider.deleteEvent(eventId);

      if (context.mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  Future<bool?> _showDeleteConfirmationDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Delete Event'),
          content: const Text('Are you sure you want to delete this event?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
