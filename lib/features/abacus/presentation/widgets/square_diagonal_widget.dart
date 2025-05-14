import 'package:flutter/material.dart';
import 'dart:math';

import '../../../../core/core.dart';



class SquarePainter extends CustomPainter {
  final Function(LineSegment)? onLineTap;
  final Set<LineSegment> selectedLines;
  final double touchTolerance = 20.0;

  SquarePainter({
    this.onLineTap,
    this.selectedLines = const {},
  });

  bool isPointNearLine(Offset point, Offset start, Offset end) {
    double a = end.dy - start.dy;
    double b = start.dx - end.dx;
    double c = end.dx * start.dy - start.dx * end.dy;

    double distance = (a * point.dx + b * point.dy + c).abs() / sqrt(a * a + b * b);

    return distance < touchTolerance;
  }

  LineSegment? getSelectedLine(Offset touchPoint, Size size) {
    const topLeft = Offset.zero;
    final topRight = Offset(size.width, 0);
    final bottomLeft = Offset(0, size.height);
    final bottomRight = Offset(size.width, size.height);

    if (isPointNearLine(touchPoint, topLeft, topRight)) {
      return LineSegment.A;
    }
    if (isPointNearLine(touchPoint, topRight, bottomRight)) {
      return LineSegment.B;
    }
    if (isPointNearLine(touchPoint, bottomRight, bottomLeft)) {
      return LineSegment.C;
    }
    if (isPointNearLine(touchPoint, bottomLeft, topLeft)) {
      return LineSegment.D;
    }
    if (isPointNearLine(touchPoint, topLeft, bottomRight)) {
      return LineSegment.E;
    }
    if (isPointNearLine(touchPoint, topRight, bottomLeft)) {
      return LineSegment.F;
    }
    return null;
  }

  Paint getPaint(LineSegment segment, {bool isSelected = false}) {
    return Paint()
      ..color = isSelected ? segment.color : Colors.grey
      ..strokeWidth = 20 // Độ dày của đường thẳng
      // ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
  }

  void drawLine(Canvas canvas, Offset start, Offset end, LineSegment segment) {
    final paint = getPaint(segment, isSelected: selectedLines.contains(segment));
          canvas.drawLine(start, end, paint);

    // Điều chỉnh độ dài của đường thẳng dọc khi được chọn
    if (segment == LineSegment.B || segment == LineSegment.D || segment == LineSegment.A || segment == LineSegment.C) {
      final vector = end - start;
      final distance = vector.distance;
      final direction = vector / distance;
      final adjustedStart = start - direction * 10;
      final adjustedEnd = end + direction * 10;
      canvas.drawLine(adjustedStart, adjustedEnd, paint);
    } else {
      final vector = end - start;
      final distance = vector.distance;
      final direction = vector / distance;
      final adjustedStart = start - direction * 4;
      final adjustedEnd = end + direction * 4;
      canvas.drawLine(adjustedStart, adjustedEnd, paint);
    }
  }

  @override
  bool hitTest(Offset position) {
    return true; // Cho phép nhận sự kiện touch
  }

