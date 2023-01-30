import 'package:download_demo/app/modules/download/controllers/download_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'button_widget.dart';

class DownloadActionButton extends StatelessWidget {
  const DownloadActionButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DownloadController>(builder: (controller) {
      String url =
          "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4";
      if (controller.downloadStatus.value == DownloadTaskStatus.undefined) {
        return ButtonWidget(
          title: 'Download',
          icon: Icons.download,
          onPressed: () => controller.downloadFile(url),
        );
      } else if (controller.downloadStatus.value ==
          DownloadTaskStatus.running) {
        return ButtonWidget(
          title: 'Paused',
          icon: Icons.pause,
          onPressed: () => controller.pauseDownload(controller.taskId.value),
        );
      } else if (controller.downloadStatus.value == DownloadTaskStatus.paused) {
        return ButtonWidget(
          title: 'Resume',
          icon: Icons.play_arrow,
          onPressed: () => controller.resumeDownload(controller.taskId.value),
        );
      } else if (controller.downloadStatus.value == DownloadTaskStatus.failed) {
        return ButtonWidget(
          title: 'Retry',
          icon: Icons.refresh,
          onPressed: () => controller.retryDownload(controller.taskId.value),
        );
      } else if (controller.downloadStatus.value ==
          DownloadTaskStatus.complete) {
        return ButtonWidget(
          title: 'Complete',
          icon: Icons.check,
          onPressed: () {},
        );
      }
      return const Text("Error");
    });
  }
}
