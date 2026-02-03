import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  GeminiService({String? modelName})
      : _modelName = modelName ?? 'gemini-3-flash-preview';

  final String _modelName;

  String get _apiKey {
    final key = dotenv.env['GEMINI_API_KEY'];
    if (key == null || key.isEmpty) {
      throw Exception('Missing GEMINI_API_KEY in .env');
    }
    return key;
  }

  GenerativeModel _createModel() {
    final safetySettings = [
      SafetySetting(HarmCategory.harassment, HarmBlockThreshold.low),
      SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.low),
      SafetySetting(HarmCategory.sexuallyExplicit, HarmBlockThreshold.medium),
      SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.medium),
    ];

    return GenerativeModel(
      model: _modelName,
      apiKey: _apiKey,
      safetySettings: safetySettings,
    );
  }

  Future<String> generateTripPlan({
    required String destination,
    required int days,
    required double budget,
    required String seasonOrTime,
    List<String> interests = const [],
  }) async {
    final model = _createModel();
    final prompt = '''
    You are an expert travel day-planner.
    
    Create a ${days}-day travel plan for: $destination
    Season/time of visit: $seasonOrTime
    Total budget: ${budget.toStringAsFixed(0)} EUR.
    
    Requirements:
    - Return a plan for each day with hour-by-hour schedule (morning/afternoon/evening is okay if hours are not practical).
    - Include approximate cost per activity and a daily budget summary.
    - For each day add: "If it rains" indoor alternative(s).
    - Keep it realistic: travel times between places, meal times, rest breaks.
    - Output should be easy to read with clear headings per day.
    ''';

    final response = await model.generateContent([Content.text(prompt)]);
    final text = response.text;

    if (text == null || text.trim().isEmpty) {
      throw Exception('Gemini returned empty response');
    }

    return text.trim();
  }
}