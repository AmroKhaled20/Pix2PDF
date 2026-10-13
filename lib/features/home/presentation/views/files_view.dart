import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scanify_pdf/core/utils/app_spacing.dart';
import 'package:scanify_pdf/features/home/presentation/manager/home%20cubit/home_cubit.dart';
import 'package:scanify_pdf/features/home/presentation/views/pdf_viewer_view.dart';
import 'package:scanify_pdf/features/home/presentation/views/widgets/pdf_item_widget.dart';
import 'package:scanify_pdf/features/home/presentation/views/widgets/bottom_bar.dart';
import 'package:scanify_pdf/core/widgets/custom_app_bar.dart';

class FilesView extends StatelessWidget {
  const FilesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1019),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              const CustomAppBar(title: 'All Files'),

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
                            hasFiles ? 'File Not found' : 'No Files Added Yet',
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

                          return GestureDetector(
                            onTap: () {
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
                            },
                            child: PdfItemWidget(pdfFile: file),
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
    );
  }
}
