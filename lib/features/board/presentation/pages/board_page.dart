import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:football_platform/core/utl/items.dart';
import 'package:football_platform/features/board/presentation/widgets/draggable_icon.dart';
import 'package:football_platform/features/board/presentation/widgets/painter.dart';

class BoardPage extends StatefulWidget {
  const BoardPage({super.key});

  @override
  State<BoardPage> createState() => _BoardPageState();
}

class _BoardPageState extends State<BoardPage> with TickerProviderStateMixin {
  late bool _canPaint;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  int _currentFormationIndex = 0;
  bool _isDisposed = false;

  // Cache static data
  static const List<MenuItem> _formations = [
    MenuItem(text: '4-3-3 Formation'),
    MenuItem(text: '4-4-2 Formation'),
    MenuItem(text: '3-5-2 Formation'),
    MenuItem(text: 'Offside Play'),
    MenuItem(text: 'Free Kick'),
    MenuItem(text: 'Corner Kick'),
  ];

  static const List<String> _titles = [
    'Select Formation',
    '4-3-3 Formation',
    '4-4-2 Formation',
    '3-5-2 Formation',
    'Offside Play',
    'Free Kick',
    'Corner Kick',
  ];

  static const List<String> _fieldImagePaths = [
    'assets/images/field.jpg',
    'assets/images/shape/4-3-3.jpg',
    'assets/images/shape/4-4-2.jpg',
    'assets/images/shape/3-5-2.jpg',
    'assets/images/shape/offside.jpg',
    'assets/images/shape/freeKick.jpg',
    'assets/images/shape/cornerKick.jpg',
  ];

  @override
  void initState() {
    super.initState();
    _canPaint = false;
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _isDisposed = true;
    _animationController.dispose();
    super.dispose();
  }

  void _reset() {
    if (_isDisposed) return;

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const BoardPage(),
        transitionDuration: const Duration(milliseconds: 300),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  void _onFormationChange(BuildContext context, MenuItem item) {
    if (_isDisposed) return;

    final index = _formations.indexOf(item) + 1;
    setState(() {
      _currentFormationIndex = index;
    });

    _animationController.reset();
    _animationController.forward();
  }

  void _togglePaint() {
    if (_isDisposed) return;

    setState(() {
      _canPaint = !_canPaint;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(context),
      body: _BoardBody(
        fadeAnimation: _fadeAnimation,
        currentFormationIndex: _currentFormationIndex,
        canPaint: _canPaint,
        onReset: _reset,
        onTogglePaint: _togglePaint,
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      flexibleSpace: const _AppBarBackground(),
      actions: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: _FormationDropdown(
            currentIndex: _currentFormationIndex,
            onChanged: (value) => _onFormationChange(context, value),
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// APP BAR BACKGROUND
// ============================================================================

class _AppBarBackground extends StatelessWidget {
  const _AppBarBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1B5E20),
            Color(0xFF2E7D32),
            Color(0xFF388E3C),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// FORMATION DROPDOWN
// ============================================================================

class _FormationDropdown extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<MenuItem> onChanged;

  const _FormationDropdown({
    required this.currentIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            offset: const Offset(0, 4),
            blurRadius: 8,
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<MenuItem>(
          isExpanded: true,
          hint: _DropdownHint(title: _BoardPageState._titles[currentIndex]),
          items: _BoardPageState._formations
              .map((item) => DropdownMenuItem<MenuItem>(
            value: item,
            child: _DropdownItem(item: item),
          ))
              .toList(),
          onChanged: (value) {
            if (value != null) onChanged(value);
          },
          buttonStyleData: _buildButtonStyle(),
          dropdownStyleData: _buildDropdownStyle(),
          menuItemStyleData: const MenuItemStyleData(
            height: 50,
            padding: EdgeInsets.symmetric(horizontal: 16),
          ),
        ),
      ),
    );
  }

  ButtonStyleData _buildButtonStyle() {
    return ButtonStyleData(
      height: 55,
      width: 250,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 2,
        ),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0D47A1),
            Color(0xFF1565C0),
            Color(0xFF1976D2),
          ],
        ),
      ),
      elevation: 8,
    );
  }

  DropdownStyleData _buildDropdownStyle() {
    return DropdownStyleData(
      maxHeight: 300,
      width: 250,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0D47A1),
            Color(0xFF1565C0),
            Color(0xFF1976D2),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            offset: const Offset(0, 8),
            blurRadius: 16,
          ),
        ],
      ),
      offset: const Offset(-10, 0),
      scrollbarTheme: ScrollbarThemeData(
        radius: const Radius.circular(40),
        thickness: WidgetStateProperty.all<double>(6),
        thumbVisibility: WidgetStateProperty.all<bool>(true),
        thumbColor: WidgetStateProperty.all<Color>(
          Colors.white.withOpacity(0.5),
        ),
      ),
    );
  }
}

class _DropdownHint extends StatelessWidget {
  final String title;

