import '../../../../core/constants/asset_paths.dart';
import '../../domain/entities/project.dart';
import '../../domain/repositories/projects_repository.dart';

/// Store apps use carousel URLs from storefront CDNs (`play-lh…`, Apple `mzstatic`). Those paths can
/// change when listings update—re-scrape from Play / App Store if needed.
///
/// Non-store rows: single hero (`showcaseImageUrls` empty)—`bannerImageUrl` from site/GitHub OG, or
/// `bannerAssetPath` when the art is bundled (e.g. Humani PNG to avoid Flutter Web CORS on remote assets).
class ProjectsRepositoryImpl implements ProjectsRepository {
  /// Siemens Omnivise — Play (`com.siemensenergy.oam`).
  static const String _siemensCover =
      'https://play-lh.googleusercontent.com/'
      'Tstk5ZWdpvVKwDNQ7nWOCeqJLpkQOeBlONMNo8lYUb9qYcCQuveP06rg1ejFcIwHLQ8u=w1052-h592';

  static const List<String> _siemensStoreShots = [
    _siemensCover,
    'https://play-lh.googleusercontent.com/'
        '-HCkc9Qb1-2u4xXHOEzLRovdND4PoB1tUV2wl7fBfm_CTdSudnr3aqD4mw0nrkWigYI=w1052-h592',
    'https://play-lh.googleusercontent.com/'
        'kIYQhkam4OYwVfIS7IZ5-C0dWxwvqKCESXGoaa8bxX2Z-1Oydj7qSeaFEWemdOx2bw=w1052-h592',
    'https://play-lh.googleusercontent.com/'
        '-Rw1HvX46wyv8yMqd1r6LNBGJB9O4DhOrhXbhsNPPEtWCDJZFNyWa3cZSEnjU3w6xck=w1052-h592',
    'https://play-lh.googleusercontent.com/'
        'GAVZ7WECu5vQ6DYfbOVozDkSX2vwsRmDoJr9rs16zjIoB7J4ZzgXIFt15gURQ-lqOsIW=w1052-h592',
    'https://play-lh.googleusercontent.com/'
        'Ub0KAZy4znTW9b3FnBQcbUp1vkNmsvEenif2ypVRSpbXDnSvJCniyN453TlwUCagXoRQ=w1052-h592',
  ];

  /// Maids.cc — Play (`cc.maids.app`).
  static const String _maidsCover =
      'https://play-lh.googleusercontent.com/'
      'jpEmS2qGJiaU4Ng-8FzYzH2fZxC7dc-nZ36Tsumgi02BjH8FcsQ3YgujqErOn-VbBxSp=w1052-h592';

  static const List<String> _maidsStoreShots = [
    _maidsCover,
    'https://play-lh.googleusercontent.com/'
        '8zW19PS1imNUhpX-kIrs1VkRMQnrX8jUtj_3s1malvyhqLGs6apLH9_c9uzDIgbQaGkU=w1052-h592',
    'https://play-lh.googleusercontent.com/'
        'OvC6QJ1bcuTKJCvInhGtxSel0yroK63eOMGsQPsM_NfhrEfIgcMruZmddjzScHT8Tg=w1052-h592',
    'https://play-lh.googleusercontent.com/'
        'm730rBorgHNg3SwGU51XKaTIqmDVvSAh8Rgc0VsyC87eDTwZDWJFItwvIfXJPnYO68Xl=w1052-h592',
    'https://play-lh.googleusercontent.com/'
        'rBocbhawhN8HGnvVvnua_aL6AiJuNaSI33VU3oa_VXm_bZlpcYXT6h5IvyTXExJ5pQ=w1052-h592',
    'https://play-lh.googleusercontent.com/'
        'U2CJEttwmqg2hO51NN1Pg10PSiTlfTWWoBTDFF8oOOxx-qG9HPD1h4Fst18j6D_dKQ=w1052-h592',
  ];

  /// Gotcha! — Play (`com.gotchapet.app.v2`).
  static const String _gotchaCover =
      'https://play-lh.googleusercontent.com/'
      '6ZUKIEiMHftAhHn8XnAPGWl_P72f1KjQehjfwoMxe2oUbkrTz2goEu3dAmVjd8pSq1JyVI1uLYPCJszCSkDy=w1052-h592';

