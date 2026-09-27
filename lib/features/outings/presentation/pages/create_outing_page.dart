import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:yalla_5roga/core/demo/demo_data.dart';
import 'package:yalla_5roga/core/demo/discover_data.dart';
import 'package:yalla_5roga/core/localization/l10n.dart';
import 'package:yalla_5roga/core/theme/app_colors.dart';
import 'package:yalla_5roga/core/utils/extensions.dart';
import 'package:yalla_5roga/core/widgets/app_card.dart';
import 'package:yalla_5roga/core/widgets/app_network_image.dart';
import 'package:yalla_5roga/core/widgets/app_page_bar.dart';
import 'package:yalla_5roga/core/widgets/app_snackbar.dart';
import 'package:yalla_5roga/core/widgets/custom_button.dart';
import 'package:yalla_5roga/core/widgets/custom_textfield.dart';
import 'package:yalla_5roga/core/widgets/icon_circle.dart';
import 'package:yalla_5roga/core/widgets/image_source_sheet.dart';
import 'package:yalla_5roga/features/outings/presentation/pages/event_page.dart';
import 'package:yalla_5roga/features/outings/presentation/pages/pick_location_page.dart';
import 'package:yalla_5roga/features/outings/presentation/providers/outings_provider.dart';
import 'package:yalla_5roga/features/outings/presentation/providers/saved_outings_provider.dart';
import 'package:yalla_5roga/features/outings/presentation/widgets/vibe_picker.dart';

class CreateOutingPage extends StatefulWidget {
  const CreateOutingPage({
    super.key,
    this.group,
    this.suggestion,
    this.suggestedPlace,
    this.saved,
    this.draft,
    this.specialEvent = false,
  });

  final DemoGroup? group;
  final SuggestedOuting? suggestion;
  final SuggestedPlace? suggestedPlace;
  final SavedOuting? saved;
  final OutingDraft? draft;
  final bool specialEvent;

  @override
  State<CreateOutingPage> createState() => _CreateOutingPageState();
}

class _CreateOutingPageState extends State<CreateOutingPage> {
  late final TextEditingController _nameController;
  final _customPlaceController = TextEditingController();
  int _step = 0;
  int _vibe = 0;
  bool _letVote = true;
  String? _image;
  DemoGroup? _group;
  DateTime _date = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _time = const TimeOfDay(hour: 11, minute: 30);
  OutingPlace? _place;
  double? _customLatitude;
  double? _customLongitude;
  OutingOccasion _occasion = OutingOccasion.none;
  late final bool _specialEvent;
  final _guestIds = <String>{};
  late final String _draftId;

  var _appliedSuggestionName = false;

  @override
  void initState() {
    super.initState();
    _specialEvent = widget.specialEvent || (widget.draft?.specialEvent ?? false);
    _nameController = TextEditingController(text: _specialEvent ? '' : 'Friday brunch');
    _group = widget.group;
    _draftId = widget.draft?.id ?? 'draft-${DateTime.now().millisecondsSinceEpoch}';
    if (_specialEvent) _occasion = OutingOccasion.birthday;
    _customPlaceController.addListener(_onCustomPlaceChanged);
    final suggestion = widget.suggestion;
    final suggestedPlace = widget.suggestedPlace ?? suggestion?.place;
    if (suggestion != null) {
      _image = suggestion.imageUrl;
      _vibe = suggestion.vibe.index;
      _time = suggestion.time;
      _date = suggestion.nextDate();
    }
    if (suggestedPlace != null) {
      _place = suggestedPlace.toOutingPlace();
      if (suggestion == null) _vibe = suggestedPlace.vibe.index;
    }
    final saved = widget.saved;
    if (saved != null) {
      _nameController.text = saved.title;
      _image = saved.image;
      _applyLocation(saved.location);
    }
    final draft = widget.draft;
    if (draft != null) {
      _nameController.text = draft.title;
      _image = draft.image;
      _vibe = draft.vibe;
      _time = draft.time;
      _date = draft.date;
      _occasion = draft.occasion == OutingOccasion.none && _specialEvent
          ? OutingOccasion.birthday
          : draft.occasion;
      _guestIds.addAll(draft.guestIds);
      if (draft.groupId != null) {
        _group = DemoData.groups.cast<DemoGroup?>().firstWhere(
          (group) => group?.id == draft.groupId,
          orElse: () => widget.group,
        );
      }
      _applyLocation(draft.location);
    }
    _date = _clampDate(_date);
  }

