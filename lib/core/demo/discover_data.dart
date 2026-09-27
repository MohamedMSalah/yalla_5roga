import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yalla_5roga/core/localization/l10n.dart';
import 'package:yalla_5roga/features/outings/presentation/providers/outings_provider.dart';

enum OutingVibe { food, activity, outdoor, movie }

class SuggestedPlace {
  const SuggestedPlace({
    required this.id,
    required this.name,
    required this.area,
    required this.vibe,
    required this.imageUrl,
    this.latitude,
    this.longitude,
  });

  final String id;
  final String name;
  final String area;
  final OutingVibe vibe;
  final String imageUrl;
  final double? latitude;
  final double? longitude;

  OutingPlace toOutingPlace() => OutingPlace(
        name: name,
        area: area,
        latitude: latitude,
        longitude: longitude,
      );

  String localizedName(L10n l10n) => l10n.suggestedPlaceName(id);

  String localizedArea(L10n l10n) => l10n.suggestedArea(area);
}

class SuggestedOuting {
  const SuggestedOuting({
    required this.id,
    required this.placeId,
    required this.vibe,
    required this.imageUrl,
    required this.hour,
    required this.minute,
    required this.weekday,
    this.featured = false,
  });

  final String id;
  final String placeId;
  final OutingVibe vibe;
  final String imageUrl;
  final int hour;
  final int minute;
  final int weekday;
  final bool featured;

  TimeOfDay get time => TimeOfDay(hour: hour, minute: minute);

  SuggestedPlace get place => DiscoverData.placeById(placeId);

  String title(L10n l10n) => l10n.suggestedOutingTitle(id);

  String blurb(L10n l10n) => l10n.suggestedOutingBlurb(id);

  String formattedTime(L10n l10n) {
    final date = DateTime(0, 1, 1, hour, minute);
    return DateFormat('h:mm a', l10n.locale.languageCode).format(date);
  }

  String formattedWeekday(L10n l10n) {
    return DateFormat.E(l10n.locale.languageCode).format(DateTime.utc(2024, 1, weekday));
  }

  DateTime nextDate() {
    final now = DateTime.now();
    var date = DateTime(now.year, now.month, now.day);
    while (date.weekday != weekday) {
      date = date.add(const Duration(days: 1));
    }
    final start = DateTime(date.year, date.month, date.day, hour, minute);
    if (!start.isAfter(now)) {
      date = date.add(const Duration(days: 7));
    }
    return date;
  }
}

class DiscoverData {
  const DiscoverData._();

  static const places = [
    SuggestedPlace(
      id: 'zed-park',
      name: 'ZED Park',
      area: 'New Cairo',
      vibe: OutingVibe.outdoor,
      imageUrl: 'https://images.unsplash.com/photo-1529156069898-49953e39b3ac?auto=format&fit=crop&w=800&q=85',
      latitude: 30.0215,
      longitude: 31.4952,
    ),
    SuggestedPlace(
      id: 'brunch-room',
      name: 'The Brunch Room',
      area: 'Maadi',
      vibe: OutingVibe.food,
      imageUrl: 'https://images.unsplash.com/photo-1533777324565-a040eb52facd?auto=format&fit=crop&w=800&q=85',
      latitude: 29.9602,
      longitude: 31.2589,
    ),
    SuggestedPlace(
      id: 'lucilles',
      name: "Lucille's",
      area: 'Zamalek',
      vibe: OutingVibe.food,
      imageUrl: 'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?auto=format&fit=crop&w=800&q=85',
      latitude: 30.0616,
      longitude: 31.2197,
    ),
    SuggestedPlace(
      id: 'tap-east',
      name: 'The Tap East',
      area: 'Heliopolis',
      vibe: OutingVibe.activity,
      imageUrl: 'https://images.unsplash.com/photo-1517457373958-b7bdd4587205?auto=format&fit=crop&w=800&q=85',
      latitude: 30.0917,
      longitude: 31.3244,
    ),
    SuggestedPlace(
      id: 'cfc',
      name: 'Cairo Festival City',
      area: 'New Cairo',
      vibe: OutingVibe.activity,
      imageUrl: 'https://images.unsplash.com/photo-1579532537598-459ecdaf39cc?auto=format&fit=crop&w=800&q=85',
      latitude: 30.0285,
      longitude: 31.4073,
    ),
    SuggestedPlace(
      id: 'left-bank',
      name: 'Left Bank',
      area: 'Zamalek',
      vibe: OutingVibe.food,
      imageUrl: 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?auto=format&fit=crop&w=800&q=85',
      latitude: 30.0619,
      longitude: 31.2235,
    ),
    SuggestedPlace(
      id: 'sequoia',
      name: 'Sequoia',
      area: 'Zamalek',
      vibe: OutingVibe.food,
      imageUrl: 'https://images.unsplash.com/photo-1559339352-11d035aa65de?auto=format&fit=crop&w=800&q=85',
      latitude: 30.0730,
      longitude: 31.2240,
    ),
    SuggestedPlace(
      id: 'os-pasta',
      name: "O's Pasta",
      area: 'Maadi',
      vibe: OutingVibe.food,
      imageUrl: 'https://images.unsplash.com/photo-1621996346565-e3dbc646d9a9?auto=format&fit=crop&w=800&q=85',
      latitude: 29.9600,
      longitude: 31.2560,
    ),
    SuggestedPlace(
      id: 'azhar-park',
      name: 'Al Azhar Park',
      area: 'Islamic Cairo',
      vibe: OutingVibe.outdoor,
      imageUrl: 'https://images.unsplash.com/photo-1501785888041-af3ef285b470?auto=format&fit=crop&w=800&q=85',
      latitude: 30.0408,
      longitude: 31.2647,
    ),
    SuggestedPlace(
      id: 'felucca',
      name: 'Felucca Dock',
      area: 'Garden City',
      vibe: OutingVibe.outdoor,
      imageUrl: 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=800&q=85',
      latitude: 30.0370,
      longitude: 31.2290,
    ),
    SuggestedPlace(
      id: 'wadi-degla',
      name: 'Wadi Degla Protectorate',
      area: 'Maadi',
      vibe: OutingVibe.outdoor,
      imageUrl: 'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=800&q=85',
      latitude: 29.9550,
      longitude: 31.3350,
    ),
    SuggestedPlace(
      id: 'vox-cfc',
      name: 'VOX Cinemas',
      area: 'Cairo Festival City',
      vibe: OutingVibe.movie,
      imageUrl: 'https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?auto=format&fit=crop&w=800&q=85',
      latitude: 30.0285,
      longitude: 31.4073,
    ),
    SuggestedPlace(
      id: 'zawya',
      name: 'Zawya',
      area: 'Downtown',
      vibe: OutingVibe.movie,
      imageUrl: 'https://images.unsplash.com/photo-1517604931442-7e0c8ed2963c?auto=format&fit=crop&w=800&q=85',
      latitude: 30.0475,
      longitude: 31.2384,
    ),
  ];

