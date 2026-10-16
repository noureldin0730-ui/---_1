import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class MosqueGame extends FlameGame {
  double _messageTimer = 0;
  bool _adhanCalled = false;
  String _message = '';
  late AdhanButton _adhanButton;

  @override
  Color backgroundColor() => const Color(0xFF1A1410);

  @override
  Future<void> onLoad() async {
    // نضيف الزرار
    _adhanButton = AdhanButton(game: this);
    add(_adhanButton);
    debugPrint('>>> GAME LOADED. Size: $size');
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (_message.isNotEmpty) {
      _messageTimer += dt;
      if (_messageTimer > 3) {
        _message = '';
        _messageTimer = 0;
      }
    }
  }

  void callAdhan() {
    if (_adhanCalled) {
      _message = 'أذنت بالفعل';
    } else {
      _adhanCalled = true;
      _message = 'الله أكبر، الله أكبر...';
    }
    _messageTimer = 0;
    debugPrint('>>> ADHAN CALLED. message: $_message');
  }

  void resetAdhan() {
    _adhanCalled = false;
    _message = '';
    _messageTimer = 0;
    debugPrint('>>> ADHAN RESET');
  }

  @override
  void render(Canvas canvas) {
    // 1. السماء
    final skyPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF1A0F1A),
          Color(0xFF2A1F2A),
          Color(0xFF3A2F20),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.x, size.y));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y), skyPaint);

    // 2. النجوم
    final starPaint = Paint()..color = Colors.white.withOpacity(0.7);
    for (int i = 0; i < 30; i++) {
      final x = (i * 137.5) % size.x;
      final y = (i * 73.3) % (size.y * 0.5);
      final r = ((i % 3) + 1).toDouble();
      canvas.drawCircle(Offset(x, y), r, starPaint);
    }

    // 3. القمر
    canvas.drawCircle(
      Offset(size.x - 120, 120),
      45,
      Paint()..color = const Color(0xFFFFF3D0),
    );
    canvas.drawCircle(
      Offset(size.x - 120, 120),
      45,
      Paint()
        ..color = const Color(0xFFFFF3D0).withOpacity(0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 25),
    );

    // 4. الأرض
    final groundPaint = Paint()..color = const Color(0xFF3A2A1A);
    canvas.drawRect(
      Rect.fromLTWH(0, size.y * 0.75, size.x, size.y * 0.25),
      groundPaint,
    );

    // 5. الجامع
    _drawMosque(canvas, size.x / 2, size.y * 0.78);

    // 6. الرسالة
    if (_message.isNotEmpty) {
      _drawMessage(canvas);
    }

    // 7. HUD
    _drawHud(canvas);
  }

  void _drawMosque(Canvas canvas, double cx, double baseY) {
    final wallColor = Paint()..color = const Color(0xFFE8DCC0);
    final wallShadow = Paint()..color = const Color(0xFFB8A88C);
    final domeColor = Paint()..color = const Color(0xFF7AB89A);
    final domeShadow = Paint()..color = const Color(0xFF4A8A6A);
    final doorColor = Paint()..color = const Color(0xFF8B5A2B);
    final gold = Paint()..color = const Color(0xFFFFD54A);

    final w = 240.0;
    final h = 160.0;

    // جسم الجامع
    canvas.drawRect(
      Rect.fromLTWH(cx - w / 2, baseY - h, w, h),
      wallColor,
    );

    // ظل على الجنب
    canvas.drawRect(
      Rect.fromLTWH(cx + w / 2 - 20, baseY - h, 20, h),
      wallShadow,
    );

    // القبة
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(cx, baseY - h),
        width: 140,
        height: 100,
      ),
      math.pi,
      math.pi,
      true,
      domeColor,
    );
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(cx + 20, baseY - h),
        width: 100,
        height: 60,
      ),
      math.pi,
      math.pi / 2,
      true,
      domeShadow,
    );

    // رأس القبة
    canvas.drawCircle(Offset(cx, baseY - h - 55), 6, gold);

    // مأذنة شمال
    final minaretX = cx - w / 2 - 30;
    canvas.drawRect(
      Rect.fromLTWH(minaretX - 15, baseY - h - 140, 30, 140 + h),
      wallColor,
    );
    canvas.drawRect(
      Rect.fromLTWH(minaretX + 5, baseY - h - 140, 10, 140 + h),
      wallShadow,
    );
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(minaretX, baseY - h - 140),
        width: 40,
        height: 40,
      ),
      math.pi,
      math.pi,
      true,
      domeColor,
    );
    canvas.drawCircle(Offset(minaretX, baseY - h - 165), 5, gold);

    // مأذنة يمين
    final minaret2X = cx + w / 2 + 30;
    canvas.drawRect(
      Rect.fromLTWH(minaret2X - 15, baseY - h - 120, 30, 120 + h),
      wallColor,
    );
    canvas.drawRect(
      Rect.fromLTWH(minaret2X + 5, baseY - h - 120, 10, 120 + h),
      wallShadow,
    );
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(minaret2X, baseY - h - 120),
        width: 40,
        height: 40,
      ),
      math.pi,
      math.pi,
      true,
      domeColor,
    );
    canvas.drawCircle(Offset(minaret2X, baseY - h - 145), 5, gold);

    // الباب
    final doorW = 60.0;
    final doorH = 80.0;
    canvas.drawRect(
      Rect.fromLTWH(cx - doorW / 2, baseY - doorH, doorW, doorH),
      doorColor,
    );
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(cx, baseY - doorH),
        width: doorW,
        height: 40,
      ),
      math.pi,
      math.pi,
      true,
      doorColor,
    );

    // شبابيك
    final windowPaint = Paint()..color = const Color(0xFFFFE88A);
    canvas.drawRect(
      Rect.fromLTWH(cx - 90, baseY - h + 40, 30, 40),
      windowPaint,
    );
    canvas.drawRect(
      Rect.fromLTWH(cx + 60, baseY - h + 40, 30, 40),
      windowPaint,
    );

    // إطار الشبابيك
    final framePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawRect(
      Rect.fromLTWH(cx - 90, baseY - h + 40, 30, 40),
      framePaint,
    );
    canvas.drawRect(
      Rect.fromLTWH(cx + 60, baseY - h + 40, 30, 40),
      framePaint,
    );
  }

  void _drawMessage(Canvas canvas) {
    final tp = TextPainter(
      text: TextSpan(
        text: _message,
        style: const TextStyle(
          color: Color(0xFFFFD54A),
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.rtl,
    )..layout();

    final boxW = tp.width + 60;
    final boxH = tp.height + 40;
    final boxX = (size.x - boxW) / 2;
    final boxY = size.y * 0.15;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(boxX, boxY, boxW, boxH),
        const Radius.circular(12),
      ),
      Paint()..color = Colors.black.withOpacity(0.85),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(boxX, boxY, boxW, boxH),
        const Radius.circular(12),
      ),
      Paint()
        ..color = const Color(0xFFFFD54A)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    tp.paint(canvas, Offset(boxX + 30, boxY + 20));
  }

  void _drawHud(Canvas canvas) {
    final text = _adhanCalled ? '✅ أذنت' : '⏳ لسه ما أذنتش';
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.rtl,
    )..layout();

    final boxW = tp.width + 40;
    final boxH = tp.height + 20;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(20, 20, boxW, boxH),
        const Radius.circular(8),
      ),
      Paint()..color = Colors.black.withOpacity(0.6),
    );

    tp.paint(canvas, const Offset(40, 30));
  }
}