  void _applyLocation(OutingLocation location) {
    final match = DiscoverData.catalogPlaces().where(
      (place) => place.name == location.name && (location.area.isEmpty || place.area == location.area),
    );
    if (match.isNotEmpty) {
      _place = match.first;
      return;
    }
    _customPlaceController.text = location.label;
    _customLatitude = location.latitude;
    _customLongitude = location.longitude;
  }

  DateTime get _minDate {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  DateTime get _maxDate {
    final now = DateTime.now();
    return DateTime(now.year, now.month + 1, now.day);
  }

  DateTime _clampDate(DateTime date) {
    final day = DateTime(date.year, date.month, date.day);
    if (day.isBefore(_minDate)) return _minDate;
    if (day.isAfter(_maxDate)) return _maxDate;
    return day;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_appliedSuggestionName || widget.suggestion == null) return;
    _appliedSuggestionName = true;
    _nameController.text = widget.suggestion!.title(context.l10n);
  }

  String get _resolvedImage =>
      _image ?? (_specialEvent ? DemoData.specialEventImage(_occasion) : '');

  bool get _isCustomPlace => _customPlaceController.text.trim().isNotEmpty;

  bool get _customPlacePinned => _customLatitude != null && _customLongitude != null;

  OutingLocation? get _selectedLocation {
    if (_isCustomPlace) {
      return OutingLocation(
        name: _customPlaceController.text.trim(),
        latitude: _customLatitude,
        longitude: _customLongitude,
      );
    }
    return _place?.toLocation();
  }

  void _onCustomPlaceChanged() {
    if (!mounted) return;
    if (_isCustomPlace && _place != null) {
      setState(() => _place = null);
    }
  }

