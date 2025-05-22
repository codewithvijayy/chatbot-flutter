import 'package:chatbot/server/auth.dart';
import 'package:chatbot/validation.dart';
import 'package:chatbot/website/auth/widgets/custom_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MobileSignup extends ConsumerStatefulWidget {
  const MobileSignup({super.key});

  @override
  ConsumerState<MobileSignup> createState() => _MobileSignupState();
}

class _MobileSignupState extends ConsumerState<MobileSignup> {
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              SizedBox(
                height: size.height * 0.30,
                child: Center(child: Image.asset("assets/icons/signup.png")),
              ),

              Column(
                children: [
                  Text(
                    "Create an Account",
                    style: TextStyle(
                      fontSize: size.width * 0.030,
                      fontWeight: FontWeight.w800,
                      fontStyle: FontStyle.normal,
                    ),
                  ),

                  CustomTextfield(
                    controller: firstName,
                    hintText: "First Name",
                  ),
                  CustomTextfield(controller: lastName, hintText: "Last Name"),
                  CustomTextfield(controller: email, hintText: "Email"),
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
                                ? Center(child: CircularProgressIndicator())
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

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(),
                      Row(
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
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
