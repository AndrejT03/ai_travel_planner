import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'create_plan_dialog.dart';
import 'glass.dart';

class MainScaffold extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  const MainScaffold({required this.navigationShell, super.key});

  static const accentBlue = Color(0xFF66B7FF);

  @override
  Widget build(BuildContext context) {
    final title = _getTitle(navigationShell.currentIndex);

    return Scaffold(
      extendBody: true,

      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).padding.top + 80),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
            child: Glass(
              blur: 12,
              opacity: 0.50,
              borderRadius: BorderRadius.circular(20),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              border: null,
              child: SizedBox(
                height: 48,
                child: Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),

      floatingActionButton: Glass(
        blur: 12,
        opacity: 0.22,
        borderRadius: BorderRadius.circular(18),
        padding: EdgeInsets.zero,
        child: SizedBox(
          width: 56,
          height: 56,
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: () {
              showDialog(
                context: context,
                barrierColor: Colors.black.withOpacity(0.7),
                builder: (context) => const CreatePlanDialog(),
              );
            },
            child: const Icon(Icons.add, size: 28, color: Colors.white),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      body: navigationShell,

      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
          child: Glass(
            blur: 12,
            opacity: 0.22,
            borderRadius: BorderRadius.circular(18),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              children: [
                _NavItem(
                  label: 'Home',
                  icon: Icons.home_outlined,
                  selectedIcon: Icons.home,
                  selected: navigationShell.currentIndex == 0,
                  onTap: () => navigationShell.goBranch(0),
                ),
                _NavItem(
                  label: 'Explore',
                  icon: Icons.explore_outlined,
                  selectedIcon: Icons.explore,
                  selected: navigationShell.currentIndex == 1,
                  onTap: () => navigationShell.goBranch(1),
                ),
                _NavItem(
                  label: 'Library',
                  icon: Icons.bookmark_outline,
                  selectedIcon: Icons.bookmark,
                  selected: navigationShell.currentIndex == 2,
                  onTap: () => navigationShell.goBranch(2),
                ),
                _NavItem(
                  label: 'Profile',
                  icon: Icons.person_outline,
                  selectedIcon: Icons.person,
                  selected: navigationShell.currentIndex == 3,
                  onTap: () => navigationShell.goBranch(3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getTitle(int index) {
    switch (index) {
      case 0:
        return 'AI Travel Planner';
      case 1:
        return 'Popular Destinations';
      case 2:
        return 'My Plans';
      case 3:
        return 'My Profile';
      default:
        return 'AI Travel Planner';
    }
  }
}

class _NavItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.selected,
    required this.onTap,
  });

  static const accentBlue = Color(0xFF66B7FF);

  @override
  Widget build(BuildContext context) {
    final fg = selected ? accentBlue : Colors.white70;

    return Expanded(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: selected ? accentBlue.withOpacity(0.22) : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: selected
              ? Border.all(color: accentBlue.withOpacity(0.35), width: 1)
              : null,
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(selected ? selectedIcon : icon, color: fg, size: 22),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(color: fg, fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}