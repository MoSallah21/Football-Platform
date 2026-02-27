import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:football_platform/core/componants/background.dart';
import '../bloc/blog_bloc.dart';
import '../widgets/blog_card.dart';

class BlogsPage extends StatefulWidget {
  const BlogsPage({super.key});

  @override
  State<BlogsPage> createState() => _BlogsPageState();
}

class _BlogsPageState extends State<BlogsPage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  // Static const colors for zero allocation
  static const Color _backgroundColor = Color(0xFF0A0B0F);
  static const Color _primaryColor = Color(0xFF6C5CE7);
  static const Color _accentColor = Color(0xFF00B894);
  static const Color _surfaceColor = Color(0xFF1A1D23);

  late ScrollController _scrollController;
  late AnimationController _headerAnimationController;
  late AnimationController _refreshAnimationController;
  late Animation<double> _headerSlideAnimation;
  late Animation<double> _headerFadeAnimation;

  bool _isRefreshing = false;
  double _scrollOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _setupAnimations();
    _loadInitialData();
  }

  void _initializeControllers() {
    _scrollController = ScrollController();

    _headerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _refreshAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
  }

  void _setupAnimations() {
    _headerSlideAnimation = Tween<double>(
      begin: -30.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _headerAnimationController,
      curve: Curves.easeOut,
    ));

    _headerFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _headerAnimationController,
      curve: Curves.easeIn,
    ));

    // Optimized scroll listener with threshold
    _scrollController.addListener(_onScrollOptimized);
  }

  void _loadInitialData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _headerAnimationController.forward();
      context.read<BlogBloc>().add(GetAllBlogsEvent());
    });
  }

  void _onScrollOptimized() {
    final offset = _scrollController.offset;
    if ((offset - _scrollOffset).abs() > 10) {
      setState(() {
        _scrollOffset = offset;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScrollOptimized);
    _scrollController.dispose();
    _headerAnimationController.dispose();
    _refreshAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: _backgroundColor,
      extendBodyBehindAppBar: true,
      appBar: _buildOptimizedAppBar(),
      body: _buildOptimizedBody(),
    );
  }

  PreferredSizeWidget? _buildOptimizedAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(80.0),
      child: RepaintBoundary(
        child: AnimatedBuilder(
          animation: _headerAnimationController,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _headerSlideAnimation.value),
              child: Opacity(
                opacity: _headerFadeAnimation.value,
                child: child,
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  _backgroundColor.withValues(alpha: 0.95),
                  _backgroundColor.withValues(alpha: 0.8),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.7, 1.0],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    const _AnimatedLogo(),
                    const SizedBox(width: 16),
                    const _TitleSection(),
                    _RefreshButton(
                      isRefreshing: _isRefreshing,
                      animationController: _refreshAnimationController,
                      onTap: _handleRefresh,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOptimizedBody() {
    return Container(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.topCenter,
          radius: 1.2,
          colors: [
            Color(0x146C5CE7),
            _backgroundColor,
            _backgroundColor,
          ],
          stops: [0.0, 0.3, 1.0],
        ),
      ),
      child: BackGround(
        img: 0,
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 15),
              const _OptimizedStatsBar(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: _buildOptimizedBlogList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptimizedBlogList() {
    return BlocBuilder<BlogBloc, BlogState>(
      buildWhen: (previous, current) {
        // Only rebuild when state actually changes
        return previous.runtimeType != current.runtimeType ||
            (current is GetAllBlogsSuccessState &&
                previous is GetAllBlogsSuccessState &&
                previous.blogs.length != current.blogs.length);
      },
      builder: (context, state) {
        if (state is GetAllBlogsLoadingState) {
          return const _LoadingState();
        } else if (state is GetAllBlogsErrorState) {
          return _ErrorState(message: state.message);
        } else if (state is GetAllBlogsSuccessState) {
          final blogs = state.blogs;
          if (blogs.isEmpty) {
            return const _EmptyState();
          } else {
            return _buildOptimizedBlogListView(blogs);
          }
        } else {
          return const _ErrorState(message: 'حدث خطأ ما!');
        }
      },
    );
  }

  Widget _buildOptimizedBlogListView(List blogs) {
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      color: _primaryColor,
      backgroundColor: _surfaceColor,
      child: ListView.builder(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        padding: const EdgeInsets.only(bottom: 20),
        itemCount: blogs.length,
        // Add this for better performance
        cacheExtent: 500,
        itemBuilder: (context, index) {
          return RepaintBoundary(
            child: _BlogListItem(
              blog: blogs[index],
              index: index,
            ),
          );
        },
      ),
    );
  }

  Future<void> _handleRefresh() async {
    if (_isRefreshing) return;

    setState(() => _isRefreshing = true);

    _refreshAnimationController.repeat();
    context.read<BlogBloc>().add(RefreshBlogsEvent());

    await Future.delayed(const Duration(milliseconds: 1500));

    if (mounted) {
      setState(() => _isRefreshing = false);
      _refreshAnimationController.stop();
      _refreshAnimationController.reset();
    }
  }
}

// Extract static widgets for better performance

class _AnimatedLogo extends StatelessWidget {
  const _AnimatedLogo();

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'app_logo',
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF6C5CE7), Color(0xFF00B894)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.sports_soccer,
          color: Colors.white,
          size: 22,
        ),
      ),
    );
  }
}

