import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/day_plan.dart';
import '../services/gemini_service.dart';
import 'auth_provider.dart';
import 'library_provider.dart';

final geminiServiceProvider = Provider<GeminiService>((ref) {
  return GeminiService();
});

final planControllerProvider =
AsyncNotifierProvider<PlanController, DayPlan?>(PlanController.new);

class PlanController extends AsyncNotifier<DayPlan?> {
  static const _uuid = Uuid();

  @override
  Future<DayPlan?> build() async {
    return null;
  }

  Future<void> createPlan({
    required String destination,
    required int days,
    required double budget,
    required String seasonOrTime,
    List<String> interests = const [],
  }) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final gemini = ref.read(geminiServiceProvider);

      final planText = await gemini.generateTripPlan(
        destination: destination,
        days: days,
        budget: budget,
        seasonOrTime: seasonOrTime,
        interests: interests,
      );

      final newPlan = DayPlan(
        id: _uuid.v4(),
        destination: destination,
        duration: '$days days',
        budget: budget.toStringAsFixed(0),
        season: seasonOrTime,
        fullPlanText: planText,
        createdAt: DateTime.now(),
      );

      final auth = ref.read(authProvider);
      final uid = auth.uid;

      if (uid != null) {
        final repo = ref.read(libraryRepositoryProvider);
        await repo.addPlan(uid, newPlan);
      } else {
        throw Exception('User must be logged in to save a plan.');
      }

      return newPlan;
    });
  }

  void clear() {
    state = const AsyncData(null);
  }
}