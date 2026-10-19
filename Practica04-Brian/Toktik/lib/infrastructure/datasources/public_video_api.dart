import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:practica04_brian/domain/entities/video_post.dart';

/// Tres APIs públicas sin tokens. Solo devuelve URLs de archivos reproducibles.
class PublicVideoApi {
  final http.Client client;
  PublicVideoApi(this.client);

  Future<Map<String, dynamic>> _get(Uri uri) async {
    final response = await client.get(uri).timeout(const Duration(seconds: 12));
    if (response.statusCode != 200) {
      throw http.ClientException('HTTP ${response.statusCode}', uri);
    }
    final data = jsonDecode(utf8.decode(response.bodyBytes));
    if (data is! Map<String, dynamic>) {
      throw const FormatException('JSON inválido');
    }
    return data;
  }

  static List<Map<String, dynamic>> _items(dynamic value) =>
      value is List ? value.whereType<Map<String, dynamic>>().toList() : [];

  static String? _url(dynamic value) {
    if (value is! String) return null;
    var uri = Uri.tryParse(value);
    if (uri?.scheme == 'http' && uri?.host == 'images-assets.nasa.gov') {
      uri = uri!.replace(scheme: 'https');
    }
    return uri != null && uri.scheme == 'https' && uri.host.isNotEmpty
        ? uri.toString()
        : null;
  }

  Future<List<VideoPost>> nasa(int page) async {
    final data = await _get(
      Uri.https('images-api.nasa.gov', '/search', {
        'q': 'earth',
        'media_type': 'video',
        'page_size': '2',
        'page': '${page + 1}',
      }),
    );
    final results = <VideoPost>[];
    for (final item in _items(data['collection']?['items'])) {
      final details = _items(item['data']);
      if (details.isEmpty || details.first['nasa_id'] is! String) continue;
      final info = details.first;
      final id = info['nasa_id'] as String;
      final assets = await _get(Uri.https('images-api.nasa.gov', '/asset/$id'));
      final urls = _items(assets['collection']?['items'])
          .map((asset) => _url(asset['href']))
          .whereType<String>()
          .where((url) => Uri.parse(url).path.toLowerCase().endsWith('.mp4'))
          .toList();
      urls.sort((a, b) => _quality(a).compareTo(_quality(b)));
      if (urls.isEmpty) continue;
      results.add(
        VideoPost(
          id: 'nasa:$id',
          caption: '${info['title'] ?? 'NASA'}',
          userName: 'NASA',
          songName: 'Audio del video',
          videoUrl: urls.first,
          platform: VideoPlatform.nasa,
          playbackType: VideoPlaybackType.network,
        ),
      );
    }
    return results;
  }

  static int _quality(String url) => url.contains('~small')
      ? 0
      : url.contains('~medium')
      ? 1
      : url.contains('~mobile')
      ? 2
      : 3;

  Future<List<VideoPost>> archive(int page) async {
    final data = await _get(
      Uri.https('archive.org', '/advancedsearch.php', {
        'q': 'collection:prelinger AND mediatype:movies AND format:"MPEG4"',
        'fl[]': 'identifier,title',
        'rows': '2',
        'page': '${page + 1}',
        'output': 'json',
        'sort[]': 'downloads desc',
      }),
    );
    final results = <VideoPost>[];
    for (final item in _items(data['response']?['docs'])) {
      final id = item['identifier'];
      if (id is! String) continue;
      final metadata = await _get(Uri.https('archive.org', '/metadata/$id'));
      final files = _items(metadata['files'])
          .where(
            (file) =>
                file['name'] is String &&
                (file['name'] as String).toLowerCase().endsWith('.mp4'),
          )
          .toList();
      files.sort(
        (a, b) => (int.tryParse('${a['size']}') ?? 0).compareTo(
          int.tryParse('${b['size']}') ?? 0,
        ),
      );
      if (files.isEmpty) continue;
      final url = Uri(
        scheme: 'https',
        host: 'archive.org',
        pathSegments: ['download', id, files.first['name'] as String],
      ).toString();
      results.add(
        VideoPost(
          id: 'archive:$id',
          caption: '${item['title'] ?? id}',
          userName: 'Internet Archive',
          songName: 'Audio del archivo',
          videoUrl: url,
          platform: VideoPlatform.archive,
          playbackType: VideoPlaybackType.network,
        ),
      );
    }
    return results;
  }

  Future<List<VideoPost>> wikimedia(int page) async {
    final data = await _get(
      Uri.https('commons.wikimedia.org', '/w/api.php', {
        'action': 'query',
        'format': 'json',
        'origin': '*',
        'generator': 'search',
        'gsrsearch': 'filetype:video nature',
        'gsrnamespace': '6',
        'gsrlimit': '2',
        'gsroffset': '${page * 2}',
        'prop': 'videoinfo',
        'viprop': 'url|derivatives|user',
      }),
    );
    final pages = data['query']?['pages'];
    if (pages is! Map) return [];
    final results = <VideoPost>[];
    for (final item in pages.values.whereType<Map>()) {
      final infos = _items(item['videoinfo']);
      if (infos.isEmpty) continue;
      final info = infos.first;
      final variants = _items(info['derivatives']).where((variant) {
        final url = _url(variant['src']);
        return url != null &&
            (Uri.parse(url).path.endsWith('.webm') ||
                Uri.parse(url).path.endsWith('.mp4'));
      }).toList();
      variants.sort(
        (a, b) => ((a['width'] as num?) ?? 10000).compareTo(
          (b['width'] as num?) ?? 10000,
        ),
      );
      final suitable = variants.where(
        (v) => ((v['width'] as num?) ?? 0) >= 360,
      );
      final selected = suitable.isNotEmpty
          ? suitable.first
          : variants.firstOrNull;
      final url = selected == null ? _url(info['url']) : _url(selected['src']);
      if (url == null ||
          !RegExp(
            r'\.(mp4|webm)$',
            caseSensitive: false,
          ).hasMatch(Uri.parse(url).path)) {
        continue;
      }
      results.add(
        VideoPost(
          id: "wikimedia:${item['pageid']}",
          caption: '${item['title'] ?? 'Naturaleza'}'.replaceFirst('File:', ''),
          userName: '${info['user'] ?? 'Wikimedia Commons'}',
          songName: 'Audio del archivo',
          externalUrl: _url(info['descriptionurl']),
          videoUrl: url,
          platform: VideoPlatform.wikimedia,
          playbackType: VideoPlaybackType.network,
        ),
      );
    }
    return results;
  }
}
