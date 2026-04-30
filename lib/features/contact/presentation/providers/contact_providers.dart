import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/contact_repository_impl.dart';
import '../../domain/entities/contact_links.dart';
import '../../domain/repositories/contact_repository.dart';

final contactRepositoryProvider = Provider<ContactRepository>((ref) {
  return ContactRepositoryImpl();
});

final contactLinksProvider = Provider<ContactLinks>((ref) {
  return ref.watch(contactRepositoryProvider).getContactLinks();
});

