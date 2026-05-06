import '../../domain/entities/widget_demo_entry.dart';
import '../../domain/repositories/widget_explore_repository.dart';

/// Add demo metadata here; previews are built by id in the presentation layer.
class WidgetExploreRepositoryImpl implements WidgetExploreRepository {
  @override
  List<WidgetDemoEntry> listDemos() {
    return const [
      WidgetDemoEntry(
        id: 'image_loader_takehome',
        title: 'Image loader',
        description:
            'Home project: exploring creative loading physics (FancyLogoLoader), random-image flow, '
            'caching, and palette-backdrop polish—vendored here as a full RandomImageScreen.',
      ),
      WidgetDemoEntry(
        id: 'neon_orb_pulse',
        title: 'Neon Orb',
        description: 'Glow + pulse accent — reusable for statuses or badges.',
      ),
      WidgetDemoEntry(
        id: 'shimmer_scan_line',
        title: 'Scan Line',
        description: 'Sci‑fi sweep overlay for loading or emphasis.',
      ),
      WidgetDemoEntry(
        id: 'liquid_chip',
        title: 'Liquid chip',
        description: 'Gradient border chip for tags or metrics.',
      ),
    ];
  }
}
