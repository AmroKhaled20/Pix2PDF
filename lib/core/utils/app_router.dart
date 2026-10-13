import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:scanify_pdf/core/services/permission_service.dart';
import 'package:scanify_pdf/core/utils/service_locator.dart';
import 'package:scanify_pdf/features/home/presentation/views/files_view.dart';
import 'package:scanify_pdf/features/home/presentation/views/home_view.dart';
import 'package:scanify_pdf/features/scanner/presentation/manager/camera%20permission%20cubit/camera_permission_cubit.dart';
import 'package:scanify_pdf/features/scanner/presentation/manager/scanner%20cubit/scanner_cubit.dart';
import 'package:scanify_pdf/features/scanner/presentation/views/gallery_handler_view.dart';
import 'package:scanify_pdf/features/scanner/presentation/views/scanner_view.dart';
import 'package:scanify_pdf/features/scanner/presentation/views/captured_images_view.dart';
import 'package:scanify_pdf/features/scanner/presentation/views/widgets/scanner_view_body.dart';

abstract class AppRouter {
  static const kHomeView = '/homeView';
  static const kCameraView = '/cameraView';
  static const kFilesView = '/filesView';
  static const kCapturedImagesView = '/capturedImagesView';
  static const kGalleryHandlerView = '/galleryHandlerView';
  static const kAddMoreCameraView = '/addMoreCameraView';
  static final router = GoRouter(
    initialLocation: kHomeView,
    routes: [
      GoRoute(path: kHomeView, builder: (context, state) => const HomeView()),
      GoRoute(
        path: kCameraView,
        builder: (context, state) => const ScannerView(),
      ),
      GoRoute(
        path: kCapturedImagesView,
        builder: (context, state) {
          return BlocProvider.value(
            value: state.extra as ScannerCubit,
            child: const CapturedImagesView(),
          );
        },
      ),
      GoRoute(
        path: kGalleryHandlerView,
        builder: (context, state) => const GalleryHandlerView(),
      ),
      GoRoute(
        path: kAddMoreCameraView,
        builder: (context, state) {
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) =>
                    CameraPermissionCubit(getIt.get<PermissionService>()),
              ),
              BlocProvider.value(value: state.extra as ScannerCubit),
            ],
            child: const ScannerViewBody(),
          );
        },
      ),
      GoRoute(path: kFilesView, builder: (context, state) => const FilesView()),
    ],
  );
}
