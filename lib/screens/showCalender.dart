import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:holidaysapp/screens/addDate.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:holidaysapp/model/holiday.dart';
import 'package:http/http.dart' as http;

class CalenderPage extends StatefulWidget {
  const CalenderPage(
      {super.key,
      required this.startDate,
      required this.endDate,
      required this.country});
  final String startDate;
  final String endDate;
  final String country;
  @override
  State<CalenderPage> createState() => _CalenderPageState();
}

class _CalenderPageState extends State<CalenderPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  Map<DateTime, List<Holiday>> _holidays = {};

  @override
  void initState() {
    super.initState();
    _initializeHolidays();
  }

  void _initializeHolidays() async {
    var url = Uri.parse(
            'https://working-days.p.rapidapi.com/1.3/list_non_working_days')
        .replace(queryParameters: {
      'country_code': widget.country,
      'start_date': widget.startDate,
      'end_date': widget.endDate,
      'configuration': 'Federal holidays',
    });
    // Replace with your endpoint URL

    var response = await http.get(
      url,
      headers: {
        'X-RapidAPI-Key': 'f459110d40msh4ac1e13f6151011p11c70ajsn087c7c69df2d',
        'X-RapidAPI-Host': 'working-days.p.rapidapi.com',
      },
    );

    if (response.statusCode == 200) {
      // Request successful
      var jsonResponse = response.body;
      // Process the response here

      var data = jsonDecode(jsonResponse);
      // Process the response here
      List<Holiday> holidays = [];
      for (var item in data['non_working_days']) {
        var holiday = Holiday(
          date: DateTime.parse(item['date']),
          description: item['description'],
          type: item['type'],
        );
        holidays.add(holiday);
      }

      _holidays = Map.fromIterable(
        holidays,
        key: (holiday) => holiday.date,
        value: (holiday) => [holiday],
      );
      // Print the list of holidays

      setState(() {});
    } else {
      // Request failed
      showSnacks();
    }
    // Map the holidays to their respective dates
  }

  void showSnacks() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Something Wrong With Request-Try Again'),
        duration: Duration(seconds: 1),
      ),
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Holiday Calendar'),
        backgroundColor: Color.fromARGB(255, 9, 8, 12),
        foregroundColor: Colors.white,
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
            color: Colors.white,
            gradient: LinearGradient(colors: [
              Color.fromARGB(0, 0, 142, 251),
              Color.fromARGB(255, 240, 237, 248),
            ])),
        child: TableCalendar(
          firstDay: DateTime.utc(2023, 1, 1),
          lastDay: DateTime.utc(2023, 12, 31),
          focusedDay: _selectedDay,
          calendarFormat: _calendarFormat,
          holidayPredicate: (day) {
            // Weekends
            // Check if the selected day is a holiday
            final isHoliday =
                _holidays.keys.any((date) => isSameDay(date, day));

            // Weekends
            // final dayTime = DateTime( day.year, day.month, day.day);
            return isHoliday;
          },
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
            });
          },
          calendarStyle: const CalendarStyle(
            holidayTextStyle: TextStyle(color: Colors.red),
          ),
          headerStyle: const HeaderStyle(
            formatButtonVisible: false,
          ),
        ),
      ),
    );
  }
}