  Future<void> _pickCustomLocation() async {
    final picked = await Get.to<PickedPlace>(
      () => PickLocationPage(
        placeName: _customPlaceController.text.trim(),
        initialLatitude: _customLatitude,
        initialLongitude: _customLongitude,
      ),
    );
    if (picked == null || !mounted) return;
    setState(() {
      _place = null;
      _customLatitude = picked.latitude;
      _customLongitude = picked.longitude;
      _customPlaceController.text = picked.name;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _customPlaceController.dispose();
    super.dispose();
  }

  String get _formattedDate => DateFormat('EEE, d MMM').format(_date).toUpperCase();

  String get _formattedTime {
    final date = DateTime(0, 1, 1, _time.hour, _time.minute);
    return DateFormat('h:mm a').format(date);
  }

  String get _locationLabel {
    if (_customPlaceController.text.trim().isNotEmpty) return _customPlaceController.text.trim();
    if (_place != null) return '${_place!.name}, ${_place!.area}';
    return '';
  }

  Future<void> _pickDate() async {
    final initial = _clampDate(_date);
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: _minDate,
      lastDate: _maxDate,
    );
    if (picked == null || !mounted) return;
    setState(() => _date = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(context: context, initialTime: _time);
    if (picked == null || !mounted) return;
    setState(() => _time = picked);
  }

  bool get _groupLocked => widget.group != null;

  Future<void> _pickGroup() async {
    if (_groupLocked) return;
    final selected = await Get.bottomSheet<DemoGroup>(
      SafeArea(
        child: Builder(
          builder: (context) {
            final palette = context.palette;
            final l10n = context.l10n;
            return Container(
              padding: Responsive.padding(all: 20),
              decoration: BoxDecoration(
                color: palette.surface,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.chooseGroup, style: TextStyle(fontWeight: FontWeight.w800, fontSize: Responsive.fontMd)),
                  Responsive.spaceMd.gapH,
                  for (final group in DemoData.groups)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: AppNetworkImage(url: group.image, width: 40.w, height: 40.w, radius: 12.r),
                      title: Text(group.name, style: const TextStyle(fontWeight: FontWeight.w700)),
                      subtitle: Text(l10n.membersWillBeInvited(group.people.length)),
                      trailing: _group?.id == group.id
                          ? Icon(Icons.check_circle, color: AppColors.brand600, size: 22.w)
                          : null,
                      onTap: () => Get.back(result: group),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
    if (selected == null) return;
    setState(() => _group = selected);
  }

  void _next() {
    final l10n = context.l10n;
    if (_step == 0) {
      if (_nameController.text.trim().isEmpty) {
        AppSnackBar.show(l10n.nameRequired);
        return;
      }
      if (!_specialEvent && _image == null) {
        AppSnackBar.show(l10n.photoRequired);
        return;
      }
      if (_specialEvent) {
        if (_guestIds.isEmpty) {
          AppSnackBar.show(l10n.guestsRequired);
          return;
        }
      } else if (_group == null) {
        AppSnackBar.show(l10n.groupRequired);
        return;
      }
    }
    if (_step == 1) {
      if (_locationLabel.isEmpty) {
        AppSnackBar.show(l10n.locationRequired);
        return;
      }
      if (_isCustomPlace && !_customPlacePinned) {
        AppSnackBar.show(l10n.pickLocationRequired);
        return;
      }
    }
    setState(() => _step += 1);
  }

  void _create() {
    final guests = [
      for (final id in _guestIds)
        if (DemoData.memberById(id) != null) id,
    ];
    final outing = HeroSlide(
      id: 'outing-${DateTime.now().millisecondsSinceEpoch}',
      image: _resolvedImage,
      title: _nameController.text.trim(),
      meta: '$_locationLabel · $_formattedTime',
      date: _formattedDate,
      time: _formattedTime,
      going: _specialEvent ? guests.length : _group!.people.length,
      groupId: _specialEvent ? null : _group!.id,
      location: _selectedLocation,
      occasion: _occasion,
      guestIds: guests,
    );
    context.read<OutingsProvider>().add(outing);
    if (widget.draft != null) {
      context.read<SavedOutingsProvider>().removeDraft(widget.draft!.id);
    }
    AppSnackBar.show(context.l10n.outingCreated);
    Get.off(() => EventPage(event: outing));
  }

  Future<void> _saveDraft() async {
    final l10n = context.l10n;
    if (_nameController.text.trim().isEmpty) {
      AppSnackBar.show(l10n.nameRequired);
      return;
    }
    if (!_specialEvent && _image == null) {
      AppSnackBar.show(l10n.photoRequired);
      return;
    }
    if (_locationLabel.isEmpty) {
      AppSnackBar.show(l10n.locationRequired);
      return;
    }
    await context.read<SavedOutingsProvider>().saveDraft(
      OutingDraft(
        id: _draftId,
        title: _nameController.text.trim(),
        image: _resolvedImage,
        location: _selectedLocation ?? OutingLocation(name: _locationLabel),
        date: _date,
        hour: _time.hour,
        minute: _time.minute,
        vibe: _vibe,
        groupId: _group?.id,
        occasion: _occasion,
        specialEvent: _specialEvent,
        guestIds: _guestIds.toList(),
      ),
    );
    if (!mounted) return;
    AppSnackBar.show(l10n.draftSaved);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final titles = [l10n.theBasics, l10n.chooseLocation, l10n.reviewOuting];
    final headlines = [l10n.whatAreWeDoing, l10n.pickAPlace, l10n.reviewOuting];
    final bodies = [l10n.addEssentials, l10n.chooseLocationNext, l10n.almostThere];
    final actions = [l10n.continueToLocation, l10n.continueToReview, l10n.createAndGo];

    return Scaffold(
      appBar: AppPageBar(
        title: _specialEvent ? l10n.createSpecialEvent : l10n.createOuting,
        subtitle: _specialEvent ? l10n.specialEventSubtitle : l10n.funStartsHere,
        backIcon: _step == 0 ? Icons.close : Icons.chevron_left,
        onBack: () => _step == 0 ? Get.back() : setState(() => _step -= 1),
        trailing: _step == 2
            ? TextButton(
                onPressed: _saveDraft,
                child: Text(
                  l10n.saveDraft,
                  style: TextStyle(color: AppColors.brand600, fontWeight: FontWeight.w800, fontSize: Responsive.fontSm),
                ),
              )
            : null,
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: Responsive.padding(horizontal: 20, top: 16, bottom: 20),
                children: [
                  Row(
                    children: [
                      for (var i = 0; i < 3; i++) ...[
                        if (i > 0) 6.gapW,
                        Expanded(
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            height: 6.h,
                            decoration: BoxDecoration(
                              color: i <= _step
                                  ? (i == _step ? AppColors.brand600 : AppColors.brand200)
                                  : context.palette.border,
                              borderRadius: BorderRadius.circular(999.r),
                            ),
                          ),
                        ),
                      ],
                      Responsive.spaceSm.gapW,
                      Text(l10n.stepOf(_step + 1, 3), style: TextStyle(color: AppColors.brand600, fontWeight: FontWeight.w800, fontSize: 10.sp)),
                    ],
                  ),
                  Responsive.spaceLg.gapH,
                  Text(titles[_step].toUpperCase(), style: TextStyle(color: AppColors.brand600, fontSize: 10.sp, fontWeight: FontWeight.w800, letterSpacing: 1.4)),
                  Text(headlines[_step], style: TextStyle(fontSize: Responsive.fontLg, fontWeight: FontWeight.w800)),
                  Responsive.spaceXs.gapH,
                  Text(bodies[_step], style: TextStyle(color: context.palette.textMuted, fontSize: 12.sp)),
                  Responsive.spaceLg.gapH,
                  if (_step == 0) _basics(l10n),
                  if (_step == 1) _location(l10n),
                  if (_step == 2) _review(l10n),
                ],
              ),
            ),
            Padding(
              padding: Responsive.padding(horizontal: 20, top: 8, bottom: 16),
              child: CustomButton(
                label: _step == 2 && _specialEvent ? l10n.createSpecialEvent : actions[_step],
                icon: Icons.arrow_forward,
                onPressed: _step == 2 ? _create : _next,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleSelectAll() {
    final people = DemoData.groupContacts;
    setState(() {
      if (_guestIds.length == people.length) {
        _guestIds.clear();
      } else {
        _guestIds
          ..clear()
          ..addAll(people.map((person) => person.id));
      }
    });
  }

  Widget _basics(L10n l10n) {
    final preview = _image ?? (_specialEvent ? DemoData.specialEventImage(_occasion) : null);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () async {
            final path = await ImageSourceSheet.pick(title: context.l10n.uploadPhoto);
            if (path == null || !mounted) return;
            setState(() => _image = path);
          },
          child: preview == null
              ? Container(
                  height: 140.h,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: context.palette.surfaceMuted,
                    borderRadius: BorderRadius.circular(22.r),
                    border: Border.all(color: context.palette.border),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_a_photo_outlined, color: AppColors.brand600, size: 28.w),
                      8.gapH,
                      Text(l10n.uploadPhoto, style: TextStyle(color: AppColors.brand600, fontWeight: FontWeight.w800)),
                    ],
                  ),
                )
              : Stack(
                  children: [
                    AppNetworkImage(url: preview, width: double.infinity, height: 140.h, radius: 22.r),
                    if (_specialEvent && _image == null)
                      Positioned(
                        right: 12.w,
                        bottom: 12.h,
                        child: Container(
                          padding: Responsive.padding(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.55),
                            borderRadius: BorderRadius.circular(999.r),
                          ),
                          child: Text(
                            l10n.uploadPhoto,
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 10.sp),
                          ),
                        ),
                      ),
                  ],
                ),
        ),
        Responsive.spaceMd.gapH,
        CustomTextField(
          controller: _nameController,
          label: _specialEvent ? l10n.eventName : l10n.outingName,
          prefixIcon: Icons.auto_awesome,
        ),
        Responsive.spaceMd.gapH,
        if (_specialEvent) ...[
          Text(l10n.specialEvent, style: TextStyle(fontSize: Responsive.fontSm, fontWeight: FontWeight.w800, color: context.palette.textSecondary)),
          Responsive.spaceXs.gapH,
          Text(l10n.specialEventHint, style: TextStyle(color: context.palette.textMuted, fontSize: 10.sp)),
          Responsive.spaceSm.gapH,
          VibePicker(
            options: [
              VibeOption('🎂', l10n.birthday),
              VibeOption('💍', l10n.wedding),
            ],
            index: _occasion == OutingOccasion.wedding ? 1 : 0,
            onChanged: (index) => setState(() {
              _occasion = index == 1 ? OutingOccasion.wedding : OutingOccasion.birthday;
            }),
          ),
          Responsive.spaceMd.gapH,
          Row(
            children: [
              Expanded(
                child: Text(l10n.invitePeople, style: TextStyle(fontSize: Responsive.fontSm, fontWeight: FontWeight.w800, color: context.palette.textSecondary)),
              ),
              TextButton(
                onPressed: _toggleSelectAll,
                child: Text(
                  _guestIds.length == DemoData.groupContacts.length ? l10n.clearSelection : l10n.selectAll,
                  style: TextStyle(color: AppColors.brand600, fontWeight: FontWeight.w800, fontSize: Responsive.fontSm),
                ),
              ),
            ],
          ),
          Text(l10n.invitePeopleHint, style: TextStyle(color: context.palette.textMuted, fontSize: 10.sp)),
          Responsive.spaceSm.gapH,
          for (final person in DemoData.groupContacts) ...[
            AppCard(
              onTap: () => setState(() {
                if (!_guestIds.add(person.id)) _guestIds.remove(person.id);
              }),
              color: _guestIds.contains(person.id) ? context.palette.brandSoft : null,
              borderColor: _guestIds.contains(person.id) ? context.palette.brandSoftBorder : null,
              child: Row(
                children: [
                  AppNetworkImage(url: person.avatar, width: 40.w, height: 40.w, radius: 12.r),
                  12.gapW,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(person.name, style: const TextStyle(fontWeight: FontWeight.w800)),
                        Text(
                          DemoData.groupsForMember(person.id),
                          style: TextStyle(color: context.palette.textMuted, fontSize: 10.sp),
                        ),
                      ],
                    ),
                  ),
                  Checkbox(
                    value: _guestIds.contains(person.id),
                    activeColor: AppColors.brand600,
                    onChanged: (_) => setState(() {
                      if (!_guestIds.add(person.id)) _guestIds.remove(person.id);
                    }),
                  ),
                ],
              ),
            ),
            8.gapH,
          ],
        ] else ...[
          Text(l10n.pickAVibe, style: TextStyle(fontSize: Responsive.fontSm, fontWeight: FontWeight.w800, color: context.palette.textSecondary)),
          Responsive.spaceSm.gapH,
          VibePicker(
            options: [
              VibeOption('🍽️', l10n.food),
              VibeOption('🎳', l10n.activity),
              VibeOption('🌿', l10n.outdoor),
              VibeOption('🎬', l10n.movie),
            ],
            index: _vibe,
            onChanged: (index) => setState(() => _vibe = index),
          ),
          Responsive.spaceMd.gapH,
          Text(l10n.inviteAGroup, style: TextStyle(fontSize: Responsive.fontSm, fontWeight: FontWeight.w800, color: context.palette.textSecondary)),
          Responsive.spaceSm.gapH,
          AppCard(
            onTap: _groupLocked ? null : _pickGroup,
            color: _group == null ? context.palette.brandSoft : null,
            borderColor: _group == null ? context.palette.brandSoftBorder : null,
            child: Row(
              children: [
                IconCircle(
                  icon: Icons.groups_2_outlined,
                  background: _group == null ? AppColors.brand50 : AppColors.brand600,
                  foreground: _group == null ? AppColors.brand600 : Colors.white,
                ),
                12.gapW,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_group?.name ?? l10n.chooseGroup, style: const TextStyle(fontWeight: FontWeight.w800)),
                      Text(
                        _group == null ? l10n.inviteAGroup : l10n.membersWillBeInvited(_group!.people.length),
                        style: TextStyle(color: context.palette.textMuted, fontSize: 10.sp),
                      ),
                    ],
                  ),
                ),
                if (!_groupLocked) Icon(Icons.unfold_more, color: context.palette.textMuted),
              ],
            ),
          ),
        ],
        Responsive.spaceMd.gapH,
        Row(
          children: [
            Expanded(
              child: AppCard(
                onTap: _pickDate,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.date, style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w800, color: context.palette.textSecondary)),
                    Responsive.spaceSm.gapH,
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 16, color: AppColors.brand600),
                        Responsive.spaceSm.gapW,
                        Expanded(
                          child: Text(
                            DateFormat('d MMM').format(_date),
                            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12.sp),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            10.gapW,
            Expanded(
              child: AppCard(
                onTap: _pickTime,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.time, style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w800, color: context.palette.textSecondary)),
                    Responsive.spaceSm.gapH,
                    Row(
                      children: [
                        const Icon(Icons.schedule, size: 16, color: AppColors.brand600),
                        Responsive.spaceSm.gapW,
                        Expanded(
                          child: Text(_formattedTime, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12.sp)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        if (!_specialEvent) ...[
          12.gapH,
          AppCard(
            color: context.palette.brandSoft,
            borderColor: context.palette.brandSoftBorder,
            onTap: () => setState(() => _letVote = !_letVote),
            child: Row(
              children: [
                Checkbox(
                  value: _letVote,
                  activeColor: AppColors.brand600,
                  onChanged: (value) => setState(() => _letVote = value ?? true),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.letGroupVote, style: TextStyle(color: context.palette.brandStrong, fontWeight: FontWeight.w800, fontSize: 12.sp)),
                      Text(l10n.everyoneCanSuggest, style: TextStyle(color: AppColors.brand500, fontSize: 10.sp)),
                    ],
                  ),
                ),
                const Icon(Icons.how_to_vote_outlined, color: AppColors.brand600),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _location(L10n l10n) {
    return Column(
      children: [
        AppCard(
          onTap: _pickCustomLocation,
          color: _customPlacePinned ? context.palette.brandSoft : null,
          borderColor: _customPlacePinned ? context.palette.brandSoftBorder : null,
          child: Row(
            children: [
              IconCircle(
                icon: _customPlacePinned ? Icons.check_circle : Icons.add_location_alt_outlined,
                background: _customPlacePinned ? AppColors.brand600 : AppColors.brand50,
                foreground: _customPlacePinned ? Colors.white : AppColors.brand600,
              ),
              12.gapW,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _isCustomPlace ? _customPlaceController.text.trim() : l10n.pickOnMap,
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                    Text(
                      _customPlacePinned ? l10n.changeMapLocation : l10n.locationHint,
                      style: TextStyle(color: context.palette.textMuted, fontSize: 10.sp),
                    ),
                  ],
                ),
              ),
              Icon(Icons.map_outlined, color: AppColors.brand600, size: 20.w),
            ],
          ),
        ),
        Responsive.spaceMd.gapH,
        for (final place in DiscoverData.catalogPlaces()) ...[
          AppCard(
            onTap: () => setState(() {
              _place = place;
              _customLatitude = null;
              _customLongitude = null;
              _customPlaceController.clear();
            }),
            color: _place == place ? context.palette.brandSoft : null,
            borderColor: _place == place ? context.palette.brandSoftBorder : null,
            child: Row(
              children: [
                IconCircle(
                  icon: Icons.location_on_outlined,
                  background: _place == place ? AppColors.brand600 : AppColors.brand50,
                  foreground: _place == place ? Colors.white : AppColors.brand600,
                ),
                12.gapW,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(place.name, style: const TextStyle(fontWeight: FontWeight.w800)),
                      Text(place.area, style: TextStyle(color: context.palette.textMuted, fontSize: 10.sp)),
                    ],
                  ),
                ),
                if (_place == place) Icon(Icons.check_circle, color: AppColors.brand600, size: 20.w),
              ],
            ),
          ),
          8.gapH,
        ],
      ],
    );
  }

  Widget _review(L10n l10n) {
    return Column(
      children: [
        AppNetworkImage(url: _resolvedImage, width: double.infinity, height: 160.h, radius: 22.r),
        Responsive.spaceMd.gapH,
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_nameController.text.trim(), style: TextStyle(fontWeight: FontWeight.w800, fontSize: Responsive.fontMd)),
              if (_occasion != OutingOccasion.none) ...[
                Responsive.spaceXs.gapH,
                Text(
                  _occasion == OutingOccasion.birthday ? l10n.birthday : l10n.wedding,
                  style: TextStyle(color: AppColors.brand600, fontWeight: FontWeight.w800, fontSize: 12.sp),
                ),
              ],
              Responsive.spaceSm.gapH,
              Text(_locationLabel, style: TextStyle(color: context.palette.textMuted)),
              if (_selectedLocation?.hasCoordinates ?? false) ...[
                Responsive.spaceXs.gapH,
                Text(l10n.locationPinned, style: TextStyle(color: AppColors.brand600, fontWeight: FontWeight.w800, fontSize: 10.sp)),
              ],
              Responsive.spaceSm.gapH,
              Text('$_formattedDate · $_formattedTime', style: const TextStyle(fontWeight: FontWeight.w700)),
              Responsive.spaceSm.gapH,
              Text(
                _specialEvent
                    ? l10n.guestsInvited(_guestIds.length)
                    : _group == null
                        ? l10n.chooseGroup
                        : l10n.membersWillBeInvited(_group!.people.length),
                style: TextStyle(color: AppColors.brand600, fontWeight: FontWeight.w800),
              ),
              if (_specialEvent)
                Text(
                  [
                    for (final id in _guestIds)
                      if (DemoData.memberById(id) != null) DemoData.memberById(id)!.name,
                  ].join(', '),
                  style: const TextStyle(fontWeight: FontWeight.w800),
                )
              else if (_group != null)
                Text(_group!.name, style: const TextStyle(fontWeight: FontWeight.w800)),
            ],
          ),
        ),
      ],
    );
  }
}
