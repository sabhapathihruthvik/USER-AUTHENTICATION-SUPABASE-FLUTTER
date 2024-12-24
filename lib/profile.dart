import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});
  final SupabaseClient _supabase = Supabase.instance.client;
  void logOut(BuildContext context) async {
    await Supabase.instance.client.auth.signOut();
    // ignore: use_build_context_synchronously
    if (Navigator.canPop(context)) {
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    String? getCurrentUserEmail() {
      final session = _supabase.auth.currentSession;
      final user = session?.user;
      return user?.email;
    }

    final currentUserEmail = getCurrentUserEmail();

    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("PROFILE!")),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              logOut(context);
            },
          )
        ],
      ),
      body: Center(
        child: Text(
          currentUserEmail != null
              ? 'This is your email: $currentUserEmail'
              : 'No user logged in.',
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
