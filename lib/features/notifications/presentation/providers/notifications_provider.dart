import 'package:flutter/foundation.dart';
import 'package:yalla_5roga/core/demo/demo_data.dart';

class NotificationsProvider extends ChangeNotifier {
  NotificationsProvider() {
    _items = List.of(DemoData.notifications);
  }

  late List<DemoNotificationItem> _items;

  List<DemoNotificationItem> get items => List.unmodifiable(_items);

  int get unreadCount => _items.where((item) => item.unread).length;

  void markAllRead() {
    _items = _items.map((item) => item.copyWith(unread: false)).toList();
    notifyListeners();
  }

  void markRead(String id) {
    _items = _items
        .map((item) => item.id == id ? item.copyWith(unread: false) : item)
        .toList();
    notifyListeners();
  }
}
