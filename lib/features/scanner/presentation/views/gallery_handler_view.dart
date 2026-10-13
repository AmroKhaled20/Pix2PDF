import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:scanify_pdf/core/utils/app_router.dart';
import 'package:scanify_pdf/core/utils/service_locator.dart';
import 'package:scanify_pdf/features/scanner/domain/use_cases/clear_cached_images_use_case.dart';
import 'package:scanify_pdf/features/scanner/domain/use_cases/generate_and_save_pdf_use_case.dart';
import 'package:scanify_pdf/features/scanner/domain/use_cases/pick_images_from_gallery_use_case.dart';
import 'package:scanify_pdf/features/scanner/domain/use_cases/update_existing_pdf_use_case.dart';
import 'package:scanify_pdf/features/scanner/presentation/manager/scanner%20cubit/scanner_cubit.dart';

class GalleryHandlerView extends StatelessWidget {
  const GalleryHandlerView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ScannerCubit(
        generateAndSavePdfUseCase: getIt.get<GenerateAndSavePdfUseCase>(),
        clearCachedImagesUseCase: getIt.get<ClearCachedImagesUseCase>(),
        pickImagesFromGalleryUseCase: getIt.get<PickImagesFromGalleryUseCase>(),
        updateExistingPdfUseCase: getIt.get<UpdateExistingPdfUseCase>(),
      )..pickImagesFromGallery(),
      child: const _GalleryHandlerBody(),
    );
  }
}

class _GalleryHandlerBody extends StatelessWidget {
  const _GalleryHandlerBody();

  @override
  Widget build(BuildContext context) {
    return BlocListener<ScannerCubit, ScannerState>(
      listener: (context, state) {
        if (state is ScannerImagesUpdated) {
          if (state.images.isNotEmpty) {
            GoRouter.of(context).push(
              AppRouter.kCapturedImagesView,
              extra: context.read<ScannerCubit>(),
            );
          } else {
            GoRouter.of(context).pop();
          }
        } else if (state is ScannerPdfGenerationError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
          GoRouter.of(context).pop();
        }
      },
      child: const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
