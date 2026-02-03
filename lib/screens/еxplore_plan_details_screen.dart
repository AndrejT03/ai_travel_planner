import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../models/explore_template.dart';
import '../widgets/create_plan_dialog.dart';

class ExplorePlanDetailsScreen extends StatelessWidget {
  final ExploreTemplate template;
  const ExplorePlanDetailsScreen({super.key, required this.template});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${template.destination} Plan'),
      ),
      body: ListView(
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Image.network(
              template.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(color: Colors.grey),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
            child: ElevatedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => CreatePlanDialog(
                    initialDestination: template.destination,
                  ),
                );
              },
              icon: const Icon(Icons.edit_calendar, color: Colors.white),
              label: const Text('Customize / Create Your Own Plan'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const Divider(indent: 16, endIndent: 16, height: 30),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            child: MarkdownBody(
              data: template.planMarkdown,
              styleSheet: MarkdownStyleSheet(
                h1: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                h2: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                p: const TextStyle(fontSize: 16, height: 1.5),
                listBullet: const TextStyle(fontSize: 16),
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}