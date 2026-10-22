import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _cardController;
  bool _dirty = false;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _cardController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _nameController.text = authService.name;
      _cardController.text = authService.cardNumber;
      _nameController.addListener(_markDirty);
      _cardController.addListener(_markDirty);
      _initialized = true;
    }
  }

  void _markDirty() {
    if (!_dirty) setState(() => _dirty = true);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cardController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!authService.isLoggedIn) {
      authService.login(
        name: _nameController.text.trim().isEmpty
            ? 'Студент'
            : _nameController.text.trim(),
        cardNumber: _cardController.text.trim().isEmpty
            ? 'KB-001'
            : _cardController.text.trim(),
      );
    } else {
      authService.updateProfile(
        _nameController.text.trim(),
        _cardController.text.trim(),
      );
    }
    setState(() => _dirty = false);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Профіль збережено')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: authService,
      builder: (context, _) {
        return PopScope(
          canPop: !_dirty,
          onPopInvokedWithResult: (didPop, result) async {
            if (didPop) return;
            final shouldLeave = await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('Незбережені зміни'),
                content: const Text(
                  'Є незбережені зміни в профілі. Вийти без збереження?',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(false),
                    child: const Text('Залишитись'),
                  ),
                  FilledButton(
                    onPressed: () => Navigator.of(ctx).pop(true),
                    child: const Text('Вийти'),
                  ),
                ],
              ),
            );
            if (shouldLeave == true && context.mounted) {
              // Reset controllers to last saved values
              _nameController.text = authService.name;
              _cardController.text = authService.cardNumber;
              setState(() => _dirty = false);
              // Allow pop by navigating away via shell
            }
          },
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Профіль'),
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              actions: [
                if (authService.isLoggedIn)
                  IconButton(
                    icon: const Icon(Icons.logout),
                    tooltip: 'Вийти',
                    onPressed: () {
                      authService.logout();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Ви вийшли з акаунту')),
                      );
                    },
                  ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (authService.isLoggedIn) ...[
                    const Icon(Icons.person, size: 64),
                    const SizedBox(height: 8),
                    Text(
                      'Увійшли як',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ] else ...[
                    const Icon(Icons.person_outline, size: 64),
                    const SizedBox(height: 8),
                    Text(
                      'Гість — увійдіть, щоб бронювати книги',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                  const SizedBox(height: 24),
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Ім\'я',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.badge),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _cardController,
                    decoration: const InputDecoration(
                      labelText: 'Номер читацького квитка',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.credit_card),
                    ),
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: _save,
                    child: Text(
                      authService.isLoggedIn ? 'Зберегти' : 'Увійти',
                    ),
                  ),
                  if (!authService.isLoggedIn) ...[
                    const SizedBox(height: 8),
                    OutlinedButton(
                      onPressed: () {
                        authService.login();
                        _nameController.text = authService.name;
                        _cardController.text = authService.cardNumber;
                        setState(() => _dirty = false);
                      },
                      child: const Text('Швидкий вхід (демо)'),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
