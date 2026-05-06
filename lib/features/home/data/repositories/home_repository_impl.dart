import '../../../../core/constants/asset_paths.dart';
import '../../domain/entities/hero_section_content.dart';
import '../../domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  @override
  HeroSectionContent getHeroSectionContent() {
    return const HeroSectionContent(
      bioText:
          'I’m Alhussein Aldali — a results-oriented mobile developer with 8+ years in IT, '
          'shipping cross-platform apps for teams from Humani and Siemens Energy to marketplaces '
          'in MENA. I care about architecture that lasts, code review that teaches, and UX that '
          'actually works in the field. Browse projects, explore widget demos, or unwind with Neon Memory.',
      githubUrl: 'https://github.com/AlhussienAldali',
      linkedinUrl: 'https://www.linkedin.com/in/alhussein-aldali-2b2a99158/',
      heroGifAssetPath: AssetPaths.heroGif,
    );
  }
}
