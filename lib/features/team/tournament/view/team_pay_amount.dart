import 'package:flutter/material.dart';

import 'package:next_kick/common/widgets/video_webview_page.dart';

class TeamPayAmount extends StatelessWidget {
  static const routeName = '/pay-to-register';
  final String url;
  const TeamPayAmount({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return VideoWebViewPage(url: url, title: 'Payment');
  }
}
