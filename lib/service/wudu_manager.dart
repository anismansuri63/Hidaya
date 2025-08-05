class WuduManager {
  static final WuduManager _instance = WuduManager._internal();

  factory WuduManager() => _instance;

  WuduManager._internal();

  bool hasConfirmedWudu = false;
}
