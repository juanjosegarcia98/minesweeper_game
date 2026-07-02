import 'dart:math';

Set<int> randomInts({
  required final int min,
  required final int max,
  required final int count,
  final Set<int> excludeNumbers = const <int>{},
}) {
  if (count > max - min + 1) {
    throw Exception('count must be smaller than max - min + 1.');
  }
  final Random rng = Random();
  final Set<int> seen = <int>{};
  while (seen.length < count) {
    final int newNumber = min + rng.nextInt(max - min + 1);
    if (excludeNumbers.isEmpty || !excludeNumbers.contains(newNumber)) {
      seen.add(newNumber);
    }
  }
  return seen;
}
