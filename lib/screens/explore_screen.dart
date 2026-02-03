import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/explore_templates_provider.dart';

class ExploreScreen extends ConsumerWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final templatesAsync = ref.watch(exploreTemplatesStreamProvider);

    return Scaffold(
      body: templatesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
        data: (templates) {
          if (templates.isEmpty) {
            return const Center(child: Text('No templates found.'));
          }

          return GridView.builder(
            padding: const EdgeInsets.fromLTRB(16, 0, 0, 150),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.8,
            ),
            itemCount: templates.length,
            itemBuilder: (context, index) {
              final template = templates[index];

              return GestureDetector(
                onTap: () => context.push('/explore-plan', extra: template),
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        template.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: Colors.black12,
                          alignment: Alignment.center,
                          child: const Icon(Icons.broken_image, color: Colors.white54),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.7),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            template.destination,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}