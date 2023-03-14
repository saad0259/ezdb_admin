import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../repo/auth_repo.dart';
import '../../util/snippet.dart';
import '../../view/responsive/extended_media_query.dart';
import '../../view/responsive/responsive_layout.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final email = TextEditingController();

  final password = TextEditingController();

  final formKey = GlobalKey<FormState>();

  final loadingNotifier = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      email.text = 'user46.enchap@yopmail.com';
      password.text = '12345678';
    }
    return ResponsiveHeightLayout(
      child: Scaffold(
        body: Stack(
          children: [
            Container(color: Colors.black.withOpacity(0.7)),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal:
                    MediaQuery.of(context).getResponsiveHorizontalPadding(),
                vertical: 48,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        'assets/images/white-logo.png',
                        width: rTabletWidth / 6,
                      ),
                      TextButton(
                        onPressed: () {
                          // push(context, const OnboardingView());
                        },
                        child: const Text('Sign Up',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                  getLoginCard(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getLoginCard(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: rTabletWidth / 2,
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
                      'Login',
                      style: Theme.of(context).textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    TextFormField(
                      validator: emailValidator,
                      decoration: const InputDecoration(
                        hintText: 'Enter Email',
                        prefixIcon: Icon(Icons.email),
                      ),
                      controller: email,
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
                              child: const Text('Login'),
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
      AuthRepo.instance.login(email.text, password.text).catchError((error) {
        loadingNotifier.value = false;
        if (error is FirebaseException) {
          snack(context, "${error.message}");
        } else {
          snack(context, "$error");
        }
      }).then((value) {
        loadingNotifier.value = false;
      });
    } else {
      loadingNotifier.value = false;
    }
  }
}
