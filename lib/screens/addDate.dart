import 'package:flutter/material.dart';
import 'package:holidaysapp/screens/showCalender.dart';

class DateAdder extends StatefulWidget {
  const DateAdder({super.key});

  @override
  State<DateAdder> createState() => _DateAdderState();
}

class _DateAdderState extends State<DateAdder> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String startDate = '';
  String endDate = '';
  String country = '';

  void saveItem() async {
    final validation = _formKey.currentState!.validate();
    if (!validation) {
      return;
    }
    _formKey.currentState!.save();
    Navigator.of(context).push(MaterialPageRoute(
        builder: (ctx) => CalenderPage(
            startDate: startDate, endDate: endDate, country: country)));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Container(
      width: double.infinity,
      color: Colors.black,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10.0),
            child: const Text(
              'Pick Up Dates',
              style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(10.0),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Start Date : YY/MM/DD',
                        ),
                        keyboardType: TextInputType.datetime,
                        validator: (value) {
                          if (value == null ||
                              value.trim().isEmpty ||
                              value.isEmpty) {
                            return 'Invalid Format';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          startDate = value!;
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'End Date :   YY/MM/DD',
                        ),
                        keyboardType: TextInputType.datetime,
                        validator: (value) {
                          if (value == null ||
                              value.trim().isEmpty ||
                              value.isEmpty) {
                            return 'Invalid Format';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          endDate = value!;
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Enter Country e.g US,PK',
                        ),
                        keyboardType: TextInputType.datetime,
                        validator: (value) {
                          if (value == null ||
                              value.trim().length <= 0 ||
                              value.isEmpty) {
                            return 'Invalid Format';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          country = value!;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          saveItem();
                          
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primaryContainer,
                        ),
                        child: const Text('Find Holidays'),
                      ),
                    ],
                  ),
                )),
          )
        ],
      ),
    )));
  }
}
