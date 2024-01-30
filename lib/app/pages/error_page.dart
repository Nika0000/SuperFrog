import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ErrorPage extends StatelessWidget {
  final GoRouterState? state;

  const ErrorPage({this.state, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(state?.error?.message.toString() ?? 'Failed to navigate route'),
      ),
    );
  }
}
