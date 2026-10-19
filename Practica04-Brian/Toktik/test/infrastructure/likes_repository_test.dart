import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:practica04_brian/domain/entities/video_post.dart';
import 'package:practica04_brian/infrastructure/repositories/likes_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test(
    'Localstore escribe en disco antes de confirmar y persiste quitar like',
    () async {
      final video = VideoPost(
        caption: 'test',
        videoUrl: 'test-${DateTime.now().microsecondsSinceEpoch}',
      );
      final file = File(
        'video_likes/${LocalstoreLikesRepository.keyFor(video)}',
      );
      addTearDown(() async {
        if (await file.exists()) await file.delete();
      });
      final repository = LocalstoreLikesRepository();
      await repository.setLiked(video, true);
      expect(jsonDecode(await file.readAsString())['liked'], isTrue);
      expect(await LocalstoreLikesRepository().isLiked(video), isTrue);
      await repository.setLiked(video, false);
      expect(jsonDecode(await file.readAsString())['liked'], isFalse);
      expect(await LocalstoreLikesRepository().isLiked(video), isFalse);
    },
  );
  test('un fallo real de escritura se propaga al llamador', () async {
    final video = VideoPost(
      caption: 'test',
      videoUrl: 'blocked-${DateTime.now().microsecondsSinceEpoch}',
    );
    final directory = Directory(
      'video_likes/${LocalstoreLikesRepository.keyFor(video)}',
    );
    await directory.create(recursive: true);
    addTearDown(() => directory.delete());
    await expectLater(
      LocalstoreLikesRepository().setLiked(video, true),
      throwsA(isA<FileSystemException>()),
    );
  });
  test('la identidad remota sobrevive cambios de URL y separa las fuentes', () {
    const first = VideoPost(
      id: '1',
      caption: 'A',
      videoUrl: 'https://example.org/a',
      platform: VideoPlatform.nasa,
    );
    const renewed = VideoPost(
      id: '1',
      caption: 'B',
      videoUrl: 'https://example.org/b',
      platform: VideoPlatform.nasa,
    );
    const other = VideoPost(
      id: '1',
      caption: 'A',
      videoUrl: 'https://example.org/a',
      platform: VideoPlatform.archive,
    );
    expect(
      LocalstoreLikesRepository.keyFor(first),
      LocalstoreLikesRepository.keyFor(renewed),
    );
    expect(
      LocalstoreLikesRepository.keyFor(first),
      isNot(LocalstoreLikesRepository.keyFor(other)),
    );
  });
}
