import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../providers/auth_provider.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late final ValueNotifier<List<Event>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final Map<DateTime, List<Event>> _events = {};

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
    _loadSampleEvents();
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  void _loadSampleEvents() {
    // Sample events for demonstration
    final today = DateTime.now();
    _events[DateTime(today.year, today.month, today.day)] = [
      Event('Equipment Maintenance - Elevator A'),
      Event('Water Reading - Building 1'),
    ];
    _events[DateTime(today.year, today.month, today.day + 1)] = [
      Event('Monthly Meeting'),
    ];
    _events[DateTime(today.year, today.month, today.day + 3)] = [
      Event('Cleaning Service'),
      Event('Security Inspection'),
    ];
    _events[DateTime(today.year, today.month, today.day + 7)] = [
      Event('Gas Reading - All Units'),
    ];
  }

  List<Event> _getEventsForDay(DateTime day) {
    final normalizedDay = DateTime(day.year, day.month, day.day);
    return _events[normalizedDay] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });
      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final user = authProvider.user;
        if (user == null) return const SizedBox();

        return Scaffold(
          appBar: AppBar(
            title: const Text('Calendar & Appointments'),
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: _showAddEventDialog,
              ),
            ],
          ),
          body: Column(
            children: [
              // Calendar widget
              Card(
                margin: const EdgeInsets.all(16),
                child: TableCalendar<Event>(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: _focusedDay,
                  calendarFormat: _calendarFormat,
                  eventLoader: _getEventsForDay,
                  startingDayOfWeek: StartingDayOfWeek.sunday,
                  calendarStyle: const CalendarStyle(
                    outsideDaysVisible: false,
                    weekendTextStyle: TextStyle(color: Colors.red),
                    holidayTextStyle: TextStyle(color: Colors.red),
                  ),
                  onDaySelected: _onDaySelected,
                  onFormatChanged: (format) {
                    if (_calendarFormat != format) {
                      setState(() {
                        _calendarFormat = format;
                      });
                    }
                  },
                  onPageChanged: (focusedDay) {
                    _focusedDay = focusedDay;
                  },
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                ),
              ),

              // Events for selected day
              Expanded(
                child: ValueListenableBuilder<List<Event>>(
                  valueListenable: _selectedEvents,
                  builder: (context, events, _) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'Events for ${_selectedDay?.day}/${_selectedDay?.month}/${_selectedDay?.year}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: events.isEmpty
                              ? const Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.event_busy,
                                        size: 64,
                                        color: Colors.grey,
                                      ),
                                      SizedBox(height: 16),
                                      Text(
                                        'No events for this day',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : ListView.builder(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  itemCount: events.length,
                                  itemBuilder: (context, index) {
                                    final event = events[index];
                                    return Card(
                                      margin: const EdgeInsets.only(bottom: 8),
                                      child: ListTile(
                                        leading: const Icon(
                                          Icons.event,
                                          color: Color(0xFF2563EB),
                                        ),
                                        title: Text(event.title),
                                        subtitle: event.description != null 
                                            ? Text(event.description!)
                                            : null,
                                        trailing: event.time != null 
                                            ? Text(event.time!)
                                            : null,
                                        onTap: () => _showEventDetails(event),
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            heroTag: "calendar_fab",
            onPressed: _showAddEventDialog,
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  void _showAddEventDialog() {
    showDialog(
      context: context,
      builder: (context) => AddEventDialog(
        selectedDate: _selectedDay ?? DateTime.now(),
        onEventAdded: (event, date) {
          setState(() {
            final normalizedDate = DateTime(date.year, date.month, date.day);
            if (_events[normalizedDate] != null) {
              _events[normalizedDate]!.add(event);
            } else {
              _events[normalizedDate] = [event];
            }
          });
          _selectedEvents.value = _getEventsForDay(_selectedDay!);
        },
      ),
    );
  }

  void _showEventDetails(Event event) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(event.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (event.description != null) ...[
              const Text(
                'Description:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(event.description!),
              const SizedBox(height: 16),
            ],
            if (event.time != null) ...[
              const Text(
                'Time:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(event.time!),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          TextButton(
            onPressed: () {
              // TODO: Edit event
              Navigator.pop(context);
            },
            child: const Text('Edit'),
          ),
        ],
      ),
    );
  }
}

class Event {
  final String title;
  final String? description;
  final String? time;

  Event(this.title, {this.description, this.time});
}

class AddEventDialog extends StatefulWidget {
  final DateTime selectedDate;
  final Function(Event, DateTime) onEventAdded;

  const AddEventDialog({
    super.key,
    required this.selectedDate,
    required this.onEventAdded,
  });

  @override
  State<AddEventDialog> createState() => _AddEventDialogState();
}

class _AddEventDialogState extends State<AddEventDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _timeController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _eventType = 'Maintenance';

  final List<String> _eventTypes = [
    'Maintenance',
    'Reading',
    'Meeting',
    'Inspection',
    'Cleaning',
    'Repair',
    'Appointment',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        constraints: const BoxConstraints(maxHeight: 600),
        child: Column(
          children: [
            AppBar(
              title: const Text('Add Event'),
              automaticallyImplyLeading: false,
              actions: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                          labelText: 'Event Title',
                          hintText: 'Enter event title...',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an event title';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      DropdownButtonFormField<String>(
                        value: _eventType,
                        decoration: const InputDecoration(
                          labelText: 'Event Type',
                        ),
                        items: _eventTypes.map((type) {
                          return DropdownMenuItem<String>(
                            value: type,
                            child: Text(type),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _eventType = value!;
                          });
                        },
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          labelText: 'Description (Optional)',
                          hintText: 'Enter event description...',
                        ),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _timeController,
                        decoration: const InputDecoration(
                          labelText: 'Time (Optional)',
                          hintText: 'e.g., 09:00 AM',
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Date picker
                      ListTile(
                        title: const Text('Date'),
                        subtitle: Text(
                          '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                        ),
                        leading: const Icon(Icons.calendar_today),
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: _selectedDate,
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(const Duration(days: 365)),
                          );
                          if (date != null) {
                            setState(() {
                              _selectedDate = date;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _submitEvent,
                      child: const Text('Add Event'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitEvent() {
    if (_formKey.currentState!.validate()) {
      final event = Event(
        _titleController.text,
        description: _descriptionController.text.isEmpty 
            ? null 
            : _descriptionController.text,
        time: _timeController.text.isEmpty 
            ? null 
            : _timeController.text,
      );
      
      widget.onEventAdded(event, _selectedDate);
      Navigator.pop(context);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Event added successfully'),
        ),
      );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _timeController.dispose();
    super.dispose();
  }
}