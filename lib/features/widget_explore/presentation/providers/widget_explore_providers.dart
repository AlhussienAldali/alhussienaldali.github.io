import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/widget_explore_repository_impl.dart';
import '../../domain/entities/widget_demo_entry.dart';
import '../../domain/repositories/widget_explore_repository.dart';

final widgetExploreRepositoryProvider = Provider<WidgetExploreRepository>((ref) {
  return WidgetExploreRepositoryImpl();
});

final widgetDemoListProvider = Provider<List<WidgetDemoEntry>>((ref) {
  return ref.watch(widgetExploreRepositoryProvider).listDemos();
});
