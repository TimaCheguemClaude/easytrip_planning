import 'package:flutter/material.dart';
import '../../utils/wallet_storage.dart';

class TripWalletPage extends StatefulWidget {
  final Map<String, dynamic>? trip;
  const TripWalletPage({super.key, this.trip});

  @override
  State<TripWalletPage> createState() => _TripWalletPageState();
}

class _TripWalletPageState extends State<TripWalletPage> {
  double _balance = 0.0;
  List<String> _history = [];

  @override
  void initState() {
    super.initState();
    // Use trip budget as initial balance if available
    if (widget.trip != null && widget.trip!['budget'] != null) {
      final budget = double.tryParse(widget.trip!['budget'].toString());
      if (budget != null) {
        _balance = budget;
      }
    }
    _loadWallet();
  }

  Future<void> _loadWallet() async {
    final bal = await WalletStorage.getBalance();
    final hist = await WalletStorage.getHistory();
    setState(() {
      // Only use wallet storage balance if no trip budget is set
      if ((widget.trip == null || widget.trip!['budget'] == null) &&
          bal != null) {
        _balance = bal;
      }
      _history = hist;
    });
  }

  Future<void> _addMoney() async {
    final amount = await _showAmountDialog('Add Money');
    if (amount != null && amount > 0) {
      final newBalance = _balance + amount;
      await WalletStorage.setBalance(newBalance);
      await WalletStorage.addHistory('Added XAF ${amount.toStringAsFixed(2)}');
      setState(() {
        _balance = newBalance;
      });
      await _loadWallet();
    }
  }

  Future<void> _withdrawMoney() async {
    final amount = await _showAmountDialog('Withdraw Money');
    if (amount != null && amount > 0 && amount <= _balance) {
      final newBalance = _balance - amount;
      await WalletStorage.setBalance(newBalance);
      await WalletStorage.addHistory(
        'Withdrew XAF ${amount.toStringAsFixed(2)}',
      );
      setState(() {
        _balance = newBalance;
      });
      await _loadWallet();
    } else if (amount != null && amount > _balance) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Insufficient balance')));
    }
  }

  Future<double?> _showAmountDialog(String title) async {
    final controller = TextEditingController();
    final result = await showDialog<double>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(labelText: 'Amount'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final value = double.tryParse(controller.text);
              Navigator.pop(context, value);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
    return result;
  }

  void _showHistory() {
    showModalBottomSheet(
      context: context,
      builder: (context) => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Transaction History',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          if (_history.isEmpty) const Text('No transactions yet.'),
          ..._history.map((e) => ListTile(title: Text(e))),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () async {
              await WalletStorage.clearHistory();
              await _loadWallet();
              Navigator.pop(context);
            },
            child: const Text('Clear History'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Balance: XAF ${_balance.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: ListTile(
                  leading: const Icon(Icons.add),
                  title: const Text('Add Money'),
                  onTap: _addMoney,
                ),
              ),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.remove),
                  title: const Text('Withdraw Money'),
                  onTap: _withdrawMoney,
                ),
              ),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.history),
                  title: const Text('Transaction History'),
                  onTap: _showHistory,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
