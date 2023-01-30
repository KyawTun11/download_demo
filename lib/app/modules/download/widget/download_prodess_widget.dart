import 'package:flutter/material.dart';

class DownloadProgressWidget extends StatelessWidget {
  DownloadProgressWidget({
    Key? key,
    required this.percent,
    required this.speed,
    required this.progressValue,
    required this.visible,
  }) : super(key: key);
  String percent;
  String speed;
  double progressValue;
  bool visible;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visible,
      child: Padding(
        padding:  EdgeInsets.only(top: 8,bottom: 8),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(percent),
                Text(speed),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              minHeight: 12,
              value: progressValue,
            ),
          ],
        ),
      ),
    );
  }
}
