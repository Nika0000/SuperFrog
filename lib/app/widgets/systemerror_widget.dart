import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

Widget systemErrorWidget(FlutterErrorDetails details) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Builder(
      builder: (context) {
        return Scaffold(
          body: kReleaseMode
              ? const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Runtime Error',
                        style: TextStyle(fontSize: 24.0, color: Colors.red),
                      ),
                      SelectableText(
                        'Unexcepted error occured please report the bug thats halp us make this app better.',
                      ),
                      SizedBox(height: 16.0),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: double.maxFinite,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Runtime Error',
                          style: TextStyle(fontSize: 24.0, color: Colors.red),
                        ),
                        const SizedBox(height: 16.0),
                        SelectableText(
                          details.exceptionAsString(),
                        ),
                      ],
                    ),
                  ),
                ),
        );
      },
    ),
  );
}
