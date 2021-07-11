import 'package:flutter/material.dart';

extension ExtendedSize on Size {
  Size get onlyWidth => Size(width, 0);

  Size get onlyHeight => Size(0, height);

  Offset get offset => Offset(width, height);
}
