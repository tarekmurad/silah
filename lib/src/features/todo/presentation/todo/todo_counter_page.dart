import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:boilerplate_flutter/src/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:rrule/rrule.dart';

import '../../../../core/navigation/app_router.dart';
import '../../../../core/shared_components/widgets/button_widget.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/assets.dart';
import '../../data/models/goal_folder_model.dart';
import '../../data/models/goal_model.dart';
import '../../data/models/todo_model.dart';
import '../../data/models/user_task_interaction_model.dart';
import 'bloc/bloc.dart';

@RoutePage()
class TodoCounterPage extends StatefulWidget {
  final TodoModel todo;

  const TodoCounterPage({Key? key, required this.todo}) : super(key: key);

  @override
  _TodoCounterPageState createState() => _TodoCounterPageState();
}

class _TodoCounterPageState extends State<TodoCounterPage> {
  late TodoBloc _bloc;
  late GlobalKey _scaffoldKey;
  int _currentValue = 100;
  String recurrence = '';
  UserTaskInteractionModel? userTaskInteractionModel;

  @override
  void initState() {
    super.initState();

    _bloc = getIt<TodoBloc>();
    _scaffoldKey = GlobalKey<ScaffoldState>();

    DateTime now = DateTime.now();
    DateTime dateWithoutTime = DateTime(now.year, now.month, now.day);

    userTaskInteractionModel = getRecord(
      recurrenceRule: RecurrenceRule.fromString(widget.todo.recurrence!),
      currentDate: dateWithoutTime,
      interactions: widget.todo.userTaskInteractions!,
      goalDetails: widget.todo.goalDetails,
      goalType: widget.todo.goalType!,
    );

    if (userTaskInteractionModel != null) {
      _currentValue = userTaskInteractionModel!.record!;
    }

    _initializeGetRecurrence();
  }

