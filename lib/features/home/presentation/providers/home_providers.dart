import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/home_repository_impl.dart';
import '../../domain/entities/hero_section_content.dart';
import '../../domain/repositories/home_repository.dart';

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  return HomeRepositoryImpl();
});

final heroSectionContentProvider = Provider<HeroSectionContent>((ref) {
  return ref.watch(homeRepositoryProvider).getHeroSectionContent();
});

