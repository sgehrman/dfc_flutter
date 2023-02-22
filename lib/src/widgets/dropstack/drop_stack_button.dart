import 'package:dfc_flutter/src/file_system/server_file.dart';
import 'package:dfc_flutter/src/widgets/dropstack/drop_stack.dart';
import 'package:dfc_flutter/src/widgets/dropstack/floating_action_bubble.dart';
import 'package:dfc_flutter/src/widgets/dropstack/overlay_container.dart';
import 'package:dfc_flutter/src/widgets/tooltip_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DropStackButton extends StatefulWidget {
  const DropStackButton({required this.directory});
  final ServerFile? directory;

  @override
  State<DropStackButton> createState() => _DropStackButtonState();
}

class _DropStackButtonState extends State<DropStackButton>
    with SingleTickerProviderStateMixin {
  late Animation<double> _animation;
  AnimationController? _animationController;

  void _statusListener(AnimationStatus status) {
    switch (status) {
      case AnimationStatus.dismissed:
      case AnimationStatus.completed:
        setState(() {});
        break;
      default:
        break;
    }
  }

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _animationController!.addStatusListener(_statusListener);

    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: _animationController!);

    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);
  }

  @override
  void dispose() {
    _animationController!.removeStatusListener(_statusListener);
    _animationController!.dispose();
    _animationController = null;

    super.dispose();
  }

  List<ActionBubble> _items(BuildContext context, DropStack dropStack) {
    const double fontSize = 14;
    const Color bubbleColor = Colors.cyan;
    const Color textColor = Colors.white;

    final List<ActionBubble> result = <ActionBubble>[];

    result.add(
      ActionBubble(
        title: 'Clear Stack',
        iconColor: textColor,
        bubbleColor: bubbleColor,
        icon: Icons.clear_all,
        titleStyle: const TextStyle(fontSize: fontSize, color: textColor),
        onPressed: () {
          dropStack.clear();
          _animationController?.reverse();
        },
      ),
    );

    if (dropStack.count > 1) {
      result.add(
        ActionBubble(
          title: 'Drop Top Only',
          iconColor: textColor,
          bubbleColor: bubbleColor,
          icon: Icons.file_download,
          titleStyle: const TextStyle(fontSize: fontSize, color: textColor),
          onPressed: () async {
            await dropStack.drop(
              context: context,
              directory: widget.directory!,
              topOnly: true,
            );

            await _animationController?.reverse();
          },
        ),
      );
    }

    result.add(
      ActionBubble(
        title: 'Drop Here',
        iconColor: textColor,
        bubbleColor: bubbleColor,
        icon: Icons.file_download,
        titleStyle: const TextStyle(fontSize: fontSize, color: textColor),
        onPressed: () async {
          await dropStack.drop(
            context: context,
            directory: widget.directory!,
            topOnly: false,
          );

          await _animationController?.reverse();
        },
      ),
    );

    return result;
  }

  Widget _overlay(BuildContext context, Widget child) {
    Widget showChild = Align(
      alignment: Alignment.bottomRight,
      child: child,
    );

    if (_animation.value == 1) {
      showChild = GestureDetector(
        onTap: () => onPressed(reverseOnly: true),
        child: Container(
          // needs a color set otherwise onTap never gets called
          color: Colors.transparent,
          child: showChild,
        ),
      );
    }

    return OverlayContainer(
      child: Container(
        child: showChild,
      ),
    );
  }

  void onPressed({
    bool reverseOnly = false,
  }) {
    if (reverseOnly) {
      if (_animationController!.isCompleted) {
        _animationController!.reverse();
      }
    } else {
      _animationController!.isCompleted
          ? _animationController!.reverse()
          : _animationController!.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: DropStack(),
      builder: (context, child) {
        final DropStack dropStack = Provider.of<DropStack>(context);

        return _overlay(
          context,
          FloatingActionBubble(
            title: dropStack.count.toString(),
            tooltip: tipString('Drop Stack'),
            items: _items(context, dropStack),
            animation: _animation,
            onPressed: onPressed,
            icon: AnimatedIcons.menu_close,
          ),
        );
      },
    );
  }
}