// ============================================================
// زرار "أذن"
// ============================================================
class AdhanButton extends PositionComponent with TapCallbacks {
  final MosqueGame game;
  bool _pressed = false;

  AdhanButton({required this.game})
      : super(
          priority: 100,
        );

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    this.position = Vector2(size.x / 2 - 100, size.y - 90);
    this.size = Vector2(200, 60);
    debugPrint('>>> BUTTON at ${this.position}, size: ${this.size}');
  }

  @override
  void render(Canvas canvas) {
    final rect = Rect.fromLTWH(0, 0, size.x, size.y);

    final bgColor = game._adhanCalled
        ? const Color(0xFF4A8A4A)
        : const Color(0xFFFFD54A);

    // خلفية الزرار
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(12)),
      Paint()..color = bgColor,
    );

    // ظل
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 4, size.x, size.y),
        const Radius.circular(12),
      ),
      Paint()..color = Colors.black.withOpacity(0.3),
    );

    // خلفية الزرار (فوق الظل)
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(12)),
      Paint()..color = bgColor,
    );

    // حدود
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(12)),
      Paint()
        ..color = Colors.black
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );

    // تأثير الضغط
    if (_pressed) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(12)),
        Paint()..color = Colors.black.withOpacity(0.2),
      );
    }

    // النص
    final label = game._adhanCalled ? '✅ أذنت' : '🕌 أذن';
    final tp = TextPainter(
      text: TextSpan(
        text: label,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.rtl,
    )..layout();

    tp.paint(
      canvas,
      Offset((size.x - tp.width) / 2, (size.y - tp.height) / 2),
    );
  }

  @override
  void onTapDown(TapDownEvent event) {
    _pressed = true;
  }

  @override
  void onTapUp(TapUpEvent event) {
    _pressed = false;
    if (game._adhanCalled) {
      game.resetAdhan();
    } else {
      game.callAdhan();
    }
  }

  @override
  void onTapCancel(TapCancelEvent event) {
    _pressed = false;
  }
}