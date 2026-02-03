import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/day_plan.dart';
import '../services/library_repository.dart';
import 'auth_provider.dart';

final libraryRepositoryProvider = Provider<LibraryRepository>((ref) {
  return LibraryRepository();
});

final userPlansStreamProvider = StreamProvider<List<DayPlan>>((ref) {
  final auth = ref.watch(authProvider);
  final uid = auth.uid;
  if (uid == null) return const Stream.empty();
  final repo = ref.watch(libraryRepositoryProvider);
  return repo.streamUserPlans(uid);
});

final userFavoritesStreamProvider = StreamProvider<List<DayPlan>>((ref) {
  final auth = ref.watch(authProvider);
  final uid = auth.uid;
  if (uid == null) return const Stream.empty();
  final repo = ref.watch(libraryRepositoryProvider);
  return repo.streamUserFavorites(uid);
});

final libraryControllerProvider = Provider((ref) => LibraryController(ref));

class LibraryController {
  final Ref _ref;

  LibraryController(this._ref);

  Future<void> add(DayPlan plan) async {
    final auth = _ref.read(authProvider);
    final uid = auth.uid;

    if (uid == null) return;

    final repo = _ref.read(libraryRepositoryProvider);
    await repo.addPlan(uid, plan);
  }

  Future<void> remove(DayPlan plan) async {
    final auth = _ref.read(authProvider);
    final uid = auth.uid;

    if (uid == null) return;

    final repo = _ref.read(libraryRepositoryProvider);
    await repo.removePlan(uid, plan.id);
  }

  Future<void> addFavorite(DayPlan plan) async {
    final auth = _ref.read(authProvider);
    final uid = auth.uid;
    if (uid == null) return;
    final repo = _ref.read(libraryRepositoryProvider);
    await repo.addFavorite(uid, plan);
  }

  Future<void> removeFavorite(DayPlan plan) async {
    final auth = _ref.read(authProvider);
    final uid = auth.uid;
    if (uid == null) return;
    final repo = _ref.read(libraryRepositoryProvider);
    await repo.removeFavorite(uid, plan.id);
  }
}

final librarySearchQueryProvider = StateProvider.autoDispose<String>((ref) => '');

final filteredUserPlansProvider = Provider.autoDispose<AsyncValue<List<DayPlan>>>((ref) {
  final query = ref.watch(librarySearchQueryProvider).trim().toLowerCase();
  final plansAsync = ref.watch(userPlansStreamProvider);

  return plansAsync.whenData((plans) {
    if (query.isEmpty) return plans;

    bool matches(DayPlan p) {
      final destination = (p.destination ?? '').toString();
      final season = (p.season ?? '').toString();
      final budget = (p.budget).toString();

      final text = (p.fullPlanText ?? '').toString();

      final haystack = '$destination $season $budget $text'.toLowerCase();
      return haystack.contains(query);
    }

    return plans.where(matches).toList();
  });
});