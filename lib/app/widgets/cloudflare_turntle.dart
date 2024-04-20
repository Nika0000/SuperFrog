import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class CloudFlareTurntiles extends StatefulWidget {
  const CloudFlareTurntiles({super.key});

  @override
  State<CloudFlareTurntiles> createState() => _CloudFlareTurntilesState();
}

class _CloudFlareTurntilesState extends State<CloudFlareTurntiles> {
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
    crossPlatform: InAppWebViewOptions(
      transparentBackground: true,
      disableHorizontalScroll: true,
      disableVerticalScroll: true,
    ),
    android: AndroidInAppWebViewOptions(useHybridComposition: true),
  );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 65,
      child: InAppWebView(
        initialData: InAppWebViewInitialData(
          baseUrl: Uri.parse('http://localhost:8000/'),
          data: _data(siteKey: '0x4AAAAAAAXtCJcLXiSpwwcT', theme: 'dark'),
        ),
        initialOptions: options,
        onWebViewCreated: (controller) {
          controller.addJavaScriptHandler(
            handlerName: 'TurntlesToken',
            callback: (args) {
              print(args[0]);
            },
          );
        },
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
