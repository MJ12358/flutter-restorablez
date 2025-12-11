part of flutter_restorablez;

/// {@template flutter_restorablez.NavigationRail}
/// A [NavigationRail] that restores the previously selected item.
/// {@endtemplate}
class RestorableNavigationRail extends StatefulWidget {
  /// {@macro flutter_restorablez.NavigationRail}
  const RestorableNavigationRail({
    super.key,
    required this.id,
    required this.destinations,
    required this.controller,
    this.backgroundColor,
    this.elevation,
    this.extended = false,
    this.indicatorColor,
    this.indicatorShape,
    this.labelType,
    this.leading,
    this.onDestinationSelected,
    int? selectedIndex,
    this.trailing,
    this.useIndicator,
  }) : selectedIndex = selectedIndex ?? 0;

  /// Unique identifier for this bottom navigation bar.
  /// Used as the [SharedPreferences] key.
  final String id;

  /// Defines the appearance of the button items
  /// that are arrayed within the navigation rail.
  final List<NavigationRailDestination> destinations;

  /// The [PageController] for the rail.
  final PageController controller;

  /// Sets the color of the Container that holds
  /// all of the [NavigationRail]'s contents.
  final Color? backgroundColor;

  /// The rail's elevation or z-coordinate.
  final double? elevation;

  /// Indicates that the [NavigationRail] should be
  /// in the extended state.
  final bool extended;

  /// Overrides the default value of [NavigationRail]'s
  /// selection indicator color, when [useIndicator] is true.
  final Color? indicatorColor;

  /// Overrides the default value of [NavigationRail]'s
  /// selection indicator shape, when [useIndicator] is true.
  final ShapeBorder? indicatorShape;

  /// Defines the layout and behavior of the labels
  /// for the default, unextended [NavigationRail].
  final NavigationRailLabelType? labelType;

  /// The leading widget in the rail that is placed
  /// above the destinations.
  final Widget? leading;

  /// Called when one of the [destinations] is selected.
  final ValueChanged<int>? onDestinationSelected;

  /// The index into [destinations] for the current selected
  /// [NavigationRailDestination] or null if no destination is selected.
  final int selectedIndex;

  /// The trailing widget in the rail that is placed
  /// below the destinations.
  final Widget? trailing;

  /// If true, adds a rounded [NavigationIndicator]
  /// behind the selected destination's icon.
  final bool? useIndicator;

  @override
  State<RestorableNavigationRail> createState() =>
      _RestorableNavigationRailState();
}

class _RestorableNavigationRailState extends State<RestorableNavigationRail> {
  late int _selectedIndex;

  /// Prefix for [SharedPreferences] keys.
  static const String _keyPrefix = 'flutter_restorablez.navigation';

  String get _prefsKey => '$_keyPrefix.${widget.id}';

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
    _onInit();
  }

  Future<void> _onInit() async {
    final int? savedIndex = await _getIndex();
    if (savedIndex != null &&
        savedIndex >= 0 &&
        savedIndex < widget.destinations.length &&
        savedIndex != _selectedIndex) {
      setState(() {
        _selectedIndex = savedIndex;
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

  void _onDestinationSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _saveIndex(index);
    widget.onDestinationSelected?.call(index);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, BoxConstraints constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: constraints.copyWith(
              minHeight: constraints.maxHeight,
              maxHeight: double.infinity,
            ),
            child: IntrinsicHeight(
              child: NavigationRail(
                backgroundColor: widget.backgroundColor,
                destinations: widget.destinations,
                elevation: widget.elevation,
                extended: widget.extended,
                indicatorColor: widget.indicatorColor,
                indicatorShape: widget.indicatorShape,
                labelType: widget.labelType,
                leading: widget.leading,
                onDestinationSelected: _onDestinationSelected,
                selectedIndex: _selectedIndex,
                trailing: widget.trailing,
                useIndicator: widget.useIndicator,
              ),
            ),
          ),
        );
      },
    );
  }
}
