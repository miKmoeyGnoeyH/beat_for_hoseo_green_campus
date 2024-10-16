import 'package:beat_flutter/extensions/buildcontext_extension.dart';
import 'package:flutter/material.dart';

class CustomScaffold extends StatelessWidget {
  const CustomScaffold({
    this.top = false,
    this.backgroundColor,
    this.appBar,
    this.body,
    this.hasScrollBody = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: backgroundColor ?? context.colorScheme.surface,
        child: SafeArea(
          top: top,
          child: CustomScrollView(
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
  final Widget? appBar;
  final Widget? body;
  final bool hasScrollBody;
}
