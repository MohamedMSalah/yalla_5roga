import 'package:flutter/foundation.dart';

class OutingChatProvider extends ChangeNotifier {
  OutingChatProvider() {
    _unread = {
      'sunset-picnic': 4,
      'game-night': 2,
      'weekend-brunch': 1,
      'bowling-night': 3,
    };
  }

  late Map<String, int> _unread;

  int unreadFor(String eventId) => _unread[eventId] ?? 0;

  void markRead(String eventId) {
    if ((_unread[eventId] ?? 0) == 0) return;
    _unread[eventId] = 0;
    notifyListeners();
  }
}
