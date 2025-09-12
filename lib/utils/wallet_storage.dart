import 'package:shared_preferences/shared_preferences.dart';

class WalletStorage {
  static const String _balanceKey = 'wallet_balance';
  static const String _historyKey = 'wallet_history';

  static Future<double> getBalance() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_balanceKey) ?? 0.0;
  }

  static Future<void> setBalance(double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_balanceKey, value);
  }

  static Future<List<String>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_historyKey) ?? [];
  }

  static Future<void> addHistory(String entry) async {
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList(_historyKey) ?? [];
    history.insert(0, entry);
    await prefs.setStringList(_historyKey, history);
  }

  static Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_historyKey);
  }
}