  @override
  void paint(Canvas canvas, Size size) {
    const topLeft = Offset.zero;
    final topRight = Offset(size.width, 0);
    final bottomLeft = Offset(0, size.height);
    final bottomRight = Offset(size.width, size.height);

    

    // Vẽ nền trắng cho hình vuông
    final backgroundPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final path = Path()
      ..moveTo(topLeft.dx, topLeft.dy)
      ..lineTo(topRight.dx, topRight.dy)
      ..lineTo(bottomRight.dx, bottomRight.dy)
      ..lineTo(bottomLeft.dx, bottomLeft.dy)
      ..close();
    canvas.drawPath(path, backgroundPaint);

    // Hàm vẽ viền chấm vuông (hai đường song song: trong và ngoài)
    void drawDoubleDottedLine(
      Offset start,
      Offset end, {
      bool isVertical = false,
      bool isDiagonal = false,
      required LineSegment segment,
      bool isSelected = false,
    }) {
      final dotPaint = Paint()
        ..color = isDiagonal && selectedLines.isEmpty ? Colors.red : (isSelected ? segment.color : Colors.grey)
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.fill;

      const dotSize = 1.0;
      const dotSpace = 1.0;
      const offsetDistance = 10.0;
      const cornerRadius = 4.0;

      double distance = (end - start).distance;
      Offset direction = (end - start) / distance;

      Offset perpendicularDirection;
      if (isDiagonal) {
        start = start + direction * -5;
        end = end - direction * -5;
        perpendicularDirection = Offset(direction.dy, -direction.dx);
        dotPaint.strokeWidth = 1.0;
      } else if (isVertical) {
        start = start + direction * -10 ;
        end = end - direction * -10 ;
        perpendicularDirection = Offset(-direction.dy, direction.dx);
      } else {
        // Đường ngang khi được chọn sẽ dài thêm 10
        if (isSelected) {
          start = start - direction * 10;
          end = end + direction * 10;
        } else {
          start = start + direction * 10;
          end = end - direction * 10;
        }
        perpendicularDirection = Offset(direction.dy, -direction.dx);
      }

      

      // Calculate initial outer and inner points
      Offset outerStart = start + perpendicularDirection * offsetDistance;
      Offset outerEnd = end + perpendicularDirection * offsetDistance;
      Offset innerStart = start - perpendicularDirection * offsetDistance;
      Offset innerEnd = end - perpendicularDirection * offsetDistance;

      // Adjust points for special segments
      if (segment == LineSegment.E) {
        final adjustedOffset = Offset(direction.dy - 0.5, -direction.dx) * (offsetDistance + 5);
        innerStart = start - direction * 15 - adjustedOffset;
        outerEnd = end + direction * 15 + adjustedOffset;
      } else if (segment == LineSegment.F) {
        if (!isSelected) {
          final innerOffset = Offset(direction.dy, -direction.dx) * (offsetDistance - 3);
          innerStart = start - direction - innerOffset;
          innerEnd = end + direction * 10 - innerOffset;
          outerStart = start - direction * 10 + perpendicularDirection * (offsetDistance - 3);
          outerEnd = end + direction + Offset(direction.dy, -direction.dx) * (offsetDistance - 3);
        } else {
          final adjustedOffset = Offset(direction.dy - 0.5, -direction.dx) * (offsetDistance + 5);
          innerEnd = end + direction * 15 - adjustedOffset;
          outerStart = start - direction * 15 + adjustedOffset;
        }
      }

      final fillPaint = Paint()
        ..color = isSelected ? segment.color : Colors.white
        ..style = PaintingStyle.fill;

      final fillPath = Path()
        ..moveTo(outerStart.dx, outerStart.dy)
        ..lineTo(outerEnd.dx, outerEnd.dy)
        ..lineTo(innerEnd.dx, innerEnd.dy)
        ..lineTo(innerStart.dx, innerStart.dy)
        ..close();
      canvas.drawPath(fillPath, fillPaint);

      void drawSingleDottedLine(Offset lineStart, Offset lineEnd) {
        double lineDistance = (lineEnd - lineStart).distance;
        Offset lineDirection = (lineEnd - lineStart) / lineDistance;
        double currentDistance = 0;

        int dotCount = (lineDistance / (dotSize + dotSpace)).floor();
        double adjustedDistance = lineDistance - (dotCount * (dotSize + dotSpace));

        while (currentDistance < lineDistance) {
          final dotCenter = lineStart + lineDirection * currentDistance;
          canvas.drawCircle(dotCenter, dotSize / 2, dotPaint);
          currentDistance += dotSize + dotSpace;
        }
      }

      drawSingleDottedLine(outerStart, outerEnd);
      drawSingleDottedLine(innerStart, innerEnd);

      // Bỏ vẽ dấu nối cho đường chéo
      if (!isDiagonal) {
        void drawConnectingDots(Offset start, Offset end) {
          double distance = (end - start).distance;
          Offset direction = (end - start) / distance;
          double currentDistance = 0;
          
          while (currentDistance < distance) {
            final dotCenter = start + direction * currentDistance;
            canvas.drawCircle(dotCenter, dotSize / 2, dotPaint);
            currentDistance += dotSize + dotSpace;
          }
        }

        drawConnectingDots(outerStart, innerStart);
        drawConnectingDots(outerEnd, innerEnd);
      }
    }

  
    const topLeftDiagonal = Offset(5, 0);
    final bottomRightDiagonal = Offset(size.width - 5, size.height);
    final topRightDiagonal = Offset(size.width - 5, 0);
    final bottomLeftDiagonal = Offset(5, size.height );
    
    

    if (!selectedLines.contains(LineSegment.A)) {
      drawDoubleDottedLine(topLeft, topRight, isVertical: false, segment: LineSegment.A, isSelected: false);
    }
    if (!selectedLines.contains(LineSegment.C)) {
      drawDoubleDottedLine(bottomRight, bottomLeft, isVertical: false, segment: LineSegment.C, isSelected: false);
    }
    if (!selectedLines.contains(LineSegment.B)) {
      drawDoubleDottedLine(topRight, bottomRight, isVertical: true, segment: LineSegment.B, isSelected: false);
    }
    if (!selectedLines.contains(LineSegment.D)) {
      drawDoubleDottedLine(bottomLeft, topLeft, isVertical: true, segment: LineSegment.D, isSelected: false);
    }
    if (!selectedLines.contains(LineSegment.F)) {
      drawDoubleDottedLine(topRightDiagonal, bottomLeftDiagonal, isDiagonal: true, segment: LineSegment.F, isSelected: false);
    }
    if (!selectedLines.contains(LineSegment.E)) {
      drawDoubleDottedLine(topLeftDiagonal, bottomRightDiagonal, isDiagonal: true, segment: LineSegment.E, isSelected: false);
    }

    if (selectedLines.contains(LineSegment.F)) {
      drawDoubleDottedLine(topRightDiagonal, bottomLeftDiagonal, isDiagonal: true, segment: LineSegment.F, isSelected: true);
    }
    if (selectedLines.contains(LineSegment.E)) {
      drawDoubleDottedLine(topLeftDiagonal, bottomRightDiagonal, isDiagonal: true, segment: LineSegment.E, isSelected: true);
    }
    if (selectedLines.contains(LineSegment.A)) {
      drawDoubleDottedLine(topLeft, topRight, isVertical: false, segment: LineSegment.A, isSelected: true);
    }
    if (selectedLines.contains(LineSegment.C)) {
      drawDoubleDottedLine(bottomRight, bottomLeft, isVertical: false, segment: LineSegment.C, isSelected: true);
    }
    if (selectedLines.contains(LineSegment.B)) {
      drawDoubleDottedLine(topRight, bottomRight, isVertical: true, segment: LineSegment.B, isSelected: true);
    }
    if (selectedLines.contains(LineSegment.D)) {
      drawDoubleDottedLine(bottomLeft, topLeft, isVertical: true, segment: LineSegment.D, isSelected: true);
    }
  }

