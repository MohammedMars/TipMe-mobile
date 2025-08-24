//lib\reciver\auth\screens\profile\document_upload.dart
//lib\reciver\auth\screens\profile\document_upload.dart
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import 'package:tipme_app/providersChangeNotifier/profileSetupProvider.dart';
import 'package:tipme_app/utils/app_font.dart';
import 'package:tipme_app/utils/colors.dart';
import '../../../routs/app_routs.dart';
import '../../../data/services/language_service.dart';
import '../../widgets/onboarding_layout.dart';
import '../../widgets/document_upload_card.dart';
import '../../widgets/info_message.dart';
import '../../widgets/progress_next_button.dart';

class DocumentUploadPage extends StatefulWidget {
  const DocumentUploadPage({Key? key}) : super(key: key);

  @override
  State<DocumentUploadPage> createState() => _DocumentUploadPageState();
}

class _DocumentUploadPageState extends State<DocumentUploadPage> {
  UploadState _frontSideState = UploadState.idle;
  UploadState _backSideState = UploadState.idle;
  double _frontSideProgress = 0.0;
  double _backSideProgress = 0.0;
  File? _frontSideFileName;
  File? _backSideFileName;

  bool get _canProceed =>
      _frontSideState == UploadState.completed &&
      _backSideState == UploadState.completed;

  Future<void> _uploadFile(bool isFrontSide) async {
    final languageService =
        Provider.of<LanguageService>(context, listen: false);

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png', 'doc', 'docx'],
        withData: kIsWeb,
      );

      if (result != null) {
        PlatformFile file = result.files.first;

        if (file.size > 5 * 1024 * 1024) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(languageService.getText('fileSizeError')),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        setState(() {
          if (isFrontSide) {
            _frontSideState = UploadState.uploading;
            _frontSideProgress = 0.0;
          } else {
            _backSideState = UploadState.uploading;
            _backSideProgress = 0.0;
          }
        });

        Timer.periodic(const Duration(milliseconds: 100), (timer) {
          setState(() {
            if (isFrontSide) {
              _frontSideProgress += 10;
              if (_frontSideProgress >= 100) {
                _frontSideProgress = 100;
                timer.cancel();
                _frontSideState = UploadState.showingCheck;
                Future.delayed(const Duration(milliseconds: 500), () {
                  setState(() {
                    _frontSideState = UploadState.completed;
                    if (kIsWeb) {
                      context.read<ProfileSetupProvider>().update(
                            frontSideOfDocumentIdBytes: file.bytes,
                          );
                      _frontSideFileName = null;
                    } else {
                      _frontSideFileName =
                          file.path != null ? File(file.path!) : null;
                    }
                  });
                });
              }
            } else {
              _backSideProgress += 10;
              if (_backSideProgress >= 100) {
                _backSideProgress = 100;
                timer.cancel();
                _backSideState = UploadState.showingCheck;
                Future.delayed(const Duration(milliseconds: 500), () {
                  setState(() {
                    _backSideState = UploadState.completed;
                    if (kIsWeb) {
                      context.read<ProfileSetupProvider>().update(
                            backSideOfDocumentIdBytes: file.bytes,
                          );
                      _backSideFileName = null;
                    } else {
                      _backSideFileName =
                          file.path != null ? File(file.path!) : null;
                    }
                  });
                });
              }
            }
          });
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${languageService.getText('fileUploadError')} $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _deleteFile(bool isFrontSide) {
    setState(() {
      if (isFrontSide) {
        _frontSideState = UploadState.idle;
        _frontSideProgress = 0.0;
        _frontSideFileName = null;
      } else {
        _backSideState = UploadState.idle;
        _backSideProgress = 0.0;
        _backSideFileName = null;
      }
    });
  }

  void _onNext() {
    if (_canProceed) {
      final provider =
          Provider.of<ProfileSetupProvider>(context, listen: false);
      provider.update(
        frontSideOfDocumentId: _frontSideFileName,
        backSideOfDocumentId: _backSideFileName,
      );
      Navigator.of(context).pushNamed(
        AppRoutes.addBankAccount,
      );
    }
  }

  Widget _buildHeaderComponent() {
    return Builder(
      builder: (context) {
        final languageService = Provider.of<LanguageService>(context);
        final screenSize = MediaQuery.of(context).size;
        final isTablet = screenSize.width > 600;

        return Container(
          constraints: BoxConstraints(
            maxWidth: isTablet ? 400 : screenSize.width - 48,
          ),
          child: Text(
            languageService.getText('uploadDocumentsSubtitle'),
            style: AppFonts.mdMedium(context,
                color: AppColors.white.withOpacity(0.9)),
            textAlign: TextAlign.center,
            maxLines: 3,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final languageService = Provider.of<LanguageService>(context);

    return OnboardingLayout(
      step: 3,
      totalSteps: 5,
      title: languageService.getText('uploadRequiredDocuments'),
      headerComponent: _buildHeaderComponent(),
      content: _buildDocumentUploadContent(),
      nextButton: ProgressNextButton(
        onPressed: _canProceed ? _onNext : null,
        isEnabled: _canProceed,
        currentStep: 3,
        totalSteps: 5,
      ),
      topPadding: 16.0,
      bottomPadding: 48.0,
    );
  }

  Widget _buildDocumentUploadContent() {
    final languageService = Provider.of<LanguageService>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          languageService.getText('nationalIdPassportResidency'),
          style: AppFonts.mdBold(context, color: AppColors.black),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          languageService.getText('uploadBothSidesMessage'),
          style: AppFonts.xsMedium(context, color: AppColors.black),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: DocumentUploadCard(
                title: languageService.getText('frontSide'),
                subtitle: languageService.getText('supportedFormats'),
                uploadState: _frontSideState,
                uploadProgress: _frontSideProgress,
                fileName: _frontSideFileName?.path.split('/').last,
                onUpload: () => _uploadFile(true),
                onDelete: () => _deleteFile(true),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: DocumentUploadCard(
                title: languageService.getText('backSide'),
                subtitle: languageService.getText('supportedFormats'),
                uploadState: _backSideState,
                uploadProgress: _backSideProgress,
                fileName: _backSideFileName?.path.split('/').last,
                onUpload: () => _uploadFile(false),
                onDelete: () => _deleteFile(false),
              ),
            ),
          ],
        ),
        const SizedBox(height: 56),
        InfoMessage(
          message: languageService.getText('documentsWarningMessage'),
        ),
        const SizedBox(height: 80),
      ],
    );
  }
}
