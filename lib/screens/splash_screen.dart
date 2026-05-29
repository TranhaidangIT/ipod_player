import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;
  late Animation<double> _glowAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.0, 0.55, curve: Curves.easeOut),
      ),
    );

    _scaleAnim = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.0, 0.55, curve: Curves.easeOutCubic),
      ),
    );

    _glowAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
      ),
    );

    _ctrl.forward();

    Future.delayed(const Duration(milliseconds: 2800), () {
      if (mounted) context.go('/');
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Always dark for splash — pure cinematic Apple black
    return Scaffold(
      backgroundColor: const Color(0xFF080A0E),
      body: AnimatedBuilder(
        animation: _ctrl,
        builder: (context, child) {
          return Stack(
            fit: StackFit.expand,
            children: [
              // Background radial glow
              Opacity(
                opacity: _glowAnim.value * 0.25,
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment.center,
                      radius: 0.8,
                      colors: [
                        Color(0xFF3A4050),
                        Color(0xFF080A0E),
                      ],
                    ),
                  ),
                ),
              ),
              // Center content
              Center(
                child: Opacity(
                  opacity: _fadeAnim.value,
                  child: Transform.scale(
                    scale: _scaleAnim.value,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Logo icon with metallic look
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFF8A939E),
                                Color(0xFF5A6370),
                                Color(0xFF3A434E),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(22),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF5A6370).withOpacity(
                                    _glowAnim.value * 0.6),
                                blurRadius: 40,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.music_note_rounded,
                            color: Colors.white,
                            size: 42,
                          ),
                        ),
                        const SizedBox(height: 32),
                        // SPATIAL text
                        const Text(
                          'SPATIAL',
                          style: TextStyle(
                            color: Color(0xFFECEFF4),
                            fontSize: 30,
                            fontWeight: FontWeight.w200,
                            letterSpacing: 14.0,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Subtitle
                        Opacity(
                          opacity: _glowAnim.value,
                          child: const Text(
                            'MUSIC PLAYER',
                            style: TextStyle(
                              color: Color(0xFF5A6370),
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 5.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 48),
                        // Loading dots
                        Opacity(
                          opacity: _glowAnim.value,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(3, (i) {
                              return AnimatedBuilder(
                                animation: _ctrl,
                                builder: (ctx, _) {
                                  final delay = i * 0.15;
                                  final t = ((_ctrl.value - delay) / 0.4)
                                      .clamp(0.0, 1.0);
                                  return Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 4),
                                    width: 5,
                                    height: 5,
                                    decoration: BoxDecoration(
                                      color: Color.lerp(
                                        const Color(0xFF3A434E),
                                        const Color(0xFF8A939E),
                                        t,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                  );
                                },
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
