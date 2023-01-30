import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/download_controller.dart';
import '../widget/download_action_button_widget.dart';
import '../widget/download_prodess_widget.dart';

class DownloadView extends StatelessWidget {
  const DownloadView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DownloadController>(builder: (controller) {
      String url =
          "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4";
      return Scaffold(
        appBar: AppBar(
          title: const Text('DownloadView'),
          centerTitle: true,
        ),
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: [
              const Text("Big Buck Bunny"),
              DownloadProgressWidget(
                visible: controller.startDownload.value,
                percent: '${controller.progress.value}%',
                speed: '19mb/16m',
                progressValue: controller.progress.value / 100,
              ),
              const DownloadActionButton(),
            ],
          ),
        ),
      );
    });
  }
}