  Future<void> _initializeGetRecurrence() async {
    final result = await getRecurrence(widget.todo.recurrence!);

    setState(() {
      recurrence = result.toString();
    });
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  // return PopScope(
  // canPop: false,
  // onPopInvokedWithResult: (didPop, result) async {
  // context.router.maybePop(true);
  // },

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        top: false,
        bottom: false,
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 105.h,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(0),
                      topRight: Radius.circular(0),
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: SvgPicture.asset(
                    Assets.background,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              SizedBox(width: 20.w),
                              SizedBox(
                                width: 18.w,
                                height: 18.w,
                                child: GestureDetector(
                                  onTap: () {
                                    context.router.maybePop();
                                  },
                                  child: Icon(
                                    Icons.arrow_back_ios,
                                    color: AppColors.whiteColor,
                                    size: 18.w,
                                  ),
                                ),
                              )
                            ],
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                "To Do List",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                      color: AppColors.whiteColor,
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ),
                          ),
                          SizedBox(width: 38.w),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10.h,
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(20.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    widget.todo.goalType == 'FILE'
                                        ? Assets.wirdBlueIcon
                                        : Assets.salatIcon,
                                    width: 36.w,
                                    height: 36.w,
                                  ),
                                  SizedBox(width: 12.w),
                                  Text(
                                    widget.todo.title ?? '',
                                    style: TextStyle(
                                      fontSize: 30.sp,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                              if (widget.todo.desc != null &&
                                  widget.todo.desc!.isNotEmpty) ...[
                                SizedBox(height: 16.h),
                                Text(
                                  widget.todo.desc ?? '',
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    color: AppColors.blackColor,
                                  ),
                                ),
                              ],
                              SizedBox(height: 16.h),
                              RichText(
                                text: TextSpan(
                                  text: 'Recurrence: ',
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: '$recurrence.',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: AppColors.blackColor,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (widget.todo.goalType != 'FILE') ...[
                                SizedBox(height: 10.h),
                                RichText(
                                  text: TextSpan(
                                    text: 'The target: ',
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      color: AppColors.primaryColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    children: [
                                      TextSpan(
                                        text:
                                            '${(widget.todo.goalDetails as GoalModel).counterGoal}',
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          color: AppColors.blackColor,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10.h),
                                RichText(
                                  text: TextSpan(
                                    text: 'Minimum amount: ',
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      color: AppColors.primaryColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    children: [
                                      TextSpan(
                                        text:
                                            '${(widget.todo.goalDetails as GoalModel).counterMin}',
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          color: AppColors.blackColor,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                              if (userTaskInteractionModel != null) ...[
                                SizedBox(height: 10.h),
                                if (userTaskInteractionModel!.record == 1)
                                  Text(
                                    '- You have complete the tasks.',
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      color: AppColors.greenColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )
                                else
                                  RichText(
                                    text: TextSpan(
                                      text: 'Your amount: ',
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        color: AppColors.greenColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      children: [
                                        TextSpan(
                                          text:
                                              '${userTaskInteractionModel!.record}',
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            color: AppColors.blackColor,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ],
                          ),
                        ),
                        const Spacer(),
                        if (widget.todo.goalType == 'FILE')
                          Container(
                            width: double.infinity,
                            color: Colors.white,
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ButtonWidget(
                                    onPressed: () {
                                      switch ((widget.todo.goalDetails
                                              as GoalFolderModel)
                                          .folder
                                          ?.type) {
                                        case 'VIDEO':
                                          context.router.push(
                                            VideoPlayerRoute(
                                              file: (widget.todo.goalDetails
                                                      as GoalFolderModel)
                                                  .folder!,
                                            ),
                                          );

                                        case 'AUDIO':
                                          context.router.push(
                                            AudioPlayerRoute(
                                              file: (widget.todo.goalDetails
                                                      as GoalFolderModel)
                                                  .folder!,
                                            ),
                                          );

                                        case 'PDF':
                                          context.router.push(
                                            PdfViewerRoute(
                                              file: (widget.todo.goalDetails
                                                      as GoalFolderModel)
                                                  .folder!,
                                            ),
                                          );
                                      }
                                    },
                                    labelText: "Do It Now",
                                    color: AppColors.primaryColor,
                                    labelColor: AppColors.whiteColor,
                                  ),
                                  SizedBox(
                                    height: 16.h,
                                  ),
                                  if (userTaskInteractionModel == null) ...[
                                    BlocListener<TodoBloc, TodoState>(
                                      bloc: _bloc,
                                      listener: (contexta, state) async {
                                        if (state
                                            is InteractionTodoSucceedState) {
                                          // showSnackBar(
                                          //   contexta,
                                          //   'Task is updated successfully',
                                          //   AppColors.greenColor,
                                          // );

                                          context.router.maybePop(true);

                                          // Future.delayed(
                                          //     const Duration(milliseconds: 2000),
                                          //     () {
                                          //       print('ddd');
                                          //   context.router.maybePop(true);
                                          //       print('dggdd');
                                          //
                                          // });
                                        }
                                      },
                                      child: BlocBuilder<TodoBloc, TodoState>(
                                        bloc: _bloc,
                                        buildWhen: (previous, current) {
                                          if (current is InteractionTodoLoadingState ||
                                              current
                                                  is InteractionTodoSucceedState ||
                                              current
                                                  is InteractionTodoFailedState) {
                                            return true;
                                          } else {
                                            return false;
                                          }
                                        },
                                        builder: (context, state) {
                                          return ButtonWidget(
                                            onPressed: () async {
                                              String forDate =
                                                  await handleTaskCompletion(
                                                      widget.todo.recurrence!,
                                                      DateTime.now().toUtc());

                                              _bloc.add(InteractionTodo(
                                                  taskId: widget.todo.id!,
                                                  forDate: forDate,
                                                  record: 1));
                                            },
                                            labelText: "Completed Already",
                                            color: AppColors.whiteColor,
                                            labelColor: AppColors.primaryColor,
                                            loading: state
                                                is InteractionTodoLoadingState,
                                            borderColor: AppColors.primaryColor,
                                          );
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      height: 30.h,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          )
                        else
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(16.0),
                                topRight: Radius.circular(16.0),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  offset: Offset(0, -2),
                                  blurRadius: 6,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Choose amount",
                                    style: TextStyle(
                                      fontSize: 22.sp,
                                      color: AppColors.primaryColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 4.h,
                                  ),
                                  Text(
                                    "Select the amount of zikr you have completed",
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: AppColors.blackColor,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 24.h,
                                  ),
                                  Center(
                                    child: NumberPicker(
                                      value: _currentValue,
                                      minValue: 100,
                                      maxValue: 5000,
                                      step: 50,
                                      itemCount: 5,
                                      haptics: true,
                                      onChanged: (value) => setState(() {
                                        _currentValue = value;
                                      }),
                                      axis: Axis.horizontal,
                                      selectedTextStyle: TextStyle(
                                        fontSize: 24.sp,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primaryColor,
                                      ),
                                      textStyle: TextStyle(
                                        fontSize: 16.sp,
                                        color: AppColors.primary300Color,
                                      ),
                                      itemHeight: 60.h,
                                      itemWidth: 65.w,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 16.h,
                                  ),
                                  BlocListener<TodoBloc, TodoState>(
                                    bloc: _bloc,
                                    listener: (contexta, state) async {
                                      if (state
                                          is InteractionTodoSucceedState) {
                                        // showSnackBar(
                                        //   contexta,
                                        //   'Task is updated successfully',
                                        //   AppColors.greenColor,
                                        // );

                                        context.router.maybePop(true);

                                        // Future.delayed(
                                        //     const Duration(milliseconds: 2000),
                                        //     () {
                                        //       print('ddd');
                                        //   context.router.maybePop(true);
                                        //       print('dggdd');
                                        //
                                        // });
                                      }
                                    },
                                    child: BlocBuilder<TodoBloc, TodoState>(
                                      bloc: _bloc,
                                      buildWhen: (previous, current) {
                                        if (current is InteractionTodoLoadingState ||
                                            current
                                                is InteractionTodoSucceedState ||
                                            current
                                                is InteractionTodoFailedState) {
                                          return true;
                                        } else {
                                          return false;
                                        }
                                      },
                                      builder: (context, state) {
                                        return ButtonWidget(
                                          onPressed: () async {
                                            String forDate =
                                                await handleTaskCompletion(
                                                    widget.todo.recurrence!,
                                                    DateTime.now().toUtc());

                                            _bloc.add(InteractionTodo(
                                                taskId: widget.todo.id!,
                                                forDate: forDate,
                                                record: _currentValue));
                                          },
                                          labelText: "Save Changes",
                                          color: AppColors.primaryColor,
                                          loading: state
                                              is InteractionTodoLoadingState,
                                          labelColor: AppColors.whiteColor,
                                        );
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    height: 30.h,
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> getRecurrence(String rruleString) async {
    // Parse the recurrence rule
    final rrule = RecurrenceRule.fromString(rruleString);

    // Generate localized text (Optional)
    final l10n = await RruleL10nEn.create();
    print("Recurrence rule description: ${rrule.toText(l10n: l10n)}");
    return rrule.toText(l10n: l10n);
  }

  Future<String> handleTaskCompletion(
      String rruleString, DateTime currentDate) async {
    // Parse the recurrence rule
    final rrule = RecurrenceRule.fromString(rruleString);

    // Generate localized text (Optional)
    final l10n = await RruleL10nEn.create();
    print("Recurrence rule description: ${rrule.toText(l10n: l10n)}");

    // Calculate the next occurrences starting from the current date
    final instances = rrule.getInstances(start: currentDate).takeWhile(
        (instance) => instance.isBefore(currentDate.add(Duration(days: 365))));

    // Find the next relevant date
    if (instances.isNotEmpty) {
      final nextOccurrence = instances.first;

      // Format the date for display or API
      final formattedDate = DateFormat('yyyy-MM-dd').format(nextOccurrence);

      print("Task is done for the date: $formattedDate");
      return formattedDate;
    } else {
      print("No occurrences found for the given rule.");
      return "";
    }
  }

  UserTaskInteractionModel? getRecord({
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
        return null;
      } else {
        return interaction;
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
            return interaction;
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
            return interaction;
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
            return interaction;
          }
        }
      }
    }

    return null;
  }
}