  @override
  bool shouldRepaint(SquarePainter oldDelegate) {
    return oldDelegate.selectedLines != selectedLines;
  }
}

class SquareWithDiagonals extends StatefulWidget {
  final Function(LineSegment) onLineTap;
  final List<LineSegment>? initialSelectedLines;
  final Function(List<LineSegment>)? onSelectedLines;
  final double width;
  final double height;

  const SquareWithDiagonals({
    Key? key,
    required this.onLineTap,
    this.width = 120,
    this.height = 120,
    this.initialSelectedLines,
    this.onSelectedLines,
  }) : super(key: key);

  @override
  State<SquareWithDiagonals> createState() => _SquareWithDiagonalsState();
}

class _SquareWithDiagonalsState extends State<SquareWithDiagonals> {
  Set<LineSegment> selectedLines = {};

  @override
  void initState() {
    if (widget.initialSelectedLines != null) {
      selectedLines = widget.initialSelectedLines!.toSet();
    }
    super.initState();
  }

  @override
  void didUpdateWidget(covariant SquareWithDiagonals oldWidget) {
    selectedLines = widget.initialSelectedLines!.toSet();
    super.didUpdateWidget(oldWidget);
  }

  void _handleTap(LineSegment line) {
    setState(() {
      if (selectedLines.contains(line)) {
        selectedLines.remove(line);
      } else {
        selectedLines.add(line);
      }
    });
    widget.onLineTap(line);
    widget.onSelectedLines?.call(selectedLines.toList());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (TapDownDetails details) {
        final RenderBox renderBox = context.findRenderObject() as RenderBox;
        final localPosition = renderBox.globalToLocal(details.globalPosition);
        final painter = SquarePainter(
          onLineTap: widget.onLineTap,
          selectedLines: selectedLines,
        );
        final selectedLine = painter.getSelectedLine(localPosition, Size(widget.width, widget.height));
        if (selectedLine != null) {
          _handleTap(selectedLine);
        }
      },
      child: CustomPaint(
        key: ValueKey(selectedLines.toString()),

        /// force rebuild khi selectedLines thay đổi
        painter: SquarePainter(
          onLineTap: widget.onLineTap,
          selectedLines: selectedLines,
        ),
        size: Size(widget.width, widget.height),
      ),
    );
  }
}