  static const List<String> _gotchaStoreShots = [
    _gotchaCover,
    'https://play-lh.googleusercontent.com/'
        'cKcK2gDRJNxYW-Ls9M2VJvcEtmQmSgRbTbqmMHjCxCxlN7ctfFX3iXC8yjIdv8RHBp4yutWNwmoMp17im0aDBw=w1052-h592',
    'https://play-lh.googleusercontent.com/'
        'fgkQDO67rJK7qK64wcz_os4xEs6TDMDhXU8wGV20tB5z-j4QL3uAnRjjt8DM_ZfdVlTvpQrH2ovKEmlyvSsWFQ0=w1052-h592',
    'https://play-lh.googleusercontent.com/'
        'XFVpuggqBubob2-Z_Z9Bui0yftdZ0FUMbImK-S6ej3OyeA09ULRS8dJyA4gtH9bPzIaZaU-D0Q88NaGQ7sXc6w=w1052-h592',
    'https://play-lh.googleusercontent.com/'
        'L9w4Ilzn9vDYoCr_UQw5DoAv4JgyrOrhoaX89Ds0pZ3hNF9p8uPZidArSn1JzemQf8-wtFjDKCOjKacKv1bdRQ=w1052-h592',
    'https://play-lh.googleusercontent.com/'
        'zvzT7Ghmw9noSvP4MmfrzBpPSoUSk53kGUqUu-diKNCDQkhVFl2Z1w304h9VELbUi5x36ca-z8sOlv9qQniudQ=w1052-h592',
  ];

  /// Clinic CRM — App Store screenshots (`lookup` API, iPhone frames).
  static const String _clinicCover =
      'https://is1-ssl.mzstatic.com/image/thumb/PurpleSource125/v4/'
      'd8/ee/eb/d8eeeb7b-510e-8b64-9d41-3f7306b93daf/'
      '0ce9e538-ddeb-49de-b6b7-e03fa3c9a5d0_2.jpg/392x696bb.jpg';

  static const List<String> _clinicStoreShots = [
    _clinicCover,
    'https://is1-ssl.mzstatic.com/image/thumb/PurpleSource125/v4/'
        '46/42/31/464231a8-31fe-5fbd-3dfd-968e39f609bf/'
        '377adae0-fe04-41d0-b47d-5fcf1fa3b65c_9.jpg/392x696bb.jpg',
    'https://is1-ssl.mzstatic.com/image/thumb/PurpleSource115/v4/'
        'dd/b9/7b/ddb97bd0-97ca-959c-f8fe-9a6a7c210988/'
        '99199f7b-f718-4573-8239-a9e2020c73f5_10.jpg/392x696bb.jpg',
    'https://is1-ssl.mzstatic.com/image/thumb/PurpleSource125/v4/'
        'ae/d0/18/aed0186c-a2fb-3a34-c140-da50c7204979/'
        'c4f673cc-8671-41ca-860b-f08bd4c354f2_11.jpg/392x696bb.jpg',
    'https://is1-ssl.mzstatic.com/image/thumb/PurpleSource115/v4/'
        '49/94/84/4994841b-112b-4386-72b2-aa3eec5f71a7/'
        '6f3cdc51-1170-419a-ae24-9374cbc8661d_12.jpg/392x696bb.jpg',
    'https://is1-ssl.mzstatic.com/image/thumb/PurpleSource125/v4/'
        '91/33/73/91337371-52af-f096-0767-d63f5258323a/'
        '8f1438fc-6681-4774-856e-a469c5f51f51_14.jpg/392x696bb.jpg',
  ];

  /// GitHub Open Graph banner — [handover repo](https://github.com/AlhussienAldali/handover).
  /// Hash may rotate when repo metadata changes.
  static const String _handoverBanner =
      'https://opengraph.githubassets.com/d3f259ef4fcffeeaed6d8e8df7dc983a647097fadd4fc0b408552198e6d2242a/AlhussienAldali/handover';

  /// GitHub Open Graph — [portfolio repo](https://github.com/AlhussienAldali/alhussein_aldali_portfolio).
  static const String _portfolioBanner =
      'https://opengraph.githubassets.com/5f395ae38bc4e378f0aad7cf0b9be50b8a65d68e5672bd9afd68b61b4124564e/AlhussienAldali/alhussein_aldali_portfolio';

