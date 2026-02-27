import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';

class BlogDescriptionScreen extends StatefulWidget {
  final String title;
  final String description;
  final String image;
  final String date;
  final String author;

  const BlogDescriptionScreen({
    Key? key,
    required this.title,
    required this.description,
    required this.image,
    required this.date,
    required this.author,
  }) : super(key: key);

  @override
  State<BlogDescriptionScreen> createState() => _BlogDescriptionScreenState();
}

class _BlogDescriptionScreenState extends State<BlogDescriptionScreen>
    with SingleTickerProviderStateMixin { // Changed to Single for performance

  // Static const colors - zero allocation, no HexColor parsing overhead
  static const Color _backgroundColor = Color(0xFF0A0B0F);
  static const Color _primaryColor = Color(0xFF6C5CE7);
  static const Color _accentColor = Color(0xFF00B894);
  static const Color _surfaceColor = Color(0xFF1A1D23);

  // Static date formatter to avoid recreation
  static final DateFormat _dateFormatter = DateFormat('MMM dd, yyyy');

  late ScrollController _scrollController;
  late AnimationController _animationController; // Single controller for all animations
  late Animation<double> _fadeAnimation;

  double _scrollOffset = 0.0;
  late final String _formattedDate;

  @override
  void initState() {
    super.initState();

    // Initialize scroll controller with optimized listener
    _scrollController = ScrollController();
    _scrollController.addListener(_onScrollOptimized);

    // Single animation controller for better performance
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // Setup animations
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    // Format date once
    try {
      final DateTime dateTime = DateTime.parse(widget.date);
      _formattedDate = _dateFormatter.format(dateTime);
    } catch (e) {
      _formattedDate = widget.date;
    }

    // Start animation
    _animationController.forward();
  }

  // Optimized scroll listener with threshold
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
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      extendBodyBehindAppBar: true,
      appBar: _buildOptimizedAppBar(),
      body: _buildOptimizedBody(),
      floatingActionButton: const _FloatingActions(),
    );
  }

  PreferredSizeWidget _buildOptimizedAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(80.0),
      child: RepaintBoundary(
        child: AnimatedBuilder(
          animation: _fadeAnimation,
          builder: (context, child) {
            return Opacity(
              opacity: _fadeAnimation.value,
              child: child,
            );
          },
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  _backgroundColor.withValues(
                    alpha: _scrollOffset > 100 ? 0.95 : 0.3,
                  ),
                  Colors.transparent,
                ],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    _BackButton(onTap: () => Navigator.of(context).pop()),
                    const Spacer(),
                    if (_scrollOffset > 50) const _ReadingIndicator(),
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
            Color(0x146C5CE7), // Pre-calculated alpha
            _backgroundColor,
            _backgroundColor,
          ],
          stops: [0.0, 0.4, 1.0],
        ),
      ),
      child: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildHeroImageSection(),
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: _buildContentSection(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroImageSection() {
    return SliverAppBar(
      expandedHeight: 300.0,
      floating: false,
      pinned: false,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        background: RepaintBoundary(
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Hero image with optimized parallax
              Transform.translate(
                offset: Offset(0, -_scrollOffset * 0.4), // Reduced multiplier
                child: _buildOptimizedImage(),
              ),

              // Gradient overlay
              const _GradientOverlay(),

              // Title overlay
              Positioned(
                bottom: 20,
                left: 16,
                right: 16,
                child: _HeroTitle(title: widget.title),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptimizedImage() {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(30),
        bottomRight: Radius.circular(30),
      ),
      child: Hero(
        tag: 'blog_image_${widget.image}',
        child: CachedNetworkImage(
          imageUrl: widget.image,
          fit: BoxFit.cover,
          memCacheWidth: 1200, // Optimize cache size
          maxHeightDiskCache: 600,
          fadeInDuration: const Duration(milliseconds: 300),
          placeholder: (context, url) => const _ImagePlaceholder(),
          errorWidget: (context, url, error) => const _ImageError(),
        ),
      ),
    );
  }

  Widget _buildContentSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 10),
          _MetaInfo(
            formattedDate: _formattedDate,
            author: widget.author,
          ),
          const SizedBox(height: 30),
          _ArticleContent(description: widget.description),
          const SizedBox(height: 40),
          _AuthorSection(author: widget.author),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

// ============================================================================
// EXTRACTED STATIC WIDGETS FOR MAXIMUM PERFORMANCE
// ============================================================================

class _BackButton extends StatelessWidget {
  final VoidCallback onTap;

  const _BackButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          color: const Color(0xCC1A1D23),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0x4D6C5CE7),
            width: 1,
          ),
        ),
        child: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }
}

