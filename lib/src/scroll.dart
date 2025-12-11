part of flutter_restorablez;

/// A function that builds a widget with a [ScrollController].
typedef RestorableScrollBuilder = Widget Function(
  BuildContext context,
  ScrollController controller,
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

  String get _key => '$_keyPrefix.${widget.id}';

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _onInit();
  }

  Future<void> _onInit() async {
    _prefs = await SharedPreferences.getInstance();
    final double savedOffset = _getOffset();

    // Wait for first frame so controller has a valid position
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted ||
          !_controller.hasClients ||
          _controller.positions.isEmpty) {
        return;
      }

      final double maxScroll = _controller.position.maxScrollExtent;
      final double offset = savedOffset.clamp(0.0, maxScroll);
      _controller.jumpTo(offset);

      // Start listening to scroll end events after initialization
      _controller.position.isScrollingNotifier.addListener(_setOffset);
    });
  }

  double _getOffset() {
    return _prefs.getDouble(_key) ?? 0.0;
  }

  void _setOffset() {
    // Only save when scrolling stops
    if (!_controller.hasClients ||
        !_controller.position.hasContentDimensions ||
        _controller.position.isScrollingNotifier.value) {
      return;
    }
    _prefs.setDouble(_key, _controller.offset);
  }

  @override
  void dispose() {
    if (_controller.hasClients) {
      _controller.position.isScrollingNotifier.removeListener(_setOffset);
    }
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _controller);
  }
}
