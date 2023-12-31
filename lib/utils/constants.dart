import 'package:flutter/material.dart';
import 'package:ftoast/ftoast.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:todo_app/data/hibe_date_store.dart';
import 'package:todo_app/main.dart';

import 'package:todo_app/utils/app_str.dart';

String lottiURL = 'assets/lottie/file.json';
dynamic emptyWarning(BuildContext context) {
  return FToast.toast(context,
      msg: App.opsMsg,
      subMsg: 'You Must fill all fields!',
      corner: 20.0,
      duration: 2000,
      padding: const EdgeInsets.all(20));
}

dynamic updateTaskWarning(BuildContext context) {
  return FToast.toast(context,
      msg: App.opsMsg,
      subMsg: 'You must edit the tasks then try to update it!',
      corner: 20.0,
      duration: 5000,
      padding: const EdgeInsets.all(20));
}

dynamic noTaskWarning(BuildContext context) {
  return PanaraInfoDialog.showAnimatedGrow(
    context,
    title: App.opsMsg,
    message:
        "There is no Task For Delete!\n Try adding some and then try to delete it!",
    buttonText: "Okay",
    onTapDismiss: () {
      Navigator.pop(context);
    },
    panaraDialogType: PanaraDialogType.warning,
  );
}

dynamic deletedAllTask(BuildContext context) {
  return PanaraConfirmDialog.show(context,
      title: App.areYouSure,
      message:
          "Do You really want to delete all tasks? You will no be able to undo this action!",
      confirmButtonText: 'Yes',
      cancelButtonText: "No", onTapConfirm: () {
    HiveDateStore.box.clear();
    Navigator.pop(context);
  }, onTapCancel: () {
    Navigator.pop(context);
  }, panaraDialogType: PanaraDialogType.error, barrierDismissible: false);
}
