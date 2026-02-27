import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:football_platform/features/news/presentation/pages/bottom_navigation/fixtuer_view.dart';
import 'package:football_platform/features/news/presentation/pages/bottom_navigation/table_view.dart';
import 'package:football_platform/features/news/presentation/pages/bottom_navigation/toppers_view.dart';

import '../../bloc/league_bloc.dart';

class LeagueView extends StatefulWidget {
  final String league;
  const LeagueView({Key? key, required this.league}) : super(key: key);

  @override
  State<LeagueView> createState() => LeagueViewState();
}

class LeagueViewState extends State<LeagueView>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late LeagueBloc bloc;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  // State tracking
  bool _isDataLoaded = false;
  String? _previousLeague;
  bool _isDisposed = false;

  // ============================================================================
  // THEME CONSTANTS - Pre-computed for performance
  // ============================================================================

  static const _darkBlue = Color(0xFF1A237E);
  static const _mediumBlue = Color(0xFF3F51B5);
  static const _purple = Color(0xFF9C27B0);
  static const _green = Color(0xFF00E676);
  static const _cyan = Color(0xFF00BCD4);
  static const _backgroundColor = Color(0xFF0A0E27);
  static const _backgroundGradientStart = Color(0xFF1A1A2E);
  static const _backgroundGradientEnd = Color(0xFF16213E);

  // Alpha values
  static const _alpha95 = 242;
  static const _alpha90 = 229;
  static const _alpha85 = 217;
  static const _alpha80 = 204;
  static const _alpha70 = 179;
  static const _alpha60 = 153;
  static const _alpha30 = 77;
  static const _alpha20 = 51;
  static const _alpha15 = 38;
  static const _alpha10 = 25;
  static const _alpha08 = 20;
  static const _alpha05 = 13;
  static const _alpha04 = 10;

  // ============================================================================
  // GRADIENTS - Computed once and reused
  // ============================================================================

  static final _appBarGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      _darkBlue.withAlpha(_alpha90),
      _mediumBlue.withAlpha(_alpha80),
      _purple.withAlpha(_alpha70),
    ],
  );

  static final _backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      _backgroundColor,
      _backgroundGradientStart,
      _backgroundGradientEnd,
    ],
  );

  static final _bottomNavGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      _darkBlue.withAlpha(_alpha95),
      _mediumBlue.withAlpha(_alpha90),
      _purple.withAlpha(_alpha85),
    ],
  );

  static final _selectedItemGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      _green.withAlpha(_alpha80),
      _cyan.withAlpha(_alpha90),
      _mediumBlue.withAlpha(_alpha70),
    ],
  );

  static final _glassGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Colors.white.withAlpha(_alpha08),
      Colors.white.withAlpha(_alpha04),
    ],
  );

  static final _titleContainerGradient = LinearGradient(
    colors: [
      Colors.white.withAlpha(_alpha10),
      Colors.white.withAlpha(_alpha05),
    ],
  );

  // ============================================================================
  // SHADOWS - Pre-computed for performance
  // ============================================================================

  static final _bottomNavShadows = [
    BoxShadow(
      color: _purple.withAlpha(_alpha30),
      blurRadius: 15,
      offset: const Offset(0, 4),
      spreadRadius: 1,
    ),
    BoxShadow(
      color: Colors.black.withAlpha(_alpha20),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];

  static final _selectedItemShadow = [
    BoxShadow(
      color: _green.withAlpha(_alpha30),
      blurRadius: 8,
      offset: const Offset(0, 2),
      spreadRadius: 0.5,
    ),
  ];

  static final _iconShadows = [
    Shadow(
      color: Colors.black.withAlpha(_alpha20),
      offset: const Offset(0, 1),
      blurRadius: 2,
    ),
  ];

  static final _textShadows = [
    Shadow(
      color: Colors.black.withAlpha(_alpha20),
      offset: const Offset(0, 0.5),
      blurRadius: 1,
    ),
  ];

  // ============================================================================
  // COLORS - Pre-computed border and text colors
  // ============================================================================

  static final _whiteBorder15 = Colors.white.withAlpha(_alpha15);
  static final _whiteBorder20 = Colors.white.withAlpha(_alpha20);
  static final _whiteText60 = Colors.white.withAlpha(_alpha60);

  // ============================================================================
  // TEXT STYLES - Pre-computed for performance
  // ============================================================================

  static const _titleTextStyle = TextStyle(
    color: Colors.white,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );

  static final _selectedTextStyle = TextStyle(
    color: Colors.white,
    fontSize: 9,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    shadows: _textShadows,
  );

  static final _unselectedTextStyle = TextStyle(
    color: _whiteText60,
    fontSize: 8,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
  );

  // ============================================================================
  // LIFECYCLE METHODS
  // ============================================================================

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _initializeBloc();
    _initializeAnimations();
    _scheduleDataLoad();
  }

  void _initializeBloc() {
    bloc = LeagueBloc.get(context);
    _checkAndHandleLeagueChange();
    _setupPages();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticOut,
      ),
    );

    _animationController.forward();
  }

  void _scheduleDataLoad() {
    // Use addPostFrameCallback to ensure widget tree is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !_isDisposed) {
        _loadAllData();
      }
    });
  }

  @override
  void didUpdateWidget(LeagueView oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Handle league change when widget updates
    if (oldWidget.league != widget.league) {
      _handleLeagueUpdate();
    }
  }

  void _handleLeagueUpdate() {
    _checkAndHandleLeagueChange();
    _setupPages();
    _isDataLoaded = false;

    if (mounted && !_isDisposed) {
      _loadAllData();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    _animationController.dispose();
    super.dispose();
  }

  // ============================================================================
  // DATA MANAGEMENT
  // ============================================================================

  /// Check if league has changed and handle data clearing
  void _checkAndHandleLeagueChange() {
    if (_previousLeague != null && _previousLeague != widget.league) {
      debugPrint('🔄 League change: $_previousLeague → ${widget.league}');

      // Clear data and change league atomically
      bloc.changeLeague(widget.league);
      _isDataLoaded = false;
    } else {
      // First time or same league
      bloc.selectedItem = 0;
      bloc.league = widget.league;
    }

    _previousLeague = widget.league;
  }

  /// Setup pages for navigation
  void _setupPages() {
    bloc.pages
      ..clear()
      ..addAll([
        FixturesView(league: widget.league),
        TableView(league: widget.league),
        TopInLeagueView(league: widget.league),
      ]);
  }

  /// Load all required data for tabs
  void _loadAllData() {
    if (_isDataLoaded || _isDisposed) return;

    // Batch data loading to reduce multiple state updates
    bloc
      ..getUpcomingData(widget.league)
      ..getTableData(widget.league)
      ..getGoalsData(widget.league);

    _isDataLoaded = true;
  }

  // ============================================================================
  // BUILD METHODS
  // ============================================================================

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin

    return BlocBuilder<LeagueBloc, LeagueState>(
      bloc: bloc,
      buildWhen: _shouldRebuild,
      builder: (context, state) {
        return Scaffold(
          backgroundColor: _backgroundColor,
          extendBody: true,
          appBar: _buildConditionalAppBar(),
          body: _buildBody(),
          bottomNavigationBar: _buildBottomNavigation(),
        );
      },
    );
  }

  /// Control when to rebuild based on state changes
  bool _shouldRebuild(LeagueState previous, LeagueState current) {
    // Rebuild for navigation changes and data updates
    return current is ChangeSelectedIndex ||
        current is GetTable ||
        current is GetGoals ||
        current is GetUpComingData ||
        current is DataCleared;
  }

  PreferredSizeWidget? _buildConditionalAppBar() {
    return bloc.selectedItem != 0 ? _buildAppBar() : null;
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      flexibleSpace: Container(
        decoration: BoxDecoration(gradient: _appBarGradient),
      ),
      title: RepaintBoundary(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            gradient: _titleContainerGradient,
            border: Border.all(
              color: _whiteBorder20,
              width: 1,
            ),
          ),
          child: Text(
            bloc.titles[bloc.selectedItem],
            style: _titleTextStyle,
          ),
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildBody() {
    return RepaintBoundary(
      child: Container(
        decoration: BoxDecoration(gradient: _backgroundGradient),
        child: _buildCurrentPage(),
      ),
    );
  }

  Widget _buildCurrentPage() {
    // Safely get the current page
    if (bloc.pages.isEmpty || bloc.selectedItem >= bloc.pages.length) {
      return const SizedBox.shrink();
    }

    return bloc.pages[bloc.selectedItem];
  }

  Widget _buildBottomNavigation() {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: _buildBottomNavigationContainer(),
          );
        },
      ),
    );
  }

  Widget _buildBottomNavigationContainer() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: _bottomNavGradient,
        boxShadow: _bottomNavShadows,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: _buildBottomNavigationContent(),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationContent() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _whiteBorder15,
          width: 1,
        ),
        gradient: _glassGradient,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(
            icon: Icons.sports_soccer_rounded,
            label: 'Fixtures',
            index: 0,
          ),
          _buildNavItem(
            icon: Icons.leaderboard_rounded,
            label: 'Standings',
            index: 1,
          ),
          _buildNavItem(
            icon: Icons.emoji_events_rounded,
            label: 'Top Scorers',
            index: 2,
          ),
        ],
      ),
    );
  }

  // ============================================================================
  // NAVIGATION ITEMS
  // ============================================================================

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isSelected = bloc.selectedItem == index;

    return Expanded(
      child: RepaintBoundary(
        child: _NavItemButton(
          icon: icon,
          label: label,
          index: index,
          isSelected: isSelected,
          onTap: () => _handleNavItemTap(index),
          selectedItemGradient: _selectedItemGradient,
          selectedItemShadow: _selectedItemShadow,
          iconShadows: _iconShadows,
          whiteText60: _whiteText60,
          selectedTextStyle: _selectedTextStyle,
          unselectedTextStyle: _unselectedTextStyle,
        ),
      ),
    );
  }

  void _handleNavItemTap(int index) {
    if (_isDisposed || bloc.selectedItem == index) return;

    // Update bloc state
    bloc.onTap(index);

    // Restart animations
    _restartNavigationAnimation();

    // Handle page-specific animations with safety checks
    _schedulePageAnimation(index);
  }

  void _restartNavigationAnimation() {
    if (_isDisposed || !_animationController.isAnimating) {
      _animationController.reset();
      _animationController.forward();
    }
  }

  void _schedulePageAnimation(int index) {
    // Small delay to allow navigation transition
    Future.delayed(const Duration(milliseconds: 150), () {
      if (!mounted || _isDisposed) return;

      _recreatePageIfNeeded(index);
    });
  }

  void _recreatePageIfNeeded(int index) {
    if (index >= bloc.pages.length) return;

    final currentPage = bloc.pages[index];
    Widget? newPage;

    // Recreate page to restart its animations
    switch (index) {
      case 0:
        if (currentPage is FixturesView) {
          newPage = FixturesView(league: bloc.league);
        }
        break;
      case 1:
        if (currentPage is TableView) {
          newPage = TableView(league: bloc.league);
        }
        break;
      case 2:
        if (currentPage is TopInLeagueView) {
          newPage = TopInLeagueView(league: bloc.league);
        }
        break;
    }

    if (newPage != null && mounted) {
      bloc.pages[index] = newPage;
      setState(() {});
    }
  }
}

