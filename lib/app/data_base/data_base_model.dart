import 'package:download_demo/app/data_base/daa_base_helper.dart';

class MoviesDownload {
  String taskId;
  double progress;
  MoviesDownload({
    required this.taskId,
    required this.progress
});

  Map toJson() => {
    'taskId': taskId,
    'progress': progress,
  };

  MoviesDownload.fromJson(Map<String, dynamic> json)
      : taskId = json['taskId'],
        progress = json['progress'];
}
