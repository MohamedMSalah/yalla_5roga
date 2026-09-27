import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yalla_5roga/core/constants/app_constants.dart';
import 'package:yalla_5roga/core/theme/app_colors.dart';
import 'package:yalla_5roga/core/utils/extensions.dart';
import 'package:yalla_5roga/core/widgets/app_alert.dart';
import 'package:yalla_5roga/core/widgets/app_icon_button.dart';
import 'package:yalla_5roga/core/widgets/app_page_bar.dart';
import 'package:yalla_5roga/core/widgets/app_snackbar.dart';
import 'package:yalla_5roga/core/widgets/custom_button.dart';
import 'package:yalla_5roga/core/widgets/custom_textfield.dart';

class PickedPlace {
  const PickedPlace({
    required this.latitude,
    required this.longitude,
    required this.name,
  });

  final double latitude;
  final double longitude;
  final String name;
}

class _SearchHit {
  const _SearchHit({required this.name, required this.point});

  final String name;
  final LatLng point;
}

class PickLocationPage extends StatefulWidget {
  const PickLocationPage({
    super.key,
    this.initialLatitude,
    this.initialLongitude,
    this.placeName,
  });

  final double? initialLatitude;
  final double? initialLongitude;
  final String? placeName;

  @override
  State<PickLocationPage> createState() => _PickLocationPageState();
}

class _PickLocationPageState extends State<PickLocationPage> {
  static const _cairo = LatLng(30.0444, 31.2357);

  final _map = MapController();
  late LatLng? _pin;
  late final TextEditingController _nameController;
  var _lookingUp = false;
  var _locating = false;

  @override
  void initState() {
    super.initState();
    final lat = widget.initialLatitude;
    final lng = widget.initialLongitude;
    _pin = lat != null && lng != null ? LatLng(lat, lng) : null;
    _nameController = TextEditingController(text: widget.placeName ?? '');
    _nameController.addListener(() {
      if (mounted) setState(() {});
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _askLocationOnFirstOpen();
    });
  }

