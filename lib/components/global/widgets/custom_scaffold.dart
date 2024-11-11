
import 'package:BEAT/extensions/buildcontext_extension.dart';
import 'package:flutter/material.dart';

class CustomScaffold extends StatelessWidget {
  const CustomScaffold({
    this.onPullDown,
    this.top = false,
    this.bottom = false,
    this.backgroundColor,
    this.isScrollable,
    this.appBar,
    this.body,
    this.hasScrollBody = true,
    this.bottomNavigationBar,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: backgroundColor ?? context.appColors.surface,
        child: SafeArea(
          top: top,
          bottom: bottom,
          child: CustomScrollView(
            physics: isScrollable == null
                ? const AlwaysScrollableScrollPhysics()
                : isScrollable == true
                    ? const AlwaysScrollableScrollPhysics()
                    : const NeverScrollableScrollPhysics(),
            slivers: [
              if (appBar != null) appBar!,
              SliverFillRemaining(
                hasScrollBody: hasScrollBody,
                fillOverscroll: false,
                child: RefreshIndicator(
                  color: context.appColors.primary,
                  onRefresh: onPullDown != null ? onPullDown! : () async {},
                  child: body ?? const SizedBox(),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: bottomNavigationBar,
    );
  }

  final Future<void> Function()? onPullDown;
  final bool top;
  final bool bottom;
  final Color? backgroundColor;
  final bool? isScrollable;
  final Widget? appBar;
  final Widget? body;
  final bool hasScrollBody;
  final Widget? bottomNavigationBar;
}