  @override
  List<Project> listProjects() {
    return const [
      Project(
        title: 'Humani AI app (v2 uplift)',
        description:
            'Senior Flutter track on an AI-powered mobile product: architecture mentoring, disciplined '
            'reviews, and phased delivery while stabilizing releases (BETA).',
        tech: ['Flutter', 'Architecture', 'Code review', 'AI workflows'],
        bannerAssetPath: AssetPaths.projectsHumaniFeature,
        webUrl: 'https://humani.ai',
        githubUrl: null,
        liveDemoUrl: null,
      ),
      Project(
        title: 'Siemens Energy Omnivise',
        description:
            'Field data-entry app used on site: QR-based asset lookup, capturing equipment states and '
            'photos—leaning workflows and cutting manual mistakes.',
        tech: ['Flutter', 'Offline-first', 'QR', 'Photos', 'Field UX'],
        bannerImageUrl: _siemensCover,
        showcaseImageUrls: _siemensStoreShots,
        webUrl:
            'https://play.google.com/store/apps/details?id=com.siemensenergy.oam',
        githubUrl: null,
        liveDemoUrl: null,
      ),
      Project(
        title: 'Maids.cc marketplace stack',
        description:
            'Rebuilt Flutter portal experiences with shared mobile core libraries, technical leadership '
            '(reviews, grooming) plus Yaya: maps, Firebase-rich flows, payments.',
        tech: ['Flutter', 'Maps', 'Firebase', 'Payments'],
        bannerImageUrl: _maidsCover,
        showcaseImageUrls: _maidsStoreShots,
        webUrl:
            'https://play.google.com/store/apps/details?id=cc.maids.app&hl=en_US&gl=US',
        githubUrl: null,
        liveDemoUrl: null,
      ),
      Project(
        title: 'Gotcha! Lost & Found',
        description:
            'Consumer Flutter app by Max & Molly Urban Pets GmbH for QR pet tags: when someone scans '
            'a tag, finders see safe pet-and-owner routing and owners get alerted with location '
            'context—instant reunions without juggling phone numbers.',
        tech: ['Flutter', 'QR', 'Push alerts', 'Location'],
        bannerImageUrl: _gotchaCover,
        showcaseImageUrls: _gotchaStoreShots,
        webUrl:
            'https://play.google.com/store/apps/details?id=com.gotchapet.app.v2&hl=en',
        githubUrl: null,
        liveDemoUrl: null,
      ),
      Project(
        title: 'ClinicSoftware CRM Assistant',
        description:
            'Mobile CRM companion for ClinicSoftware.COM (CLINIC SOFTWARE LTD): visual sales pipeline on '
            'iPhone and iPad, calendar and tasks with reminders, team feeds with @mentions, strong '
            'offline sync across contacts and deals—and push alerts so reps act on leads in the moment.',
        tech: ['Flutter', 'CRM', 'Offline sync', 'Push notifications'],
        bannerImageUrl: _clinicCover,
        showcaseImageUrls: _clinicStoreShots,
        webUrl:
            'https://apps.apple.com/app/clinic-software-crm-assistant/id1555953966',
        githubUrl: null,
        liveDemoUrl: null,
      ),
      Project(
        title: 'Handover (delivery simulation)',
        description:
            'Flutter learning project: a simulated delivery flow with a map, timeline stages, and scripted '
            'driver movement and local notifications—no production backend.',
        tech: ['Flutter', 'Google Maps', 'Provider', 'Local notifications'],
        bannerImageUrl: _handoverBanner,
        githubUrl: 'https://github.com/AlhussienAldali/handover',
        webUrl: null,
        liveDemoUrl: null,
      ),
      Project(
        title: 'Portfolio (this site)',
        description:
            'Feature-first Flutter web portfolio: Riverpod, go_router shells, reusable neon/glass widgets.',
        tech: ['Flutter Web', 'Riverpod', 'GoRouter', 'Cyber UI'],
        bannerImageUrl: _portfolioBanner,
        githubUrl:
            'https://github.com/AlhussienAldali/alhussein_aldali_portfolio',
        liveDemoUrl: null,
      ),
    ];
  }
}
