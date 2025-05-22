import 'package:chatbot/server/auth.dart';
import 'package:chatbot/server/chatweb_services.dart';
import 'package:chatbot/server/server.dart';
import 'package:chatbot/theme/colors.dart';
import 'package:chatbot/website/chat_page.dart';
import 'package:chatbot/website/widgets/side_nav.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MobileView extends ConsumerStatefulWidget {
  const MobileView({super.key});

  @override
  ConsumerState<MobileView> createState() => _MobileViewState();
}

class _MobileViewState extends ConsumerState<MobileView> {
  final queryController = TextEditingController();
  bool hasQueried = false;
  @override
  void dispose() {
    super.dispose();
    queryController.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(chatServiceProvider).connect(ref);
    });
    userData();
    super.initState();
  }

  Map<String, dynamic>? data;

  Future<void> userData() async {
    data = await getDatafromFirebaseFireStore();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final message = ref.watch(chatProvider);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Chatbot"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Align(
              alignment: Alignment.topCenter,
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return ProfileDialog(
                        firstName: data!["FirstName"].toString(),
                        lastName: data!["LastName"].toString(),
                        email: data!["email"].toString(),
                      );
                    },
                  );
                },
                child: CircleAvatar(
                  radius: size.height * 0.03,
                  backgroundImage: AssetImage("assets/icons/profile.png"),
                ),
              ),
            ),
          ),
        ],
      ),

      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: AppColors.searchBar),

              currentAccountPicture: CircleAvatar(
                radius: size.width * 0.10,
                backgroundImage: AssetImage("assets/icons/profile.png"),
              ),
              accountName: Row(
                children: [
                  Text(data!["FirstName"].toString()),
                  Text(data!["LastName"].toString()),
                ],
              ),
              accountEmail: Text(data!["email"].toString()),
            ),

            Row(
              children: [
                TextButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Row(
                            children: [
                              Icon(Icons.warning, color: Colors.orange),
                              const SizedBox(width: 8),
                              Text("Warning"),
                            ],
                          ),
                          content: Text("Are you sure you want to proceed?"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text("Cancel"),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(),
                              onPressed: () async {
                                await FirebaseAuth.instance.signOut();
                                context.go("/login");
                              },
                              child: Text("Proceed"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  label: Text("Log out"),
                  icon: Icon(Icons.logout),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(child: ChatPage()),
          if (!hasQueried)
            Center(
              child: Text(
                'What can I help with?',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: size.width * 0.06,
                ),
              ),
            ),

          Container(
            decoration: BoxDecoration(
              color: AppColors.searchBar,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.searchBarBorder, width: 1.5),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: queryController,
                    decoration: InputDecoration(
                      hintText: 'Search anything...',
                      hintStyle: TextStyle(color: AppColors.textGrey),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          ref
                              .read(chatServiceProvider)
                              .send(queryController.text, ref);
                          setState(() {
                            hasQueried = true;
                            queryController.clear();
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(9),
                          decoration: BoxDecoration(
                            color: AppColors.submitButton,
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child:
                              message.isNotEmpty &&
                                      message.last.data == "Bot is typing..."
                                  ? SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppColors.whiteColor,
                                    ),
                                  )
                                  : const Icon(
                                    Icons.arrow_forward,
                                    color: AppColors.whiteColor,
                                    size: 16,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
