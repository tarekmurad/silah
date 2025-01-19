import 'package:auto_route/auto_route.dart';
import 'package:boilerplate_flutter/src/injection_container.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import '../../../../core/navigation/app_router.dart';
import '../../../../core/shared_components/widgets/custom_loader.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/assets.dart';
import '../../data/models/todo_model.dart';
import '../widgets/todo_item_view.dart';
import 'bloc/bloc.dart';

@RoutePage()
class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  _TodoPageState createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  late TodoBloc _bloc;
  late GlobalKey _scaffoldKey;

  @override
  void initState() {
    super.initState();

    _bloc = getIt<TodoBloc>();
    _scaffoldKey = GlobalKey<ScaffoldState>();

    _bloc.add(GetTodoList());
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 227.h,
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
                SizedBox(
                  height: 227.h,
                  width: double.infinity,
                  child: SvgPicture.asset(
                    Assets.background,
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  height: 227.h,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0x0004075F),
                        Color(0x1104075F),
                        Color(0xdd04075F)
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(0),
                      topRight: Radius.circular(0),
                      bottomLeft: Radius.circular(20.r),
                      bottomRight: Radius.circular(20.r),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -15,
                  left: 0,
                  right: 0,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Center(
                        child: Text(
                          "To Do List",
                          style:
                              Theme.of(context).textTheme.titleLarge!.copyWith(
                                    color: AppColors.whiteColor,
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                      ),
                      SizedBox(
                        height: 25.h,
                      ),
                      EasyDateTimeLinePicker.itemBuilder(
                        firstDate: DateTime.now().subtract(Duration(days: 3)),
                        lastDate: DateTime.now().add(Duration(days: 26)),
                        focusedDate: DateTime.now(),
                        timelineOptions: TimelineOptions(),
                        monthYearPickerOptions: MonthYearPickerOptions(),
                        headerOptions: HeaderOptions(
                            headerType: HeaderType.viewOnly,
                            headerBuilder: (
                              BuildContext context,
                              DateTime date,
                              VoidCallback onTap,
                            ) {
                              return Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20.w),
                                child: Text(
                                  '${DateFormat('MMMM').format(date).toUpperCase()} ${date.day}${getDaySuffix(date.day)}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(
                                        color: AppColors.whiteColor,
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              );
                            }),
                        itemExtent: 40.w,
                        itemBuilder: (context, date, isSelected, isDisabled,
                            isToday, onTap) {
                          return InkResponse(
                            onTap: onTap,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 15.h,
                                ),
                                Text(
                                  DateFormat('EEE')
                                      .format(date)
                                      .substring(0, 2)
                                      .toUpperCase(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(
                                        color: isToday
                                            ? Color(0xffFFD466)
                                            : AppColors.primary300Color,
                                        fontSize: 15.sp,
                                        fontWeight: isToday
                                            ? FontWeight.w600
                                            : FontWeight.w400,
                                      ),
                                ),
                                SizedBox(
                                  height: 5.h,
                                ),
                                Text(
                                  date.day.toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(
                                        color: isToday
                                            ? Color(0xffFFD466)
                                            : AppColors.primary300Color,
                                        fontSize: 15.sp,
                                        fontWeight: isToday
                                            ? FontWeight.w600
                                            : FontWeight.w400,
                                      ),
                                ),
                              ],
                            ),
                          );
                        },
                        onDateChange: (date) {
                          // setState(() {
                          //   _selectedDate = date;
                          // });
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BlocBuilder<TodoBloc, TodoState>(
                    bloc: _bloc,
                    builder: (context, state) {
                      if (state is GetTodoListLoadingState) {
                        return Expanded(
                          child: Center(
                            child: CustomLoader(
                              color: AppColors.primaryColor,
                              size: 30.w,
                            ),
                          ),
                        );
                      } else if (state is GetTodoListSucceedState) {
                        return Expanded(
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  if (state.dailyTasks.isNotEmpty) ...[
                                    SizedBox(
                                      height: 10.h,
                                    ),
                                    Text(
                                      "Today’s tasks",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .copyWith(
                                            color: AppColors.primaryColor,
                                            fontSize: 20.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                    SizedBox(
                                      height: 10.h,
                                    ),
                                    ListView.builder(
                                      itemCount: state.dailyTasks.length,
                                      shrinkWrap: true,
                                      padding: EdgeInsets.zero,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        final item = state.dailyTasks[index];
                                        return TodoItemView(
                                          item: item,
                                          onTab: (TodoModel item) async {
                                            final bool? result = await context
                                                .router
                                                .push(TodoCounterRoute(
                                                    todo: item));

                                            if (result != null) {
                                              if (result) {
                                                // Trigger your desired action if `true` is returned
                                                print('Todo was updated.');
                                                _bloc.add(GetTodoList());
                                              } else {
                                                // Handle `false` return value
                                                print('Todo was not updated.');
                                              }
                                            } else {
                                              // Handle the case where no value was returned
                                              print('No value returned.');
                                            }
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                  if (state.weeklyTasks.isNotEmpty) ...[
                                    SizedBox(
                                      height: 10.h,
                                    ),
                                    Text(
                                      "Weekly tasks",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .copyWith(
                                            color: AppColors.primaryColor,
                                            fontSize: 20.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                    SizedBox(
                                      height: 10.h,
                                    ),
                                    ListView.builder(
                                      itemCount: state.weeklyTasks.length,
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      padding: EdgeInsets.zero,
                                      itemBuilder: (context, index) {
                                        final item = state.weeklyTasks[index];
                                        return TodoItemView(
                                          item: item,
                                          onTab: (TodoModel item) async {
                                            final bool? result = await context
                                                .router
                                                .push(TodoCounterRoute(
                                                    todo: item));

                                            if (result != null) {
                                              if (result) {
                                                // Trigger your desired action if `true` is returned
                                                print('Todo was updated.');
                                                _bloc.add(GetTodoList());
                                              } else {
                                                // Handle `false` return value
                                                print('Todo was not updated.');
                                              }
                                            } else {
                                              // Handle the case where no value was returned
                                              print('No value returned.');
                                            }
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                  if (state.monthlyTasks.isNotEmpty) ...[
                                    SizedBox(
                                      height: 10.h,
                                    ),
                                    Text(
                                      "Monthly tasks",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .copyWith(
                                            color: AppColors.primaryColor,
                                            fontSize: 20.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                    SizedBox(
                                      height: 10.h,
                                    ),
                                    ListView.builder(
                                      itemCount: state.monthlyTasks.length,
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      padding: EdgeInsets.zero,
                                      itemBuilder: (context, index) {
                                        final item = state.monthlyTasks[index];
                                        return TodoItemView(
                                          item: item,
                                          onTab: (TodoModel item) async {
                                            final bool? result = await context
                                                .router
                                                .push(TodoCounterRoute(
                                                    todo: item));

                                            if (result != null) {
                                              if (result) {
                                                // Trigger your desired action if `true` is returned
                                                print('Todo was updated.');
                                                _bloc.add(GetTodoList());
                                              } else {
                                                // Handle `false` return value
                                                print('Todo was not updated.');
                                              }
                                            } else {
                                              // Handle the case where no value was returned
                                              print('No value returned.');
                                            }
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                  if (state.yearlyTasks.isNotEmpty) ...[
                                    SizedBox(
                                      height: 10.h,
                                    ),
                                    Text(
                                      "Yearly tasks",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .copyWith(
                                            color: AppColors.primaryColor,
                                            fontSize: 20.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                    SizedBox(
                                      height: 10.h,
                                    ),
                                    ListView.builder(
                                      itemCount: state.yearlyTasks.length,
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      padding: EdgeInsets.zero,
                                      itemBuilder: (context, index) {
                                        final item = state.yearlyTasks[index];
                                        return TodoItemView(
                                          item: item,
                                          onTab: (TodoModel item) async {
                                            final bool? result = await context
                                                .router
                                                .push(TodoCounterRoute(
                                                    todo: item));

                                            if (result != null) {
                                              if (result) {
                                                // Trigger your desired action if `true` is returned
                                                print('Todo was updated.');
                                                _bloc.add(GetTodoList());
                                              } else {
                                                // Handle `false` return value
                                                print('Todo was not updated.');
                                              }
                                            } else {
                                              // Handle the case where no value was returned
                                              print('No value returned.');
                                            }
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      } else {
                        return const SizedBox();
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to get the ordinal suffix
  String getDaySuffix(int day) {
    if (day >= 11 && day <= 13) return 'th'; // Handle special cases
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }
}
