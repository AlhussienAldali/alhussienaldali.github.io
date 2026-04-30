import '../../domain/entities/project.dart';
import '../../domain/repositories/projects_repository.dart';

class ProjectsRepositoryImpl implements ProjectsRepository {
  @override
  List<Project> listProjects() {
    return const [
      Project(
        title: 'Humani AI app (v2 uplift)',
        description:
            'Senior Flutter track on an AI-powered mobile product: architecture mentoring, disciplined '
            'reviews, and phased delivery while stabilizing releases (BETA).',
        tech: ['Flutter', 'Architecture', 'Code review', 'AI workflows'],
        webUrl: 'https://humani.com',
        githubUrl: null,
        liveDemoUrl: null,
      ),
      Project(
        title: 'Siemens Energy Omnivise',
        description:
            'Field data-entry app used on site: QR-based asset lookup, capturing equipment states and '
            'photos—leaning workflows and cutting manual mistakes.',
        tech: ['Flutter', 'Offline-first', 'QR', 'Photos', 'Field UX'],
        webUrl:
            'https://www.siemens-energy.com/global/en/offerings/digital-solutions.html',
        githubUrl: null,
        liveDemoUrl: null,
      ),
      Project(
        title: 'Maids.cc marketplace stack',
        description:
            'Rebuilt Flutter portal experiences with shared mobile core libraries, technical leadership '
            '(reviews, grooming) plus Yaya: maps, Firebase-rich flows, payments.',
        tech: ['Flutter', 'Maps', 'Firebase', 'Payments'],
        webUrl: 'https://maids.cc',
        githubUrl: null,
        liveDemoUrl: null,
      ),
      Project(
        title: 'Portfolio (this site)',
        description:
            'Feature-first Flutter web portfolio: Riverpod, go_router shells, reusable neon/glass widgets.',
        tech: ['Flutter Web', 'Riverpod', 'GoRouter', 'Cyber UI'],
        githubUrl: 'https://github.com/AlhussienAldali',
        liveDemoUrl: null,
      ),
    ];
  }
}
