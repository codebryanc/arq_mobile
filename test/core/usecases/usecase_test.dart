import 'package:flutter_test/flutter_test.dart';

import 'package:arq_mobile/core/usecases/usecase.dart';

void main() {
  group('NoParams', () {
    test('can be instantiated', () {
      const params = NoParams();

      expect(params, isA<NoParams>());
    });
  });

  group('OnlineParams', () {
    test('holds isOnline true', () {
      const params = OnlineParams(isOnline: true);

      expect(params.isOnline, isTrue);
    });

    test('holds isOnline false', () {
      const params = OnlineParams(isOnline: false);

      expect(params.isOnline, isFalse);
    });
  });
}
