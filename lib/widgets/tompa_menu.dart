import 'package:flutter/material.dart';

class TompaColors {
  static const green = Color(0xFF126245);
  static const yellow = Color(0xFFFFC400);
  static const red = Color(0xFFE92B2B);
  static const cream = Color(0xFFE3F0DF);
}

class TompaClassicScreen extends StatelessWidget {
  const TompaClassicScreen({super.key, required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TompaColors.green,
      appBar: AppBar(
        backgroundColor: TompaColors.green,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, 18, 22, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children,
          ),
        ),
      ),
    );
  }
}

class TompaHeader extends StatelessWidget {
  const TompaHeader({super.key, required this.title, this.subtitle});

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(color: TompaColors.yellow, fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: 1.5),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 6),
          Text(subtitle!, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
        ],
        const SizedBox(height: 22),
      ],
    );
  }
}

class TompaMenuButton extends StatelessWidget {
  const TompaMenuButton({super.key, required this.label, required this.onTap, this.icon});

  final String label;
  final VoidCallback onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: SizedBox(
        height: 52,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: TompaColors.cream,
            foregroundColor: TompaColors.green,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2), side: const BorderSide(color: Colors.white, width: 1.5)),
            elevation: 2,
            textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          onPressed: onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[Icon(icon, size: 22), const SizedBox(width: 10)],
              Flexible(child: Text(label, textAlign: TextAlign.center)),
            ],
          ),
        ),
      ),
    );
  }
}

class TompaComingSoon extends StatelessWidget {
  const TompaComingSoon({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return TompaClassicScreen(
      title: title,
      children: [
        TompaHeader(title: title, subtitle: 'This option is mapped from the original TOMPA APK and will be implemented next.'),
        TompaMenuButton(label: 'Back', icon: Icons.arrow_back, onTap: () => Navigator.pop(context)),
      ],
    );
  }
}
