/// Central list of asset paths (hero GIF, future illustrations, etc.).
abstract final class AssetPaths {
  /// Place your Canva GIF at this path (see `pubspec.yaml` assets).
  static const String heroGif = 'assets/images/dali_verse.gif';

  /// Bundled CV PDF (used for download / open from Contact).
  static const String cvPdf = 'assets/cv/Alhussein_Aldali_CV.pdf';

  /// About page section banners (`tools/gen_about_banners.py`).
  static const String aboutIntro = 'assets/images/about/about_intro.png';
  static const String aboutStack = 'assets/images/about/about_stack.png';
  static const String aboutFocus = 'assets/images/about/about_focus.png';
  static const String aboutExperience = 'assets/images/about/about_experience.png';
  static const String aboutEducation = 'assets/images/about/about_education.png';
  static const String aboutAwards = 'assets/images/about/about_awards.png';
  static const String aboutLanguages = 'assets/images/about/about_languages.png';

  /// Projects page hero banner + optional per-project tiles.
  static const String projectsHeader = 'assets/images/projects/projects_header.png';

  /// Humani portfolio card banner (bundled from humani.ai; avoids web CORS on direct PNG URLs).
  static const String projectsHumaniFeature = 'assets/images/projects/humani_feature_2.png';
}
