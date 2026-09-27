import 'package:flutter/foundation.dart';
import 'package:yalla_5roga/core/demo/demo_data.dart';

class OutingPlace {
  const OutingPlace({
    required this.name,
    required this.area,
    this.latitude,
    this.longitude,
  });

  final String name;
  final String area;
  final double? latitude;
  final double? longitude;

  bool get hasCoordinates => latitude != null && longitude != null;

  OutingLocation toLocation() => OutingLocation(
        name: name,
        area: area,
        latitude: latitude,
        longitude: longitude,
      );

  @override
  bool operator ==(Object other) {
    return other is OutingPlace && other.name == name && other.area == area;
  }

  @override
  int get hashCode => Object.hash(name, area);
}

class OutingsProvider extends ChangeNotifier {
  OutingsProvider() {
    _outings = List.of(DemoData.heroSlides);
  }

  late List<HeroSlide> _outings;

  static const places = [
    OutingPlace(name: 'ZED Park', area: 'New Cairo', latitude: 30.0215, longitude: 31.4952),
    OutingPlace(name: 'The Brunch Room', area: 'Maadi', latitude: 29.9602, longitude: 31.2589),
    OutingPlace(name: "Lucille's", area: 'Zamalek', latitude: 30.0616, longitude: 31.2197),
    OutingPlace(name: 'The Tap East', area: 'Heliopolis', latitude: 30.0917, longitude: 31.3244),
    OutingPlace(name: 'Cairo Festival City', area: 'New Cairo', latitude: 30.0285, longitude: 31.4073),
  ];

  List<HeroSlide> get outings => List.unmodifiable(_outings);

  List<HeroSlide> forGroup(String groupId) {
    return _outings.where((outing) => outing.groupId == groupId).toList();
  }

  void add(HeroSlide outing) {
    _outings = [outing, ..._outings];
    notifyListeners();
  }
}
