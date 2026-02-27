import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:football_platform/features/news/data/models/league_models/fixture_data.dart';
import 'package:football_platform/features/news/presentation/pages/line_up_page.dart';
import '../bloc/league_bloc.dart';
import 'event_widget_builder.dart';
import 'stats_page.dart';

class LiveMatchDetails extends StatefulWidget {
  final FixtureData fixd;
  const LiveMatchDetails({super.key, required this.fixd});

  @override
  State<LiveMatchDetails> createState() => _LiveMatchDetailsState();
}

class _LiveMatchDetailsState extends State<LiveMatchDetails>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late LeagueBloc bloc;
  late TabController _tabController;
  bool _isDisposed = false;
  bool _isDataLoaded = false;

  // ============================================================================
  // THEME CONSTANTS - Pre-computed for performance
  // ============================================================================

  static const _backgroundColor = Color(0xFF0F1419);
  static const _cardBackground = Color(0xFF1A1F2E);
  static const _tabBarBackground = Color(0xFF2A2F3E);
  static const _borderColor = Color(0xFF3A4052);

  // Gradient colors
  static const _primaryGradientStart = Color(0xFF667eea);
  static const _primaryGradientMid = Color(0xFF764ba2);
  static const _primaryGradientEnd = Color(0xFF6B73FF);
  static const _accentGradientStart = Color(0xFF00C9FF);
  static const _accentGradientEnd = Color(0xFF92FE9D);
  static const _timeGradientStart = Color(0xFFFF6B6B);
  static const _timeGradientEnd = Color(0xFFFF8E53);

  // Alpha values
  static const _alpha40 = 102;
  static const _alpha30 = 77;
  static const _alpha20 = 51;
  static const _alpha15 = 38;
  static const _alpha10 = 25;
  static const _alpha08 = 20;

  // Pre-computed gradients
  static final _headerGradient = LinearGradient(
    colors: const [
      _primaryGradientStart,
      _primaryGradientMid,
      _primaryGradientEnd,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static final _loadingGradient = LinearGradient(
    colors: const [_accentGradientStart, _accentGradientEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static final _tabIndicatorGradient = LinearGradient(
    colors: const [_accentGradientStart, _accentGradientEnd],
  );

  static final _timeGradient = LinearGradient(
    colors: const [_timeGradientStart, _timeGradientEnd],
  );

  // Pre-computed shadows
  static final _headerShadow = [
    BoxShadow(
      color: _primaryGradientStart.withAlpha(_alpha40),
      blurRadius: 25,
      spreadRadius: 5,
      offset: const Offset(0, 10),
    ),
  ];

  static final _loadingShadow = [
    BoxShadow(
      color: _accentGradientStart.withAlpha(_alpha30),
      blurRadius: 20,
      spreadRadius: 5,
    ),
  ];

  static final _tabIndicatorShadow = [
    BoxShadow(
      color: _accentGradientStart.withAlpha(_alpha30),
      blurRadius: 8,
      spreadRadius: 1,
    ),
  ];

  static final _timeShadow = [
    BoxShadow(
      color: _timeGradientStart.withAlpha(_alpha40),
      blurRadius: 6,
      spreadRadius: 1,
    ),
  ];

  static final _cardShadow = [
    BoxShadow(
      color: Colors.black.withAlpha(_alpha30),
      blurRadius: 15,
      spreadRadius: 2,
      offset: const Offset(0, 5),
    ),
  ];

  // ============================================================================
  // LIFECYCLE METHODS
  // ============================================================================

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _initializeBloc();
    _initializeTabController();
    _scheduleDataLoad();
  }

  void _initializeBloc() {
    bloc = LeagueBloc.get(context);
  }

  void _initializeTabController() {
    _tabController = TabController(length: 3, vsync: this);
    bloc.tabController = _tabController;
  }

  void _scheduleDataLoad() {
    // Use addPostFrameCallback to ensure widget tree is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !_isDisposed && !_isDataLoaded) {
        bloc.fetchData(widget.fixd);
        _isDataLoaded = true;
      }
    });
  }

  @override
  void didUpdateWidget(LiveMatchDetails oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Reload data if fixture changes
    if (oldWidget.fixd.fixture.id != widget.fixd.fixture.id) {
      _isDataLoaded = false;
      if (mounted && !_isDisposed) {
        bloc.fetchData(widget.fixd);
        _isDataLoaded = true;
      }
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    _tabController.dispose();
    super.dispose();
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
          body: SafeArea(
            child: _buildBody(state),
          ),
        );
      },
    );
  }

  bool _shouldRebuild(LeagueState previous, LeagueState current) {
    // Only rebuild when live match data changes
    return current is GetLiveMatchData ||
        current is LoadingState ||
        current is ErrorState;
  }

  Widget _buildBody(LeagueState state) {
    if (_isLoadingData()) {
      return _buildLoadingScreen();
    }

    // Update tab controller with saved index
    if (_tabController.length == 3 && bloc.tabIndex < 3) {
      _tabController.index = bloc.tabIndex;
    }

    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        _buildMatchHeader(),
        _buildTabSection(),
        const SizedBox(height: 8),
      ],
    );
  }

  bool _isLoadingData() {
    return bloc.lmd.fixStats == null;
  }

  // ============================================================================
  // LOADING SCREEN
  // ============================================================================

  Widget _buildLoadingScreen() {
    return Center(
      child: RepaintBoundary(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: _loadingGradient,
                borderRadius: BorderRadius.circular(15),
                boxShadow: _loadingShadow,
              ),
              child: const CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 3,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Loading Match Data...',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================================
  // MATCH HEADER
  // ============================================================================

  Widget _buildMatchHeader() {
    return RepaintBoundary(
      child: Container(
        height: 160,
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: _headerGradient,
          boxShadow: _headerShadow,
        ),
        child: Stack(
          children: [
            _buildHeaderBackground(),
            _buildHeaderContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderBackground() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [
              Colors.white.withAlpha(_alpha10),
              Colors.transparent,
            ],
            begin: Alignment.topLeft,
            end: Alignment.center,
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderContent() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          _buildTopInfoRow(),
          const SizedBox(height: 12),
          Expanded(child: _buildTeamsAndScore()),
        ],
      ),
    );
  }

  Widget _buildTopInfoRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(child: _buildVenueInfo()),
        const SizedBox(width: 8),
        _buildRoundInfo(),
      ],
    );
  }

  Widget _buildVenueInfo() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(_alpha20),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withAlpha(_alpha30),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.fixd.fixture.venue.name,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            widget.fixd.fixture.venue.city,
            style: TextStyle(
              color: Colors.white.withAlpha(_alpha08 * 10), // ~80% opacity
              fontSize: 10,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildRoundInfo() {
    final roundText = widget.fixd.league.round.length > 17
        ? widget.fixd.league.round.substring(17)
        : widget.fixd.league.round;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _accentGradientStart.withAlpha(_alpha20),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _accentGradientStart,
          width: 1,
        ),
      ),
      child: Text(
        "Round - $roundText",
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildTeamsAndScore() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(child: _buildTeamInfo(isHome: true)),
        Flexible(child: _buildScoreSection()),
        Expanded(child: _buildTeamInfo(isHome: false)),
      ],
    );
  }

  Widget _buildTeamInfo({required bool isHome}) {
    final team = isHome ? widget.fixd.teams.home : widget.fixd.teams.away;
    final label = isHome ? 'HOME' : 'AWAY';
    final labelColor = isHome ? _accentGradientEnd : const Color(0xFF4FACFE);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildTeamLogo(team.logo),
        const SizedBox(height: 4),
        Flexible(
          child: Text(
            team.name,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 9,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 2),
        _buildTeamLabel(label, labelColor),
      ],
    );
  }

  Widget _buildTeamLogo(String logoUrl) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withAlpha(_alpha15),
        border: Border.all(
          color: Colors.white.withAlpha(_alpha30),
          width: 2,
        ),
      ),
      child: Image.network(
        logoUrl,
        width: 32,
        height: 32,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.shield, size: 32, color: Colors.white);
        },
      ),
    );
  }

  Widget _buildTeamLabel(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: color.withAlpha(_alpha30),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 7,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildScoreSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildScore(),
        const SizedBox(height: 6),
        _buildTime(),
      ],
    );
  }

  Widget _buildScore() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(_alpha20),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withAlpha(_alpha40),
          width: 1,
        ),
      ),
      child: Text(
        "${widget.fixd.goals.home} : ${widget.fixd.goals.away}",
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTime() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        gradient: _timeGradient,
        borderRadius: BorderRadius.circular(12),
        boxShadow: _timeShadow,
      ),
      child: Text(
        "${widget.fixd.fixture.statue.elapsed}'",
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // ============================================================================
  // TAB SECTION
  // ============================================================================

  Widget _buildTabSection() {
    return Expanded(
      flex: 3,
      child: RepaintBoundary(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: _cardBackground,
            borderRadius: BorderRadius.circular(20),
            boxShadow: _cardShadow,
          ),
          child: Column(
            children: [
              _buildTabBar(),
              Expanded(child: _buildTabBarView()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _tabBarBackground,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: _borderColor,
          width: 1,
        ),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          gradient: _tabIndicatorGradient,
          borderRadius: BorderRadius.circular(12),
          boxShadow: _tabIndicatorShadow,
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
        unselectedLabelStyle: TextStyle(
          color: Colors.white.withAlpha(_alpha08 * 8), // ~60% opacity
          fontWeight: FontWeight.w500,
          fontSize: 13,
        ),
        tabs: _buildTabs(),
      ),
    );
  }

  List<Widget> _buildTabs() {
    return const [
      Tab(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.event_note, size: 14),
              SizedBox(width: 4),
              Text("Events"),
            ],
          ),
        ),
      ),
      Tab(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.bar_chart, size: 14),
              SizedBox(width: 4),
              Text("Stats"),
            ],
          ),
        ),
      ),
      Tab(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.sports_soccer, size: 14),
              SizedBox(width: 4),
              Text("LineUp"),
            ],
          ),
        ),
      ),
    ];
  }

  Widget _buildTabBarView() {
    return Container(
      margin: const EdgeInsets.fromLTRB(8, 0, 8, 8),
      child: TabBarView(
        controller: _tabController,
        children: [
          _buildEventsTab(),
          _buildStatsTab(),
          _buildLineUpTab(),
        ],
      ),
    );
  }

  // ============================================================================
  // TAB CONTENT
  // ============================================================================

  Widget _buildEventsTab() {
    return RepaintBoundary(child: _summaryWidget());
  }

  Widget _buildStatsTab() {
    if (!bloc.receivedData || bloc.lmd.fixStats == null) {
      return _buildTabLoadingState('Loading Stats...');
    }

    return RepaintBoundary(
      child: StatsWidget(
        receivedData: bloc.receivedData,
        homeStats: bloc.lmd.fixStats!.home,
        awayStats: bloc.lmd.fixStats!.away,
      ),
    );
  }

  Widget _buildLineUpTab() {
    if (!bloc.receivedData) {
      return _buildTabLoadingState('Loading LineUp...');
    }

    return RepaintBoundary(
      child: LineUpWidget(
        receivedData: bloc.receivedData,
        coachHomePhoto: bloc.lmd.lineUps.home.coach.photo,
        coachAwayPhoto: bloc.lmd.lineUps.away.coach.photo,
        coachHomeName: bloc.lmd.lineUps.home.coach.name,
        coachAwayName: bloc.lmd.lineUps.away.coach.name,
        homeFormation: bloc.lmd.lineUps.home.formation,
        awayFormation: bloc.lmd.lineUps.away.formation,
        homeStarters: bloc.lmd.lineUps.home.startAndSub.starteleven
            .map((p) => Player(name: p.name, number: p.number))
            .toList(),
        awayStarters: bloc.lmd.lineUps.away.startAndSub.starteleven
            .map((p) => Player(name: p.name, number: p.number))
            .toList(),
        homeSubs: bloc.lmd.lineUps.home.startAndSub.substitue
            .map((p) => Player(name: p.name, number: p.number))
            .toList(),
        awaySubs: bloc.lmd.lineUps.away.startAndSub.substitue
            .map((p) => Player(name: p.name, number: p.number))
            .toList(),
      ),
    );
  }

  Widget _buildTabLoadingState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: _loadingGradient,
              borderRadius: BorderRadius.circular(15),
              boxShadow: _loadingShadow,
            ),
            child: const CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 3,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================================
  // EVENTS WIDGET
  // ============================================================================

  Widget _summaryWidget() {
    if (!bloc.receivedData) {
      return _buildTabLoadingState('Loading Events...');
    }

    if (bloc.lmd.allEvent.isEmpty) {
      return _buildNoEventsState();
    }

    return _buildEventsList();
  }

  Widget _buildNoEventsState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: _tabBarBackground,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _borderColor,
                width: 1,
              ),
            ),
            child: const Icon(
              Icons.event_busy,
              size: 48,
              color: _primaryGradientStart,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "No Events Yet",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Match events will appear here",
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withAlpha(_alpha08 * 9), // ~70% opacity
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventsList() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListView.builder(
        itemCount: bloc.lmd.allEvent.length,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(4),
        itemBuilder: (context, index) {
          return RepaintBoundary(
            child: _buildEventItem(index),
          );
        },
      ),
    );
  }

  Widget _buildEventItem(int index) {
    final builder = EventWidgetBuilder(
      homeTeamId: widget.fixd.teams.home.id,
    );
    return builder.build(bloc.lmd.allEvent[index]);
  }
}