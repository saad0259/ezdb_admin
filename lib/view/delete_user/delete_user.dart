import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ezdb_admin/app_theme.dart';

import '../../flutter-utils/snippets/dialogs.dart';
import '../../flutter-utils/snippets/reusable_widgets.dart';
import '../../flutter-utils/snippets/validators.dart';
import '../../repo/auth_repo.dart';
import '../../view/responsive/responsive_layout.dart';

class DeleteUserScreen extends StatefulWidget {
  const DeleteUserScreen({Key? key}) : super(key: key);

  @override
  State<DeleteUserScreen> createState() => _DeleteUserScreenState();
}

class _DeleteUserScreenState extends State<DeleteUserScreen> {
  final phone = TextEditingController();

  final password = TextEditingController();

  final formKey = GlobalKey<FormState>();

  final loadingNotifier = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return ResponsiveHeightLayout(
      child: Scaffold(
        body: Container(
          width: context.width,
          child: Stack(
            children: [
              //gradient
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.grey.shade200,
                      Colors.grey.shade400,
                    ],
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.getResponsiveHorizontalPadding(),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    getLoginCard(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getLoginCard(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: context.isTablet ? 400 : 600,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 0,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 48) +
                      const EdgeInsets.only(bottom: 8),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Delete Account',
                      style: Theme.of(context).textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    TextFormField(
                      validator: mandatoryValidator,
                      decoration: const InputDecoration(
                        hintText: 'Enter Phone',
                        prefixIcon: Icon(Icons.phone),
                      ),
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      controller: phone,
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      validator: passwordValidator,
                      decoration: const InputDecoration(
                        hintText: 'Enter Password',
                        prefixIcon: Icon(Icons.vpn_key),
                      ),
                      obscureText: true,
                      controller: password,
                    ),
                    const SizedBox(height: 32),
                    ValueListenableBuilder<bool>(
                      valueListenable: loadingNotifier,
                      builder: (c, loading, child) => loading
                          ? getLoader()
                          : ElevatedButton(
                              onPressed: () => loginAction(context),
                              child: const Text('Delete'),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> loginAction(BuildContext context) async {
    loadingNotifier.value = true;
    final validated = formKey.currentState?.validate() ?? false;
    if (validated) {
      AuthRepo.instance
          .deleteUser(phone.text, password.text)
          .catchError((error) {
        loadingNotifier.value = false;
        if (error is FirebaseException) {
          snack(context, "Delete Failed");
        } else {
          snack(context, "Delete Failed");
        }
      }).then((value) {
        loadingNotifier.value = false;
        snack(context, "Delete Success");
      });
    } else {
      loadingNotifier.value = false;
    }
  }
}
