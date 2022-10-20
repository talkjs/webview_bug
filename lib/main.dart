import 'dart:io' show Platform;
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
    controller.loadData(data: htmlData, baseUrl: Uri.parse("https://app.talkjs.com"));
  }

  void _onLoadStop(InAppWebViewController controller, Uri? url) async {
    print('📗 _onLoadStop ($url)');

    if (url.toString() != "about:blank") {
      const js = 'await Talk.ready;';

      print('📗 _callAsyncJavaScript: $js');

      await controller.callAsyncJavaScript(functionBody: js);

      _execute(controller, 'let user_0 = new Talk.User({"id":"123456","name":"Alice","email":["alice@example.com"],"photoUrl":"https://demo.talkjs.com/img/alice.jpg","role":"default","welcomeMessage":"Hey there! How are you? :-)"});');
      _execute(controller, 'const options = {"appId":"Hku1c4Pt"};');
      _execute(controller, 'options["me"] = user_0;');
      _execute(controller, 'const session = new Talk.Session(options);');
      _execute(controller, 'chatBox = session.createChatbox({"highlightedWords":[],"messageFilter":{}});');
      _execute(controller, 'let conversation_1 = session.getOrCreateConversation("7fcfae37bf41727cd5d6")');
      _execute(controller, 'conversation_1.setParticipant(user_0, {"notify":true});');
      _execute(controller, 'let user_2 = new Talk.User({"id":"654321","name":"Sebastian","email":["Sebastian@example.com"],"photoUrl":"https://demo.talkjs.com/img/sebastian.jpg","role":"default","welcomeMessage":"Hey, how can I help?"});');
      _execute(controller, 'conversation_1.setParticipant(user_2, {});');
      _execute(controller, 'chatBox.select(conversation_1, {});');
      _execute(controller, 'chatBox.mount(document.getElementById("talkjs-container"));');
    }
  }

  void _execute(InAppWebViewController controller, String statement) {
    print('📗 _execute: $statement');

    controller.evaluateJavascript(source: statement);
  }

  @override
  Widget build(BuildContext context) {

    if (Platform.isAndroid) {
      InAppWebViewController.setWebContentsDebuggingEnabled(true);
    }

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
                onConsoleMessage: (InAppWebViewController controller, ConsoleMessage message) {
                  print("console [${message.messageLevel}] ${message.message}");
                },
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
