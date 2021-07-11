import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        height: 64,
        width: 64,
        child: CircularProgressIndicator(),
      ),
    );
  }
}
