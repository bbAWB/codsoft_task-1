import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker_fork/flutter_cupertino_date_picker_fork.dart';
import 'package:intl/intl.dart';

import 'package:todo_app/extenstions/space_exs.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/utils/app_colors.dart';
import 'package:todo_app/utils/app_str.dart';
import 'package:todo_app/utils/constants.dart';
import 'package:todo_app/views/task/Widget/taskapp_bar.dart';
import 'package:todo_app/views/components/date_time_selection.dart';
import 'package:todo_app/views/components/rep_textfiled.dart';

class TaskView extends StatefulWidget {
  const TaskView(
      {super.key,
      required this.titleTaskController,
      required this.descTaskController,
      required this.task});

  final TextEditingController? titleTaskController;
  final TextEditingController? descTaskController;
  final Task? task;
  @override
  State<TaskView> createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
  var title;
  var subtitle;
  DateTime? time;
  DateTime? date;
  String showTime(DateTime? time) {
    if (widget.task?.createdAtTime == null) {
      if (time == null) {
        return DateFormat('hh:mm a').format(DateTime.now()).toString();
      } else {
        return DateFormat('hh:mm a').format(time).toString();
      }
    } else {
      return DateFormat('hh:mm a')
          .format(widget.task!.createdAtTime)
          .toString();
    }
  }

  String showDate(DateTime? date) {
    if (widget.task?.createdAtDate == null) {
      if (date == null) {
        return DateFormat.yMMMEd().format(DateTime.now()).toString();
      } else {
        return DateFormat.yMMMEd().format(date).toString();
      }
    } else {
      return DateFormat.yMMMEd().format(widget.task!.createdAtDate).toString();
    }
  }

  DateTime showDateAsDateTime(DateTime? date) {
    if (widget.task?.createdAtDate == null) {
      if (date == null) {
        return DateTime.now();
      } else {
        return date;
      }
    } else {
      return widget.task!.createdAtDate;
    }
  }

  bool isTaskAlreadyExist() {
    if (widget.titleTaskController?.text == null &&
        widget.descTaskController?.text == null) {
      return true;
    } else {
      return false;
    }
  }

  dynamic isTaskAreadyExisUpateOtherWiseCreate() {
    if (widget.titleTaskController?.text != null &&
        widget.descTaskController?.text != null) {
      try {
        widget.titleTaskController?.text = title;
        widget.descTaskController?.text = subtitle;
        widget.task?.save();
        Navigator.pop(context);
      } catch (e) {
        updateTaskWarning(context);
      }
    } else {
      if (title != null && subtitle != null) {
        var task = Task.create(
            title: title,
            subTitle: subtitle,
            createdAtDate: date,
            createdAtTime: time);
        BaseWidget.of(context).dataStore.addTask(task: task);
        Navigator.pop(context);
      } else {
        emptyWarning(context);
      }
    }
  }

  dynamic deleteTask() {
    return widget.task?.delete();
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
      child: Scaffold(
          appBar: const TaskViewAppBar(),
          body: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: SingleChildScrollView(
              child: Column(children: [
                buildTopSideTask(textTheme),
                buildMainTaskView(textTheme, context),
                buildBottonSlideButton()
              ]),
            ),
          )),
    );
  }

  Widget buildBottonSlideButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: isTaskAlreadyExist()
            ? MainAxisAlignment.center
            : MainAxisAlignment.spaceEvenly,
        children: [
          isTaskAlreadyExist()
              ? Container()
              : MaterialButton(
                  onPressed: () {
                    deleteTask();
                    Navigator.pop(context);
                  },
                  minWidth: 150,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  height: 55,
                  child: Row(
                    children: [
                      const Icon(
                        Icons.close,
                        color: AppColors.primaryColor,
                      ),
                      5.w,
                      const Text(
                        App.deleteTask,
                        style: TextStyle(color: AppColors.primaryColor),
                      ),
                    ],
                  ),
                ),
          MaterialButton(
            onPressed: () {
              isTaskAreadyExisUpateOtherWiseCreate();
            },
            minWidth: 150,
            color: AppColors.primaryColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            height: 55,
            child: Text(
              isTaskAlreadyExist() ? App.addTaskString : App.updateTaskString,
              style: const TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }

  Widget buildMainTaskView(TextTheme textTheme, BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 530,
      child: Column(children: [
        Padding(
            padding: const EdgeInsets.only(left: 30),
            child: Text(App.titleOffTitleTextField,
                style: textTheme.headlineMedium)),
        RepTextField(
          controller: widget.titleTaskController,
          onFieldSubmitted: (String inputTitle) {
            title = inputTitle;
          },
          onChanged: (String inputTitle) {
            title = inputTitle;
          },
        ),
        10.h,
        RepTextField(
          controller: widget.descTaskController,
          isForDesc: true,
          onFieldSubmitted: (String inSubTitle) {
            subtitle = inSubTitle;
          },
          onChanged: (String inSubTitle) {
            subtitle = inSubTitle;
          },
        ),
        DateTimeSelection(
            onTap: () {
              showModalBottomSheet(
                  context: context,
                  builder: (_) => SizedBox(
                        height: 280,
                        child: TimePickerWidget(
                          initDateTime: showDateAsDateTime(time),
                          dateFormat: 'HH:mm',
                          onChange: (_, __) {},
                          onConfirm: (dateTime, __) {
                            setState(() {
                              if (widget.task?.createdAtTime == null) {
                                time = dateTime;
                              } else {
                                widget.task!.createdAtTime = dateTime;
                              }
                            });
                          },
                        ),
                      ));
            },
            title: App.timeString,
            time: showTime(time)),
        DateTimeSelection(
            onTap: () {
              DatePicker.showDatePicker(context,
                  maxDateTime: DateTime(2030, 4, 5),
                  minDateTime: DateTime.now(),
                  initialDateTime: showDateAsDateTime(date),
                  onConfirm: (dateTime, __) {
                setState(() {
                  if (widget.task?.createdAtDate == null) {
                    date = dateTime;
                  } else {
                    widget.task!.createdAtDate = dateTime;
                  }
                });
              });
            },
            title: App.dateString,
            isTime: true,
            time: showDate(date)),
      ]),
    );
  }

  Widget buildTopSideTask(TextTheme textTheme) {
    return SizedBox(
      width: double.infinity,
      height: 100,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              width: 70,
              child: Divider(
                thickness: 2,
              ),
            ),
            RichText(
                text: TextSpan(
                    text: isTaskAlreadyExist()
                        ? App.addNewTask
                        : App.updateCurrentTask,
                    style: textTheme.titleLarge,
                    children: const [
                  TextSpan(
                      text: App.taskString,
                      style: TextStyle(fontWeight: FontWeight.w400))
                ])),
            const SizedBox(
              width: 70,
              child: Divider(
                thickness: 2,
              ),
            ),
          ]),
    );
  }
}
