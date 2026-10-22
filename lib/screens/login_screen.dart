import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  /// The location the user was trying to reach (for redirect after login).
  final String? from;

  const LoginScreen({super.key, this.from});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _nameController = TextEditingController(text: 'Студент');
  final _cardController = TextEditingController(text: 'KB-001');

  @override
  void dispose() {
    _nameController.dispose();
    _cardController.dispose();
    super.dispose();
  }

  void _login() {
    authService.login(
      name: _nameController.text.trim().isEmpty
          ? 'Студент'
          : _nameController.text.trim(),
      cardNumber: _cardController.text.trim().isEmpty
          ? 'KB-001'
          : _cardController.text.trim(),
    );
    final dest = widget.from;
    if (dest != null && dest.isNotEmpty && dest != '/login') {
      context.go(dest);
    } else {
      context.go('/catalog');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Вхід'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock_outline, size: 64),
            const SizedBox(height: 16),
            const Text(
              'Для бронювання книг потрібен вхід',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Ім\'я',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _cardController,
              decoration: const InputDecoration(
                labelText: 'Номер квитка',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _login,
                child: const Text('Увійти'),
              ),
            ),
            TextButton(
              onPressed: () => context.go('/catalog'),
              child: const Text('Скасувати'),
            ),
          ],
        ),
      ),
    );
  }
}