  static const outings = [
    SuggestedOuting(
      id: 'sunset-picnic',
      placeId: 'zed-park',
      vibe: OutingVibe.outdoor,
      imageUrl: 'https://images.unsplash.com/photo-1529156069898-49953e39b3ac?auto=format&fit=crop&w=800&q=85',
      hour: 18,
      minute: 30,
      weekday: DateTime.saturday,
      featured: true,
    ),
    SuggestedOuting(
      id: 'weekend-brunch',
      placeId: 'brunch-room',
      vibe: OutingVibe.food,
      imageUrl: 'https://images.unsplash.com/photo-1533777324565-a040eb52facd?auto=format&fit=crop&w=800&q=85',
      hour: 11,
      minute: 30,
      weekday: DateTime.saturday,
      featured: true,
    ),
    SuggestedOuting(
      id: 'game-night',
      placeId: 'tap-east',
      vibe: OutingVibe.activity,
      imageUrl: 'https://images.unsplash.com/photo-1517457373958-b7bdd4587205?auto=format&fit=crop&w=800&q=85',
      hour: 20,
      minute: 0,
      weekday: DateTime.friday,
      featured: true,
    ),
    SuggestedOuting(
      id: 'bowling-night',
      placeId: 'cfc',
      vibe: OutingVibe.activity,
      imageUrl: 'https://images.unsplash.com/photo-1579532537598-459ecdaf39cc?auto=format&fit=crop&w=800&q=85',
      hour: 20,
      minute: 0,
      weekday: DateTime.wednesday,
      featured: true,
    ),
    SuggestedOuting(
      id: 'cinema-night',
      placeId: 'vox-cfc',
      vibe: OutingVibe.movie,
      imageUrl: 'https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?auto=format&fit=crop&w=800&q=85',
      hour: 19,
      minute: 30,
      weekday: DateTime.friday,
      featured: true,
    ),
    SuggestedOuting(
      id: 'nile-felucca',
      placeId: 'felucca',
      vibe: OutingVibe.outdoor,
      imageUrl: 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=800&q=85',
      hour: 17,
      minute: 0,
      weekday: DateTime.saturday,
    ),
    SuggestedOuting(
      id: 'pasta-night',
      placeId: 'os-pasta',
      vibe: OutingVibe.food,
      imageUrl: 'https://images.unsplash.com/photo-1621996346565-e3dbc646d9a9?auto=format&fit=crop&w=800&q=85',
      hour: 20,
      minute: 0,
      weekday: DateTime.thursday,
    ),
    SuggestedOuting(
      id: 'wadi-walk',
      placeId: 'wadi-degla',
      vibe: OutingVibe.outdoor,
      imageUrl: 'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=800&q=85',
      hour: 7,
      minute: 30,
      weekday: DateTime.saturday,
    ),
    SuggestedOuting(
      id: 'indie-screening',
      placeId: 'zawya',
      vibe: OutingVibe.movie,
      imageUrl: 'https://images.unsplash.com/photo-1517604931442-7e0c8ed2963c?auto=format&fit=crop&w=800&q=85',
      hour: 18,
      minute: 0,
      weekday: DateTime.thursday,
    ),
    SuggestedOuting(
      id: 'zamalek-dinner',
      placeId: 'sequoia',
      vibe: OutingVibe.food,
      imageUrl: 'https://images.unsplash.com/photo-1559339352-11d035aa65de?auto=format&fit=crop&w=800&q=85',
      hour: 21,
      minute: 0,
      weekday: DateTime.friday,
    ),
  ];

  static SuggestedPlace placeById(String id) {
    return places.firstWhere((place) => place.id == id, orElse: () => places.first);
  }

  static List<SuggestedOuting> featuredOutings() {
    return outings.where((outing) => outing.featured).toList();
  }

  static List<SuggestedOuting> outingsFor(OutingVibe? vibe) {
    if (vibe == null) return outings;
    return outings.where((outing) => outing.vibe == vibe).toList();
  }

  static List<SuggestedPlace> placesFor(OutingVibe? vibe) {
    if (vibe == null) return places;
    return places.where((place) => place.vibe == vibe).toList();
  }

  static List<OutingPlace> catalogPlaces() {
    final seen = <String>{};
    final result = <OutingPlace>[];
    for (final place in [...OutingsProvider.places, ...places.map((item) => item.toOutingPlace())]) {
      if (seen.add('${place.name}|${place.area}')) result.add(place);
    }
    return result;
  }
}
