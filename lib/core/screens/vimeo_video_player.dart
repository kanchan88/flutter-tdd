import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'dart:ui' as ui;


class VimeoVideoPlayer extends StatelessWidget {

  final String viewID;

  const VimeoVideoPlayer({Key? key, required this.viewID}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
        viewID,
            (int id) => html.IFrameElement()
          ..width = MediaQuery.of(context).size.width.toString()
          ..height = MediaQuery.of(context).size.height.toString()
          ..src = 'https://player.vimeo.com/video/$viewID&autoplay=1&title=0&byline=0&playsinline=0'
          ..style.border = 'none');

    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: HtmlElementView(
        viewType: viewID,
      ),
    );
  }
}
