import 'package:chatbot/mobile/mobile.dart';
import 'package:chatbot/server/auth.dart';
import 'package:chatbot/server/chatweb_services.dart';
import 'package:chatbot/theme/colors.dart';
import 'package:chatbot/website/chat_page.dart';
import 'package:chatbot/website/widgets/search_section.dart';
import 'package:chatbot/website/widgets/side_nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WebsiteView extends ConsumerStatefulWidget {
  const WebsiteView({super.key});

  @override
  ConsumerState<WebsiteView> createState() => _WebsiteViewState();
}

class _WebsiteViewState extends ConsumerState<WebsiteView> {
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
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 600) {
            return MobileView();
          }
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomSideBar(),

              Container(
                margin: EdgeInsets.all(10),
                width: size.width * 0.85,
                child: Center(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "ChatBot",
                              style: TextStyle(
                                fontSize: size.width * 0.02,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
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
                                        firstName:
                                            data!["FirstName"].toString(),
                                        lastName: data!["LastName"].toString(),
                                        email: data!["email"].toString(),
                                      );
                                    },
                                  );
                                },
                                child: CircleAvatar(
                                  radius: size.height * 0.03,
                                  backgroundImage: AssetImage(
                                    "assets/icons/profile.png",
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: size.height * 0.010),

                      Expanded(child: ChatPage()),

                      SearchSection(),

                      Container(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                "Pro",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.footerGrey,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                "Enterprise",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.footerGrey,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                "Store",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.footerGrey,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                "Blog",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.footerGrey,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                "Careers",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.footerGrey,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                "English (English)",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.footerGrey,
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
