import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  static const Color navy = Color(0xFF0A1F44);
  static const Color lightBg = Color(0xFFF3F6FF);

  bool notifOn = true;
  bool darkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBg,
      appBar: AppBar(
        title: const Text("Pengaturan"),
        centerTitle: true,
        backgroundColor: navy,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
        children: [
          _sectionTitle("Preferensi"),

          _switchTile(
            icon: Icons.notifications,
            title: "Notifikasi",
            subtitle: "Aktifkan notifikasi promo",
            value: notifOn,
            onChanged: (val) {
              setState(() => notifOn = val);
            },
          ),

          _switchTile(
            icon: Icons.dark_mode,
            title: "Mode Gelap",
            subtitle: "Tampilan gelap aplikasi",
            value: darkMode,
            onChanged: (val) {
              setState(() => darkMode = val);
            },
          ),

          const SizedBox(height: 30),

          _sectionTitle("Lainnya"),

          _menuTile(
            icon: Icons.info,
            title: "Tentang Aplikasi",
            subtitle: "Informasi aplikasi",
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: "Bioskop App",
                applicationVersion: "Versi 1.0.0",
                applicationIcon: const Icon(Icons.movie),
                children: const [
                  Text(
                    "Aplikasi pemesanan tiket bioskop berbasis Flutter.",
                  ),
                ],
              );
            },
          ),

          _menuTile(
            icon: Icons.lock,
            title: "Privasi & Keamanan",
            subtitle: "Kebijakan dan keamanan",
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Fitur belum tersedia"),
                ),
              );
            },
          ),

          const SizedBox(height: 30),

          Center(
            child: Text(
              "Versi Aplikasi 1.0.0",
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= SECTION TITLE =================
  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: navy,
        ),
      ),
    );
  }

  // ================= SWITCH TILE =================
  Widget _switchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: SwitchListTile(
        secondary: Icon(icon, color: navy),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        value: value,
        onChanged: onChanged,
        activeColor: navy,
      ),
    );
  }

  // ================= MENU TILE =================
  Widget _menuTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: Icon(icon, color: navy),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
