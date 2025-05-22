import 'package:chatbot/server/auth.dart';
import 'package:chatbot/theme/colors.dart';
import 'package:chatbot/website/widgets/sidebar_buttons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomSideBar extends StatefulWidget {
  const CustomSideBar({super.key});

  @override
  State<CustomSideBar> createState() => _CustomSideBarState();
}

class _CustomSideBarState extends State<CustomSideBar> {
  bool isCollapsed = false;
  @override
  void initState() {
    super.initState();
    getdata();
  }

  Map<String, dynamic>? data;

  Future<void> getdata() async {
    data = await getDatafromFirebaseFireStore();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AnimatedContainer(
      padding: EdgeInsets.only(top: 10, left: 20),
      width: isCollapsed ? size.width * 0.05 : size.width * 0.13,
      duration: const Duration(milliseconds: 500),
      decoration: BoxDecoration(
        color: isCollapsed ? AppColors.background : AppColors.sideNav,
      ),
      child: Column(
        crossAxisAlignment:
            isCollapsed ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                isCollapsed = !isCollapsed;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),

              child: Image.asset(
                "assets/icons/web.png",
                width: 20,
                color: Colors.white,
              ),
            ),
          ),

          const SizedBox(height: 16),

          isCollapsed
              ? SizedBox()
              : Expanded(
                child: Column(
                  children: [
                    HoverShadowButton(
                      onTap: () {},
                      isCollapsed: isCollapsed,
                      icon: Icons.auto_awesome_mosaic,
                      text: "DashBoard",
                    ),
                    HoverShadowButton(
                      onTap: () {},
                      isCollapsed: isCollapsed,
                      icon: Icons.search,
                      text: "Search",
                    ),
                    Spacer(),

                    HoverShadowButton(
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
                      isCollapsed: isCollapsed,
                      icon: Icons.person,
                      text: "Profile",
                    ),
                    HoverShadowButton(
                      onTap: () {
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
                              content: Text(
                                "Are you sure you want to proceed?",
                              ),
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
                      isCollapsed: isCollapsed,
                      icon: Icons.logout_outlined,
                      text: "Log out",
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
        ],
      ),
    );
  }
}

class HoverShadowButton extends StatefulWidget {
  final bool isCollapsed;
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const HoverShadowButton({
    super.key,
    required this.isCollapsed,
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  State<HoverShadowButton> createState() => _HoverShadowButtonState();
}

class _HoverShadowButtonState extends State<HoverShadowButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color:
                _isHovered
                    ? const Color.fromARGB(90, 63, 61, 61)
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(5),
            boxShadow:
                _isHovered
                    ? [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ]
                    : [],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: SideBarButton(
            isCollapsed: widget.isCollapsed,
            icon: widget.icon,
            text: widget.text,
          ),
        ),
      ),
    );
  }
}

class ProfileDialog extends StatelessWidget {
  final String firstName;
  final String lastName;
  final String email;

  const ProfileDialog({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      title: const Center(child: Text("My Profile")),
      content: SizedBox(
        height: size.height * 0.50,
        width: size.width * 0.40,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Center(
              child: CircleAvatar(
                radius: size.height * 0.05,
                backgroundImage: AssetImage("assets/icons/profile.png"),
              ),
            ),

            Text("First Name", style: TextStyle(fontWeight: FontWeight.bold)),
            Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(10),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                color: Color(0xFF3A3B3C),
              ),
              child: Text(firstName),
            ),

            Text("Last Name"),
            Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(10),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                color: Color(0xFF3A3B3C),
              ),
              child: Text(lastName),
            ),

            Text("Email"),
            Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(10),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                color: Color(0xFF3A3B3C),
              ),
              child: Text(email),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Close"),
        ),
      ],
    );
  }
}