class _TitleSection extends StatelessWidget {
  const _TitleSection();

  @override
  Widget build(BuildContext context) {
    return const Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'مدونات كرة القدم',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ),
          ),
          Text(
            'آخر أخبار وتحليلات كرة القدم',
            style: TextStyle(
              color: Color(0xB3FFFFFF),
              fontSize: 11,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

class _RefreshButton extends StatelessWidget {
  final bool isRefreshing;
  final AnimationController animationController;
  final VoidCallback onTap;

  const _RefreshButton({
    required this.isRefreshing,
    required this.animationController,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: const Color(0xCC1A1D23),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0x4D6C5CE7),
            width: 1,
          ),
        ),
        child: AnimatedBuilder(
          animation: animationController,
          builder: (context, child) {
            return Transform.rotate(
              angle: animationController.value * 2 * 3.14159,
              child: Icon(
                Icons.refresh_rounded,
                color: isRefreshing ? const Color(0xFF00B894) : Colors.white,
                size: 20,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _OptimizedStatsBar extends StatelessWidget {
  const _OptimizedStatsBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10.0),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xCC1A1D23), Color(0x991A1D23)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0x336C5CE7),
          width: 1,
        ),
      ),
      child: BlocBuilder<BlogBloc, BlogState>(
        buildWhen: (previous, current) =>
        current is GetAllBlogsSuccessState &&
            (previous is! GetAllBlogsSuccessState ||
                previous.blogs.length != current.blogs.length),
        builder: (context, state) {
          int blogCount = 0;
          if (state is GetAllBlogsSuccessState) {
            blogCount = state.blogs.length;
          }

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatItem(
                icon: Icons.article_outlined,
                value: '$blogCount',
                label: 'مقالات',
              ),
              _StatItem(
                icon: Icons.trending_up,
                value: '24.5K',
                label: 'مشاهدات',
              ),
              _StatItem(
                icon: Icons.favorite_outline,
                value: '1.2K',
                label: 'إعجابات',
              ),
            ],
          );
        },
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0x336C5CE7), Color(0x3300B894)],
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.white, size: 18),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xB3FFFFFF),
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6C5CE7)),
            strokeWidth: 3,
          ),
          SizedBox(height: 16),
          Text(
            'جاري تحميل المحتوى الرائع...',
            style: TextStyle(
              color: Color(0xCCFFFFFF),
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;

  const _ErrorState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0x1AF44336), Color(0x0DF44336)],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0x4DF44336),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 40,
            ),
            const SizedBox(height: 12),
            const Text(
              'عذراً! حدث خطأ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              message,
              style: const TextStyle(
                color: Color(0xB3FFFFFF),
                fontSize: 13,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.read<BlogBloc>().add(GetAllBlogsEvent());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C5CE7),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
              ),
              child: const Text(
                'إعادة المحاولة',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0x991A1D23), Color(0x4D1A1D23)],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0x336C5CE7),
            width: 1,
          ),
        ),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.article_outlined,
              color: Colors.white,
              size: 60,
            ),
            SizedBox(height: 16),
            Text(
              'لا توجد مدونات متاحة حالياً',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 6),
            Text(
              'تحقق لاحقاً للحصول على محتوى كرة قدم مثير!',
              style: TextStyle(
                color: Color(0xB3FFFFFF),
                fontSize: 13,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _BlogListItem extends StatelessWidget {
  final dynamic blog;
  final int index;

  const _BlogListItem({
    required this.blog,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 150 + (index * 30)),
      tween: Tween<double>(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Container(
              margin: const EdgeInsets.only(bottom: 12.0),
              child: blogCard(blog, context, index: index),
            ),
          ),
        );
      },
    );
  }
}