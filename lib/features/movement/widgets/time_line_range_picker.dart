import 'package:clams/constants/app_colors.dart';
import 'package:clams/constants/app_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:intl/intl.dart';

class MovementTimePicker extends StatefulWidget {
  const MovementTimePicker({
    super.key,
    required this.startTime,
    required this.durationHour,
    required this.onStartTimeChanged,
    required this.onDurationChanged,
  });

  final DateTime startTime;
  final int durationHour;

  final ValueChanged<DateTime> onStartTimeChanged;
  final ValueChanged<int> onDurationChanged;

  @override
  State<MovementTimePicker> createState() => _MovementTimePickerState();
}

class _MovementTimePickerState extends State<MovementTimePicker> {
  bool showTimeline = true;

  String formatTime(DateTime time) {
    return DateFormat('hh:mm a').format(time);
  }

  DateTime get endTime =>
      widget.startTime.add(Duration(hours: widget.durationHour));

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text(
              "Select Movement Time",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              "${formatTime(widget.startTime)} ➜ ${formatTime(endTime)}",
            ),
            value: showTimeline,
            activeColor: AppColors.primaryColor,
            onChanged: (value) async{
              await HapticFeedback.heavyImpact();
              setState(() {
                showTimeline = value;
              });
            },
          ),

          if (showTimeline) ...[
            Divider(),
            /// Duration Dropdown
            CustomInputCard.dropdown(
              icon: Icons.timer_outlined,
              label: "Duration",
              hintText: "Select Duration",
              selectedItem:
              "${widget.durationHour} Hour${widget.durationHour > 1 ? 's' : ''}",
              dropdownItems: const [
                "1 Hour",
                "2 Hours",
              ],
              onChanged: (value) {
                if (value == null) return;

                widget.onDurationChanged(
                  int.parse(value.split(' ').first),
                );
              },
            ),

            SizedBox(height: 20.h),

            /// Start Time
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(14.w),
              decoration: BoxDecoration(
                color: AppColors.primarySecondary.withOpacity(.2),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.play_circle_fill,
                        color: AppColors.primaryColor,
                      ),
                      SizedBox(width: 8.w),
                      const Text(
                        "Start Time",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),

                  SizedBox(height: 12.h),

                  Center(
                    child: TimePickerSpinner(
                      time: widget.startTime,
                      is24HourMode: false,
                      spacing: 40,
                      itemHeight: 50,
                      isForce2Digits: true,
                      normalTextStyle: const TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                      highlightedTextStyle: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                      ),
                      onTimeChange: (time) {
                        widget.onStartTimeChanged(time);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
