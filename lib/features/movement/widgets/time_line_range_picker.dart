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

class _MovementTimePickerState extends State<MovementTimePicker>
    with SingleTickerProviderStateMixin {
  bool showTimeline = true;

  late final AnimationController _borderController;

  @override
  void initState() {
    super.initState();

    _borderController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _borderController.dispose();
    super.dispose();
  }

  String formatTime(DateTime time) {
    return DateFormat('hh:mm a').format(time);
  }

  DateTime get endTime =>
      widget.startTime.add(Duration(hours: widget.durationHour));

  Future<void> _pickTime() async {
    await HapticFeedback.mediumImpact();

    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(widget.startTime),
    );

    if (picked != null) {
      widget.onStartTimeChanged(
        DateTime(
          widget.startTime.year,
          widget.startTime.month,
          widget.startTime.day,
          picked.hour,
          picked.minute,
        ),
      );
    }
  }

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
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              "${formatTime(widget.startTime)} ➜ ${formatTime(endTime)}",
            ),
            value: showTimeline,
            activeColor: AppColors.primaryColor,
            onChanged: (value) async {
              await HapticFeedback.heavyImpact();

              setState(() {
                showTimeline = value;
              });
            },
          ),

          if (showTimeline) ...[
            const Divider(),

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

            Container(
              width: double.infinity,
              padding: EdgeInsets.all(14.w),
              decoration: BoxDecoration(
                color: AppColors.primarySecondary.withOpacity(.2),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.play_circle_fill,
                    color: AppColors.primaryColor,
                  ),
                  SizedBox(width: 8.w),
                  const Expanded(
                    child: Text(
                      "Start Time",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  AnimatedBuilder(
                    animation: _borderController,
                    builder: (context, child) {
                      return Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: SweepGradient(
                            startAngle: 0,
                            endAngle: 2 * 3.1415926535,
                            transform: GradientRotation(
                              _borderController.value * 2 * 3.1415926535,
                            ),
                            colors: const [
                              AppColors.primaryColor,
                              Colors.transparent,
                              AppColors.primaryColor,
                            ],
                          ),
                        ),
                        child: child,
                      );
                    },
                    child: Material(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: _pickTime,
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 12,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.schedule,
                                color: AppColors.primaryColor,
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Text(
                                "Pick Time",
                                style: TextStyle(
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}