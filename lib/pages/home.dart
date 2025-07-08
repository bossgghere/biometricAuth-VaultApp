// home.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'balance_page.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final LocalAuthentication _auth = LocalAuthentication();
  final _secureStorage = const FlutterSecureStorage();

  Future<void> _authenticate() async {
    try {
      final bool isSupported = await _auth.isDeviceSupported();
      final bool canAuthenticate = await _auth.canCheckBiometrics;

      if (isSupported && canAuthenticate) {
        final bool didAuthenticate = await _auth.authenticate(
          localizedReason: 'Authenticate to access your vault',
          options: const AuthenticationOptions(
            biometricOnly: true,
            stickyAuth: false,
            useErrorDialogs: true,
          ),
        );

        if (didAuthenticate && mounted) {
          // Store a fake token securely
          await _secureStorage.write(key: 'auth_token', value: 'secure_token_123');

          // Navigate to balance page
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const BalancePage()),
          );
        }
      } else {
        _showError("Biometric authentication not supported.");
      }
    } on PlatformException catch (e) {
      _showError("Authentication error: \${e.message}");
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.redAccent),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(32),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F0C29), Color(0xFF302B63)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock_outline,
                size: 100, color: Colors.deepPurpleAccent),
            const SizedBox(height: 40),
            const Text(
              'VaultPass',
              style: TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 3,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: _authenticate,
              icon: const Icon(Icons.fingerprint, size: 26),
              label: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Text('Authenticate', style: TextStyle(fontSize: 18)),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
