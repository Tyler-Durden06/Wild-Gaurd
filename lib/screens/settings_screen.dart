import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 60),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'SETTINGS',
                  style: TextStyle(
                    color: Color(0xFF22C55E),
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
                Text(
                  'Manage alerts and preferences',
                  style: TextStyle(
                    color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF64748B),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              children: [
                _buildSectionHeader('System Preferences', isDark),
                _buildSettingTile(
                  context,
                  icon: Icons.notifications_active_outlined,
                  title: 'Enable Notifications',
                  subtitle: 'Real-time wildlife alerts',
                  trailing: Switch(
                    value: appState.isNotificationEnabled,
                    onChanged: (value) => appState.toggleNotifications(),
                    activeThumbColor: const Color(0xFF22C55E),
                  ),
                ),
                _buildSettingTile(
                  context,
                  icon: Icons.security_outlined,
                  title: 'Vigilance Mode',
                  subtitle: 'Enhanced monitoring priority',
                  trailing: Switch(
                    value: appState.isVigilanceMode,
                    onChanged: (value) => appState.toggleVigilanceMode(),
                    activeThumbColor: const Color(0xFF22C55E),
                  ),
                ),
                _buildSettingTile(
                  context,
                  icon: isDark ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
                  title: 'Theme Style',
                  subtitle: appState.themeSetting == ThemeSettings.dark ? 'Premium Dark' : 'Modern Light',
                  trailing: Switch(
                    value: appState.themeSetting == ThemeSettings.dark,
                    onChanged: (value) {
                      appState.setTheme(value ? ThemeSettings.dark : ThemeSettings.light);
                    },
                    activeThumbColor: const Color(0xFF22C55E),
                  ),
                ),
                
                const SizedBox(height: 24),
                _buildSectionHeader('Support & Info', isDark),
                _buildSettingTile(
                  context,
                  icon: Icons.info_outline,
                  title: 'About Wild Guard',
                  subtitle: 'App version 2.4.0',
                  onTap: () {},
                ),
                _buildSettingTile(
                  context,
                  icon: Icons.help_outline,
                  title: 'Help Center',
                  subtitle: 'Guidelines and documentation',
                  onTap: () {},
                ),
                
                const SizedBox(height: 120),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF64748B),
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 2,
        ),
      ),
    );
  }

  Widget _buildSettingTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F2133) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF22C55E).withValues(alpha: isDark ? 0.05 : 0.1),
        ),
        boxShadow: isDark ? null : [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF22C55E).withValues(alpha: 0.1),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF22C55E).withValues(alpha: 0.05),
                blurRadius: 10,
              ),
            ],
          ),
          child: Icon(icon, color: const Color(0xFF22C55E), size: 22),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF0F172A),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF64748B),
            fontSize: 13,
          ),
        ),
        trailing: trailing ?? const Icon(Icons.chevron_right, color: Color(0xFF22C55E), size: 20),
      ),
    );
  }
}
