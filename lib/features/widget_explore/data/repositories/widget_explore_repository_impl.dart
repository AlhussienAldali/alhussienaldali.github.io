import '../../domain/entities/widget_demo_entry.dart';
import '../../domain/repositories/widget_explore_repository.dart';

/// Add demo metadata here; previews are built by id in the presentation layer.
class WidgetExploreRepositoryImpl implements WidgetExploreRepository {
  @override
  List<WidgetDemoEntry> listDemos() {
    return const [
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
      WidgetDemoEntry(
        id: 'you_custom',
        title: 'Your widget',
        description: 'Duplicate a card above and map a new preview in widget_explore_page.dart.',
      ),
    ];
  }
}
