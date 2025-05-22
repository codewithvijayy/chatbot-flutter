import 'package:chatbot/server/auth.dart';
import 'package:chatbot/validation.dart';
import 'package:chatbot/website/auth/widgets/custom_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MobileLogin extends ConsumerStatefulWidget {
  const MobileLogin({super.key});

  @override
  ConsumerState<MobileLogin> createState() => _MobileLoginState();
}

class _MobileLoginState extends ConsumerState<MobileLogin> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isCheck = false;
  bool ischeckPassword = true;
  void login(WidgetRef ref) async {
    if (isCheck == true) {
      if (isValidEmail(emailController.text) &&
          isValidPassword(passwordController.text)) {
        final error = await ref
            .read(authProvider.notifier)
            .login(
              email: emailController.text,
              password: passwordController.text,
            );

        if (error != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(error)));
          return;
        }

        final uid = FirebaseAuth.instance.currentUser?.uid;
        if (uid != null) {
          context.go("/home/user?uid=$uid");
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Email or password format is invalid")),
        );
      }
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Enable checkbox")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authProvider);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Center(
                child: Image.asset(
                  "assets/icons/login.png",
                  height: size.height * 0.4,
                ),
              ),
              Center(
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 20, top: 20),
                      child: Text(
                        "Welcome Back",
                        style: TextStyle(
                          fontSize: size.width * 0.04,
                          fontWeight: FontWeight.w800,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, top: 5),
                      child: Text(
                        "Enter your email and password to access your account",
                        style: TextStyle(fontSize: size.width * 0.020),
                      ),
                    ),
                    CustomTextfield(
                      controller: emailController,
                      hintText: "Email",
                    ),
                    CustomTextfield(
                      controller: passwordController,
                      hintText: "* * * * * *",
                      obscureText: ischeckPassword,
                      onTap: () {
                        setState(() {
                          ischeckPassword = !ischeckPassword;
                        });
                      },
                      suffixIcon:
                          ischeckPassword
                              ? Icons.visibility_off
                              : Icons.remove_red_eye,
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: isCheck,
                          onChanged: (val) {
                            setState(() {
                              isCheck = !isCheck;
                            });
                          },
                        ),
                        Text("I agree to the "),
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () {},
                            child: Text(
                              'Terms & Conditions',
                              style: TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    InkWell(
                      onTap: () {
                        login(ref);
                      },
                      child: Container(
                        margin: EdgeInsets.all(15),
                        width: size.width * 0.50,
                        height: size.height * 0.08,
                        decoration: BoxDecoration(
                          color: Colors.indigo.shade600,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Center(
                          child:
                              isLoading
                                  ? CircularProgressIndicator()
                                  : Text(
                                    "Log In",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                        ),
                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(),
                        Row(
                          children: [
                            Text("Don't have an account? "),
                            InkWell(
                              onTap: () {
                                context.go("/signup");
                              },
                              child: Text(
                                "Register Now",
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                          ],
                        ),
                      ],
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
}
