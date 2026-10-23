import 'package:flutter/material.dart';

import '../widgets/app_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Your System')),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppButton(
                    label: 'Open Login',
                    icon: Icons.login,
                    onPressed: () => Navigator.pushNamed(context, '/login'),
                  ),
                  const SizedBox(height: 12),
                  AppButton(
                    label: 'Open Report Form',
                    icon: Icons.description_outlined,
                    onPressed: () => Navigator.pushNamed(context, '/report'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
