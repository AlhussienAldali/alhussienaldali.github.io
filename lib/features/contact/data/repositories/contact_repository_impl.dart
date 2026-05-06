import '../../../../core/constants/asset_paths.dart';
import '../../domain/entities/contact_links.dart';
import '../../domain/repositories/contact_repository.dart';

class ContactRepositoryImpl implements ContactRepository {
  @override
  ContactLinks getContactLinks() {
    return const ContactLinks(
      email: 'mailto:alhussien.aldali@gmail.com',
      linkedinUrl: 'https://www.linkedin.com/in/alhussein-aldali-2b2a99158/',
      githubUrl: 'https://github.com/AlhussienAldali',
      phoneTel: 'tel:+40737961172',
      cvBundledAssetPath: AssetPaths.cvPdf,
    );
  }
}