  const _DropdownHint({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.sports_soccer,
          color: Colors.white,
          size: 20,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [
                Shadow(
                  color: Colors.black54,
                  offset: Offset(1, 1),
                  blurRadius: 2,
                ),
              ],
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _DropdownItem extends StatelessWidget {
  final MenuItem item;

  const _DropdownItem({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.05),
          ],
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          const Icon(
            Icons.sports_soccer,
            color: Colors.white70,
            size: 18,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              item.text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// BOARD BODY
// ============================================================================

class _BoardBody extends StatelessWidget {
  final Animation<double> fadeAnimation;
  final int currentFormationIndex;
  final bool canPaint;
  final VoidCallback onReset;
  final VoidCallback onTogglePaint;

  const _BoardBody({
    required this.fadeAnimation,
    required this.currentFormationIndex,
    required this.canPaint,
    required this.onReset,
    required this.onTogglePaint,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF1B5E20),
            Color(0xFF2E7D32),
            Color(0xFF4CAF50),
            Color(0xFF66BB6A),
          ],
        ),
      ),
      child: SafeArea(
        child: FadeTransition(
          opacity: fadeAnimation,
          child: Stack(
            children: [
              const Positioned.fill(
                child: CustomPaint(
                  painter: _FieldPatternPainter(),
                ),
              ),
              Column(
                children: [
                  const SizedBox(height: 5),
                  const _PageTitle(),
                  const SizedBox(height: 8),
                  Expanded(
                    flex: 12,
                    child: _FootballField(
                      currentFormationIndex: currentFormationIndex,
                      canPaint: canPaint,
                    ),
                  ),
                  _ToolsBar(
                    canPaint: canPaint,
                    onReset: onReset,
                    onTogglePaint: onTogglePaint,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// PAGE TITLE
// ============================================================================

class _PageTitle extends StatelessWidget {
  const _PageTitle();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF0D47A1),
            Color(0xFF1976D2),
          ],
        ),
        borderRadius: const BorderRadius.all(Radius.circular(25)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            offset: const Offset(0, 4),
            blurRadius: 12,
          ),
        ],
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.sports_soccer,
            color: Colors.white,
            size: 28,
          ),
          SizedBox(width: 12),
          Text(
            'Tactical Planning Board',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [
                Shadow(
                  color: Colors.black54,
                  offset: Offset(1, 1),
                  blurRadius: 3,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// FOOTBALL FIELD
// ============================================================================

class _FootballField extends StatelessWidget {
  final int currentFormationIndex;
  final bool canPaint;

  const _FootballField({
    required this.currentFormationIndex,
    required this.canPaint,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 20,
            spreadRadius: 5,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            _FieldImage(index: currentFormationIndex),
            _DrawingLayer(canPaint: canPaint),
            if (currentFormationIndex == 0) const _PlayerLayer(),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// FIELD IMAGE
// ============================================================================

class _FieldImage extends StatelessWidget {
  final int index;

  const _FieldImage({required this.index});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: Image.asset(
          key: ValueKey(index),
          _BoardPageState._fieldImagePaths[index],
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

// ============================================================================
// DRAWING LAYER
// ============================================================================

class _DrawingLayer extends StatelessWidget {
  final bool canPaint;

  const _DrawingLayer({required this.canPaint});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        ignoring: !canPaint,
        child: const Signature(
          color: Colors.white,
        ),
      ),
    );
  }
}

// ============================================================================
// PLAYER LAYER
// ============================================================================

class _PlayerLayer extends StatelessWidget {
  const _PlayerLayer();

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 600;
    final scale = isTablet ? 7.0 : 10.0;

    return Positioned.fill(
      child: Container(
        padding: const EdgeInsets.all(15),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Red team players
            for (int i = 1; i <= 11; i++)
              DraggableIcon(
                key: ValueKey('red_$i'),
                child: Image.asset(
                  'assets/images/red$i.png',
                  scale: scale,
                ),
              ),
            // Blue team players
            for (int i = 1; i <= 11; i++)
              DraggableIcon(
                key: ValueKey('blue_$i'),
                child: Image.asset(
                  'assets/images/blue$i.png',
                  scale: scale,
                ),
              ),
            // Ball
            DraggableIcon(
              key: const ValueKey('ball'),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      offset: const Offset(0, 4),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Image.asset(
                  'assets/images/ball.png',
                  scale: isTablet ? 12.0 : 15.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// TOOLS BAR
// ============================================================================

class _ToolsBar extends StatelessWidget {
  final bool canPaint;
  final VoidCallback onReset;
  final VoidCallback onTogglePaint;

  const _ToolsBar({
    required this.canPaint,
    required this.onReset,
    required this.onTogglePaint,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF263238),
            Color(0xFF37474F),
          ],
        ),
        borderRadius: const BorderRadius.all(Radius.circular(25)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            offset: const Offset(0, 4),
            blurRadius: 12,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _ToolButton(
            icon: Icons.refresh,
            label: 'Reset',
            onPressed: onReset,
            color: Colors.red,
          ),
          Container(
            width: 2,
            height: 30,
            color: Colors.white.withOpacity(0.3),
          ),
          _ToolButton(
            icon: canPaint ? Icons.edit_off : Icons.edit,
            label: canPaint ? 'Stop Drawing' : 'Enable Drawing',
            onPressed: onTogglePaint,
            color: canPaint ? Colors.orange : Colors.blue,
            isActive: canPaint,
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// TOOL BUTTON
// ============================================================================

class _ToolButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final Color color;
  final bool isActive;

  const _ToolButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    required this.color,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: const BorderRadius.all(Radius.circular(15)),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? color.withOpacity(0.2) : Colors.transparent,
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          border: Border.all(
            color: isActive ? color : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? color : Colors.white,
              size: 24,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: isActive ? color : Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// FIELD PATTERN PAINTER
// ============================================================================

class _FieldPatternPainter extends CustomPainter {
  const _FieldPatternPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < 10; i++) {
      canvas.drawLine(
        Offset(0, size.height * i / 10),
        Offset(size.width, size.height * (i + 1) / 10),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}