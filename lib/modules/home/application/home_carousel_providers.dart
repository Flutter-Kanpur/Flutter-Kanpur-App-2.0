import 'package:flutter_knp_mobile_app_v2/modules/home/data/repositories/home_carousel_repository.dart';
import 'package:flutter_knp_mobile_app_v2/modules/home/domain/entities/home_carousel_slide_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final homeCarouselRepositoryProvider = Provider<HomeCarouselRepository>(
  (ref) => HomeCarouselRepository(),
);

final homeCarouselSlidesProvider =
    AsyncNotifierProvider<HomeCarouselSlidesNotifier, List<Map<String, String?>>>(
      HomeCarouselSlidesNotifier.new,
    );

class HomeCarouselSlidesNotifier
    extends AsyncNotifier<List<Map<String, String?>>> {
  @override
  Future<List<Map<String, String?>>> build() => _load(HomeCarouselScreen.home);

  Future<List<Map<String, String?>>> _load(HomeCarouselScreen screen) async {
    final slides = await ref
        .read(homeCarouselRepositoryProvider)
        .fetchActiveSlides(screen: screen);
    return slides.map((slide) => slide.toCarouselMap()).toList();
  }

  Future<void> refresh() async {
    state = await AsyncValue.guard(() => _load(HomeCarouselScreen.home));
  }
}

final exploreCarouselSlidesProvider =
    AsyncNotifierProvider<ExploreCarouselSlidesNotifier, List<Map<String, String?>>>(
      ExploreCarouselSlidesNotifier.new,
    );

class ExploreCarouselSlidesNotifier
    extends AsyncNotifier<List<Map<String, String?>>> {
  @override
  Future<List<Map<String, String?>>> build() => _load(HomeCarouselScreen.explore);

  Future<List<Map<String, String?>>> _load(HomeCarouselScreen screen) async {
    final slides = await ref
        .read(homeCarouselRepositoryProvider)
        .fetchActiveSlides(screen: screen);
    return slides.map((slide) => slide.toCarouselMap()).toList();
  }

  Future<void> refresh() async {
    state = await AsyncValue.guard(() => _load(HomeCarouselScreen.explore));
  }
}
