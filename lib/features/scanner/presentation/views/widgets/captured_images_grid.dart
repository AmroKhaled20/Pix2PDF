import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:scanify_pdf/core/utils/app_router.dart';
import 'package:scanify_pdf/core/utils/app_spacing.dart';
import 'package:scanify_pdf/core/utils/constants.dart';
import 'package:scanify_pdf/core/utils/size_extensions.dart';
import 'package:scanify_pdf/core/utils/styles.dart';
import 'package:scanify_pdf/features/scanner/presentation/manager/scanner%20cubit/scanner_cubit.dart';

class CapturedImagesGrid extends StatelessWidget {
  const CapturedImagesGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScannerCubit, ScannerState>(
      builder: (context, state) {
        final images = context.read<ScannerCubit>().capturedImages;

        if (images.isEmpty) {
          return Center(
            child: Text(
              'No images added',
              style: Styles.textStyle18.copyWith(color: Colors.grey),
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s16,
            vertical: AppSpacing.s8,
          ),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: AppSpacing.s16,
            mainAxisSpacing: AppSpacing.s16,
            childAspectRatio: 0.75,
          ),
          itemCount: images.length + 2,
          itemBuilder: (context, index) {
            if (index == images.length) {
              return _buildAddButton(
                context: context,
                icon: Icons.photo_library_rounded,
                title: 'Gallery',
                onTap: () {
                  context.read<ScannerCubit>().pickImagesFromGallery();
                },
              );
            }

            if (index == images.length + 1) {
              return _buildAddButton(
                context: context,
                icon: Icons.camera_alt_rounded,
                title: 'Camera',
                onTap: () {
                  GoRouter.of(context).push(
                    AppRouter.kAddMoreCameraView,
                    extra: context.read<ScannerCubit>(),
                  );
                },
              );
            }

            return Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 5,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      File(images[index].imagePath),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: AppSpacing.s8,
                  right: AppSpacing.s8,
                  child: GestureDetector(
                    onTap: () {
                      final file = File(images[index].imagePath);
                      if (file.existsSync()) {
                        file.deleteSync();
                      }
                      context.read<ScannerCubit>().removeImage(index);

                      if (context.read<ScannerCubit>().capturedImages.isEmpty) {
                        GoRouter.of(context).pop();
                      }
                    },
                    child: Container(
                      width: context.w * 0.08,
                      height: context.w * 0.08,
                      decoration: const BoxDecoration(
                        color: Colors.redAccent,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildAddButton({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF202334),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: primaryColor.withOpacity(0.5), width: 1.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: primaryColor, size: 28),
            ),
            const SizedBox(height: AppSpacing.s16),
            Text(
              title,
              style: Styles.textStyle16.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
