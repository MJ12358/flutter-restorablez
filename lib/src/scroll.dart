part of flutter_restorablez;

/// A function that builds a widget with a [ScrollController].
typedef RestorableScrollBuilder = Widget Function(
  BuildContext,
  ScrollController,
);

/// {@template flutter_restorablez.Scroll}
/// Wrap any scrollable widget to remember its scroll offset.
/// {@endtemplate}
class RestorableScroll extends StatefulWidget {
  /// {@macro flutter_restorablez.Scroll}
  const RestorableScroll({
    super.key,
    required this.id,
    required this.builder,
  });

  /// Unique identifier for this scrollable.
  /// Used as the [SharedPreferences] key.
  final String id;

  /// Build your scrollable, passing in the provided [ScrollController].
  final RestorableScrollBuilder builder;

  @override
  _RestorableScrollState createState() => _RestorableScrollState();
}

/// State for [RestorableScroll].
class _RestorableScrollState extends State<RestorableScroll> {
  late final ScrollController _controller;
  late final SharedPreferences _prefs;

  /// Prefix for [SharedPreferences] keys.
  static const String _keyPrefix = 'flutter_restorablez.scroll';

  String get _prefsKey => '$_keyPrefix.${widget.id}';

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    final double savedOffset = _prefs.getDouble(_prefsKey) ?? 0.0;

    // Wait for first frame so controller has a valid position
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_controller.hasClients || _controller.positions.isEmpty) {
        return;
      }

      final double maxScroll = _controller.position.maxScrollExtent;
      final double offset = savedOffset.clamp(0.0, maxScroll);
      _controller.jumpTo(offset);

      // Start listening to scroll end events after initialization
      _controller.position.isScrollingNotifier.addListener(_saveOffset);
    });
  }

  void _saveOffset() {
    // Only save when scrolling stops
    if (!_controller.hasClients || !_controller.position.hasContentDimensions) {
      return;
    }
    _prefs.setDouble(_prefsKey, _controller.offset);
  }

  @override
  void dispose() {
    if (_controller.hasClients) {
      _controller.position.isScrollingNotifier.removeListener(_saveOffset);
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _controller);
  }
}