class _ReadingIndicator extends StatelessWidget {
  const _ReadingIndicator();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xCC1A1D23),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0x4D6C5CE7),
          width: 1,
        ),
      ),
      child: const Text(
        'Reading...',
        style: TextStyle(
          color: Color(0xFF6C5CE7),
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _GradientOverlay extends StatelessWidget {
  const _GradientOverlay();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.transparent,
            Color(0xCC0A0B0F),
            Color(0xFF0A0B0F),
          ],
          stops: [0.0, 0.4, 0.8, 1.0],
        ),
      ),
    );
  }
}

class _HeroTitle extends StatelessWidget {
  final String title;

  const _HeroTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xE61A1D23), Color(0xB31A1D23)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0x4D6C5CE7),
          width: 1,
        ),
      ),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.w800,
          height: 1.3,
          letterSpacing: 0.5,
        ),
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1A1D23), Color(0x801A1D23)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: Color(0xFF6C5CE7),
              strokeWidth: 3,
            ),
            SizedBox(height: 16),
            Text(
              'Loading image...',
              style: TextStyle(
                color: Color(0xB3FFFFFF),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ImageError extends StatelessWidget {
  const _ImageError();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1A1D23), Color(0xFF424242)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_not_supported_outlined,
            color: Colors.white54,
            size: 40,
          ),
          SizedBox(height: 16),
          Text(
            'Image not available',
            style: TextStyle(
              color: Color(0xB3FFFFFF),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaInfo extends StatelessWidget {
  final String formattedDate;
  final String author;

  const _MetaInfo({
    required this.formattedDate,
    required this.author,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0x991A1D23), Color(0x661A1D23)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0x336C5CE7),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _MetaItem(
              icon: Icons.schedule_outlined,
              label: 'Published',
              value: formattedDate,
              color: const Color(0xFF00B894),
            ),
            Container(
              width: 1,
              height: 40,
              color: const Color(0x33FFFFFF),
            ),
            _MetaItem(
              icon: Icons.person_outline,
              label: 'Author',
              value: author,
              color: const Color(0xFF6C5CE7),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetaItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _MetaItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xB3FFFFFF),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class _ArticleContent extends StatelessWidget {
  final String description;

  const _ArticleContent({required this.description});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0x801A1D23), Color(0x4D1A1D23)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0x266C5CE7),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0x336C5CE7), Color(0x3300B894)],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.article_outlined,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Article Content',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SelectableText(
              description,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                height: 1.8,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AuthorSection extends StatelessWidget {
  final String author;

  const _AuthorSection({required this.author});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0x1A00B894), Color(0x0D00B894)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0x4D00B894),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6C5CE7), Color(0xFF00B894)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Icon(
                Icons.person,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Written by',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    author,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FloatingActions extends StatelessWidget {
  const _FloatingActions();

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: "share",
            onPressed: () {
              HapticFeedback.mediumImpact();
              // Share functionality
            },
            backgroundColor: const Color(0xFF6C5CE7),
            child: const Icon(Icons.share_rounded, color: Colors.white),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: "bookmark",
            onPressed: () {
              HapticFeedback.lightImpact();
              // Bookmark functionality
            },
            backgroundColor: const Color(0xFF00B894),
            child: const Icon(Icons.bookmark_outline_rounded, color: Colors.white),
          ),
        ],
      ),
    );
  }
}