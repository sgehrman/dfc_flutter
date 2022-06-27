import 'dart:math';

import 'package:dfc_flutter/src/extensions/string_ext.dart';
import 'package:dfc_flutter/src/google_fonts/google_font_library.dart';
import 'package:dfc_flutter/src/themes/editor/theme_set.dart';
import 'package:dfc_flutter/src/themes/editor/theme_set_manager.dart';
import 'package:dfc_flutter/src/utils/preferences.dart';
import 'package:dfc_flutter/src/widgets/draggable_scrollbar.dart';
import 'package:dfc_flutter/src/widgets/theme_button.dart';
import 'package:flutter/material.dart';

class _FontObj {
  _FontObj({
    required this.name,
    required this.displayName,
    required this.fav,
    required this.firstChar,
  });

  final String name;
  final String displayName;
  final String firstChar;
  bool fav;
}

class GoogleFontsWidget extends StatefulWidget {
  const GoogleFontsWidget({
    Key? key,
    this.showNext = false,
  }) : super(key: key);

  final bool showNext;

  @override
  GoogleFontsWidgetState createState() => GoogleFontsWidgetState();
}

class GoogleFontsWidgetState extends State<GoogleFontsWidget> {
  final String appBarTitle = 'Choose a Font';
  final ScrollController _scrollController = ScrollController();

  final _fontList = _buildFontList();

  static const _itemHeight = 45.0;

  static List<_FontObj> _buildFontList() {
    final List<String> gFonts = googleFonts();
    final List<String?> favs = Preferences().getFavoriteGoogleFonts();

    final result = <_FontObj>[];

    for (final f in gFonts) {
      final String fixed = f.replaceFirst('TextTheme', '');

      final bool fav = favs.contains(f);

      result.add(
        _FontObj(
          name: f,
          displayName: fixed.fromCamelCase(),
          fav: fav,
          firstChar: f.toUpperCase().firstChar,
        ),
      );
    }

    return result;
  }

  Widget _contents(Color? normalColor, String currentFont) {
    return DraggableScrollbar(
      backgroundColor: Theme.of(context).primaryColor,
      labelTextBuilder: (double offset) {
        int index = offset ~/ _itemHeight;

        index = min(index, _fontList.length - 1);

        return Text(
          _fontList[index].firstChar,
          style: const TextStyle(color: Colors.white, fontSize: 24),
        );
      },
      controller: _scrollController,
      child: ListView.builder(
        itemExtent: _itemHeight,
        // separatorBuilder: (context, index) =>
        //     const Divider(height: _dividerHeight),
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        itemCount: _fontList.length,
        itemBuilder: (context, index) {
          final fontObj = _fontList[index];

          TextTheme theme = Theme.of(context).textTheme;
          theme = themeWithGoogleFont(fontObj.name, theme);

          // not using ListTile for speed
          // we use the itemExtent and add our own divider
          return InkWell(
            onTap: () {
              ThemeSetManager().googleFont = fontObj.name;
            },
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: Text(
                            fontObj.displayName,
                            style: theme.headline6!.copyWith(
                              color: fontObj.name == currentFont
                                  ? Theme.of(context).primaryColor
                                  : null,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        iconSize: 18,
                        onPressed: () {
                          setState(() {
                            fontObj.fav = !fontObj.fav;

                            // save in prefs
                            final List<String?> favs =
                                Preferences().getFavoriteGoogleFonts();

                            if (fontObj.fav) {
                              favs.add(fontObj.name);
                            } else {
                              favs.remove(fontObj.name);
                            }

                            Preferences().setFavoriteGoogleFonts(favs);
                          });
                        },
                        icon: fontObj.fav
                            ? const Icon(
                                Icons.favorite,
                                color: Colors.red,
                              )
                            : const Icon(
                                Icons.favorite_border,
                              ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 2),
              ],
            ),
          );
        },
      ),
    );
  }

  void useDefault() {
    final String fontName = ThemeSet.defaultSet().fontName;

    ThemeSetManager().googleFont = fontName;

    // scroll to default
    int index = 0;
    for (int i = 0; i < _fontList.length; i++) {
      final font = _fontList[i];

      if (font.name == fontName) {
        index = i;
        break;
      }
    }

    _scrollController.animateTo(
      _itemHeight * index,
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }

  void _next() {
    final String currentFont = ThemeSetManager().googleFont;

    // scroll to default
    int index = 0;
    for (int i = 0; i < _fontList.length; i++) {
      final font = _fontList[i];

      if (font.name == currentFont) {
        index = i;
        break;
      }
    }

    _scrollController.animateTo(
      _itemHeight * index,
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );

    int nextIndex = index + 1;
    if (nextIndex >= _fontList.length) {
      nextIndex = 0;
    }

    ThemeSetManager().googleFont = _fontList[nextIndex].name;
  }

  @override
  Widget build(BuildContext context) {
    final Color? normalColor = Theme.of(context).textTheme.bodyText2!.color;
    final String currentFont = ThemeSetManager().googleFont;

    if (widget.showNext) {
      return Column(
        children: [
          ThemeButton(
            onPressed: () {
              _next();
            },
            title: 'Next',
          ),
          Expanded(
            child: _contents(normalColor, currentFont),
          ),
        ],
      );
    }

    return _contents(normalColor, currentFont);
  }
}
