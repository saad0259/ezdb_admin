import 'dart:math';

import 'package:beamer/beamer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

String get placesApiKey => 'AIzaSyDK80tNhh90sMf5VFouxEfPSYPDULvdB2Q';

// String get placesProxyUrl =>
//     "https://google-places-web-proxy.herokuapp.com/https://maps.googleapis.com/maps/api";

String? Function(String?) get mandatoryValidator =>
    (String? val) => val?.isEmpty ?? true ? "This field is mandatory" : null;

String? Function(String?) get emailValidator => (String? email) => RegExp(
            // r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(email ?? "")
    ? null
    : "Enter a valid email";

String? Function(String?) get numberValidator =>
    (String? number) => number?.isEmpty ?? true
        ? "This field is mandatory"
        : RegExp(r"^[0-9]*$").hasMatch(number ?? "")
            ? null
            : "Enter a valid number";

String getRandomNumber() {
  var rng = Random();

  return (rng.nextInt(90000) + 10000).toString();
}

String parseDate(DateTime date) {
  return DateFormat.yMMMd().format(date);
}

String parseTime(DateTime time) {
  return DateFormat.jm().format(time);
}

String parseDateTime(DateTime date) {
  return "${parseDate(date)} ${parseTime(date)}";
}

void pushNamed(BuildContext context, String routeName) =>
    Navigator.pushNamed(context, routeName);

String? Function(String?) get passwordValidator => (String? password) =>
    (password?.length ?? 0) < 8 ? "Password too short" : null;

String? validateConfirmPassword(String password, String? confirm) {
  if (password != confirm) {
    return "Passwords don't match";
  }
  final err = passwordValidator(confirm);
  if (err != null) {
    return err;
  } else {
    return null;
  }
}

class ConfirmationPopup extends StatelessWidget {
  const ConfirmationPopup({
    Key? key,
    required this.onConfirm,
    this.onCancel,
    this.dialogText,
  }) : super(key: key);

  final Function onConfirm;
  final Function? onCancel;
  final String? dialogText;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content:
          Text(dialogText ?? 'Are you sure you want to complete this action?'),
      actions: [
        //confirm and cancel button
        TextButton(
          onPressed: () => onCancel ?? pop(context),
          child: const Text('cancel'),
        ),

        ElevatedButton(
          onPressed: () async {
            await onConfirm.call();
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(2.0),
            visualDensity: VisualDensity.compact,
          ),
          child: const Text('confirm'),
        ),
      ],
    );
  }
}

Future<T?> push<T>(BuildContext context, Widget child) =>
    Navigator.of(context).push<T>(MaterialPageRoute(builder: (_) => child));

void replace(BuildContext context, Widget child) => Navigator.pushReplacement(
    context, MaterialPageRoute(builder: (context) => child));

void pop(BuildContext context) => Navigator.of(context).pop();

void popToMain(BuildContext context) =>
    Navigator.of(context).popUntil((route) => route.isFirst);

void snack(BuildContext context, String message, {bool info = false}) {
  debugPrint(message);

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(
      backgroundColor: info ? Theme.of(context).primaryColor : Colors.red,
      // behavior: SnackBarBehavior.floating,
      content: Text(
        message,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.white,
            ),
      ),
    ));
}

void beamerPush(BuildContext context, {required String routeName}) {
  return Beamer.of(context).beamToNamed(routeName);
}

void alert(BuildContext context, String message,
    {bool info = false, IconData? icon, String? title}) {
  debugPrint(message);

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      contentPadding: const EdgeInsets.symmetric(vertical: 40, horizontal: 120),
      actionsPadding:
          const EdgeInsets.symmetric(vertical: 40, horizontal: 120) -
              const EdgeInsets.only(top: 40),
      actionsAlignment: MainAxisAlignment.center,
      title: info
          ? Icon(
              icon ?? Icons.check_circle_outline,
              color: Theme.of(context).primaryColor,
              size: 90,
            )
          : Icon(
              icon ?? Icons.error_outline,
              color: Theme.of(context).colorScheme.error,
              size: 90,
            ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title ?? (info ? "success" : "error"),
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: <Widget>[
        ElevatedButton(
          child: const Text("ok"),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    ),
  );
}

void sureAlert({
  required BuildContext context,
  required String message,
  required void Function() onYes,
}) =>
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 40, horizontal: 120),
        actionsPadding:
            const EdgeInsets.symmetric(vertical: 40, horizontal: 120) -
                const EdgeInsets.only(top: 40),
        actionsAlignment: MainAxisAlignment.center,
        title: Icon(
          Icons.help_outline,
          color: Theme.of(context).primaryColor,
          size: 90,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Are you sure you want to complete this action?",
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: <Widget>[
          ElevatedButton(
            child: const Text("yes"),
            onPressed: () {
              onYes();
              pop(context);
            },
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
            ),
            child: const Text("no"),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );

Widget getLoader() => const Center(child: CircularProgressIndicator());

void getStickyLoader(context) async {
  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => getLoader(),
  );
}

