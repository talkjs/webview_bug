import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: ChatHomeExample(),
      ),
    );
  }
}

class ChatHomeExample extends StatelessWidget {
  const ChatHomeExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          showModalBottomSheet(
            enableDrag: true,
            context: context,
            isScrollControlled: false,
            builder: (_) => const WebViewCustomPage(),
          );
        },
        child: const Text('Open modal bottom sheet'),
      ),
    );
  }
}

class WebViewCustomPage extends StatelessWidget {
  const WebViewCustomPage({
    Key? key,
  }) : super(key: key);

  void _onWebViewCreated(InAppWebViewController controller) async {
    print('📗 _onWebViewCreated');

    String htmlData = await rootBundle.loadString('packages/webview_bug/assets/index.html');
    controller.loadData(data: htmlData, baseUrl: Uri.parse("https://google.com"));
  }

  void _onLoadStop(InAppWebViewController controller, Uri? url) async {
    print('📗 _onLoadStop ($url)');
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Column(
          children: [
            const SizedBox(height: 100),
            Expanded(
              child: InAppWebView(
                initialUrlRequest: URLRequest(url: null),
                onWebViewCreated: _onWebViewCreated,
                onLoadStop: _onLoadStop,
              ),
            ),
          ],
        ),
        ElevatedButton(
            onPressed: () {
              print('On Pressed capture');
            },
            child: const Text('Over the webView'))
      ],
    );
  }
}
