import 'package:flutter/material.dart';

class FloatingActionBubble extends AnimatedWidget {
  const FloatingActionBubble({
    required this.items,
    required this.onPressed,
    required this.icon,
    required this.title,
    required Animation<double> animation,
    this.tooltip,
  }) : super(listenable: animation);

  final List<ActionBubble> items;
  final void Function() onPressed;
  final AnimatedIconData icon;
  final String title;
  final String? tooltip;

  Animation<double> get _animation => listenable as Animation<double>;

  Widget buildItem(BuildContext context, int index) {
    final screenWidth = MediaQuery.of(context).size.width;

    final transform = Matrix4.translationValues(
      -(screenWidth - _animation.value * screenWidth) *
          ((items.length - index) / 4),
      0.0,
      0.0,
    );

    return Align(
      alignment: Alignment.centerRight,
      child: Transform(
        transform: transform,
        child: Opacity(
          opacity: _animation.value,
          child: BubbleMenu(items[index]),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Widget child = Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          IgnorePointer(
            ignoring: _animation.value == 0,
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder: (_, __) => const SizedBox(height: 4.0),
              padding: const EdgeInsets.symmetric(vertical: 12),
              itemCount: items.length,
              itemBuilder: buildItem,
            ),
          ),
          const SizedBox(height: 6.0),
          FloatingActionButton.extended(
            onPressed: onPressed,
            label: Text(title),
            tooltip: tooltip,
            icon: AnimatedIcon(
              icon: icon,
              progress: _animation,
            ),
          ),
        ],
      ),
    );

    return child;
  }
}

class ActionBubble {
  const ActionBubble({
    required this.title,
    this.subtitle,
    required this.titleStyle,
    required this.iconColor,
    required this.bubbleColor,
    required this.icon,
    required this.onPressed,
  });

  final IconData icon;
  final Color iconColor;
  final Color bubbleColor;
  final void Function() onPressed;
  final String title;
  final String? subtitle;
  final TextStyle titleStyle;
}

// =========================================================
// =========================================================

class BubbleMenu extends StatelessWidget {
  const BubbleMenu(this.item);

  final ActionBubble item;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      shape: const StadiumBorder(),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 22),
      color: item.bubbleColor,
      splashColor: Colors.grey.withOpacity(0.1),
      highlightColor: Colors.grey.withOpacity(0.1),
      elevation: 2,
      highlightElevation: 2,
      disabledColor: item.bubbleColor,
      onPressed: item.onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            item.title,
            style: item.titleStyle,
          ),
          const SizedBox(width: 14.0),
          Icon(
            item.icon,
            color: item.iconColor,
          ),
        ],
      ),
    );
  }
}
