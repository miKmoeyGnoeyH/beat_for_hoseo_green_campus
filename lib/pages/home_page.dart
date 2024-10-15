import 'package:flutter/material.dart';

import '../widgets/global/basic_appbar.dart';
import '../widgets/global/custom_scaffold.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const CustomScaffold(
      appBar: BasicAppBar(title: 'Home'),
      body: Center(
        child: Text('Home Page'),
      ),
    );
  }

  const HomePage({super.key});
}
