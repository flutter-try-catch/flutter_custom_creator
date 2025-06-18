import 'package:flutter/material.dart';
import 'package:my_app/config/auth/auth_manager.dart';
import 'package:my_app/config/theme/theme_manager.dart';
import 'package:provider/provider.dart';
import '../../../../injection_container.dart';
import '../provider/test_provider.dart';

final userData = {'id': '1', 'name': 'أحمد', 'email': 'ahmed@example.com'};

class TestScreen extends StatefulWidget {
  static const routeName = "/test";
  const TestScreen({super.key});
  @override
  State<TestScreen> createState() => _TestState();
}

class _TestState extends State<TestScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => getIt<TestProvider>(),
      child: Consumer<TestProvider>(
        builder: (context, provider, child) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Test Screen"),
                  SizedBox(height: 20),
                  Text("This is a test screen using Provider and GetIt."),
                  SizedBox(height: 20),
                  // toggle button to change theme
                  ElevatedButton(
                    onPressed: toggleTheme,
                    child: Text("Toggle Theme"),
                  ),
                  SizedBox(height: 20),
                  authManager.isLoggedIn
                      ? ElevatedButton(
                          onPressed: () {
                            authManager.logout();
                          },
                          child: Text("Logout"),
                        )
                      : ElevatedButton(
                          onPressed: () {
                            authManager.login(userData);
                          },
                          child: Text("Login"),
                        ),

                  SizedBox(height: 20),
                  Text(
                    "Current User: ${authManager.currentUser ?? 'No user logged in'}",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
