import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize
  (
  url: 'https://scitvrburkmxlzznpbux.supabase.co', 
  anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNjaXR2cmJ1cmtteGx6em5wYnV4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDgwMTE0MjksImV4cCI6MjA2MzU4NzQyOX0.8YrkwJsOH5pkG7WWxEIx4561ZLfVUp0LrtGfBhbwfqE'
  );
  runApp(SignupApp());
}

class SignupApp extends StatelessWidget
{
  const SignupApp({super.key});

  @override
  Widget build(BuildContext context)
  {
    return MaterialApp
    (
      title: 'Signup',
      theme: ThemeData
      (
        primarySwatch: Colors.blue,
      ),
      home: SignUpPage(),
    );
  }
}

class SignUpPage extends StatefulWidget
{
  const SignUpPage({super.key});

  @override
  SignUpPageState createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage>
{
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _signUp() async
  {
    final response = await Supabase.instance.client.auth.signUp
    (
      email: _emailController.text,
      password: _passwordController.text,
    );
    if (response.error != null)
    {
      debugPrint('Error signing up: ${response.error!.message}');
    }
    else
    {
      debugPrint('User signed up: ${response.user}');
    }
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold
    (
      appBar: AppBar(title: Text('Sign Up')),
      body: Padding
      (
        padding: const EdgeInsets.all(16.0),
        child: Column
        (
          children:
          [
            TextField
            (
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField
            (
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            ElevatedButton
            (
              onPressed: _signUp,
              child: Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}

extension on AuthResponse
{
  get error => null;
}