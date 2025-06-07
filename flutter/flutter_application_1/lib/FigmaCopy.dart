import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main()
{
  runApp
  (
    MaterialApp
    (
      home: OnboardingScreen(),
      debugShowCheckedModeBanner: false,
    )
  );
}

class OnboardingScreen extends StatelessWidget
{
  final TextEditingController nameController = TextEditingController();

  OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context)
  {
    return Scaffold
    (
      backgroundColor: Colors.white,
      body: SafeArea
      (
        child: Container
        (
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column
          (
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children:
            [
              Container
              (
                margin: EdgeInsets.only(top: 12),
                child: LinearProgressIndicator
                (
                  value: 0.25,
                  backgroundColor: Colors.grey,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF003E18)),
                ),
              ),
              Container(height: 80),
              Container
              (
                alignment: Alignment.center,
                child: Text
                (
                  'Fitly',
                  style: GoogleFonts.nunito
                  (
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(height: 24),
              Container
              (
                alignment: Alignment.center,
                child: Text
                (
                  'Before we dive in, what’s the\nname we’ll be cheering for?',
                  textAlign: TextAlign.center,
                  style: TextStyle
                  (
                    fontSize: 20,
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(height: 32),
              Container
              (
                decoration: BoxDecoration
                (
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(color: Colors.grey),
                ),
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: TextField
                (
                  controller: nameController,
                  decoration: InputDecoration
                  (
                    hintText: 'Preferred First Name',
                    border: InputBorder.none,
                  ),
                ),
              ),
              Spacer(),
              Container
              (
                width: double.infinity,
                child: ElevatedButton
                (
                  onPressed: ()
                  {
                    debugPrint('Next pressed: ${nameController.text}');
                  },
                  style: ElevatedButton.styleFrom
                  (
                    backgroundColor: Color(0xFF003E18),
                    padding: EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder
                    (
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                  child: Text
                  (
                    'Next',
                    style: TextStyle
                    (
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Container(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}