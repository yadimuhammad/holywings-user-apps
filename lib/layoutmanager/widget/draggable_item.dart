import 'package:flutter/material.dart';
import 'package:holywings_user_apps/layoutmanager/controller/layout_manager_controller.dart';
import 'package:holywings_user_apps/models/table_model.dart';

// ignore: must_be_immutable
class DraggableItem extends StatefulWidget {
  final Widget child;
  final VoidCallback onPressed;
  final GlobalKey parentKey;
  bool enabled = false;
  final TableModel model;
  final LayoutManagerController controller;

  DraggableItem({
    Key? key,
    required this.child,
    required this.onPressed,
    required this.parentKey,
    required this.enabled,
    required this.model,
    required this.controller,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DraggableItemState();
}

class _DraggableItemState extends State<DraggableItem> {
  final GlobalKey _key = GlobalKey();

  bool _isDragging = false;
  late Offset _offset;
  late Offset _minOffset;
  late Offset _maxOffset;

  @override
  void initState() {
    super.initState();
    _offset = Offset(
      widget.model.position?.x ?? 0.0,
      widget.model.position?.y ?? 0.0,
    );

    WidgetsBinding.instance?.addPostFrameCallback(_setBoundary);
  }

  void _setBoundary(_) {
    try {
      final RenderBox parentRenderBox = widget.parentKey.currentContext?.findRenderObject() as RenderBox;
      final RenderBox renderBox = _key.currentContext?.findRenderObject() as RenderBox;

      final Size parentSize = parentRenderBox.size;
      final Size size = renderBox.size;

      setState(() {
        widget.model.position?.x = (widget.model.position?.ratioWidth ?? 0.0) * parentSize.width;
        widget.model.position?.y = (widget.model.position?.ratioHeight ?? 0.0) * parentSize.height;

        _minOffset = const Offset(0, 0);
        _maxOffset = Offset(parentSize.width - size.width, parentSize.height - size.height);
      });
    } catch (e) {}
  }

  void _updatePosition(PointerMoveEvent pointerMoveEvent) {
    double newOffsetX = _offset.dx + pointerMoveEvent.delta.dx;
    double newOffsetY = _offset.dy + pointerMoveEvent.delta.dy;

    if (newOffsetX < _minOffset.dx) {
      newOffsetX = _minOffset.dx;
    } else if (newOffsetX > _maxOffset.dx) {
      newOffsetX = _maxOffset.dx;
    }

    if (newOffsetY < _minOffset.dy) {
      newOffsetY = _minOffset.dy;
    } else if (newOffsetY > _maxOffset.dy) {
      newOffsetY = _maxOffset.dy;
    }
    // int divisor = 5;
    // int y = (newOffsetY / divisor).floor() * divisor;
    final RenderBox parentRenderBox = widget.parentKey.currentContext?.findRenderObject() as RenderBox;
    final RenderBox renderBox = _key.currentContext?.findRenderObject() as RenderBox;
    final Size parentSize = parentRenderBox.size;
    final Size size = renderBox.size;

    double x2 = (newOffsetX + size.width) - 11;
    double y2 = (newOffsetY + size.height) - 2;
    setState(() {
      _offset = Offset(newOffsetX, newOffsetY);
      widget.controller.rulerOffset1.value = _offset;
      widget.controller.rulerOffset2.value = Offset(x2, y2);

      widget.model.position?.x = newOffsetX;
      widget.model.position?.y = newOffsetY;

      widget.model.position?.ratioWidth = (widget.model.position?.x ?? 0.0) / parentSize.width;
      widget.model.position?.ratioHeight = (widget.model.position?.y ?? 0.0) / parentSize.height;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!(widget.model.position?.show ?? true)) return Container();
    return Positioned(
      left: widget.model.position?.x,
      top: widget.model.position?.y,
      child: Listener(
        onPointerMove: (PointerMoveEvent pointerMoveEvent) {
          if (!widget.enabled) {
            return;
          }
          _updatePosition(pointerMoveEvent);
          widget.controller.panEnabled.value = false;
          widget.controller.scaleEnabled.value = false;

          setState(() {
            _isDragging = true;
          });
        },
        onPointerUp: (PointerUpEvent pointerUpEvent) {
          if (_isDragging) {
            setState(() {
              _isDragging = false;
            });
          } else {
            // widget.onPressed();
          }

          if (!widget.enabled) {
            return;
          }

          widget.controller.panEnabled.value = true;
          widget.controller.scaleEnabled.value = true;
          widget.controller.showDragRuler.value = false;
        },
        onPointerDown: (PointerDownEvent event) {
          if (!widget.enabled) {
            return;
          }
          widget.controller.showDragRuler.value = true;
        },
        child: InkWell(
          onTap: () => widget.onPressed(),
          child: Container(
            key: _key,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
