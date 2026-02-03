import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/explore_template.dart';
import '../services/templates_repository.dart';

final templatesRepositoryProvider = Provider<TemplatesRepository>((ref) {
  return TemplatesRepository();
});

final exploreTemplatesStreamProvider = StreamProvider<List<ExploreTemplate>>((ref) {
  final repo = ref.watch(templatesRepositoryProvider);
  return repo.streamTemplates().map((items) {
    return items.map((m) => ExploreTemplate.fromMap(m)).toList();
  });
});