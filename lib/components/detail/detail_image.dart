import 'package:flutter/material.dart';

import '../global/widgets/custom_rounded_bordered_container.dart';

class DetailImage extends StatelessWidget {
  const DetailImage({
    super.key,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return CustomRoundedBorderedContainer(
      child: imageUrl != null
          ? Image.network(
        imageUrl!,
        fit: BoxFit.fill,
      )
          : const SizedBox(),
    );
  }

  final String? imageUrl;
}