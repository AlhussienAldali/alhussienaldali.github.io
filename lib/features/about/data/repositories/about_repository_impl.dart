import '../../domain/entities/about_content.dart';
import '../../domain/entities/experience_item.dart';
import '../../domain/repositories/about_repository.dart';

class AboutRepositoryImpl implements AboutRepository {
  @override
  AboutContent getAboutContent() {
    return const AboutContent(
      title: 'About',
      headline: 'Mobile developer · 8+ years in IT',
      summary:
          'Cross-platform Flutter specialist with senior-level experience designing and delivering '
          'production mobile apps—from AI-powered upgrades and Siemens field tooling to ecommerce '
          'and marketplace platforms. Strong on architecture reviews, Flutter core packages, CI/CD '
          'and pragmatic state management.',
      techStack: [
        'Flutter',
        'Dart',
        'Android · Kotlin',
        'Riverpod · Bloc · Provider',
        'MVVM · MVI',
        'REST',
        'Git · CI/CD',
      ],
      softSkills: [
        'Architecture design',
        'Offline-first',
        'UX analysis',
        'Unit / integration testing',
        'Store releases',
        'Vibe coding with AI tools',
      ],
      experience: [
        ExperienceItem(
          role: 'Senior Flutter Developer',
          company: 'Humani',
          period: 'Jan 2024 – Present',
          location: 'Denmark · Remote',
          highlights: [
            'Upgrading an AI‑powered app toward v2: architecture consulting, systematic code reviews '
                'and feature rollout aimed at stability and delivery speed (BETA phase).',
          ],
        ),
        ExperienceItem(
          role: 'Senior Flutter Developer',
          company: 'Siemens Energy — Omnivise',
          period: 'Dec 2022 – Apr 2024',
          location: 'Germany · Remote',
          highlights: [
            'Flutter field data‑entry flows: QR scanning, equipment states, photo capture—reducing manual errors.',
          ],
        ),
        ExperienceItem(
          role: 'Flutter Developer · Team lead (GotchaPet)',
          company: 'Freelance',
          period: 'Jul 2021 – Present',
          location: 'Romania',
          highlights: [
            'GotchaPet: led modernization to app v2 and production fixes.',
            'ClickSoftware: upgrades, third‑party integrations, IAP and other capabilities.',
          ],
        ),
        ExperienceItem(
          role: 'Technical Team Leader · Flutter lead',
          company: 'Maids.cc',
          period: 'Feb 2020 – Jul 2021',
          location: 'Dubai',
          highlights: [
            'Rebuilt portal apps for maid & client journeys with contemporary patterns and reusable core libraries.',
            'Yaya App: Maps, Firebase, video, native payments.',
          ],
        ),
        ExperienceItem(
          role: 'Flutter Developer',
          company: 'IT land',
          period: 'Jul 2019 – Feb 2020',
          location: 'Damascus',
          highlights: [
            'Clean‑architecture ecommerce with expressive UI and TDD‑style layering.',
          ],
        ),
        ExperienceItem(
          role: 'Software Engineer',
          company: 'Syriatel',
          period: 'May 2017 – Jul 2019',
          location: 'Damascus',
          highlights: [
            'Telco‑side engineering before focusing full‑time on Flutter.',
          ],
        ),
      ],
      education: [
        "Romanian-American University · Master's degree in Computer Science for Business · 2023–2024",
        'Al-Baath University, Homs · Bachelor in Computer Engineering · 2012–2018',
      ],
      awards: [
        'ICPC Programming Contest · Syria rank 5 (2013 & 2014) · Honorable mention in the Middle East',
      ],
      languages: [
        'Arabic — native',
        'English — C1 fluent',
      ],
    );
  }
}
