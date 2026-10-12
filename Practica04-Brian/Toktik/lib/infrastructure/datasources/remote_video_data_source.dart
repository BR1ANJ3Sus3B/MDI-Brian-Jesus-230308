import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:practica04_brian/domain/repositories/video_data_source.dart';

class RemoteVideoDataSource implements VideoDataSource {
  RemoteVideoDataSource({http.Client? client})
      : _client = client ?? http.Client();

  final http.Client _client;

  List<Map<String, dynamic>>? _cache;

  static const int _videosPerPage = 6;
  static const String _graphVersion = 'v26.0';

  static const String _facebookPageId =
      String.fromEnvironment('FACEBOOK_PAGE_ID');

  static const String _facebookToken =
      String.fromEnvironment('FACEBOOK_ACCESS_TOKEN');

  static const String _instagramUserId =
      String.fromEnvironment('INSTAGRAM_USER_ID');

  static const String _instagramToken =
      String.fromEnvironment('INSTAGRAM_ACCESS_TOKEN');

  static const String _tiktokToken =
      String.fromEnvironment('TIKTOK_ACCESS_TOKEN');

  @override
  Future<List<Map<String, dynamic>>> getVideosByPage(int page) async {
    _cache ??= await _loadAllPlatforms();

    final int start = page * _videosPerPage;

    if (start >= _cache!.length) {
      return const [];
    }

    final int end =
        (start + _videosPerPage).clamp(0, _cache!.length);

    return _cache!.sublist(start, end);
  }

  Future<List<Map<String, dynamic>>> _loadAllPlatforms() async {
    print('');
    print('======================================');
    print('🚀 INICIANDO CARGA DE APIs');
    print('======================================');

    final results = await Future.wait<List<Map<String, dynamic>>>([
      _safeFetch(
        platform: 'FACEBOOK',
        fetch: _fetchFacebookVideos,
      ),
      _safeFetch(
        platform: 'TIKTOK',
        fetch: _fetchTikTokVideos,
      ),
      _safeFetch(
        platform: 'INSTAGRAM',
        fetch: _fetchInstagramVideos,
      ),
    ]);

    final facebook = results[0];
    final tiktok = results[1];
    final instagram = results[2];

    print('');
    print('======================================');
    print('📊 RESUMEN DE APIs');
    print('======================================');
    print('Facebook  : ${facebook.length} videos');
    print('TikTok    : ${tiktok.length} videos');
    print('Instagram : ${instagram.length} videos');
    print('======================================');
    print('');

    final videos = results
        .expand((items) => items)
        .toList(growable: false);

    if (videos.isEmpty) {
      throw StateError(
        'Ninguna API devolvió videos. '
        'Revisa los errores individuales mostrados anteriormente.',
      );
    }

    return videos;
  }

  Future<List<Map<String, dynamic>>> _safeFetch({
    required String platform,
    required Future<List<Map<String, dynamic>>> Function() fetch,
  }) async {
    try {
      print('');
      print('--------------------------------------');
      print('🔵 $platform: iniciando petición...');
      print('--------------------------------------');

      final videos = await fetch();

      print(
        '✅ $platform: ${videos.length} '
        '${videos.length == 1 ? 'video encontrado' : 'videos encontrados'}',
      );

      return videos;
    } catch (error, stackTrace) {
      print('');
      print('❌ ======================================');
      print('❌ ERROR EN $platform');
      print('❌ ======================================');
      print('❌ $error');

      // Si quieres ver también el stack completo:
      // print(stackTrace);

      return const [];
    }
  }

  // =========================================================
  // INSTAGRAM
  // =========================================================

