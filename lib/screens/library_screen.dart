import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/library_provider.dart';
import '../widgets/plan_list_tile.dart';

class LibraryScreen extends ConsumerWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncPlans = ref.watch(filteredUserPlansProvider);
    final query = ref.watch(librarySearchQueryProvider);

    return asyncPlans.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
        data:  (plans) {
        return CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              sliver: SliverToBoxAdapter(
                child: TextField(
                  onChanged: (v) =>
                  ref.read(librarySearchQueryProvider.notifier).state = v,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search by destination, text, season, budget…',
                    hintStyle: const TextStyle(color: Colors.white54),
                    prefixIcon: const Icon(Icons.search, color: Colors.white70),
                    suffixIcon: query.trim().isEmpty
                        ? null
                        : IconButton(
                      icon: const Icon(Icons.close, color: Colors.white70),
                      onPressed: () => ref
                          .read(librarySearchQueryProvider.notifier)
                          .state = '',
                    ),
                    filled: true,
                    fillColor: Colors.black.withOpacity(0.22),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: Colors.white.withOpacity(0.10)),
                    ),
                  ),
                ),
              ),
            ),

            if (plans.isEmpty)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(child: Text('No saved trips found')),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 110),
                sliver: SliverList.separated(
                  itemCount: plans.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final plan = plans[index];
                    return PlanListTile(
                      plan: plan,
                      onDismissedFromScreen: () {
                        ref.read(libraryControllerProvider).remove(plan);
                      },
                    );
                  },
                ),
              ),
          ],
        );
      },
    );
  }
}