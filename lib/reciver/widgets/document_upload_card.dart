//lib\reciver\auth\widgets\document_upload_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../utils/colors.dart';
import '../../utils/app_font.dart';
import '../../data/services/language_service.dart';

enum UploadState { idle, uploading, completed, showingCheck }

class DocumentUploadCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final UploadState uploadState;
  final double uploadProgress;
  final String? fileName;
  final VoidCallback onUpload;
  final VoidCallback? onDelete;

  const DocumentUploadCard({
    Key? key,
    required this.title,
    required this.subtitle,
    this.uploadState = UploadState.idle,
    this.uploadProgress = 0.0,
    this.fileName,
    required this.onUpload,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 36),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F8FB),
        border: Border.all(color: const Color(0xFFF0F0F0)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: AppFonts.mdSemiBold(context, color: AppColors.black),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: AppFonts.xsMedium(context, color: AppColors.text),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          _buildUploadButton(context),
        ],
      ),
    );
  }

  Widget _buildUploadButton(BuildContext context) {
    final languageService = Provider.of<LanguageService>(context);

    switch (uploadState) {
      case UploadState.idle:
        return GestureDetector(
          onTap: onUpload,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 7),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Text(
              languageService.getText('upload'),
              style: AppFonts.smSemiBold(context, color: AppColors.white),
            ),
          ),
        );

      case UploadState.uploading:
        return SizedBox(
          width: 60,
          height: 60,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(
                  value: uploadProgress / 100,
                  strokeWidth: 3,
                  backgroundColor: const Color(0xFF05CBE7).withOpacity(0.2),
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(Color(0xFF05CBE7)),
                ),
              ),
              Text(
                '${uploadProgress.toInt()}%',
                style: AppFonts.h5(context, color: AppColors.primary),
              ),
            ],
          ),
        );

      case UploadState.showingCheck:
        return Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.success_400,
              width: 3,
            ),
            color: Colors.transparent,
          ),
          child: const Icon(
            Icons.check,
            size: 30,
            color: AppColors.success_400,
          ),
        );

      case UploadState.completed:
        return fileName != null
            ? LayoutBuilder(
                builder: (context, constraints) {
                  final subtitleText = languageService
                      .getText('supportedFormats')
                      .split(
                          '\n')[0]; // Get first line only for width calculation
                  final textPainter = TextPainter(
                    text: TextSpan(
                      text: subtitleText,
                      style: AppFonts.xsMedium(context, color: AppColors.text),
                    ),
                    maxLines: 1,
                    textDirection: TextDirection.ltr,
                  )..layout();

                  final subtitleWidth = textPainter.width;

                  return Container(
                    width: subtitleWidth,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFE5E5E5)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            fileName!,
                            style: AppFonts.xsMedium(context,
                                color: AppColors.text),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: onDelete,
                          child: SvgPicture.asset(
                            'assets/icons/trash.svg',
                            width: 20,
                            height: 20,
                            colorFilter: const ColorFilter.mode(
                              Colors.red,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              )
            : Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.success_400,
                    width: 3,
                  ),
                  color: Colors.transparent,
                ),
                child: const Icon(
                  Icons.check,
                  size: 30,
                  color: AppColors.success_400,
                ),
              );
    }
  }
}
