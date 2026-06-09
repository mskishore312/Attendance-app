import 'package:flutter/material.dart';

void main() {
  runApp(const TompaApp());
}

class TompaApp extends StatelessWidget {
  const TompaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TOMPA',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.teal,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final modules = <TompaModule>[
      TompaModule('Companies', Icons.business, 'Create, edit, and select companies'),
      TompaModule('Masters', Icons.account_tree, 'Groups, ledgers, stock items, units'),
      TompaModule('Vouchers', Icons.receipt_long, 'Receipt, payment, contra, journal, sales, purchase'),
      TompaModule('Reports', Icons.bar_chart, 'Day book, ledger, trial balance, P&L, balance sheet'),
      TompaModule('GST', Icons.percent, 'GST registers, GSTR-1, GSTR-3B summaries'),
      TompaModule('Backup & Export', Icons.backup, 'PDF, Excel, JSON backup, Tally export roadmap'),
      TompaModule('AI Assistant', Icons.smart_toy, 'Ledger suggestion, bill extraction, voice entry roadmap'),
      TompaModule('Settings', Icons.settings, 'Financial year, security, app preferences'),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('TOMPA'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const _HeroCard(),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: modules.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.05,
            ),
            itemBuilder: (context, index) => ModuleCard(module: modules[index]),
          ),
        ],
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tally-style accounting on mobile',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Create companies, maintain ledgers, record vouchers, view reports, and gradually add AI-assisted accounting workflows.',
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add_business),
              label: const Text('Create Company'),
            ),
          ],
        ),
      ),
    );
  }
}

class ModuleCard extends StatelessWidget {
  const ModuleCard({super.key, required this.module});

  final TompaModule module;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => PlaceholderScreen(module: module)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(module.icon, size: 32),
              const Spacer(),
              Text(
                module.title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(
                module.subtitle,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({super.key, required this.module});

  final TompaModule module;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(module.title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(module.icon, size: 48),
            const SizedBox(height: 16),
            Text(
              module.title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(module.subtitle),
            const SizedBox(height: 24),
            const Text('This module is a placeholder for the MVP implementation.'),
          ],
        ),
      ),
    );
  }
}

class TompaModule {
  const TompaModule(this.title, this.icon, this.subtitle);

  final String title;
  final IconData icon;
  final String subtitle;
}
