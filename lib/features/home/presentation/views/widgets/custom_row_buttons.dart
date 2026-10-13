import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:scanify_pdf/core/utils/app_router.dart';
import 'package:scanify_pdf/features/home/presentation/views/widgets/custom_button.dart';
import 'package:scanify_pdf/features/scanner/presentation/manager/camera%20permission%20cubit/camera_permission_cubit.dart';

class CustomRowButtons extends StatelessWidget {
  const CustomRowButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.15,
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CustomButton(
            imagePath: 'assets/icons/pdf.png',
            label: 'Image to PDF',
            onTap: () {
              GoRouter.of(context).push(AppRouter.kGalleryHandlerView);
            },
          ),

          BlocListener<CameraPermissionCubit, CameraPermissionState>(
            listener: (context, state) {
              if (state is CameraPermissionGranted) {
                GoRouter.of(context).push(AppRouter.kCameraView);
              } else if (state is CameraPermissionDenied) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Camera permission is required to scan documents',
                    ),
                  ),
                );
              }
            },
            child: CustomButton(
              imagePath: 'assets/icons/scan.png',
              label: 'Scan',
              onTap: () {
                context.read<CameraPermissionCubit>().requestPermission();
              },
            ),
          ),
        ],
      ),
    );
  }
}
