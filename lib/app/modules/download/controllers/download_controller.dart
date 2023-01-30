import 'dart:isolate';
import 'dart:ui';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadController extends GetxController {
  final downloadAction = [
    {DownloadTaskStatus.undefined: "Download"},
    {DownloadTaskStatus.running: "Paused"},
  ];

  final count = 0.obs;
  var startDownload = false.obs;
  var progress = 0.0.obs;
  ReceivePort receivePort = ReceivePort();
  var downloadStatus = DownloadTaskStatus.undefined.obs;
  var taskId = "".obs;

  late List<DownloadTask> tasks;

  @override
  void onInit() async {
    await FlutterDownloader.registerCallback(downloadCallback);
    IsolateNameServer.registerPortWithName(
        receivePort.sendPort, "downloader_send_port");
    receivePort.listen((dynamic data) {
      int progressValue = data[2];
      progress.value = progressValue.toDouble();
      update();
    });

    super.onInit();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  loadTasks() async {
    tasks = (await FlutterDownloader.loadTasks())!;
    update();
  }

  static void downloadCallback(id, status, progress) {
    SendPort? send = IsolateNameServer.lookupPortByName('downloader_send_port');
    send?.send([id, status, progress]);
  }

  downloadFile(String url) async {
    startDownload.value = true;
    downloadStatus.value = DownloadTaskStatus.running;
    final status = await Permission.storage.request();
    DateTime now = DateTime.now();
    if (status.isGranted) {
      String path = "";
      final baseStorage =
          await getExternalStorageDirectories(type: StorageDirectory.downloads);
      path = baseStorage!.first.path;
      await FlutterDownloader.enqueue(
              url: url,
              showNotification: true,
              openFileFromNotification: true,
              saveInPublicStorage: true,
              savedDir: path,
              fileName: 'Sample${now.millisecondsSinceEpoch}.mp4')
          .then((value) => taskId.value = value!);
    } else {
      print("No Permission");
    }
    update();
  }

  pauseDownload(String? task) async {
    print("Pause Downlaod");
    downloadStatus.value = DownloadTaskStatus.paused;
    await FlutterDownloader.pause(taskId: task!);
  }

  resumeDownload(String? task) async {
    downloadStatus.value = DownloadTaskStatus.paused;
    print("Resume Downlaod");
    await FlutterDownloader.resume(taskId: task!);
    update();
  }

  retryDownload(String? task) async {
    downloadStatus.value = DownloadTaskStatus.canceled;
    String? newTaskId = await FlutterDownloader.retry(taskId: task!);
    taskId.value = newTaskId!;
    update();
  }

  delete(String? task) async {
    downloadStatus.value = DownloadTaskStatus.failed;
    await FlutterDownloader.remove(taskId: task!, shouldDeleteContent: true);
    update();
  }

  void increment() => count.value++;
}
