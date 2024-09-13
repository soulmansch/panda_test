import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:panda_events/util/enums/events_types_enums.dart';

import '../provider/create_edit_event_screen_provider.dart';
import 'loading_screen.dart';

class CreateEditEventScreen extends StatelessWidget {
  final String? eventId;

  const CreateEditEventScreen({super.key, this.eventId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CreateEditEventScreenProvider()..loadEvent(eventId),
      child: Consumer<CreateEditEventScreenProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const LoadingScreen();
          }

          return Scaffold(
            appBar: AppBar(
              title: Text(provider.eventModel.id.isEmpty
                  ? 'Create Event'
                  : 'Edit Event'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.save),
                  onPressed: () {
                    provider.saveEvent(eventId, provider.eventModel.toMap());
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: GlobalKey<FormState>(),
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: provider.eventModel.title,
                      decoration: const InputDecoration(labelText: 'Title'),
                      validator: (value) =>
                          value!.isEmpty ? 'Enter a title' : null,
                      onChanged: (value) {
                        provider.updateEventModel(title: value);
                      },
                    ),
                    TextFormField(
                      initialValue: provider.eventModel.description,
                      decoration:
                          const InputDecoration(labelText: 'Description'),
                      onChanged: (value) {
                        provider.updateEventModel(description: value);
                      },
                    ),
                    TextFormField(
                      initialValue: provider.eventModel.location,
                      decoration: const InputDecoration(labelText: 'Location'),
                      onChanged: (value) {
                        provider.updateEventModel(location: value);
                      },
                    ),
                    TextFormField(
                      initialValue: provider.eventModel.organizer,
                      decoration: const InputDecoration(labelText: 'Organizer'),
                      onChanged: (value) {
                        provider.updateEventModel(organizer: value);
                      },
                    ),
                    DropdownButtonFormField<EventsTypesEnums>(
                      value: provider.eventModel.eventType,
                      items: EventsTypesEnums.values.map((eventType) {
                        return DropdownMenuItem(
                          value: eventType,
                          child: Text(eventType.toShortString()),
                        );
                      }).toList(),
                      onChanged: (value) {
                        provider.updateEventModel(eventType: value);
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
