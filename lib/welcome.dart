import 'package:flutter/material.dart';
import 'package:flutter_application_1/home_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to ',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.normal,
              ),
            ),
            Text(
              'WeatherNow!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold, 
                color: Colors.black, 
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, 
              ),
              child: Text(
                'Get Started',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold, 
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
