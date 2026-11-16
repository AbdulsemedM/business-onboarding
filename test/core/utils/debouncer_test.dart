import 'package:business_onboarding/core/utils/debouncer.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const delay = Duration(milliseconds: 20);

  test('runs only the last action after the delay', () async {
    final calls = <int>[];
    final debouncer = Debouncer(delay);

    debouncer.run(() => calls.add(1));
    debouncer.run(() => calls.add(2));
    expect(calls, isEmpty);

    await Future<void>.delayed(delay * 2);
    expect(calls, [2]);
    expect(debouncer.isPending, isFalse);
  });

  test('flush runs the pending action immediately, once', () async {
    var count = 0;
    final debouncer = Debouncer(delay)..run(() => count++);

    debouncer.flush();
    expect(count, 1);

    await Future<void>.delayed(delay * 2);
    expect(count, 1);
  });

  test('cancel drops the pending action', () async {
    var count = 0;
    final debouncer = Debouncer(delay)..run(() => count++);

    debouncer.cancel();
    await Future<void>.delayed(delay * 2);
    expect(count, 0);
  });
}
