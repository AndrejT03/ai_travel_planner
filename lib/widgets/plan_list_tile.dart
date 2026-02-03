import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../models/day_plan.dart';
import '../providers/library_provider.dart';

class PlanListTile extends ConsumerWidget {
  final DayPlan plan;
  final VoidCallback onDismissedFromScreen;

  const PlanListTile({
    super.key,
    required this.plan,
    required this.onDismissedFromScreen,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dismissible(
      key: ValueKey(plan.id),
      direction: DismissDirection.horizontal,

      background: Container(
        color: Colors.green,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        child: const Icon(Icons.favorite, color: Colors.white),
      ),

      secondaryBackground: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),

      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          await ref.read(libraryControllerProvider).addFavorite(plan);

          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Added to Favorites.')),
            );
          }
          return false;
        }
        return true;
      },

      onDismissed: (direction) async {
        if (direction == DismissDirection.endToStart) {
          await ref.read(libraryControllerProvider).remove(plan);

          onDismissedFromScreen();
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Plan deleted.')),
            );
          }
        }
      },

      child: Card(
        elevation: 0,
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
        color: Colors.transparent,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: Colors.white.withOpacity(0.10)),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.center,
              end: Alignment.center,
              colors: [
                const Color(0xFF66B7FF).withOpacity(0.14),
                Colors.black.withOpacity(0.55),
                Colors.black.withOpacity(0.85),
              ],
              stops: const [0.0, 0.55, 1.0],
            ),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            title: Text(
              plan.destination,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
            subtitle: Text.rich(
              TextSpan(
                style: TextStyle(color: Colors.white.withOpacity(0.65), fontSize: 13),
                children: [
                  TextSpan(text: '${plan.duration} • ${plan.budget}'),
                  const WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: Padding(
                      padding: EdgeInsets.only(left: 3, right: 3),
                      child: Icon(Icons.euro, size: 14, color: Colors.white54),
                    ),
                  ),
                  TextSpan(text: ' • ${plan.season}'),
                ],
              ),
            ),
            trailing: const Icon(Icons.chevron_right, color: Colors.white70),
            onTap: () => context.push('/plan-details', extra: plan),
          ),
        ),
      ),
    );
  }
}