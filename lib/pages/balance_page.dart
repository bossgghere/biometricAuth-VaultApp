// balance_page.dart
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:math';

class BalancePage extends StatefulWidget {
  const BalancePage({super.key});

  @override
  State<BalancePage> createState() => _BalancePageState();
}

class _BalancePageState extends State<BalancePage> {
  double _balance = 0.0;
  final _secureStorage = const FlutterSecureStorage();
  final String vaultId = 'VAULT-${Random().nextInt(999999).toString().padLeft(6, '0')}';

  @override
  void initState() {
    super.initState();
    _animateBalance();
  }

  void _animateBalance() async {
    for (int i = 0; i <= 69000; i += 1000) {
      await Future.delayed(const Duration(milliseconds: 20));
      setState(() => _balance = i.toDouble());
    }
  }

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: "\$${_balance.toInt()}"))
        .then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Balance copied to clipboard!'),
          backgroundColor: Colors.green,
        ),
      );
    });
  }

  Future<void> _logoutAndGoBack() async {
    await _secureStorage.delete(key: 'auth_token');
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text("Vault Unlocked"),
        backgroundColor: Colors.deepPurpleAccent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: _logoutAndGoBack,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.deepPurpleAccent.withOpacity(0.3),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Icon(Icons.lock_open_rounded,
                      size: 60, color: Colors.greenAccent),
                  const SizedBox(height: 20),
                  Text(
                    '\$${_balance.toInt()}',
                    style: const TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Shimmer.fromColors(
                    baseColor: Colors.grey,
                    highlightColor: Colors.white,
                    child: const Text(
                      'Secure Balance Unlocked',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: _copyToClipboard,
                    icon: const Icon(Icons.copy),
                    label: const Text("Copy Balance"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurpleAccent,
                      foregroundColor: Colors.white,
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 30),
            _infoTile(Icons.vpn_key_rounded, "Vault ID", vaultId),
            _infoTile(Icons.sync_rounded, "Last Synced", "Just now"),
            _infoTile(Icons.verified_rounded, "Status", "Authenticated"),
            const SizedBox(height: 20),
            const Divider(color: Colors.white24),
            const SizedBox(height: 10),
            const Text(
              "Recent Transactions",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            _transactionTile("Pizza Palace", "-\$24.99", Icons.fastfood),
            _transactionTile("Netflix", "-\$15.99", Icons.tv),
            _transactionTile("Salary", "+\$5,000.00", Icons.attach_money),
            _transactionTile("Amazon", "-\$142.89", Icons.shopping_cart),
          ],
        ),
      ),
    );
  }

  Widget _infoTile(IconData icon, String title, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white.withOpacity(0.05),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.deepPurpleAccent),
          const SizedBox(width: 12),
          Text(title, style: const TextStyle(color: Colors.white70)),
          const Spacer(),
          Text(value, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  Widget _transactionTile(String title, String amount, IconData icon) {
    final bool isPositive = amount.startsWith("+");
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white.withOpacity(0.04),
      ),
      child: Row(
        children: [
          Icon(icon, color: isPositive ? Colors.greenAccent : Colors.redAccent),
          const SizedBox(width: 12),
          Text(title, style: const TextStyle(color: Colors.white)),
          const Spacer(),
          Text(
            amount,
            style: TextStyle(
              color: isPositive ? Colors.greenAccent : Colors.redAccent,
              fontWeight: FontWeight.w600,
            ),
          )
        ],
      ),
    );
  }
}