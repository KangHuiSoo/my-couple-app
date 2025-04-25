class CacheManager<T> {
  final Map<String, T> _cache = {};
  final Map<String, DateTime> _cacheTimestamp = {};
  final Duration cacheDuration;

  CacheManager({this.cacheDuration = const Duration(minutes: 10)});

  bool isCashed(String key) {
    return _cache.containsKey(key) &&
        DateTime.now().difference(_cacheTimestamp[key]!) < cacheDuration;
  }

  T? getCachedData(String key){
    return _cache[key];
  }

  void saveToCache(String key, T data) {
    _cache[key] = data;
    _cacheTimestamp[key] = DateTime.now();
  }
}
