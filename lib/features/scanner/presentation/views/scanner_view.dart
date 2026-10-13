import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scanify_pdf/core/services/permission_service.dart';
import 'package:scanify_pdf/core/utils/service_locator.dart';
import 'package:scanify_pdf/features/scanner/domain/use_cases/clear_cached_images_use_case.dart';
import 'package:scanify_pdf/features/scanner/domain/use_cases/generate_and_save_pdf_use_case.dart';
import 'package:scanify_pdf/features/scanner/domain/use_cases/pick_images_from_gallery_use_case.dart';
import 'package:scanify_pdf/features/scanner/domain/use_cases/update_existing_pdf_use_case.dart';
import 'package:scanify_pdf/features/scanner/presentation/manager/camera%20permission%20cubit/camera_permission_cubit.dart';
import 'package:scanify_pdf/features/scanner/presentation/manager/scanner%20cubit/scanner_cubit.dart';
import 'package:scanify_pdf/features/scanner/presentation/views/widgets/scanner_view_body.dart';

class ScannerView extends StatelessWidget {
  const ScannerView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              CameraPermissionCubit(getIt.get<PermissionService>()),
        ),
        BlocProvider(
          create: (context) => ScannerCubit(
            generateAndSavePdfUseCase: getIt.get<GenerateAndSavePdfUseCase>(),
            clearCachedImagesUseCase: getIt.get<ClearCachedImagesUseCase>(),
            pickImagesFromGalleryUseCase: getIt
                .get<PickImagesFromGalleryUseCase>(),
            updateExistingPdfUseCase: getIt.get<UpdateExistingPdfUseCase>(),
          ),
        ),
      ],
      child: const ScannerViewBody(),
    );
  }
}
