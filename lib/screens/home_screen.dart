import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../models/alert.dart';
import '../widgets/live_alert_banner.dart';
import '../widgets/latest_alert_card.dart';
import '../widgets/system_status_section.dart';
import '../widgets/animations.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final latestAlert = appState.latestAlert;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          GradientBackground(
            child: SafeArea(
              child: RefreshIndicator(
                onRefresh: appState.refreshAlerts,
                backgroundColor: isDark
                    ? const Color(0xFF0F2133)
                    : Colors.white,
                color: const Color(0xFF22C55E),
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 60),
                            _buildHeader(context, theme),
                            const SizedBox(height: 32),

                            if (latestAlert != null) ...[
                              Text(
                                'LATEST ALERT',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 2,
                                  color: theme.colorScheme.primary.withValues(alpha: 0.8),
                                ),
                              ),
                              const SizedBox(height: 16),
                              LatestAlertCard(
                                alert: latestAlert,
                                onTakeAction: () {
                                  appState.takeAction(latestAlert);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Vigilance Mode Activated'),
                                      behavior: SnackBarBehavior.floating,
                                      backgroundColor: Color(0xFF22C55E),
                                    ),
                                  );
                                },
                                onShare: () => appState.shareAlert(latestAlert),
                              ),
                              const SizedBox(height: 32),
                              _buildLastSeenStatus(context, latestAlert),
                            ] else
                              _buildEmptyState(context),

                            const SizedBox(height: 40),

                            if (appState.status != null) ...[
                              const Text(
                                'SYSTEM MONITORING',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 2,
                                  color: Color(0xFF9CA3AF),
                                ),
                              ),
                              const SizedBox(height: 16),
                              SystemStatusSection(status: appState.status!),
                            ],
                            const SizedBox(
                              height: 120,
                            ), // Space for floating bottom nav
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (appState.currentBannerAlert != null)
            Positioned(
              top: MediaQuery.of(context).padding.top + 10,
              left: 0,
              right: 0,
              child: LiveAlertBanner(alert: appState.currentBannerAlert!),
            ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'WILD GUARD',
              style: TextStyle(
                color: Color(0xFF22C55E),
                fontSize: 26,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
            Text(
              'Secure & Monitoring',
              style: TextStyle(
                color: isDark
                    ? theme.colorScheme.onSurface.withValues(alpha: 0.8)
                    : theme.colorScheme.onSurfaceVariant,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Monitoring service active. Ready for alerts.'),
                behavior: SnackBarBehavior.floating,
                backgroundColor: Color(0xFF0F2133),
              ),
            );
          },
          child: Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0F2133) : Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
              ),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? theme.colorScheme.primary.withValues(alpha: 0.05)
                      : Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                ),
              ],
            ),
            child: const Icon(
              Icons.notifications_outlined,
              color: Color(0xFF22C55E),
              size: 24,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLastSeenStatus(BuildContext context, Alert alert) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final timeAgo = _formatTimeAgo(alert.timestamp);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F2133) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.black.withValues(alpha: 0.05),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.visibility_rounded,
              color: Color(0xFF22C55E),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Last Detected: ${alert.species}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                Text(
                  '$timeAgo • STATUS: ACTIVE THREAT',
                  style: const TextStyle(
                    color: Color(0xFF22C55E),
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimeAgo(DateTime timestamp) {
    final diff = DateTime.now().difference(timestamp);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} mins ago';
    if (diff.inHours < 24) return '${diff.inHours} hours ago';
    return '${diff.inDays} days ago';
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 60),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF0F2133).withValues(alpha: 0.5)
            : Colors.white.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.05)),
      ),
      child: Column(
        children: [
          Icon(
            Icons.shield_outlined,
            size: 48,
            color: theme.colorScheme.primary.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'No threats detected',
            style: TextStyle(
              color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF475569),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'System is performing routine scans',
            style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 12),
          ),
        ],
      ),
    );
  }
}
