import "dart:collection";

/// Basic Cache based on first-in-first-out
///
/// When the cache gets full (determined by the [size]) it will start
/// removing the older values.
///
/// Uses a simple [Queue] to store keys, and start removing the first ones
/// in a "first in-first out" manner, until the queue is smaller than the max
/// [size].
///
/// This cache can be used for storing in memory thumbnails and similar.
///
/// Call to [clear] when no longer used.
///
class BasicCache<K, V> {
  BasicCache({
    this.size,
  });

  final int size;
  final _map = Map<K, V>();
  final _queue = Queue<K>();

  bool containsKey(K key) {
    return _map.containsKey(key);
  }

  V operator [](K key) {
    return _map[key];
  }

  void operator []=(K key, V value) {
    _map[key] = value;
    _queue.add(key);
    _deleteOldValues();
  }

  void clear() {
    _map.clear();
    _queue.clear();
  }

  void _deleteOldValues() {
    while (_queue.length > size) {
      final key = _queue.removeFirst();
      _map.remove(key);
    }
  }
}
