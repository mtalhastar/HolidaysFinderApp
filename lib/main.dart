import 'package:flutter/material.dart';
import 'package:holidaysapp/screens/addDate.dart';
import 'package:google_fonts/google_fonts.dart';
void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'FlutterChat',
        theme: ThemeData().copyWith(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
              seedColor: Color.fromARGB(255, 194, 218, 255),
          ),
         textTheme: GoogleFonts.latoTextTheme(),
        ),
      home: const DateAdder());
    // child: const Login()
  }
}
