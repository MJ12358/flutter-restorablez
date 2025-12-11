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

  /// Prefix for [SharedPreferences] keys.
  static const String _keyPrefix = 'flutter_restorablez.navigation';

  String get _prefsKey => '$_keyPrefix.${widget.id}';

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex;
    _onInit();
  }

  Future<void> _onInit() async {
    final int? savedIndex = await _getIndex();
    if (savedIndex != null &&
        savedIndex >= 0 &&
        savedIndex < widget.items.length &&
        savedIndex != _currentIndex) {
      setState(() {
        _currentIndex = savedIndex;
      });
      widget.controller.jumpToPage(savedIndex);
    }
  }

  Future<int?> _getIndex() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_prefsKey);
  }

  Future<void> _saveIndex(int index) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_prefsKey, index);
  }

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
    _saveIndex(index);
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
