import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/alert.dart';

class AlertCard extends StatelessWidget {
  final Alert alert;
  final VoidCallback onViewDetails;

  const AlertCard({super.key, required this.alert, required this.onViewDetails});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F2133) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF22C55E).withValues(alpha: isDark ? 0.1 : 0.05),
        ),
        boxShadow: [
          BoxShadow(
            color: (isDark ? Colors.black : Colors.grey[400]!).withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: onViewDetails,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Species Image Thumbnail
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.network(
                  alert.imageUrl,
                  height: 72,
                  width: 72,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 72,
                    width: 72,
                    color: isDark ? const Color(0xFF1E293B) : Colors.grey[100]!,
                    child: Icon(
                      Icons.image_not_supported, 
                      color: isDark ? Colors.grey : Colors.grey[400]!, 
                      size: 24,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              
              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          alert.species,
                          style: TextStyle(
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        _buildThreatIndicator(alert.threatLevel),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, color: Color(0xFF22C55E), size: 14),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            alert.location,
                            style: TextStyle(
                              color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF64748B), 
                              fontSize: 13,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('hh:mm a, MMM dd').format(alert.timestamp),
                      style: TextStyle(
                        color: (isDark ? const Color(0xFF9CA3AF) : const Color(0xFF94A3B8)).withValues(alpha: 0.6),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.chevron_right, color: Color(0xFF22C55E), size: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThreatIndicator(ThreatLevel level) {
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Text(
        level.name.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 9,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
