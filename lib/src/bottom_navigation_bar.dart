part of flutter_restorablez;

/// {@template flutter_restorablez.BottomNavigationBar}
/// A [BottomNavigationBar] that restores the previously selected item.
/// {@endtemplate}
class RestorableBottomNavigationBar extends StatefulWidget {
  /// {@macro flutter_restorablez.BottomNavigationBar}
  const RestorableBottomNavigationBar({
    super.key,
    required this.id,
    required this.items,
    required this.controller,
    this.backgroundColor,
    int? currentIndex,
    this.elevation,
    this.enableFeedback,
    this.onTap,
    this.type = BottomNavigationBarType.fixed,
  }) : currentIndex = currentIndex ?? 0;

  /// Unique identifier for this bottom navigation bar.
  /// Used as the [SharedPreferences] key.
  final String id;

  /// The items to display.
  final List<BottomNavigationBarItem> items;

  /// The [PageController] for the bottom navigation bar.
  final PageController controller;

  /// Called when one of the [items] is tapped.
  final ValueChanged<int>? onTap;

  /// The color of the [BottomNavigationBar] itself.
  final Color? backgroundColor;

  /// The index into [items] for the current active [BottomNavigationBarItem].
  final int currentIndex;

  /// The z-coordinate of this [BottomNavigationBar].
  final double? elevation;

  /// Whether detected gestures should provide acoustic and/or haptic feedback.
  final bool? enableFeedback;

  /// Defines the layout and behavior of a [BottomNavigationBar].
  final BottomNavigationBarType type;

  @override
  State<RestorableBottomNavigationBar> createState() =>
      _RestorableBottomNavigationBarState();
}

class _RestorableBottomNavigationBarState
    extends State<RestorableBottomNavigationBar> {
  late int _currentIndex;
  late SharedPreferences _prefs;

  /// Prefix for [SharedPreferences] keys.
  static const String _keyPrefix = 'flutter_restorablez.navigation';

  String get _key => '$_keyPrefix.${widget.id}';

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex;
    _onInit();
  }

  Future<void> _onInit() async {
    _prefs = await SharedPreferences.getInstance();
    final int? savedIndex = _getIndex();
    if (savedIndex == null ||
        savedIndex <= 0 ||
        savedIndex >= widget.items.length ||
        savedIndex == _currentIndex) {
      return;
    }
    setState(() {
      _currentIndex = savedIndex;
    });
    widget.controller.jumpToPage(savedIndex);
  }

  int? _getIndex() {
    return _prefs.getInt(_key);
  }

  Future<void> _setIndex(int index) async {
    await _prefs.setInt(_key, index);
  }

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
    _setIndex(index);
    widget.onTap?.call(index);
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: widget.backgroundColor,
      currentIndex: _currentIndex,
      elevation: widget.elevation,
      enableFeedback: widget.enableFeedback,
      items: widget.items,
      onTap: _onTap,
      type: widget.type,
    );
  }
}
