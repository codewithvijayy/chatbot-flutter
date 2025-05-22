import 'package:chatbot/server/auth.dart';
import 'package:chatbot/validation.dart';
import 'package:chatbot/website/auth/widgets/custom_textfield.dart';
import 'package:chatbot/website/auth/widgets/mobile_signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  bool isCheckBox = false;
  bool ischeckPassword = true;

  void signUp(WidgetRef ref) async {
    if (isCheckBox == true) {
      if (isValidEmail(email.text) && isValidPassword(password.text)) {
        final success = await ref
            .read(authProvider.notifier)
            .signUp(
              email: email.text,
              password: password.text,
              firstName: firstName.text,
              lastName: lastName.text,
            );

        if (success) {
          final uid = FirebaseAuth.instance.currentUser?.uid;
          if (uid != null) {
            context.go("/home/user?uid=$uid");
          }
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
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color.fromRGBO(99, 95, 117, 1),
      body: LayoutBuilder(
        builder: (context, constaints) {
          if (constaints.maxWidth < 600) {
            return MobileSignup();
          }
          return Stack(
            children: [
              Center(
                child: Container(
                  width: size.width * 0.85,
                  height: size.height * 0.85,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color.fromRGBO(44, 38, 56, 1),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: size.width * 0.50,
                        height: size.height * 0.90,
                        child: Center(
                          child: Image.asset("assets/icons/signup.png"),
                        ),
                      ),

                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 20, top: 20),
                              child: Text(
                                "Create an Account",
                                style: TextStyle(
                                  fontSize: size.width * 0.030,
                                  fontWeight: FontWeight.w800,
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                            ),

                            Row(
                              children: [
                                Expanded(
                                  child: CustomTextfield(
                                    controller: firstName,
                                    hintText: "First Name",
                                  ),
                                ),
                                Expanded(
                                  child: CustomTextfield(
                                    controller: lastName,
                                    hintText: "Last Name",
                                  ),
                                ),
                              ],
                            ),
                            CustomTextfield(
                              controller: email,
                              hintText: "Email",
                            ),
                            CustomTextfield(
                              controller: password,
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
                                  value: isCheckBox,
                                  onChanged: (val) {
                                    setState(() {
                                      isCheckBox = !isCheckBox;
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

                            MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () {
                                  signUp(ref);
                                },
                                child: Container(
                                  margin: EdgeInsets.all(15),
                                  width: size.width * 0.50,
                                  height: size.height * 0.08,
                                  decoration: BoxDecoration(
                                    color: Colors.indigo.shade600,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child:
                                      ref.watch(authProvider) == true
                                          ? Center(
                                            child: CircularProgressIndicator(),
                                          )
                                          : Center(
                                            child: Text(
                                              "Create account",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                ),
                              ),
                            ),
                            Spacer(),
                            InkWell(
                              onTap: () {},
                              child: Container(
                                margin: EdgeInsets.all(size.width * 0.020),
                                padding: EdgeInsets.only(
                                  left: size.width * 0.010,
                                ),
                                child: Row(
                                  children: [
                                    Text("Already have an account? "),
                                    InkWell(
                                      onTap: () {
                                        context.go("/login");
                                      },
                                      child: Text(
                                        "Login",
                                        style: TextStyle(color: Colors.blue),
                                      ),
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
              ),
            ],
          );
        },
      ),
    );
  }
}