  Future<void> _askLocationOnFirstOpen() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(AppConstants.locationPromptShownKey) ?? false) return;

    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
      await prefs.setBool(AppConstants.locationPromptShownKey, true);
      return;
    }
    if (!mounted) return;

    final l10n = context.l10n;
    final allowed = await AppAlert.confirm(
      title: l10n.locationAccessTitle,
      message: l10n.locationAccessBody,
      confirmText: l10n.allowLocation,
      cancelText: l10n.notNow,
    );
    await prefs.setBool(AppConstants.locationPromptShownKey, true);
    if (!allowed || !mounted) return;
    await _useCurrentLocation();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _map.dispose();
    super.dispose();
  }

  void _moveTo(LatLng point, {double zoom = 16}) {
    try {
      _map.move(point, zoom);
    } catch (_) {}
  }

  Future<void> _dropPin(LatLng point, {String? name}) async {
    setState(() {
      _pin = point;
      _lookingUp = name == null;
    });
    _moveTo(point);
    if (name != null && name.trim().isNotEmpty) {
      _nameController.text = name.trim();
      setState(() => _lookingUp = false);
      return;
    }
    final lookedUp = await _lookupName(point);
    if (!mounted) return;
    if (lookedUp != null && lookedUp.isNotEmpty) {
      _nameController.text = lookedUp;
    } else if (_nameController.text.trim().isEmpty) {
      _nameController.text = context.l10n.customPlace;
    }
    setState(() => _lookingUp = false);
  }

  Future<String?> _lookupName(LatLng point) async {
    try {
      final uri = Uri.https('nominatim.openstreetmap.org', '/reverse', {
        'format': 'jsonv2',
        'lat': '${point.latitude}',
        'lon': '${point.longitude}',
      });
      final response = await http.get(uri, headers: {'User-Agent': 'Yalla5roga/1.0'});
      if (response.statusCode != 200) return null;
      final data = jsonDecode(response.body);
      if (data is! Map) return null;
      final named = data['name'] as String?;
      if (named != null && named.trim().isNotEmpty) return named.trim();
      final display = data['display_name'] as String?;
      if (display == null || display.trim().isEmpty) return null;
      return display.split(',').first.trim();
    } catch (_) {
      return null;
    }
  }

  Future<void> _useCurrentLocation() async {
    if (_locating) return;
    final l10n = context.l10n;
    setState(() => _locating = true);
    try {
      final enabled = await Geolocator.isLocationServiceEnabled();
      if (!enabled) {
        if (mounted) AppSnackBar.show(l10n.locationDisabled);
        return;
      }
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        if (mounted) AppSnackBar.show(l10n.locationPermissionDenied);
        return;
      }
      final position = await Geolocator.getCurrentPosition();
      if (!mounted) return;
      await _dropPin(LatLng(position.latitude, position.longitude));
    } catch (_) {
      if (mounted) AppSnackBar.show(l10n.couldNotGetLocation);
    } finally {
      if (mounted) setState(() => _locating = false);
    }
  }

  Future<void> _openSearch() async {
    final hit = await Get.bottomSheet<_SearchHit>(
      const _PlaceSearchSheet(),
      isScrollControlled: true,
    );
    if (hit == null || !mounted) return;
    await _dropPin(hit.point, name: hit.name);
  }

  void _confirm() {
    final pin = _pin;
    if (pin == null) return;
    final name = _nameController.text.trim().isEmpty ? context.l10n.customPlace : _nameController.text.trim();
    Get.back(
      result: PickedPlace(latitude: pin.latitude, longitude: pin.longitude, name: name),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final center = _pin ?? _cairo;

    return Scaffold(
      appBar: AppPageBar(
        title: l10n.pickLocation,
        subtitle: _nameController.text.trim().isEmpty ? null : _nameController.text.trim(),
        trailingIcon: Icons.search,
        onTrailingTap: _openSearch,
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                FlutterMap(
                  mapController: _map,
                  options: MapOptions(
                    initialCenter: center,
                    initialZoom: _pin == null ? 12 : 15,
                    onTap: (_, point) => _dropPin(point),
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.yalla_5roga',
                    ),
                    if (_pin != null)
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: _pin!,
                            width: 40,
                            height: 40,
                            alignment: Alignment.bottomCenter,
                            child: const Icon(Icons.location_on, color: AppColors.brand600, size: 40),
                          ),
                        ],
                      ),
                  ],
                ),
                Positioned(
                  right: 16.w,
                  bottom: 16.h,
                  child: Column(
                    children: [
                      AppIconButton(
                        icon: Icons.search,
                        background: Colors.white,
                        onTap: _openSearch,
                      ),
                      8.gapH,
                      AppIconButton(
                        icon: _locating ? Icons.hourglass_top : Icons.my_location,
                        background: AppColors.brand600,
                        foreground: Colors.white,
                        onTap: _useCurrentLocation,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: Responsive.padding(horizontal: 20, top: 12, bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomTextField(
                    controller: _nameController,
                    label: l10n.chooseLocation,
                    hint: l10n.customPlace,
                    prefixIcon: Icons.place_outlined,
                  ),
                  Responsive.spaceSm.gapH,
                  Text(
                    _lookingUp ? l10n.locationPinned : l10n.tapToPin,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: context.palette.textMuted, fontSize: Responsive.fontSm),
                  ),
                  Responsive.spaceSm.gapH,
                  CustomButton(
                    label: l10n.confirmLocation,
                    icon: Icons.check,
                    onPressed: _pin == null || _lookingUp ? null : _confirm,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlaceSearchSheet extends StatefulWidget {
  const _PlaceSearchSheet();

  @override
  State<_PlaceSearchSheet> createState() => _PlaceSearchSheetState();
}

class _PlaceSearchSheetState extends State<_PlaceSearchSheet> {
  final _query = TextEditingController();
  var _results = const <_SearchHit>[];
  var _searching = false;
  var _searched = false;

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  Future<void> _search() async {
    final query = _query.text.trim();
    if (query.isEmpty) return;
    setState(() {
      _searching = true;
      _searched = true;
    });
    try {
      final uri = Uri.https('nominatim.openstreetmap.org', '/search', {
        'format': 'jsonv2',
        'q': query,
        'limit': '8',
      });
      final response = await http.get(uri, headers: {'User-Agent': 'Yalla5roga/1.0'});
      if (!mounted) return;
      if (response.statusCode != 200) {
        setState(() {
          _results = const [];
          _searching = false;
        });
        return;
      }
      final data = jsonDecode(response.body);
      final hits = <_SearchHit>[];
      if (data is List) {
        for (final item in data) {
          if (item is! Map) continue;
          final lat = double.tryParse('${item['lat']}');
          final lon = double.tryParse('${item['lon']}');
          if (lat == null || lon == null) continue;
          final named = (item['name'] as String?)?.trim();
          final display = (item['display_name'] as String?)?.trim();
          final label = (named != null && named.isNotEmpty)
              ? named
              : (display == null || display.isEmpty ? query : display.split(',').first.trim());
          hits.add(_SearchHit(name: label, point: LatLng(lat, lon)));
        }
      }
      setState(() {
        _results = hits;
        _searching = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _results = const [];
        _searching = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final palette = context.palette;

    return SafeArea(
      child: Container(
        height: Responsive.height * 0.7,
        padding: Responsive.padding(all: 20),
        decoration: BoxDecoration(
          color: palette.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.searchPlace, style: TextStyle(fontWeight: FontWeight.w800, fontSize: Responsive.fontMd)),
            Responsive.spaceMd.gapH,
            CustomTextField(
              controller: _query,
              label: l10n.searchPlace,
              hint: l10n.searchPlaceHint,
              prefixIcon: Icons.search,
              textInputAction: TextInputAction.search,
            ),
            Responsive.spaceSm.gapH,
            CustomButton(
              label: l10n.searchPlace,
              icon: Icons.search,
              onPressed: _searching ? null : _search,
            ),
            Responsive.spaceMd.gapH,
            Expanded(
              child: _searching
                  ? const Center(child: CircularProgressIndicator())
                  : !_searched
                      ? const SizedBox.shrink()
                      : _results.isEmpty
                          ? Center(
                              child: Text(
                                l10n.noPlaceResults,
                                style: TextStyle(color: palette.textMuted),
                              ),
                            )
                          : ListView.separated(
                              itemCount: _results.length,
                              separatorBuilder: (_, _) => 8.gapH,
                              itemBuilder: (context, index) {
                                final hit = _results[index];
                                return ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: const Icon(Icons.place_outlined, color: AppColors.brand600),
                                  title: Text(hit.name, style: const TextStyle(fontWeight: FontWeight.w700)),
                                  onTap: () => Get.back(result: hit),
                                );
                              },
                            ),
            ),
          ],
        ),
      ),
    );
  }
}
