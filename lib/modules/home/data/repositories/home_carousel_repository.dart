import 'package:flutter_knp_mobile_app_v2/core/database/database_tables.dart';
import 'package:flutter_knp_mobile_app_v2/core/database/repositories/supabase_repository.dart';
import 'package:flutter_knp_mobile_app_v2/modules/home/domain/entities/home_carousel_slide_entity.dart';

class HomeCarouselRepository extends SupabaseRepository {
  HomeCarouselRepository({super.client})
    : super(tableName: DatabaseTables.homeCarouselSlides);

  /// Active slides for [screen], ordered for carousel display.
  Future<List<HomeCarouselSlideEntity>> fetchActiveSlides({
    required HomeCarouselScreen screen,
  }) async {
    final response = await table
        .select(
          'id, screen, content_type, image_url, video_url, '
          'title, body, btn_text, btn_url, sort_order, is_active',
        )
        .eq('screen', screen.name)
        .eq('is_active', true)
        .eq('is_deleted', false)
        .order('sort_order', ascending: true);

    return (response as List<dynamic>)
        .map((row) => HomeCarouselSlideEntity.fromMap(row as Map<String, dynamic>))
        .toList();
  }
}