Widget getErrorMessage(BuildContext context, e) {
  debugPrint(e);

  return Center(
    child: Text(
      e is FirebaseException ? e.message ?? e.code : e,
      style:
          Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.red),
      textAlign: TextAlign.center,
    ),
  );
}

Widget getShimmer({
  Color? baseColor,
  Color? highlightColor,
  double? height,
  double? width,
  BoxShape? shape,
}) {
  baseColor ??= Colors.grey[300]!;
  highlightColor ??= Colors.grey[100]!;
  height ??= 12;
  width ??= 40;

  return Shimmer.fromColors(
    baseColor: baseColor,
    highlightColor: highlightColor,
    child: Card(
      clipBehavior: Clip.hardEdge,
      shape: shape == BoxShape.circle ? const CircleBorder() : null,
      child: SizedBox(
        height: height,
        width: width,
      ),
    ),
  );
}

Shimmer shimmerTableEffect() {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0) +
          const EdgeInsets.only(top: 100.0, bottom: 50),
      child: ListView.separated(
        itemCount: 20,
        separatorBuilder: (BuildContext context, int index) {
          return const Divider(
            endIndent: 0,
            color: Colors.black,
            height: 0,
            indent: 0,
          );
        },
        itemBuilder: (BuildContext context, int index) {
          return const Card(
            child: SizedBox(
              height: 40,
            ),
          );
        },
      ),
    ),
  );
}

Shimmer shimmerDashboardEffect() {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0) +
          const EdgeInsets.only(top: 15.0, bottom: 50),
      child: Column(
        children: [
          Row(
            children: const [
              Expanded(
                  child: Card(
                child: SizedBox(
                  height: 125,
                ),
              )),
              Expanded(
                  child: Card(
                child: SizedBox(
                  height: 125,
                ),
              )),
              Expanded(
                  child: Card(
                child: SizedBox(
                  height: 125,
                ),
              )),
            ],
          ),
          const SizedBox(height: 40),
          Row(
            children: const [
              Expanded(
                  child: Card(
                child: SizedBox(
                  height: 125,
                ),
              )),
              Expanded(
                  child: Card(
                child: SizedBox(
                  height: 125,
                ),
              )),
              Expanded(
                  child: Card(
                child: SizedBox(
                  height: 125,
                ),
              )),
              Expanded(
                  child: Card(
                child: SizedBox(
                  height: 125,
                ),
              )),
            ],
          ),
          const SizedBox(height: 70),
          Row(
            children: const [
              Expanded(
                  child: Card(
                child: SizedBox(
                  height: 340,
                ),
              )),
              Expanded(
                  child: Card(
                child: SizedBox(
                  height: 340,
                ),
              )),
              Expanded(
                  child: Card(
                child: SizedBox(
                  height: 340,
                ),
              )),
            ],
          ),
        ],
      ),
    ),
  );
}

Future<Uint8List?> pickedImage(BuildContext context) async {
  final image = await ImagePicker().pickImage(source: ImageSource.gallery);
  if (image != null) {
    final imageBytes = await image.readAsBytes();
    return imageBytes;
  }
  return null;
}

Widget getFirebaseError(BuildContext context, error) {
  return getErrorMessage(context,
      error is FirebaseException ? error.message ?? error.code : '$error');
}

bool isKeyboardOpen(BuildContext context) =>
    MediaQuery.of(context).viewInsets.bottom != 0;

Future<String?> alertInput(BuildContext context, String title, String hint,
    {String doneText = "Done"}) async {
  final controller = TextEditingController();
  return showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      contentPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 60),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
      actionsAlignment: MainAxisAlignment.center,
      title: Text(title),
      content: SizedBox(
        width: 500,
        child: TextField(
          decoration: InputDecoration(hintText: hint),
          controller: controller,
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
            child: Text("cancel", style: TextStyle(color: Colors.orange)),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        ElevatedButton(
          child: Text(doneText),
          onPressed: () => Navigator.of(context).pop(controller.text),
        ),
      ],
    ),
  );
}

Future<void> customLaunch(String path) async {
  final Uri url = Uri.parse(path);
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    debugPrint(' could not launch $url');
  }
}
