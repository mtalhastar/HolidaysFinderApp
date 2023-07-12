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
      required this.country,
      required this.wage,
      required this.workingHours});
  final String startDate;
  final String endDate;
  final String country;
  final String wage;
  final String workingHours;
  @override
  State<CalenderPage> createState() => _CalenderPageState();
}

class _CalenderPageState extends State<CalenderPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  Map<DateTime, List<Holiday>> _holidays = {};

  dynamic workingdays = 0;
  dynamic totalwage = 0;

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
      
        getWorkingDays();
      

    } else {
      // Request failed
      showSnacks();
    }
    // Map the holidays to their respective dates
  }

  void getWorkingDays() async {
    var url = Uri.parse('https://working-days.p.rapidapi.com/1.3/analyse')
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
   
      workingdays = data['working_days']['total'];
      final day = int.parse(widget.workingHours) * int.parse(widget.wage);
      
      setState(() {
        totalwage = day * workingdays;
      });
    } else {
      workingdays = 0;
    }
  }

  void showSnacks() {
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
        child: Column(
          children:[ TableCalendar(
            firstDay: DateTime.parse(widget.startDate),
            lastDay: DateTime.parse(widget.endDate),
            focusedDay: DateTime.parse(widget.startDate),
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
            calendarStyle: const CalendarStyle(
              holidayTextStyle: TextStyle(color: Colors.red),
            ),
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
                 Text('Working Days : $workingdays',style: const TextStyle(
                   fontSize: 16,
                   color: Colors.black
                 ),),
                 Text(
                'Total Wage \$ $totalwage',
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
            ],
          )
          
          ]
        ),
      ),
    );
  }
}