  Future<List<Map<String, dynamic>>> _fetchInstagramVideos() async {
    if (_instagramUserId.isEmpty) {
      throw StateError(
        'INSTAGRAM_USER_ID está vacío. '
        'Ejecuta Flutter con --dart-define=INSTAGRAM_USER_ID=...',
      );
    }

    if (_instagramToken.isEmpty) {
      throw StateError(
        'INSTAGRAM_ACCESS_TOKEN está vacío. '
        'Ejecuta Flutter con '
        '--dart-define=INSTAGRAM_ACCESS_TOKEN=...',
      );
    }

    print('📸 Instagram User ID: $_instagramUserId');
    print('🔑 Instagram Token: configurado');

    final uri = Uri.https(
      'graph.facebook.com',
      '/$_graphVersion/$_instagramUserId/media',
      {
        'fields':
            'id,caption,media_type,media_product_type,'
            'media_url,thumbnail_url,permalink,timestamp,'
            'username,like_count,comments_count',
        'limit': '25',
        'access_token': _instagramToken,
      },
    );

    final json = await _getJson(
      uri,
      platform: 'INSTAGRAM',
    );

    final data =
        (json['data'] as List?)
                ?.whereType<Map<String, dynamic>>() ??
            const [];

    print('📸 Instagram: ${data.length} publicaciones recibidas');

    final videos = data
        .where(
          (item) =>
              item['media_type']
                  ?.toString()
                  .toUpperCase() ==
              'VIDEO',
        )
        .map(
          (item) => <String, dynamic>{
            'id': item['id']?.toString() ?? '',
            'name':
                item['caption']?.toString() ??
                'Video de Instagram',
            'userName':
                item['username']?.toString() ??
                'instagram',
            'songName': 'Instagram',
            'videoUrl':
                item['media_url']?.toString() ?? '',
            'externalUrl':
                item['permalink']?.toString(),
            'thumbnailUrl':
                item['thumbnail_url']?.toString(),
            'likes':
                (item['like_count'] as num?)?.toInt() ??
                0,
            'views': 0,
            'platform': 'instagram',
            'playbackType': 'network',
          },
        )
        .where(
          (item) =>
              (item['videoUrl'] as String).isNotEmpty,
        )
        .toList(growable: false);

    print(
      '🎬 Instagram: ${videos.length} videos después del filtro',
    );

    return videos;
  }

  // =========================================================
  // TIKTOK
  // =========================================================

  Future<List<Map<String, dynamic>>> _fetchTikTokVideos() async {
    if (_tiktokToken.isEmpty) {
      throw StateError(
        'TIKTOK_ACCESS_TOKEN está vacío. '
        'Ejecuta Flutter con '
        '--dart-define=TIKTOK_ACCESS_TOKEN=...',
      );
    }

    print('🎵 TikTok Token: configurado');

    final uri = Uri.https(
      'open.tiktokapis.com',
      '/v2/video/list/',
      {
        'fields':
            'id,title,video_description,duration,'
            'cover_image_url,embed_link,share_url,'
            'like_count,comment_count,share_count,'
            'view_count,create_time',
      },
    );

    print('🎵 TikTok: POST $uri');

    final response = await _client.post(
      uri,
      headers: {
        'Authorization': 'Bearer $_tiktokToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'max_count': 20,
      }),
    );

    print(
      '🎵 TikTok HTTP Status: ${response.statusCode}',
    );

    final json = _decodeResponse(
      response,
      platform: 'TIKTOK',
    );

    final data =
        json['data'] as Map<String, dynamic>?;

    if (data == null) {
      throw StateError(
        'TikTok no devolvió el objeto "data".',
      );
    }

    final videos =
        (data['videos'] as List?)
                ?.whereType<Map<String, dynamic>>() ??
            const [];

    print('🎵 TikTok: ${videos.length} videos recibidos');
    print('🎵 TikTok cursor: ${data['cursor']}');
    print('🎵 TikTok has_more: ${data['has_more']}');

