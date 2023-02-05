import 'package:download_demo/app/modules/download/controllers/download_controller.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class DownloadItemsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<DownloadController>(builder: (controller) {
      var tasks = controller.tasks;
      return Scaffold(
        appBar: AppBar(
          title: const Text('DownloadItemsView'),
          centerTitle: true,
        ),
        body: tasks == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
                return ListTile(
                    title: Text(
                      tasks[index].filename.toString(),
                    ),
                  );
                }),
      );
    });
  }
}
