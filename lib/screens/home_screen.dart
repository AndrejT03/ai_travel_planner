import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/explore_templates_provider.dart';
import '../providers/user_profile_provider.dart';
import '../widgets/create_plan_dialog.dart';
import '../widgets/glass.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  static const accentBlue = Color(0xFF66B7FF);

  String _firstNameFromFullName(String? fullName) {
    final name = (fullName ?? '').trim();
    if (name.isEmpty) return 'there';
    final parts = name.split(RegExp(r'\s+'));
    return parts.isNotEmpty ? parts.first : 'there';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileStreamProvider);
    final templatesAsync = ref.watch(exploreTemplatesStreamProvider);

    final firstName = switch (profileAsync) {
      AsyncData(:final value) => _firstNameFromFullName(value?.fullName),
      _ => 'there',
    };

    return Scaffold(
      body: Stack(
        children: [
          const _HomeBackground(),

          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 5, 16, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome, $firstName',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Where to next?',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 22),
                sliver: SliverToBoxAdapter(
                  child: _HeroCreateCard(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => const CreatePlanDialog(),
                      );
                    },
                  ),
                ),
              ),

              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                sliver: SliverToBoxAdapter(
                  child: _QuickStartTemplates(
                    onCreateOwn: () {
                      showDialog(
                        context: context,
                        builder: (_) => const CreatePlanDialog(),
                      );
                    },
                  ),
                ),
              ),

              templatesAsync.when(
                loading: () => const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(top: 28),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ),
                error: (e, _) => SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 28),
                    child: Center(
                      child: Text(
                        'Error loading templates: $e',
                        style: const TextStyle(color: Colors.redAccent),
                      ),
                    ),
                  ),
                ),
                  data: (templates) {
                  final trending = templates.take(6).toList();
                  final inspired = templates.skip(6).take(8).toList();

                  return SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                          child: _SectionHeader(
                            title: 'Trending now',
                            actionText: 'See all',
                            onTap: () => context.push('/explore'),
                          ),
                        ),
                        SizedBox(
                          height: 240,
                          child: ListView.separated(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                            scrollDirection: Axis.horizontal,
                            clipBehavior: Clip.none,
                            itemCount: trending.length,
                            separatorBuilder: (_, __) => const SizedBox(width: 14),
                            itemBuilder: (context, index) {
                              final t = trending[index];
                              return _TrendingCard(
                                destination: t.destination,
                                imageUrl: t.imageUrl,
                                onTap: () => context.push('/explore-plan', extra: t),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 22),

                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                          child: _SectionHeader(
                            title: 'Inspired by you',
                            actionText: 'Refresh',
                            onTap: () => ref.invalidate(exploreTemplatesStreamProvider),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                          child: ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: inspired.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final t = inspired[index];
                              return _InspiredTile(
                                destination: t.destination,
                                imageUrl: t.imageUrl,
                                subtitle: 'Adventure • 3 Days • €450',
                                onTap: () => context.push('/explore-plan', extra: t),
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 110),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HomeBackground extends StatelessWidget {
  const _HomeBackground();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(-0.7, -0.9),
              radius: 1.2,
              colors: [
                Color(0x332D9CFF),
                Color(0xFF05070A),
              ],
            ),
          ),
          child: Align(
            alignment: const Alignment(0.9, -0.6),
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    HomeScreen.accentBlue.withOpacity(0.20),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ),

        Positioned(
          left: 0,
          right: 0,
          top: 0,
          height: 220,
          child: IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.90),
                    Colors.black.withOpacity(0.35),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.45, 1.0],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _QuickStartTemplates extends StatelessWidget {
  final VoidCallback onCreateOwn;
  const _QuickStartTemplates({required this.onCreateOwn});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Start Templates',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),

        Glass(
          opacity: 0.08,
          borderRadius: BorderRadius.circular(18),
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              _TemplatePlanCard(
                icon: Icons.weekend,
                title: 'Weekend City Break',
                days: '2-3 days',
                budget: '€300-500',
                description: 'Perfect quick escape to explore a new city',
              ),
              const SizedBox(height: 10),
              _TemplatePlanCard(
                icon: Icons.beach_access,
                title: 'Beach Relaxation',
                days: '5-7 days',
                budget: '€600-1000',
                description: 'Unwind by the ocean with sun and sea',
              ),
              const SizedBox(height: 10),
              _TemplatePlanCard(
                icon: Icons.landscape,
                title: 'Mountain Adventure',
                days: '4-6 days',
                budget: '€400-700',
                description: 'Hiking and nature in scenic landscapes',
              ),
              const SizedBox(height: 14),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: onCreateOwn,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: HomeScreen.accentBlue,
                    side: BorderSide(color: HomeScreen.accentBlue.withOpacity(0.5)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  icon: const Icon(Icons.add_circle_outline, size: 20),
                  label: const Text(
                    'Create Your Own Plan',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TemplatePlanCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String days;
  final String budget;
  final String description;

  const _TemplatePlanCard({
    required this.icon,
    required this.title,
    required this.days,
    required this.budget,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: HomeScreen.accentBlue.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: HomeScreen.accentBlue, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 12, color: Colors.white.withOpacity(0.5)),
                    const SizedBox(width: 4),
                    Text(
                      days,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(Icons.euro, size: 12, color: Colors.white.withOpacity(0.5)),
                    const SizedBox(width: 4),
                    Text(
                      budget,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroCreateCard extends StatelessWidget {
  final VoidCallback onTap;
  const _HeroCreateCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Glass(
        opacity: 0.18,
        borderRadius: BorderRadius.circular(26),
        padding: const EdgeInsets.all(18),
        tint: HomeScreen.accentBlue,
        child: Stack(
          children: [
            Positioned(
              right: -10,
              top: -12,
              child: Icon(
                Icons.auto_awesome,
                size: 90,
                color: Colors.white.withOpacity(0.10),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: HomeScreen.accentBlue.withOpacity(0.22),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                              color: HomeScreen.accentBlue.withOpacity(0.40)),
                        ),
                        child: const Text(
                          'AI POWERED',
                          style: TextStyle(
                            color: HomeScreen.accentBlue,
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Create your next travel\nplan in seconds',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          height: 1.15,
                        ),
                      ),
                      const SizedBox(height: 14),
                      FilledButton(
                        onPressed: onTap,
                        style: FilledButton.styleFrom(
                          backgroundColor: HomeScreen.accentBlue,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Create plan',
                                style: TextStyle(fontWeight: FontWeight.w900)),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward, size: 16),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String actionText;
  final VoidCallback onTap;

  const _SectionHeader({
    required this.title,
    required this.actionText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
        ),
        TextButton(
          onPressed: onTap,
          child: Text(
            actionText,
            style: TextStyle(
              color: HomeScreen.accentBlue.withOpacity(0.9),
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}

class _TrendingCard extends StatelessWidget {
  final String imageUrl;
  final String destination;
  final VoidCallback onTap;

  const _TrendingCard({
    required this.imageUrl,
    required this.destination,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Glass(
        padding: EdgeInsets.zero,
        borderRadius: BorderRadius.circular(22),
        opacity: 0.10,
        child: SizedBox(
          width: 180,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(imageUrl, fit: BoxFit.cover),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.80),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 12,
                  right: 12,
                  bottom: 12,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        destination,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: const [
                          Icon(Icons.star,
                              size: 14, color: HomeScreen.accentBlue),
                          SizedBox(width: 6),
                          Text('Popular',
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InspiredTile extends StatelessWidget {
  final String imageUrl;
  final String destination;
  final String subtitle;
  final VoidCallback onTap;

  const _InspiredTile({
    required this.imageUrl,
    required this.destination,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Glass(
        padding: const EdgeInsets.all(10),
        borderRadius: BorderRadius.circular(18),
        opacity: 0.08,
        child: Row(
          children: [
            SizedBox(
              width: 70,
              height: 70,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.network(imageUrl, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    destination,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    style: const TextStyle(fontSize: 12, color: Colors.white54),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward_ios,
                size: 14, color: Colors.white30),
          ],
        ),
      ),
    );
  }
}