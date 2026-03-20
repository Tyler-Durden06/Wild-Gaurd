import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/alert.dart';

class AlertDetailScreen extends StatelessWidget {
  final Alert alert;

  const AlertDetailScreen({super.key, required this.alert});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF08121A) : const Color(0xFFF8FAFC),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            backgroundColor: isDark ? const Color(0xFF0B1C2C) : Colors.white,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: isDark ? Colors.black.withValues(alpha: 0.5) : Colors.white.withValues(alpha: 0.8),
                child: BackButton(color: isDark ? const Color(0xFF22C55E) : const Color(0xFF1B5E20)),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'alert-image-${alert.id}',
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      alert.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: isDark ? const Color(0xFF0F2133) : Colors.grey[200]!,
                        child: Icon(
                          Icons.image_not_supported, 
                          size: 50, 
                          color: isDark ? Colors.grey : Colors.grey[400]!,
                        ),
                      ),
                    ),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            isDark ? const Color(0xFF08121A) : const Color(0xFFF8FAFC),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildThreatBadge(alert.threatLevel),
                      Text(
                        DateFormat('hh:mm a, MMM dd').format(alert.timestamp),
                        style: TextStyle(
                          color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF64748B),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    alert.species.toUpperCase(),
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 20, color: Color(0xFF22C55E)),
                      const SizedBox(width: 8),
                      Text(
                        alert.location,
                        style: TextStyle(
                          fontSize: 16,
                          color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32.0),
                    child: Divider(
                      color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0), 
                      height: 1,
                    ),
                  ),
                  const Text(
                    'DETECTION DATA',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2,
                      color: Color(0xFF22C55E),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    alert.message,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      height: 1.4,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    alert.description,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.6,
                      color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF475569),
                    ),
                  ),
                  const SizedBox(height: 60),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF22C55E),
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'RETURN TO DASHBOARD',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 48),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThreatBadge(ThreatLevel level) {
    Color color;
    switch (level) {
      case ThreatLevel.high:
        color = const Color(0xFFEF4444);
        break;
      case ThreatLevel.medium:
        color = const Color(0xFFF59E0B);
        break;
      case ThreatLevel.low:
        color = const Color(0xFF22C55E);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Text(
        level.name.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w800,
          letterSpacing: 1,
        ),
      ),
    );
  }
}
