import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:scanify_pdf/core/utils/app_router.dart';
import 'package:scanify_pdf/core/utils/constants.dart';

class BottomBar extends StatelessWidget {
  final int currentIndex;

  const BottomBar({super.key, this.currentIndex = 0});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      clipBehavior: Clip.antiAlias,
      color: const Color(0xFF0D1019),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: () {
              if (currentIndex != 0) {
                GoRouter.of(context).go(AppRouter.kHomeView);
              }
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.home,
                  color: currentIndex == 0 ? primaryColor : Colors.grey,
                ),
                Text(
                  'Home',
                  style: TextStyle(
                    color: currentIndex == 0 ? primaryColor : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 48),
          GestureDetector(
            onTap: () {
              if (currentIndex != 1) {
                GoRouter.of(context).push(AppRouter.kFilesView);
              }
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.file_copy,
                  color: currentIndex == 1 ? primaryColor : Colors.grey,
                ),
                Text(
                  'Files',
                  style: TextStyle(
                    color: currentIndex == 1 ? primaryColor : Colors.grey,
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
