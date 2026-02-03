import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../models/day_plan.dart';
import '../providers/library_provider.dart';

class FavoritePlanCard extends ConsumerWidget {
  final DayPlan plan;

  const FavoritePlanCard({super.key, required this.plan});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: 180,
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          clipBehavior: Clip.antiAlias,
          child: Ink(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.center,
                end: Alignment.center,
                colors: [
                  const Color(0xFF66B7FF).withOpacity(0.12),
                  Colors.black.withOpacity(0.55),
                  Colors.black.withOpacity(0.85),
                ],
                stops: const [0.0, 0.55, 1.0],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.10)),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => context.push('/plan-details', extra: plan),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.favorite, size: 16, color: Colors.redAccent),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            plan.destination,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                        IconButton(
                          visualDensity: VisualDensity.compact,
                          padding: EdgeInsets.zero,
                          tooltip: 'Remove from favorites',
                          icon: const Icon(Icons.delete_outline, size: 18, color: Colors.redAccent),
                          onPressed: () async {
                            await ref.read(libraryControllerProvider).removeFavorite(plan);

                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Removed from favorites')),
                              );
                            }
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),
                    Text(
                      '${plan.duration} • ${plan.budget}€',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      plan.season,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const Spacer(),
                    const Align(
                      alignment: Alignment.bottomRight,
                      child: Icon(Icons.chevron_right),
                    ),
                  ],
            ),
          ),
        ),
       ),
      ),
    );
  }
}