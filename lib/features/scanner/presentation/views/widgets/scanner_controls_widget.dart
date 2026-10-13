import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:scanify_pdf/core/utils/app_router.dart';
import 'package:scanify_pdf/features/scanner/presentation/manager/scanner%20cubit/scanner_cubit.dart';

class ScannerControlsWidget extends StatelessWidget {
  final CameraController cameraController;

  const ScannerControlsWidget({super.key, required this.cameraController});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        color: Colors.black.withOpacity(0.5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BlocBuilder<ScannerCubit, ScannerState>(
              builder: (context, state) {
                final capturedImages = context
                    .read<ScannerCubit>()
                    .capturedImages;

                final count = capturedImages.length;

                String? lastImagePath;

                if (count > 0) {
                  lastImagePath = capturedImages.last.imagePath;
                }

                return GestureDetector(
                  onTap: () {
                    if (count > 0) {
                      final currentPath = ModalRoute.of(context)?.settings.name;

                      if (currentPath == AppRouter.kAddMoreCameraView) {
                        GoRouter.of(context).pop();
                      } else {
                        GoRouter.of(context).push(
                          AppRouter.kCapturedImagesView,
                          extra: context.read<ScannerCubit>(),
                        );
                      }
                    }
                  },
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white24),
                      image: lastImagePath != null
                          ? DecorationImage(
                              image: ResizeImage(
                                FileImage(File(lastImagePath)),
                                width: 150,
                              ),
                              fit: BoxFit.cover,
                              colorFilter: ColorFilter.mode(
                                Colors.black.withOpacity(0.5),
                                BlendMode.darken,
                              ),
                            )
                          : null,
                    ),
                    child: count > 0
                        ? Center(
                            child: Text(
                              '$count',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        : const Icon(Icons.photo_library, color: Colors.white),
                  ),
                );
              },
            ),
            GestureDetector(
              onTap: () async {
                try {
                  if (!cameraController.value.isInitialized) return;

                  final image = await cameraController.takePicture();

                  if (context.mounted) {
                    context.read<ScannerCubit>().addImage(image.path);
                  }
                } catch (e) {
                  debugPrint('Error taking picture: $e');
                }
              },
              child: Container(
                width: 75,
                height: 75,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4),
                  color: Colors.white.withOpacity(0.2),
                ),
              ),
            ),
            const SizedBox(width: 60),
          ],
        ),
      ),
    );
  }
}
