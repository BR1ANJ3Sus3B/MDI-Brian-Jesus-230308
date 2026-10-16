import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:practica04_brian/domain/entities/video_post.dart';
import 'package:practica04_brian/infrastructure/datasources/public_video_api.dart';

http.Response json(Object body) => http.Response(jsonEncode(body), 200);
void main() {
  test('NASA selecciona MP4 pequeño y pagina desde uno', () async {
    final api = PublicVideoApi(
      MockClient((request) async {
        if (request.url.path == '/search') {
          expect(request.url.queryParameters['page'], '3');
          return json({
            'collection': {
              'items': [
                {
                  'data': [
                    {'nasa_id': 'earth', 'title': 'Earth'},
                  ],
                },
              ],
            },
          });
        }
        return json({
          'collection': {
            'items': [
              {'href': 'https://example.org/earth~orig.mp4'},
              {'href': 'http://images-assets.nasa.gov/earth~small.mp4'},
              {'href': 'https://example.org/earth.jpg'},
            ],
          },
        });
      }),
    );
    final videos = await api.nasa(2);
    expect(
      videos.single.videoUrl,
      'https://images-assets.nasa.gov/earth~small.mp4',
    );
    expect(videos.single.platform, VideoPlatform.nasa);
    expect(videos.single.playbackType, VideoPlaybackType.network);
  });
  test('Archive elige MP4 pequeño y codifica nombres de archivo', () async {
    final api = PublicVideoApi(
      MockClient((request) async {
        if (request.url.path == '/advancedsearch.php') {
          return json({
            'response': {
              'docs': [
                {'identifier': 'film', 'title': 'Film'},
              ],
            },
          });
        }
        return json({
          'files': [
            {'name': 'large.mp4', 'size': '9999'},
            {'name': 'clip #1.mp4', 'size': '100'},
            {'name': 'cover.jpg', 'size': '1'},
          ],
        });
      }),
    );
    final videos = await api.archive(0);
    expect(
      videos.single.videoUrl,
      'https://archive.org/download/film/clip%20%231.mp4',
    );
  });
  test('Wikimedia usa variante de video y conserva autor y origen', () async {
    final api = PublicVideoApi(
      MockClient(
        (_) async => json({
          'query': {
            'pages': {
              '1': {
                'pageid': 1,
                'title': 'File:Nature.webm',
                'videoinfo': [
                  {
                    'user': 'Author',
                    'descriptionurl':
                        'https://commons.wikimedia.org/wiki/File:Nature.webm',
                    'derivatives': [
                      {'src': 'https://example.org/120.webm', 'width': 120},
                      {'src': 'https://example.org/360.webm', 'width': 360},
                      {'src': 'https://example.org/720.webm', 'width': 720},
                    ],
                  },
                ],
              },
            },
          },
        }),
      ),
    );
    final videos = await api.wikimedia(0);
    expect(videos.single.videoUrl, endsWith('360.webm'));
    expect(videos.single.userName, 'Author');
  });
  test('no inventa videos cuando la respuesta no contiene archivos', () async {
    final api = PublicVideoApi(MockClient((_) async => json({})));
    expect(await api.nasa(0), isEmpty);
    expect(await api.archive(0), isEmpty);
    expect(await api.wikimedia(0), isEmpty);
  });
  test('rechaza HTTP fallido y JSON inválido', () async {
    final api = PublicVideoApi(
      MockClient((_) async => http.Response('error', 503)),
    );
    await expectLater(api.nasa(0), throwsA(isA<http.ClientException>()));
    final invalid = PublicVideoApi(
      MockClient((_) async => http.Response('oops', 200)),
    );
    await expectLater(invalid.archive(0), throwsFormatException);
  });
}
