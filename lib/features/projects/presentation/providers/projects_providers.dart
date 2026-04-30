import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/projects_repository_impl.dart';
import '../../domain/entities/project.dart';
import '../../domain/repositories/projects_repository.dart';

final projectsRepositoryProvider = Provider<ProjectsRepository>((ref) {
  return ProjectsRepositoryImpl();
});

final projectsListProvider = Provider<List<Project>>((ref) {
  return ref.watch(projectsRepositoryProvider).listProjects();
});