    return videos
        .map(
          (item) => <String, dynamic>{
            'id': item['id']?.toString() ?? '',
            'name':
                (
                  item['video_description'] ??
                  item['title'] ??
                  'Video de TikTok'
                ).toString(),
            'userName': 'tiktok',
            'songName': 'TikTok',

            // NO es MP4. Es el reproductor embed oficial.
            'videoUrl':
                item['embed_link']?.toString() ?? '',

            'externalUrl':
                item['share_url']?.toString(),

            'thumbnailUrl':
                item['cover_image_url']?.toString(),

            'likes':
                (item['like_count'] as num?)
                    ?.toInt() ??
                0,

            'views':
                (item['view_count'] as num?)
                    ?.toInt() ??
                0,

            'platform': 'tiktok',
            'playbackType': 'embed',
          },
        )
        .where(
          (item) =>
              (item['videoUrl'] as String).isNotEmpty,
        )
        .toList(growable: false);
  }

  // =========================================================
  // FACEBOOK
  // =========================================================

  Future<List<Map<String, dynamic>>> _fetchFacebookVideos() async {
    if (_facebookPageId.isEmpty) {
      throw StateError(
        'FACEBOOK_PAGE_ID está vacío. '
        'Ejecuta Flutter con '
        '--dart-define=FACEBOOK_PAGE_ID=...',
      );
    }

    if (_facebookToken.isEmpty) {
      throw StateError(
        'FACEBOOK_ACCESS_TOKEN está vacío. '
        'Ejecuta Flutter con '
        '--dart-define=FACEBOOK_ACCESS_TOKEN=...',
      );
    }

    print('📘 Facebook Page ID: $_facebookPageId');
    print('🔑 Facebook Token: configurado');

    final uri = Uri.https(
      'graph.facebook.com',
      '/$_graphVersion/$_facebookPageId/feed',
      {
        'fields':
            'id,message,created_time,permalink_url,'
            'attachments{media_type,type,url,title}',
        'limit': '25',
        'access_token': _facebookToken,
      },
    );

    final json = await _getJson(
      uri,
      platform: 'FACEBOOK',
    );

    final data =
        (json['data'] as List?)
                ?.whereType<Map<String, dynamic>>() ??
            const [];

    print(
      '📘 Facebook: ${data.length} posts recibidos',
    );

    final result = <Map<String, dynamic>>[];

    for (final post in data) {
      final attachments =
          post['attachments'] as Map<String, dynamic>?;

      final attachmentData =
          (attachments?['data'] as List?)
                  ?.whereType<Map<String, dynamic>>() ??
              const [];

      final hasVideo = attachmentData.any(
        (attachment) {
          final mediaType =
              attachment['media_type']
                  ?.toString()
                  .toLowerCase() ??
              '';

          final type =
              attachment['type']
                  ?.toString()
                  .toLowerCase() ??
              '';

          return mediaType.contains('video') ||
              type.contains('video');
        },
      );

      if (!hasVideo) {
        continue;
      }

      final permalink =
          post['permalink_url']?.toString() ?? '';

      if (permalink.isEmpty) {
        continue;
      }

      result.add({
        'id': post['id']?.toString() ?? '',
        'name':
            post['message']?.toString() ??
            'Video de Facebook',
        'userName': 'facebook',
        'songName': 'Facebook',
        'videoUrl': permalink,
        'externalUrl': permalink,
        'likes': 0,
        'views': 0,
        'platform': 'facebook',
        'playbackType': 'embed',
      });
    }

    print(
      '🎬 Facebook: ${result.length} posts de video encontrados',
    );

    return result;
  }

  // =========================================================
  // HTTP
  // =========================================================

  Future<Map<String, dynamic>> _getJson(
    Uri uri, {
    required String platform,
  }) async {
    print('🌐 $platform GET: $uri');

    final response = await _client.get(uri);

    print(
      '🌐 $platform HTTP Status: ${response.statusCode}',
    );

    return _decodeResponse(
      response,
      platform: platform,
    );
  }

  Map<String, dynamic> _decodeResponse(
    http.Response response, {
    required String platform,
  }) {
    Object? decoded;

    try {
      decoded = jsonDecode(response.body);
    } catch (e) {
      throw FormatException(
        '$platform devolvió JSON inválido: '
        '${response.body}',
      );
    }

    if (response.statusCode < 200 ||
        response.statusCode >= 300) {
      throw StateError(
        '$platform HTTP ${response.statusCode}: '
        '${response.body}',
      );
    }

    if (decoded is! Map<String, dynamic>) {
      throw FormatException(
        '$platform devolvió una respuesta inválida.',
      );
    }

    final error = decoded['error'];

    if (error is Map<String, dynamic>) {
      final code = error['code']?.toString();
      final message = error['message']?.toString();
      final logId = error['log_id']?.toString();

      if (code != null && code != 'ok') {
        throw StateError(
          '$platform API ERROR\n'
          'Código: $code\n'
          'Mensaje: ${message ?? "Sin mensaje"}\n'
          'Log ID: ${logId ?? "N/A"}',
        );
      }
    }

    return decoded;
  }
}