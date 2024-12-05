import 'package:flutter/material.dart';

abstract class Dialogs {
  static alert({required BuildContext context, required String titulo, required String descripcion}) {
    showDialog(context: context, builder: (_) => AlertDialog(
      title: Text(titulo),
      content: Text(descripcion),
      actions: [
        TextButton(onPressed: (){
          Navigator.pop(_);
        }, 
        child: Text("OK")),
      ],
    ));
  }
}

abstract class ProgressDialog {
  static show(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) {
          return WillPopScope(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.white.withOpacity(0.7),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
            onWillPop: () async => false,
          );
        });
  }

  static dissmiss(BuildContext context) {
    Navigator.pop(context);
  }
}
