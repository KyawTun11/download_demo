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
          actions: [
            IconButton(
                onPressed: () {
                  controller.addUrl(
                      "https://test-videos.co.uk/vids/bigbuckbunny/mp4/h264/1080/Big_Buck_Bunny_1080_10s_30MB.mp4");
                },
                icon: const Icon(Icons.add)),
            IconButton(
                onPressed: () {
                 // controller.reload();
                },
                icon: const Icon(Icons.refresh))
          ],
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
              SizedBox(height: 20),
              ListView.builder(
                shrinkWrap: true,
                  itemCount: controller.tasks.length,
                  itemBuilder: (context, index) {
                    return Row(
                      children: [
                        IconButton(
                          onPressed: () {
                          },
                          icon: const Icon(Icons.delete),),
                        DownloadActionButton(
                          tasks: controller.tasks[index],
                        ),
                      ],
                    );
                  }),
            ],
          ),
        ),
      );
    });
  }
}
