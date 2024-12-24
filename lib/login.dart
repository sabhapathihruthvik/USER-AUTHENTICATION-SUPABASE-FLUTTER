import 'package:auth_supabase/profile.dart';
import 'package:auth_supabase/signup.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final supabase = Supabase.instance.client;
  final email = TextEditingController();
  final password = TextEditingController();

  @override
  void dispose() {
    email.dispose(); // Clears the text and releases resources
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Supabase Login"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          TextField(
            controller: email,
            decoration: const InputDecoration(labelText: "Email"),
            keyboardType: TextInputType.emailAddress,
          ),
          TextField(
            controller: password,
            decoration: const InputDecoration(labelText: "Password"),
            obscureText: true,
          ),
          const SizedBox(height: 20),
          MaterialButton(
            color: Theme.of(context).primaryColor,
            textColor: Colors.white,
            onPressed: () async {
              final sm = ScaffoldMessenger.of(context);
              try {
                final response = await supabase.auth.signInWithPassword(
                  email: email.text.trim(),
                  password: password.text.trim(),
                );

                if (response.user != null) {
                  sm.showSnackBar(SnackBar(
                    content: Text("Welcome, ${response.user!.email}!"),
                  ));

                  // Navigate to the profile page and clear fields after returning
                  await Navigator.push(
                    // ignore: use_build_context_synchronously
                    context,
                    MaterialPageRoute(builder: (_) => ProfilePage()),
                  );

                  // Clear the fields after navigating back
                  email.clear();
                  password.clear();
                } else {
                  sm.showSnackBar(const SnackBar(
                    content: Text("Invalid credentials. Please try again."),
                  ));
                }
              } catch (e) {
                sm.showSnackBar(SnackBar(
                  content: Text("Error: ${e.toString()}"),
                ));
              }
            },
            child: const Text("Log In"),
          ),
          const SizedBox(
            height: 20,
          ),
          MaterialButton(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SignUp()),
              );

              // Clear fields when returning from the signup page
              email.clear();
              password.clear();
            },
            child: const Center(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Don't have an account yet? Sign up here!",
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
