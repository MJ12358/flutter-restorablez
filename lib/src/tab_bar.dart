part of flutter_restorablez;

/// {@template flutter_restorablez.TabBar}
/// A [TabBar] that restores the previously selected tab.
/// {@endtemplate}
class RestorableTabBar extends StatefulWidget implements PreferredSizeWidget {
  /// {@macro flutter_restorablez.TabBar}
  const RestorableTabBar({
    super.key,
    required this.id,
    required this.tabs,
    this.indicatorWeight = 2.0,
    this.onTap,
  });

  /// Unique identifier for this tab bar.
  /// Used as the [SharedPreferences] key.
  final String id;

  /// The tabs to display.
  final List<Widget> tabs;

  /// The thickness of the tab indicator.
  final double indicatorWeight;

  /// Called when a tab is tapped.
  final ValueChanged<int>? onTap;

  @override
  State<RestorableTabBar> createState() => _RestorableTabBarState();

  /// Copied from [TabBar.preferredSize].
  @override
  Size get preferredSize {
    double maxHeight = 46.0;
    for (final Widget item in tabs) {
      if (item is PreferredSizeWidget) {
        final double itemHeight = item.preferredSize.height;
        maxHeight = math.max(itemHeight, maxHeight);
      }
    }
    return Size.fromHeight(maxHeight + indicatorWeight);
  }
}

class _RestorableTabBarState extends State<RestorableTabBar> {
  late TabController _controller;
  late SharedPreferences _prefs;

  /// Prefix for [SharedPreferences] keys.
  static const String _keyPrefix = 'flutter_restorablez.tabbar';

  String get _key => '$_keyPrefix.${widget.id}';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // MUST use didChangeDependencies for inherited widgets
    final TabController? defaultController =
        DefaultTabController.maybeOf(context);
    if (defaultController == null) {
      throw FlutterError(
        'RestorableTabBar must be placed under a DefaultTabController.',
      );
    }
    _controller = defaultController;
    _onInit();
  }

  Future<void> _onInit() async {
    _prefs = await SharedPreferences.getInstance();
    final int? savedIndex = _getIndex();
    if (savedIndex == null ||
        savedIndex <= 0 ||
        savedIndex >= widget.tabs.length ||
        savedIndex == _controller.index) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || savedIndex >= _controller.length) {
        return;
      }
      // Use index assignment for immediate switch to saved tab
      _controller.index = savedIndex;
    });
  }

  int? _getIndex() {
    return _prefs.getInt(_key);
  }

  Future<void> _setIndex(int index) async {
    await _prefs.setInt(_key, index);
  }

  void _onTap(int index) {
    widget.onTap?.call(index);
    FocusManager.instance.primaryFocus?.unfocus();
    _setIndex(index);
  }

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: _controller,
      tabs: widget.tabs,
      indicatorWeight: widget.indicatorWeight,
      onTap: _onTap,
    );
  }
}
