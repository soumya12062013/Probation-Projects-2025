import 'package:flutter/material.dart';

import 'package:lucide_icons/lucide_icons.dart';

class BottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabSelected;
  const BottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
  });
  @override
  Widget build(BuildContext context) {
    final navItems = [
      {'icon': LucideIcons.layoutDashboard, 'label': 'Dashboard'},
      {'icon': LucideIcons.scan, 'label': 'Disease'},
      {'icon': LucideIcons.leaf, 'label': 'Health'},
      {'icon': LucideIcons.trendingUp, 'label': 'Yield'},
      {'icon': LucideIcons.fileText, 'label': 'Reports'},
    ];
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFD1FAE5), width: 1.0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, -2),
            blurRadius: 4,
          ),
        ],
      ),

      child: SafeArea(
        top: false,
        left: false,
        right: false,
        bottom: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(navItems.length, (index) {
              final item = navItems[index];
              final isActive = currentIndex == index;

              return GestureDetector(
                onTap: () => onTabSelected(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isActive
                        ? const Color(0xFFF0FDF4)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        item['icon'] as IconData,
                        color: isActive ? Colors.green[700] : Colors.grey[600],
                        size: 24,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        item['label'] as String,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: isActive
                              ? FontWeight.w600
                              : FontWeight.w400,
                          color: isActive
                              ? Colors.green[700]
                              : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
