import 'package:BEAT/extensions/buildcontext_extension.dart';
import 'package:flutter/material.dart';

class CustomScaffold extends StatelessWidget {
  const CustomScaffold({
    this.top = false,
    this.backgroundColor,
    this.isScrollable,
    this.appBar,
    this.body,
    this.hasScrollBody = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: backgroundColor ?? context.appColors.surface,
        child: SafeArea(
          top: top,
          child: CustomScrollView(
            physics: isScrollable == null
                ? const AlwaysScrollableScrollPhysics()
                : isScrollable!
                    ? const AlwaysScrollableScrollPhysics()
                    : const NeverScrollableScrollPhysics(),
            slivers: [
              if (appBar != null) appBar!,
              SliverFillRemaining(
                hasScrollBody: hasScrollBody,
                child: body,
              ),
            ],
          ),
        ),
      ),
    );
  }

  final bool top;
  final Color? backgroundColor;
  final bool? isScrollable;
  final Widget? appBar;
  final Widget? body;
  final bool hasScrollBody;
}
