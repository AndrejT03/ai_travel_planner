import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/day_plan.dart';
import '../providers/plan_provider.dart';
import '../widgets/glass.dart';
import '../widgets/streaming_markdown.dart';

class PlanDetailsScreen extends ConsumerWidget {
  final DayPlan? existingPlan;
  const PlanDetailsScreen({this.existingPlan, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (existingPlan != null) {
      return Scaffold(
        appBar: AppBar(title: Text(existingPlan!.destination)),
        body: _buildPlanContent(context, existingPlan!, animate: false),
      );
    }

    final state = ref.watch(planControllerProvider);

    if (state is AsyncLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Generating...')),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('AI is creating your day plan...'),
            ],
          ),
        ),
      );
    }

    if (state is AsyncError) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(child: Text('Error: ${state.error}')),
      );
    }

    final plan = state.value;
    if (plan == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('No Plan')),
        body: const Center(child: Text('No plan generated.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          '${plan.destination} Plan',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
      ),
      body: _buildPlanContent(context, plan, animate: true),
    );
  }

  Widget _buildPlanContent(BuildContext context, DayPlan plan, {required bool animate}) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Glass(
          blur: 10,
          opacity: 0.18,
          borderRadius: BorderRadius.circular(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                plan.destination,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text.rich(
                TextSpan(
                  style: const TextStyle(color: Colors.white70),
                  children: [
                    TextSpan(text: '${plan.duration} • ${plan.budget}'),
                    const WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: Padding(
                        padding: EdgeInsets.only(left: 1),
                        child: Icon(Icons.euro, size: 14, color: Colors.white70),
                      ),
                    ),
                    TextSpan(text: ' • ${plan.season}'),
                  ],
                ),
              ),
              const Divider(height: 24),
              StreamingMarkdown(
                data: plan.fullPlanText,
                animate: animate,
                styleSheet: MarkdownStyleSheet(
                  blockSpacing: 18,
                  pPadding: const EdgeInsets.only(bottom: 10),

                  h1: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
                  h1Padding: const EdgeInsets.only(top: 10, bottom: 10),

                  h2: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                  h2Padding: const EdgeInsets.only(top: 10, bottom: 10),

                  h3: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
                  h3Padding: const EdgeInsets.only(top: 8, bottom: 8),

                  p: const TextStyle(color: Colors.white, height: 1.4),
                  listBullet: const TextStyle(color: Colors.white),
                  strong: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}