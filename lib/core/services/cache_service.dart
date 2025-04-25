/// 제네릭 타입의 데이터를 캐싱하는 서비스
/// T: 캐시할 데이터의 타입
class CacheService<T> {
  // 메모리에 데이터를 저장하는 맵
  // key: 캐시 키
  // value: CacheItem 객체 (데이터와 타임스탬프 포함)
  final Map<String, CacheItem<T>> _cache = {};

  // 캐시 유효 기간 (기본값: 10분)
  final Duration _duration;

  CacheService({Duration? duration})
      : _duration = duration ?? Duration(minutes: 10);

  /// 캐시된 데이터를 조회하는 메서드
  /// key: 조회할 캐시의 키
  /// 반환: 캐시된 데이터 (만료된 경우 null)
  T? get(String key) {
    final item = _cache[key];
    if (item != null && !item.isExpired(_duration)) {
      return item.data;
    }
    return null;
  }

  /// 데이터를 캐시에 저장하는 메서드
  /// key: 저장할 캐시의 키
  /// data: 저장할 데이터
  void set(String key, T data) {
    _cache[key] = CacheItem(data: data, timestamp: DateTime.now());
  }

  /// 캐시를 초기화하는 메서드
  void clear() {
    _cache.clear();
  }
}

/// 캐시 아이템을 나타내는 클래스
/// T: 캐시된 데이터의 타입
class CacheItem<T> {
  // 실제 캐시된 데이터
  final T data;
  // 캐시된 시간
  final DateTime timestamp;

  CacheItem({required this.data, required this.timestamp});

  /// 캐시가 만료되었는지 확인하는 메서드
  /// duration: 캐시 유효 기간
  /// 반환: 만료 여부
  bool isExpired(Duration duration) {
    return DateTime.now().difference(timestamp) > duration;
  }
}
