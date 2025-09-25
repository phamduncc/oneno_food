import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../services/language_service.dart';
import 'qr_scanner_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final languageService = LanguageService.instance;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.settings,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.red[700],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Language Section
          _buildSectionCard(
            title: l10n.language,
            icon: Icons.language,
            children: [
              ...languageService.availableLanguages.map((lang) {
                final isSelected = languageService.currentLocale.languageCode == lang['code'];
                return ListTile(
                  leading: Text(
                    lang['flag']!,
                    style: const TextStyle(fontSize: 24),
                  ),
                  title: Text(
                    lang['name']!,
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? Colors.red[700] : null,
                    ),
                  ),
                  trailing: isSelected 
                      ? Icon(Icons.check, color: Colors.red[700])
                      : null,
                  onTap: () async {
                    if (!isSelected) {
                      await languageService.changeLanguage(lang['code']!);
                      setState(() {});
                    }
                  },
                );
              }).toList(),
            ],
          ),

          const SizedBox(height: 16),

          // QR Scanner Section
          _buildSectionCard(
            title: l10n.scanQR,
            icon: Icons.qr_code_scanner,
            children: [
              ListTile(
                leading: Icon(
                  Icons.qr_code_scanner,
                  color: Colors.red[700],
                ),
                title: Text(l10n.scanQR),
                subtitle: Text(l10n.scanQRDescription),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const QRScannerScreen(),
                    ),
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: 16),

          // App Info Section
          _buildSectionCard(
            title: l10n.aboutApp,
            icon: Icons.info_outline,
            children: [
              ListTile(
                leading: Icon(
                  Icons.info_outline,
                  color: Colors.red[700],
                ),
                title: Text(l10n.version),
                subtitle: Text(l10n.versionContent),
              ),
              ListTile(
                leading: Icon(
                  Icons.share,
                  color: Colors.red[700],
                ),
                title: Text(l10n.shareApp),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.shareFeatureComingSoon),
                      backgroundColor: Colors.blue,
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.star_outline,
                  color: Colors.red[700],
                ),
                title: Text(l10n.rateApp),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.rateFeatureComingSoon),
                      backgroundColor: Colors.orange,
                    ),
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Quick Language Toggle
          Center(
            child: ElevatedButton.icon(
              onPressed: () async {
                await languageService.toggleLanguage();
                setState(() {});
              },
              icon: const Icon(Icons.translate),
              label: Text(
                languageService.isVietnamese 
                    ? 'Switch to English' 
                    : 'Chuyển sang Tiếng Việt',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[700],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: Colors.red[700],
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red[700],
                  ),
                ),
              ],
            ),
          ),
          ...children,
        ],
      ),
    );
  }
}
