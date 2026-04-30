import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/about_repository_impl.dart';
import '../../domain/entities/about_content.dart';
import '../../domain/repositories/about_repository.dart';

final aboutRepositoryProvider = Provider<AboutRepository>((ref) {
  return AboutRepositoryImpl();
});

final aboutContentProvider = Provider<AboutContent>((ref) {
  return ref.watch(aboutRepositoryProvider).getAboutContent();
});

