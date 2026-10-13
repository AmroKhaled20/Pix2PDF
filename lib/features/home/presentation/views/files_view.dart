import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scanify_pdf/core/services/permission_service.dart';
import 'package:scanify_pdf/core/utils/app_spacing.dart';
import 'package:scanify_pdf/core/utils/service_locator.dart';
import 'package:scanify_pdf/core/widgets/custom_app_bar.dart';
import 'package:scanify_pdf/features/home/presentation/manager/home%20cubit/home_cubit.dart';
import 'package:scanify_pdf/features/home/presentation/views/pdf_viewer_view.dart';
import 'package:scanify_pdf/features/home/presentation/views/widgets/bottom_bar.dart';
import 'package:scanify_pdf/features/home/presentation/views/widgets/pdf_item_widget.dart';
import 'package:scanify_pdf/features/scanner/presentation/manager/camera%20permission%20cubit/camera_permission_cubit.dart';

class FilesView extends StatelessWidget {
  const FilesView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              CameraPermissionCubit(getIt.get<PermissionService>()),
        ),
      ],
      child: Scaffold(
        backgroundColor: const Color(0xFF0D1019),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),

                BlocBuilder<HomeCubit, HomeState>(
                  builder: (context, state) {
                    final cubit = context.read<HomeCubit>();

                    if (cubit.isSelectionMode) {
                      return SizedBox(
                        height: 40,
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              ),
                              onPressed: () => cubit.clearSelection(),
                            ),
                            Text(
                              '${cubit.selectedFilesIds.length} Selected',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                _showMultiDeleteDialog(
                                  context,
                                  cubit.selectedFilesIds.length,
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.select_all,
                                color: Colors.white,
                              ),
                              onPressed: () => cubit.selectAll(),
                            ),
                          ],
                        ),
                      );
                    }

                    return const CustomAppBar(title: 'All Files');
                  },
                ),

                const SizedBox(height: 24),

                Expanded(
                  child: BlocBuilder<HomeCubit, HomeState>(
                    builder: (context, state) {
                      if (state is HomeLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is HomeFailure) {
                        return Center(
                          child: Text(
                            state.errorMessage,
                            style: const TextStyle(color: Colors.red),
                          ),
                        );
                      } else if (state is HomeSuccess) {
                        if (state.files.isEmpty) {
                          final hasFiles = context
                              .read<HomeCubit>()
                              .allFiles
                              .isNotEmpty;

                          return Center(
                            child: Text(
                              hasFiles
                                  ? 'File Not found'
                                  : 'No Files Added Yet',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                          );
                        }

                        return ListView.builder(
                          itemCount: state.files.length,
                          itemBuilder: (context, index) {
                            final file = state.files[index];
                            final cubit = context.read<HomeCubit>();
                            final isSelected = cubit.selectedFilesIds.contains(
                              file.id,
                            );

                            return GestureDetector(
                              onLongPress: () {
                                if (!cubit.isSelectionMode) {
                                  cubit.enableSelectionMode(file.id);
                                }
                              },
                              onTap: () {
                                if (cubit.isSelectionMode) {
                                  cubit.toggleFileSelection(file.id);
                                } else {
                                  if (file.pdfPath.isNotEmpty) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PdfViewerView(
                                          filePath: file.pdfPath,
                                          fileName: file.name,
                                        ),
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'PDF file path is not available',
                                        ),
                                      ),
                                    );
                                  }
                                }
                              },
                              child: PdfItemWidget(
                                pdfFile: file,
                                isSelectionMode: cubit.isSelectionMode,
                                isSelected: isSelected,
                              ),
                            );
                          },
                        );
                      }

                      return const SizedBox();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: const BottomBar(currentIndex: 1),
      ),
    );
  }

  void _showMultiDeleteDialog(BuildContext context, int count) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF202334),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Delete Files',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          content: Text(
            'Are you sure you want to delete $count selected files?',
            style: const TextStyle(color: Colors.grey, fontSize: 16),
          ),
          actionsPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(
                        color: Color(0xFF8E94B8),
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: const Text(
                      'CANCEL',
                      style: TextStyle(
                        color: Color(0xFF8E94B8),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<HomeCubit>().deleteSelectedFiles();
                      Navigator.pop(dialogContext);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5A67D8),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: const Text(
                      'DELETE',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
