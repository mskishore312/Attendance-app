import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/company.dart';
import '../services/backup_service.dart';

class BackupScreen extends StatefulWidget {
  const BackupScreen({super.key, required this.company});

  final Company company;

  @override
  State<BackupScreen> createState() => _BackupScreenState();
}

class _BackupScreenState extends State<BackupScreen> {
  String? _json;
  bool _loading = false;

  Future<void> _generateBackup() async {
    setState(() => _loading = true);
    final json = await const BackupService().buildCompanyBackup(widget.company);
    if (!mounted) return;
    setState(() {
      _json = json;
      _loading = false;
    });
  }

  Future<void> _copyBackup() async {
    final json = _json;
    if (json == null) return;
    await Clipboard.setData(ClipboardData(text: json));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Backup copied')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.company.name} - Backup')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Generate a JSON backup containing company, ledgers, vouchers, voucher entries, and GST values.'),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: _loading ? null : _generateBackup,
            icon: const Icon(Icons.backup),
            label: Text(_loading ? 'Generating...' : 'Generate JSON Backup'),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: _json == null ? null : _copyBackup,
            icon: const Icon(Icons.copy),
            label: const Text('Copy Backup JSON'),
          ),
          const SizedBox(height: 16),
          if (_json != null)
            SelectableText(
              _json!,
              style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
            ),
        ],
      ),
    );
  }
}
