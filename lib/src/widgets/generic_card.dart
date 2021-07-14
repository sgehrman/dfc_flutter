import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:dfc_flutter/src/utils/utils.dart';
import 'package:dfc_flutter/src/widgets/menu_item.dart';

import 'package:dfc_flutter/src/widgets/primary_title.dart';

const double kBorderRadius = 12;
const double kSmallBorderRadius = 8;

class GenericCard extends StatelessWidget {
  const GenericCard({
    required this.children,
    this.onTap,
    this.onLongPress,
    this.onDelete,
    this.onEdit,
    this.minHeight = 100,
    this.title,
    this.titleAction,
    this.showChevron = false,
    this.small = false,
    this.action,
  });

  final List<Widget> children;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;
  final double minHeight;
  final String? title;
  final bool showChevron;
  final bool small;
  final Widget? action;
  final Widget? titleAction;

  Widget _titleBar(BuildContext context) {
    if (Utils.isEmpty(title)) {
      return NothingWidget();
    }

    return PrimaryTitle(title: title, action: titleAction);
  }

  List<PopupMenuEntry<String>> _addMenuSeparators(
      List<PopupMenuEntry<String>> menuItems) {
    final List<PopupMenuEntry<String>> result = [];

    if (Utils.isNotEmpty(menuItems)) {
      menuItems.asMap().forEach((index, value) {
        if (index % 2 != 0) {
          result.add(const PopupMenuDivider());
        }

        result.add(value);
      });
    }

    return result;
  }

  Widget _popupMenu() {
    return PopupMenuButton<String>(
      itemBuilder: (context) {
        List<PopupMenuEntry<String>> menuItems = [];

        if (onEdit != null) {
          menuItems.add(
            PopupMenuItem<String>(
              value: 'edit',
              enabled: onEdit != null,
              child: const MenuItem(
                icon: Icon(Icons.edit),
                name: 'Edit',
              ),
            ),
          );
        }

        if (onDelete != null) {
          menuItems.add(
            PopupMenuItem<String>(
              value: 'delete',
              enabled: onDelete != null,
              child: const MenuItem(
                icon: Icon(Icons.delete),
                name: 'Delete',
              ),
            ),
          );
        }

        menuItems = _addMenuSeparators(menuItems);

        return menuItems;
      },
      onSelected: (selected) async {
        switch (selected) {
          case 'edit':
            if (onEdit != null) {
              onEdit!();
            }
            break;
          case 'delete':
            if (onDelete != null) {
              onDelete!();
            }
            break;
        }
      },
      child: const Icon(
        Icons.more_vert,
        size: 19,
        // color: Colors.white70,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double horizontal = 16.0;
    double vertical = 14;
    if (small) {
      horizontal = 12.0;
      vertical = 10;
    }

    return Stack(
      children: [
        BaseCard(
          small: small,
          minHeight: minHeight,
          onTap: onTap,
          onLongPress: onLongPress,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontal,
                  vertical: vertical,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [_titleBar(context), ...children],
                ),
              ),
            ],
          ),
        ),
        Visibility(
          visible: onDelete != null || onEdit != null,
          child: Positioned(
            right: 8,
            top: 12,
            child: _popupMenu(),
          ),
        ),
        Visibility(
          visible: action != null,
          child: Positioned(
            right: 8,
            top: 12,
            child: action ?? NothingWidget(),
          ),
        ),
        Visibility(
          visible: showChevron,
          child: const Positioned(
            right: 6,
            bottom: 10,
            child: Icon(
              Icons.chevron_right,
              color: Colors.white38,
            ),
          ),
        ),
      ],
    );
  }
}

// ==========================================================

class CardDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(height: dividerHeight());
  }

  static double dividerHeight({bool small = false}) {
    if (small) {
      return 8;
    }

    return 12;
  }
}

// ==========================================================

class AddCard extends StatelessWidget {
  const AddCard({
    required this.onTap,
    this.minHeight = 80,
    this.small = false,
  });

  final VoidCallback onTap;
  final double minHeight;
  final bool small;

  @override
  Widget build(BuildContext context) {
    final Color cardColor =
        Theme.of(context).textTheme.bodyText1!.color!.withOpacity(.1);

    double strokeWidth = 5;
    List<double> dashPattern = [12, 10];
    double iconSize = 38;

    if (small) {
      strokeWidth = 4;
      dashPattern = [8, 8];
      iconSize = 24;
    }

    return Padding(
      padding: EdgeInsets.all(strokeWidth / 2),
      child: DottedBorder(
        dashPattern: dashPattern,
        strokeWidth: strokeWidth,
        strokeCap: StrokeCap.round,
        borderType: BorderType.RRect,
        radius: Radius.circular(small ? kSmallBorderRadius : kBorderRadius),
        color: cardColor,
        child: BaseCard(
          fill: false,
          small: small,
          minHeight: minHeight,
          onTap: () {
            onTap();
          },
          child: Center(
              child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Icon(
              Icons.add_circle_outline,
              color: cardColor,
              size: iconSize,
            ),
          )),
        ),
      ),
    );
  }
}

// ==========================================================

class BaseCard extends StatelessWidget {
  const BaseCard({
    required this.child,
    this.onTap,
    this.onLongPress,
    this.minHeight = 100,
    this.fill = true,
    this.small = false,
  });

  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final double minHeight;
  final bool fill;
  final bool small;

  @override
  Widget build(BuildContext context) {
    return Card(
      // null will use the default color
      color: fill ? null : Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(small ? kSmallBorderRadius : kBorderRadius),
      ),
      margin: EdgeInsets.zero,
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: minHeight),
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          child: child,
        ),
      ),
    );
  }
}
