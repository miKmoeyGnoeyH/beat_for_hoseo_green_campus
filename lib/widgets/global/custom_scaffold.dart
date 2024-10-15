import 'package:beat_flutter/extensions/buildcontext_extension.dart';
import 'package:flutter/material.dart';

class CustomScaffold extends StatelessWidget {
  const CustomScaffold({this.appBar, this.body, this.hasScrollBody = true, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: context.colorScheme.surface,
        child: SafeArea(
          top: false,
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

  final Widget? appBar;
  final Widget? body;
  final bool hasScrollBody;
}
