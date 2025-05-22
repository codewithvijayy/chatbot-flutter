import 'package:chatbot/server/chatweb_services.dart';
import 'package:chatbot/server/server.dart';
import 'package:chatbot/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchSection extends ConsumerStatefulWidget {
  const SearchSection({super.key});

  @override
  ConsumerState<SearchSection> createState() => _SearchSectionState();
}

class _SearchSectionState extends ConsumerState<SearchSection> {
  final queryController = TextEditingController();
  bool hasQueried = false;
  @override
  void dispose() {
    super.dispose();
    queryController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final message = ref.watch(chatProvider);
    final size = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (!hasQueried)
          Text(
            'What can I help with?',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: size.width * 0.03,
            ),
          ),
        SizedBox(height: size.height * 0.03),
        Container(
          width: size.width * 0.50,
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
    );
  }
}
