import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:todo_app/extenstions/space_exs.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/utils/app_colors.dart';
import 'package:todo_app/utils/app_str.dart';
import 'package:todo_app/utils/constants.dart';

import 'package:todo_app/views/components/fab.dart';
import 'package:todo_app/views/components/home_app_bar.dart';
import 'package:todo_app/views/components/slide_drawer.dart';
import 'package:todo_app/views/home/widget/task_widget.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  GlobalKey<SliderDrawerState> drawerKey = GlobalKey<SliderDrawerState>();
  dynamic valueOfIndicator(List<Task> task) {
    if (task.isNotEmpty) {
      return task.length;
    } else {
      return 3;
    }
  }

  int checkDoneTask(List<Task> tasks) {
    int i = 0;

    for (Task doneTask in tasks) {
      if (doneTask.isCompleted) {
        i++;
      }
    }

    return i;
  }

  @override
  Widget build(BuildContext context) {
    TextTheme theme = Theme.of(context).textTheme;
    final base = BaseWidget.of(context);
    return ValueListenableBuilder(
        valueListenable: base.dataStore.listenToTask(),
        builder: (ctx, Box<Task> box, Widget? child) {
          var tasks = box.values.toList();
          tasks.sort((a, b) => a.createdAtDate.compareTo(b.createdAtTime));

          return Scaffold(
              backgroundColor: Colors.white,
              floatingActionButton: const Fab(),
              body: SliderDrawer(
                key: drawerKey,
                isDraggable: false,
                animationDuration: 1000,
                slider: CustomDrawer(),
                appBar: HomeAppBar(drawerKey: drawerKey),
                child: _buildHomeBody(theme, base, tasks),
              ));
        });
  }

  Widget _buildHomeBody(TextTheme theme, BaseWidget base, List<Task> tasks) {
    return SingleChildScrollView(
      child: Column(children: [
        Container(
          margin: const EdgeInsets.only(top: 60),
          width: double.infinity,
          height: 100,
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            SizedBox(
              width: 30,
              height: 30,
              child: CircularProgressIndicator(
                value: checkDoneTask(tasks) / valueOfIndicator(tasks),
                backgroundColor: Colors.grey,
                valueColor:
                    const AlwaysStoppedAnimation(AppColors.primaryColor),
              ),
            ),
            25.w,
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(App.mainTitle, style: theme.displayLarge),
                3.h,
                Text("${checkDoneTask(tasks)} of ${tasks.length} task",
                    style: theme.titleMedium)
              ],
            )
          ]),
        ),
        const Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Divider(
            thickness: 2,
            indent: 100,
          ),
        ),
        SizedBox(
            width: double.infinity,
            height: 585,
            child: tasks.isNotEmpty
                ? ListView.builder(
                    itemCount: tasks.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      var task = tasks[index];
                      return Dismissible(
                          direction: DismissDirection.horizontal,
                          onDismissed: (direction) {
                            base.dataStore.deleteTask(task: task);
                          },
                          background: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.delete_outline,
                                    color: Colors.grey),
                                8.w,
                                const Text(
                                  App.deleteTask,
                                  style: TextStyle(color: Colors.grey),
                                )
                              ]),
                          key: Key(task.id),
                          child: TaskWidget(task: task));
                    })
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FadeIn(
                        child: SizedBox(
                          width: 200,
                          height: 200,
                          child: Lottie.asset(lottiURL,
                              animate: tasks.isNotEmpty ? false : true),
                        ),
                      ),
                      FadeInUp(from: 30, child: const Text(App.doneAllTask))
                    ],
                  ))
      ]),
    );
  }
}
