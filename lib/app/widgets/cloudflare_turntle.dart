// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class CloudFlareTurntiles extends StatefulWidget {
  final CloudflareTurnstileController? controller;
  const CloudFlareTurntiles({this.controller, super.key});

  @override
  State<CloudFlareTurntiles> createState() => _CloudFlareTurntilesState();
}

class _CloudFlareTurntilesState extends State<CloudFlareTurntiles> {
  InAppWebViewSettings options = InAppWebViewSettings(
    transparentBackground: true,
    disableHorizontalScroll: true,
    disableVerticalScroll: true,
    useHybridComposition: true,
    useShouldInterceptRequest: true,
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.shrink(
      child: InAppWebView(
        initialData: InAppWebViewInitialData(
          baseUrl: WebUri('http://localhost:8080/'),
          data: _data(siteKey: '0x4AAAAAAAXtCJcLXiSpwwcT', theme: 'dark'),
        ),
        initialSettings: options,
        onWebViewCreated: (controller) {
          controller.addJavaScriptHandler(
            handlerName: 'TurntlesToken',
            callback: (args) {
              if (widget.controller != null) {
                widget.controller?.setToken = args.first;
              }
            },
          );
        },
        onConsoleMessage: (_, __) {},
      ),
    );
  }
}

String _data({
  required String siteKey,
  String? theme = 'auto',
}) =>
    """
<!DOCTYPE html>
<html lang="en">
   <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
      <script src="https://challenges.cloudflare.com/turnstile/v0/api.js?onload=onloadTurnstileCallback" defer></script>
   </head>
   <script>
      window.onloadTurnstileCallback = function () {
           turnstile.render('#example-container', {
               sitekey: '${siteKey}',
               theme: '${theme}',
               callback: function(token) {
                  window.flutter_inappwebview.callHandler('TurntlesToken', token);
               },
           });
       };
       console.log(window.location.href);
   </script>
   <style>
      * {
      overflow: hidden;
      margin: 0;
      padding: 0; 
      }
   </style>
   <body>
      <div id="example-container"></div>
   </body>
</html>
""";

class CloudflareTurnstileController {
  String? _token;

  String? get token => _token;

  set setToken(token) => _token = token;

  Future<void> refresh() async {}

  Future<String> getToken() async {
    Future.delayed(const Duration(seconds: 16)).then(
      (value) => throw Exception('Failed to get token.'),
    );
    //pool util new token release
    await Future.doWhile(() => _token == null);
    return _token!;
  }
}
