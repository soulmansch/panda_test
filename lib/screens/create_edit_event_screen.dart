import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:panda_events/util/enums/events_types_enums.dart';

import '../provider/create_edit_event_screen_provider.dart';
import '../util/helpers.dart';
import 'loading_screen.dart';

class CreateEditEventScreen extends StatelessWidget {
  final String? eventId;

  const CreateEditEventScreen({super.key, this.eventId});

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

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
                    if (_formKey.currentState!.validate()) {
                      provider.saveEvent(
                          context, eventId, provider.eventModel.toMap());
                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey, // Assign the form key
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: provider.eventModel.title,
                      decoration: const InputDecoration(labelText: 'Title'),
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter a title' : null,
                      onChanged: (value) {
                        provider.updateEventModel(title: value);
                      },
                    ),
                    TextFormField(
                      initialValue: provider.eventModel.description,
                      decoration:
                          const InputDecoration(labelText: 'Description'),
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter a description' : null,
                      onChanged: (value) {
                        provider.updateEventModel(description: value);
                      },
                    ),
                    TextFormField(
                      initialValue: provider.eventModel.location,
                      decoration: const InputDecoration(labelText: 'Location'),
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter a location' : null,
                      onChanged: (value) {
                        provider.updateEventModel(location: value);
                      },
                    ),
                    TextFormField(
                      initialValue: provider.eventModel.organizer,
                      decoration: const InputDecoration(labelText: 'Organizer'),
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter an organizer' : null,
                      onChanged: (value) {
                        provider.updateEventModel(organizer: value);
                      },
                    ),
                    DropdownButtonFormField<EventsTypesEnums>(
                      value: provider.eventModel.eventType,
                      decoration:
                          const InputDecoration(labelText: 'Event Type'),
                      items: EventsTypesEnums.values.map((eventType) {
                        return DropdownMenuItem(
                          value: eventType,
                          child: Text(eventType.toShortString()),
                        );
                      }).toList(),
                      validator: (value) =>
                          value == null ? 'Please select an event type' : null,
                      onChanged: (value) {
                        provider.updateEventModel(eventType: value);
                      },
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          showDatePicker(
                            context: context,
                            initialDate: provider.eventModel.date,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          ).then((pickedDate) {
                            if (pickedDate != null) {
                              provider.updateEventModel(
                                  date: pickedDate, notify: true);
                            }
                          });
                        },
                        child: Text(
                            'Date: ${getFormattedDate(provider.eventModel.date)}'),
                      ),
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