// ============================================================================
// EXTRACTED NAVIGATION ITEM WIDGET
// ============================================================================

class _NavItemButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;
  final bool isSelected;
  final VoidCallback onTap;
  final Gradient selectedItemGradient;
  final List<BoxShadow> selectedItemShadow;
  final List<Shadow> iconShadows;
  final Color whiteText60;
  final TextStyle selectedTextStyle;
  final TextStyle unselectedTextStyle;

  const _NavItemButton({
    required this.icon,
    required this.label,
    required this.index,
    required this.isSelected,
    required this.onTap,
    required this.selectedItemGradient,
    required this.selectedItemShadow,
    required this.iconShadows,
    required this.whiteText60,
    required this.selectedTextStyle,
    required this.unselectedTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: isSelected ? selectedItemGradient : null,
          boxShadow: isSelected ? selectedItemShadow : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildIcon(),
            const SizedBox(height: 1),
            _buildLabel(),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return AnimatedScale(
      scale: isSelected ? 1.05 : 1.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.elasticOut,
      child: Icon(
        icon,
        size: 18,
        color: isSelected ? Colors.white : whiteText60,
        shadows: isSelected ? iconShadows : null,
      ),
    );
  }

  Widget _buildLabel() {
    return Flexible(
      child: AnimatedDefaultTextStyle(
        duration: const Duration(milliseconds: 300),
        style: isSelected ? selectedTextStyle : unselectedTextStyle,
        child: Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}