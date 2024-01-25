import 'package:calendar_widget_creation/calendar/event_provider.dart';
import 'package:calendar_widget_creation/calendar/events.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EventCreator extends StatefulWidget {
  final Events? event;

  const EventCreator({
    Key? key,
    this.event,
  }) : super(key: key);

  @override
  State<EventCreator> createState() => _EventCreatorState();
}

class _EventCreatorState extends State<EventCreator> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController titleController;
  late final TextEditingController dateController;
  late final TextEditingController _description;
  late final TextEditingController _startTimeController;
  late final TextEditingController _endTimeController;

  late Color selectedColor = Colors.blue;

  late DateTime fromDate;
  late DateTime toDate;
  late bool allDay = false;

  @override
  void initState() {
    titleController = TextEditingController();
    dateController = TextEditingController();
    _description = TextEditingController();
    _startTimeController = TextEditingController();
    _endTimeController = TextEditingController();

    if (widget.event == null) {
      fromDate = DateTime.now();
      toDate = DateTime.now().add(const Duration(hours: 2));
    }
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    _description.dispose();
    dateController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();

    super.dispose();
  }

  Future mergerForDates() async {
    String val1 = DateFormat.yMMMEd().format(fromDate).toString();
    String val2 = DateFormat.yMMMEd().format(toDate).toString();

    if (val1 != val2) {
      fromDate = DateTime(
        fromDate.year,
        fromDate.month,
        fromDate.day,
        fromDate.hour,
        fromDate.minute,
      );

      toDate = DateTime(
        fromDate.year,
        fromDate.month,
        fromDate.day,
        toDate.hour,
        toDate.minute,
      );
    }
  }

  Future pickFromDateTime({required bool pickDate, required int val}) async {
    final date = await pickDateTime(fromDate, pickDate: pickDate, val: val);

    if (date == null) return null;

    if (date.isAfter(toDate)) {
      toDate =
          DateTime(date.year, date.month, date.day, toDate.hour, toDate.minute);
    }

    setState(() {
      fromDate = date;
    });
  }

  Future pickToDateTime({required bool pickDate, required int val}) async {
    final date = await pickDateTime(
      toDate,
      pickDate: pickDate,
      firstDate: pickDate ? fromDate : null,
      val: val,
    );

    if (date == null) return null;

    setState(() {
      toDate = date;
    });
  }

  Future<DateTime?> pickDateTime(
    DateTime initdate, {
    required bool pickDate,
    DateTime? firstDate,
    int? val,
  }) async {
    if (pickDate) {
      final date = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(19999),
      );

      if (date == null) {
        return null;
      }

      final time = Duration(
        hours: initdate.hour,
        minutes: initdate.minute,
      );

      setState(() {
        dateController.text = DateFormat.yMMMEd().format(date).toString();
      });

      return date.add(time);
    } else {
      final timeOfDay = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initdate),
      );

      if (timeOfDay == null) return null;

      final date = DateTime(initdate.year, initdate.month, initdate.day);
      final time = Duration(hours: timeOfDay.hour, minutes: timeOfDay.minute);

      setState(() {
        if (val == 0) {
          _startTimeController.text =
              MaterialLocalizations.of(context).formatTimeOfDay(timeOfDay);
        } else if (val == 1) {
          _endTimeController.text =
              MaterialLocalizations.of(context).formatTimeOfDay(timeOfDay);
        }
      });

      return date.add(time);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create New Event"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Row(
            children: [
              const SizedBox(
                width: 5,
              ),
              Expanded(
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(10),
                    ),
                    Title(),
                    const Padding(
                      padding: EdgeInsets.all(5),
                    ),
                    Date(),
                    const Padding(
                      padding: EdgeInsets.all(5),
                    ),
                    Row(
                      children: [
                        FromTime(),
                        EndTime(),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.all(5),
                    ),
                    Description(),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: SaveEvent(context),
                    )
                  ],
                ),
              ),
              const SizedBox(
                width: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget SaveEvent(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        textStyle: const TextStyle(fontSize: 20),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      onPressed: () async {
        saveForm();
      },
      child: const Wrap(
        children: <Widget>[
          Icon(Icons.add_box_rounded),
          SizedBox(
            width: 5,
          ),
          Text("Add Event"),
        ],
      ),
    );
  }

  Widget Description() {
    return TextFormField(
      controller: _description,
      keyboardType: TextInputType.multiline,
      autocorrect: true,
      minLines: 2,
      maxLines: 5,
      maxLength: 1000,
      onChanged: (value) {
        setState(() {});
      },
      decoration: InputDecoration(
        labelText: "Description",
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color.fromARGB(144, 71, 60, 60)),
          borderRadius: BorderRadius.circular(20.0),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.blue,
          ),
        ),
        counterText: '${_description.text.length.toString()}/1000',
        counterStyle: const TextStyle(
          fontSize: 14,
        ),
      ),
    );
  }

  Widget EndTime() {
    return Expanded(
      child: ListTile(
        subtitle: TextFormField(
          controller: _endTimeController,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (date) {
            if (date != null && date.isEmpty) {
              return "Empty!!!";
            } else {
              return null;
            }
          },
          decoration: const InputDecoration(
            labelText: "End Time",
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.blue,
              ),
            ),
          ),
          readOnly: true,
          onTap: () {
            pickToDateTime(pickDate: false, val: 1);
            mergerForDates();
          },
        ),
      ),
    );
  }

  Widget FromTime() {
    return Expanded(
      child: ListTile(
        subtitle: TextFormField(
          controller: _startTimeController,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (date) {
            if (date != null && date.isEmpty) {
              return "Empty!!!";
            } else {
              return null;
            }
          },
          decoration: const InputDecoration(
            labelText: "Start Time",
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.blue,
              ),
            ),
          ),
          readOnly: true,
          onTap: () {
            pickFromDateTime(pickDate: false, val: 0);
            mergerForDates();
          },
        ),
      ),
    );
  }

  Widget Date() {
    return TextFormField(
      controller: dateController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (date) {
        if (date != null && date.isEmpty) {
          return "Date cannot be empty";
        } else {
          return null;
        }
      },
      decoration: InputDecoration(
        labelText: "Date",
        prefixIcon: const Icon(Icons.calendar_today),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color.fromARGB(144, 71, 60, 60)),
          borderRadius: BorderRadius.circular(20.0),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.blue,
          ),
        ),
      ),
      readOnly: true,
      onTap: () {
        pickFromDateTime(pickDate: true, val: -1);
        mergerForDates();
      },
    );
  }

  Widget Title() {
    return TextFormField(
      controller: titleController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: TextInputType.name,
      onFieldSubmitted: (_) {},
      validator: (title) {
        if (title != null && title.isEmpty) {
          return "Title cannot be empty";
        } else {
          return null;
        }
      },
      autocorrect: true,
      decoration: InputDecoration(
        labelText: "Title",
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color.fromARGB(144, 71, 60, 60)),
          borderRadius: BorderRadius.circular(20.0),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.blue,
          ),
        ),
      ),
    );
  }

  Future saveForm() async {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      final event = Events(
        eventName: titleController.text,
        from: fromDate,
        to: toDate,
        desc: _description.text ?? "",
        background: selectedColor,
      );

      final provider = Provider.of<EventProvider>(context, listen: false);
      provider.addEvent(event);

      Navigator.of(context).pop();
    } else {}
  }
}
