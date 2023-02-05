import 'dart:isolate';
import 'dart:ui';
import 'package:download_demo/app/model/model.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadController extends GetxController {
  final count = 0.obs;
  var startDownload = false.obs;
  var progress = 0.0.obs;
  ReceivePort receivePort = ReceivePort();
  var downloadStatus = DownloadTaskStatus.undefined.obs;

  //var taskId = "".obs;
  String path = "";
  String? fileName = "downloader";
  final storage = GetStorage();

  //late List<DownloadTask> tasks = [].obs;
  //var tasks = DownloadTask ;
  RxList<DownloadTask> tasks = <DownloadTask>[].obs;
  //RxMap<String, int> progressTasks = <String, int>{}.obs;

  @override
  void onInit() async {
    Permission.storage.request();
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
    tasks.value = (await FlutterDownloader.loadTasks())!;
    update();
  }

  static void downloadCallback(id, status, progress) {
    SendPort? send = IsolateNameServer.lookupPortByName('downloader_send_port');
    send?.send([id, status, progress]);
  }

  // void addNewProgress(String id, int progress) {
  //   Map<String, int> oldValue = {};
  //   for (String key in progressTasks.keys) {
  //     if (progressTasks[key] != null) {
  //       oldValue[key] = progressTasks[key]!;
  //     }
  //   }
  //   oldValue[id] = progress;
  //
  //   progressTasks.value = oldValue;
  // }

  addUrl(String url) async {
    startDownload.value = true;
    downloadStatus.value = DownloadTaskStatus.running;
    final baseStorage = await getExternalStorageDirectory();
    if(baseStorage == null) {
      return;
    }
    var path = baseStorage.path;
    DateTime now = DateTime.now();
    var newTaskId = await FlutterDownloader.enqueue(
        url: url,
        savedDir: path,
        fileName: 'Sample${now.millisecondsSinceEpoch}.mp4');
    var newTasks = await FlutterDownloader.loadTasksWithRawQuery(
        query: "SELECT * FROM task where task_id = '$newTaskId'");
    if (newTasks != null && newTasks.isNotEmpty) {
      tasks.add(newTasks.first);
    }
    update();
  }

  downloadFile(String url) async {
    startDownload.value = true;
    downloadStatus.value = DownloadTaskStatus.running;
    final status = await Permission.storage.request();
    DateTime now = DateTime.now();

    if (status.isGranted) {
      final baseStorage =
          await getExternalStorageDirectories(type: StorageDirectory.downloads);
      path = baseStorage!.first.path;
      var newTaskId = await FlutterDownloader.enqueue(
        url: url,
        headers: {},
        showNotification: true,
        openFileFromNotification: true,
        saveInPublicStorage: true,
        savedDir: path,
        //fileName: fileName,
        fileName: 'Sample${now.millisecondsSinceEpoch}.mp4',
      );
      // .then((value) => taskId.value = value!);
      var newTasks = await FlutterDownloader.loadTasksWithRawQuery(
          query: "SELECT * FROM task where task_id = '$newTaskId'");
      if (newTasks != null && newTasks.isNotEmpty) {
        tasks.add(newTasks.first);
      }
    } else {
      print("No Permission");
    }
    update();
  }

  pauseDownload(String? task) async {
    downloadStatus.value = DownloadTaskStatus.paused;
    await FlutterDownloader.pause(taskId: task!);
    update();
  }

  resumeDownload(String? task) async {
    downloadStatus.value = DownloadTaskStatus.paused;
    await FlutterDownloader.resume(taskId: task!);
    update();
  }

  retryDownload(String? task) async {
    downloadStatus.value = DownloadTaskStatus.canceled;
    String? newTaskId = await FlutterDownloader.retry(taskId: task!);
    //taskId.value = newTaskId!;
    update();
  }

  delete(String? task) async {
    downloadStatus.value = DownloadTaskStatus.complete;
    await FlutterDownloader.remove(taskId: task!, shouldDeleteContent: true);
    startDownload.value = false;
    update();
  }

  reload() async {
    var loaded = await FlutterDownloader.loadTasks();
    if (loaded != null) {
      tasks.clear();
      tasks.addAll(loaded);
    } else {
      tasks.clear();
    }
  }

  void increment() => count.value++;
}
