import 'package:boilerplate_flutter/src/features/todo/data/models/todo_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rrule/rrule.dart';

import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/assets.dart';
import '../../data/models/goal_model.dart';
import '../../data/models/user_task_interaction_model.dart';

class TodoItemView extends StatefulWidget {
  final TodoModel item;
  final Function(TodoModel) onTab;

  const TodoItemView({
    super.key,
    required this.item,
    required this.onTab,
  });

  @override
  State<TodoItemView> createState() => _TodoItemViewState();
}

class _TodoItemViewState extends State<TodoItemView> {
  var isDone = false;

  @override
  void initState() {
    super.initState();

    DateTime now = DateTime.now();
    DateTime dateWithoutTime = DateTime(now.year, now.month, now.day);

    isDone = isTaskDone3(
      recurrenceRule: RecurrenceRule.fromString(widget.item.recurrence!),
      currentDate: dateWithoutTime,
      interactions: widget.item.userTaskInteractions!,
      goalDetails: widget.item.goalDetails,
      goalType: widget.item.goalType!,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        widget.onTab(widget.item);

        // final recurrenceRule = RecurrenceRule.fromString(
        //   'RRULE:FREQ=WEEKLY;BYDAY=MO;INTERVAL=1',
        // );
        //
        // final interactions = [
        //   UserTaskInteractionModel(forDate: '2025-01-13', record: 10),
        // ];
        //
        // DateTime now = DateTime.now();
        // DateTime dateWithoutTime = DateTime(now.year, now.month, now.day);
        //
        // final isDone = isTaskDone3(
        //   recurrenceRule: recurrenceRule,
        //   currentDate: dateWithoutTime,
        //   interactions: interactions,
        // );
        //
        // print('Task is done: $isDone');
      },
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Stack(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 8.h),
                decoration: BoxDecoration(
                  color: isDone
                      ? Color(0xFF5BD97A)
                      : widget.item.goalType == 'FILE'
                          ? Color(0xFFFFD466)
                          : Color(0xFF989BFB),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.r),
                    topRight: Radius.circular(20.r),
                    bottomLeft: Radius.circular(20.r),
                    bottomRight: Radius.circular(20.r),
                  ),
                ),
                child: Stack(
                  children: [
                    if (isDone)
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20.r),
                          child: SvgPicture.asset(
                            Assets.greenTexture,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    else if (widget.item.goalType == 'FILE')
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20.r),
                          child: SvgPicture.asset(
                            Assets.yellowTexture,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    else
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20.r),
                          child: Image.asset(
                            Assets.blueTexture,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              if (isDone)
                                SvgPicture.asset(
                                  widget.item.goalType == 'FILE'
                                      ? Assets.wirdIcon
                                      : Assets.salatIcon,
                                  width: 24.w,
                                  height: 24.w,
                                  colorFilter: isDone
                                      ? ColorFilter.mode(
                                          Color(0xFF134921), BlendMode.srcIn)
                                      : null,
                                )
                              else
                                SvgPicture.asset(
                                  widget.item.goalType == 'FILE'
                                      ? Assets.wirdIcon
                                      : Assets.salatIcon,
                                  width: 24.w,
                                  height: 24.w,
                                ),
                              SizedBox(width: 12.w),
                              Text(
                                widget.item.title ?? '',
                                style: TextStyle(
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.bold,
                                  color: isDone
                                      ? Color(0xFF134921)
                                      : widget.item.goalType == 'FILE'
                                          ? Color(0xff5C4200)
                                          : AppColors.primaryColor,
                                ),
                              ),
                              Spacer(),
                              if (isDone)
                                Icon(
                                  Icons.check_rounded,
                                  size: 18.w,
                                  color: Color(0xFF134921),
                                )
                              else
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16.w,
                                  color: widget.item.goalType == 'FILE'
                                      ? Color(0xff5C4200)
                                      : AppColors.primaryColor,
                                ),
                            ],
                          ),
                          if (widget.item.desc != null &&
                              widget.item.desc!.isNotEmpty) ...[
                            SizedBox(height: 8.h),
                            Text(
                              widget.item.desc ?? '',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: isDone
                                    ? Color(0xFF134921)
                                    : AppColors.blackColor,
                              ),
                            ),
                          ]
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool isTaskDone3({
    required RecurrenceRule recurrenceRule,
    required DateTime currentDate,
    required List<UserTaskInteractionModel> interactions,
    required dynamic goalDetails,
    required String goalType,
  }) {
    final currentDateUtc = currentDate.copyWith(isUtc: true);

    if (recurrenceRule.frequency == Frequency.daily) {
      final instanceDateString = currentDate.toIso8601String().split('T').first;
      final interaction = interactions.firstWhere(
        (interaction) =>
            interaction.forDate == instanceDateString &&
            ((goalType != 'FILE' &&
                    (interaction.record ?? 0) >=
                        (goalDetails as GoalModel).counterMin!.toInt()) ||
                (goalType == 'FILE' && (interaction.record ?? 0) > 0)),
        orElse: () => UserTaskInteractionModel(forDate: ''),
      );
      if (interaction.forDate == '') {
        return false;
      } else {
        return true;
      }
    }

    if (recurrenceRule.frequency == Frequency.weekly) {
      final previousInstances = recurrenceRule.getInstances(
          start: currentDateUtc.subtract(Duration(days: 7)));

      final nextInstances = recurrenceRule.getInstances(start: currentDateUtc);

      final instanceList = nextInstances.take(1).toList();
      if (instanceList.isNotEmpty) {
        final currentRecurrence = instanceList[0];

        int daysDifference = nextInstances
            .take(1)
            .toList()[0]
            .difference(previousInstances.take(1).toList()[0])
            .inDays;

        final startOfPeriod =
            currentRecurrence.subtract(Duration(days: daysDifference));
        final endOfPeriod =
            currentRecurrence.add(const Duration(hours: 23, minutes: 59));

        for (final interaction in interactions) {
          final interactionDate = DateTime.parse(interaction.forDate!)
              .copyWith(isUtc: true)
              .add(const Duration(minutes: 1));

          if (interactionDate.isAfter(startOfPeriod) &&
              interactionDate.isBefore(endOfPeriod) &&
              ((goalType != 'FILE' &&
                      (interaction.record ?? 0) >=
                          (goalDetails as GoalModel).counterMin!.toInt()) ||
                  (goalType == 'FILE' && (interaction.record ?? 0) > 0))) {
            return true;
          }
        }
      }
    }

    if (recurrenceRule.frequency == Frequency.monthly) {
      final previousInstances = recurrenceRule.getInstances(
          start: currentDateUtc.subtract(Duration(days: 31)));

      final nextInstances = recurrenceRule.getInstances(start: currentDateUtc);

      final instanceList = nextInstances.take(1).toList();
      if (instanceList.isNotEmpty) {
        final currentRecurrence = instanceList[0];

        int daysDifference = nextInstances
            .take(1)
            .toList()[0]
            .difference(previousInstances.take(1).toList()[0])
            .inDays;

        final startOfPeriod =
            currentRecurrence.subtract(Duration(days: daysDifference));
        final endOfPeriod =
            currentRecurrence.add(const Duration(hours: 23, minutes: 59));

        for (final interaction in interactions) {
          final interactionDate = DateTime.parse(interaction.forDate!)
              .copyWith(isUtc: true)
              .add(const Duration(minutes: 1));

          if (interactionDate.isAfter(startOfPeriod) &&
              interactionDate.isBefore(endOfPeriod) &&
              ((goalType != 'FILE' &&
                      (interaction.record ?? 0) >=
                          (goalDetails as GoalModel).counterMin!.toInt()) ||
                  (goalType == 'FILE' && (interaction.record ?? 0) > 0))) {
            return true;
          }
        }
      }
    }
    if (recurrenceRule.frequency == Frequency.yearly) {
      final previousInstances = recurrenceRule.getInstances(
          start: currentDateUtc.subtract(Duration(days: 366)));

      final nextInstances = recurrenceRule.getInstances(start: currentDateUtc);

      final instanceList = nextInstances.take(1).toList();
      if (instanceList.isNotEmpty) {
        final currentRecurrence = instanceList[0];

        int daysDifference = nextInstances
            .take(1)
            .toList()[0]
            .difference(previousInstances.take(1).toList()[0])
            .inDays;

        final startOfPeriod =
            currentRecurrence.subtract(Duration(days: daysDifference));
        final endOfPeriod =
            currentRecurrence.add(const Duration(hours: 23, minutes: 59));

        for (final interaction in interactions) {
          final interactionDate = DateTime.parse(interaction.forDate!)
              .copyWith(isUtc: true)
              .add(const Duration(minutes: 1));

          if (interactionDate.isAfter(startOfPeriod) &&
              interactionDate.isBefore(endOfPeriod) &&
              ((goalType != 'FILE' &&
                      (interaction.record ?? 0) >=
                          (goalDetails as GoalModel).counterMin!.toInt()) ||
                  (goalType == 'FILE' && (interaction.record ?? 0) > 0))) {
            return true;
          }
        }
      }
    }

    return false;
  }
}
