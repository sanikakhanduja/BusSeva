import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _selectedLanguage = "English";
  bool _biometricUnlock = false;
  bool _offlineQueueing = false;

  final List<String> _languages = ["English", "हिंदी", "বাংলা", "தமிழ்"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Language", style: TextStyle(fontSize: 16)),
            DropdownButton<String>(
              value: _selectedLanguage,
              items: _languages
                  .map(
                    (lang) => DropdownMenuItem(value: lang, child: Text(lang)),
                  )
                  .toList(),
              onChanged: (val) => setState(() => _selectedLanguage = val!),
            ),
            const Divider(),
            SwitchListTile(
              title: const Text("Enable Biometric Unlock"),
              value: _biometricUnlock,
              onChanged: (val) => setState(() => _biometricUnlock = val),
            ),
            SwitchListTile(
              title: const Text("Enable Offline Queueing"),
              subtitle: const Text("Sync reports when internet is available"),
              value: _offlineQueueing,
              onChanged: (val) => setState(() => _offlineQueueing = val),
            ),
          ],
        ),
      ),
    );
  }
}
