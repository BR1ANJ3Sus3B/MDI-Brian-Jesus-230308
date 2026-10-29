import 'package:cinemapedia/config/constants/environment.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  tearDown(dotenv.clean);

  test('Environment initializes without requiring a key', () async {
    await dotenv.load(fileName: 'assets/config/.env', isOptional: true);
    expect(dotenv.isInitialized, isTrue);
  });

  test('Environment reads the current key after loading', () {
    dotenv.loadFromString(envString: 'THE_MOVIEDB_KEY=test-key');
    expect(Environment.theMovieDbKey, 'test-key');
    dotenv.loadFromString(envString: 'THE_MOVIEDB_KEY=updated-key');
    expect(Environment.theMovieDbKey, 'updated-key');
  });
}
