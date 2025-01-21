import 'package:flutter/material.dart';

// menu's scrollbar is ugly and too thick

class DFCMenuAnchor extends StatelessWidget {
  const DFCMenuAnchor({
    required this.menuChildren,
    super.key,
    this.controller,
    this.childFocusNode,
    this.style,
    this.alignmentOffset = Offset.zero,
    this.layerLink,
    this.clipBehavior = Clip.hardEdge,
    this.consumeOutsideTap = false,
    this.onOpen,
    this.onClose,
    this.crossAxisUnconstrained = true,
    this.builder,
    this.child,
  });

  final MenuController? controller;
  final FocusNode? childFocusNode;
  final MenuStyle? style;
  final Offset? alignmentOffset;
  final LayerLink? layerLink;
  final Clip clipBehavior;
  final bool consumeOutsideTap;
  final VoidCallback? onOpen;
  final VoidCallback? onClose;
  final bool crossAxisUnconstrained;
  final List<Widget> menuChildren;
  final MenuAnchorChildBuilder? builder;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ScrollbarTheme(
      data: const ScrollbarThemeData(
        thickness: WidgetStatePropertyAll(
          2,
        ),
      ),
      child: MenuAnchor(
        controller: controller,
        childFocusNode: childFocusNode,
        style: style,
        alignmentOffset: alignmentOffset,
        layerLink: layerLink,
        clipBehavior: clipBehavior,
        consumeOutsideTap: consumeOutsideTap,
        onOpen: onOpen,
        onClose: onClose,
        crossAxisUnconstrained: crossAxisUnconstrained,
        menuChildren: menuChildren,
        builder: builder,
        child: child,
      ),
    );
  }
}
