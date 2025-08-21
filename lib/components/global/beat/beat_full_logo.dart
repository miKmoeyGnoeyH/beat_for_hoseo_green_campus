import 'package:beat_flutter/extensions/buildcontext_extension.dart';
import 'package:flutter/material.dart';

class BeatFullLogo extends StatelessWidget {
  const BeatFullLogo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 50),
        child: Image.asset(
          'assets/images/beat_full_logo.png',
          width: context.width * 0.3,
          height: context.height * 0.15,
        ),
      ),
    );
  }
}