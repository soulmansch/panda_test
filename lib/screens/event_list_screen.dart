import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:panda_events/screens/event_details_screen.dart';
import 'package:panda_events/util/enums/events_types_enums.dart';
import '../models/event_model.dart';
import '../provider/event_list_screen_provider.dart';
import 'create_edit_event_screen.dart';

class EventsListScreen extends StatelessWidget {
  const EventsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EventListScreenProvider>(
      create: (context) => EventListScreenProvider(),
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Events List'),
              Consumer<EventListScreenProvider>(
                builder: (context, provider, child) {
                  return DropdownButton<EventsTypesEnums>(
                    value: provider.selectedEventType,
                    onChanged: (EventsTypesEnums? newValue) {
                      provider.loadEventsFirebase(eventType: newValue);
                    },
                    items: [
                      const DropdownMenuItem(
                        value: null,
                        child: Text('Show All'),
                      ),
                      ...EventsTypesEnums.values.map((eventType) {
                        return DropdownMenuItem(
                          value: eventType,
                          child: Text(eventType.toDisplayString()),
                        );
                      }),
                    ],
                  );
                },
              ),
            ],
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreateEditEventScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        body: Consumer<EventListScreenProvider>(
          builder: (context, provider, child) {
            return StreamBuilder<List<EventModel>>(
              stream: provider.eventsStreamFirebase,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No events found.'));
                }

                final events = snapshot.data!;
                return ListView.builder(
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final event = events[index];
                    return ListTile(
                      title: Text(event.title),
                      subtitle: Text(event.description),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EventDetailScreen(
                              eventId: event.id,
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
