import 'package:dfc_flutter/src/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DialogBackButtonController extends ChangeNotifier {
  void Function()? _onPressed;

  void Function()? get onPressed => _onPressed;
  set onPressed(void Function()? onPressed) {
    _onPressed = onPressed;

    notifyListeners();
  }
}

// =====================================================

class DialogBackButton extends StatelessWidget {
  const DialogBackButton({
    required this.controller,
  });

  final DialogBackButtonController controller;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: controller,
      builder: (context, child) {
        final provider = context.watch<DialogBackButtonController>();

        return Padding(
          padding: const EdgeInsets.only(right: 10),
          child: DFIconButton(
            tooltip: 'Back',
            onPressed: provider.onPressed,
            icon: const Icon(Icons.arrow_back),
          ),
        );
      },
    );
  }
}
