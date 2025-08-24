import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:tipme_app/routs/app_routs.dart';
import 'package:tipme_app/utils/app_font.dart';
import 'package:tipme_app/utils/colors.dart';
import '../../data/services/language_service.dart';

class StepsScreen extends StatefulWidget {
  const StepsScreen({Key? key}) : super(key: key);

  @override
  State<StepsScreen> createState() => _StepsScreenState();
}

class _StepsScreenState extends State<StepsScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isFinalStepExpanded = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final languageService = Provider.of<LanguageService>(context);
    final steps = languageService.getSteps();

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = constraints.maxWidth < 600;
            final isTablet =
                constraints.maxWidth >= 600 && constraints.maxWidth < 900;

            return Stack(
              children: [
                Column(
                  children: [
                    SizedBox(height: isMobile ? 44 : 60),

                    // Dynamic Images Section
                    _buildImageSection(context, steps, isMobile, isTablet),

                    // Dynamic Bottom Section
                    _buildBottomSection(context, steps, isMobile, isTablet),
                  ],
                ),

                // Skip Button
                Positioned(
                  top: isMobile ? 24 : 32,
                  right: isMobile ? 20 : 32,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pushNamed(
                      AppRoutes.signInUp,
                    ),
                    child: Text(
                      languageService.getText('skip'),
                      style:
                          AppFonts.mdBold(context, color: AppColors.secondary),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildImageSection(BuildContext context,
      List<Map<String, String>> steps, bool isMobile, bool isTablet) {
    final screenHeight = MediaQuery.of(context).size.height;
    //= width of above side of WelcomeScreen
    final imageSectionHeight = screenHeight * 0.55 - (isMobile ? 44 : 60);

    return SizedBox(
      height: imageSectionHeight,
      child: PageView.builder(
        controller: _pageController,
        itemCount: steps.length,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
            _isFinalStepExpanded = false;
          });
        },
        itemBuilder: (context, index) {
          return _buildStepImage(
              steps[index]["image"]!, index, isMobile, isTablet);
        },
      ),
    );
  }

  Widget _buildStepImage(
      String imagePath, int index, bool isMobile, bool isTablet) {
    if (index == 1) {
      return Align(
        alignment: Alignment.bottomLeft,
        child: Padding(
          padding: EdgeInsets.only(bottom: isMobile ? 0 : 20),
          child: Image.asset(
            imagePath,
            fit: BoxFit.contain,
            alignment: Alignment.bottomLeft,
            height: isMobile ? 350 : 400,
          ),
        ),
      );
    } else {
      return Center(
        child: Image.asset(
          imagePath,
          fit: BoxFit.contain,
          height: isMobile ? 300 : 350,
        ),
      );
    }
  }

  Widget _buildBottomSection(BuildContext context,
      List<Map<String, String>> steps, bool isMobile, bool isTablet) {
    final bottomHeight = MediaQuery.of(context).size.height * 0.45;

    return Container(
      height: bottomHeight,
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 40,
        vertical: isMobile ? 32 : 40,
      ),
      decoration: const BoxDecoration(
        color: AppColors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Text(
                steps[_currentPage]["title"]!,
                style: AppFonts.h3(context, color: AppColors.black),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: isMobile ? 12 : 16),
              Text(
                steps[_currentPage]["description"]!,
                textAlign: TextAlign.center,
                style: AppFonts.mdMedium(context, color: AppColors.text),
              ),
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              steps.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: EdgeInsets.symmetric(horizontal: isMobile ? 5 : 6),
                height: isMobile ? 8 : 10,
                width: _currentPage == index
                    ? (isMobile ? 24 : 30)
                    : (isMobile ? 8 : 10),
                decoration: BoxDecoration(
                  color: _currentPage == index
                      ? AppColors.primary
                      : AppColors.gray_bg_2,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),

          // Next/Create Account Button
          _buildActionButton(context, steps.length, isMobile, isTablet),
        ],
      ),
    );
  }

  Widget _buildActionButton(
      BuildContext context, int stepsCount, bool isMobile, bool isTablet) {
    final languageService = Provider.of<LanguageService>(context);
    final buttonSize = isMobile ? 70.0 : (isTablet ? 80.0 : 90.0);
    final expandedWidth = isMobile ? 205.0 : (isTablet ? 240.0 : 260.0);

    return SizedBox(
      height: buttonSize,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: _currentPage == stepsCount - 1
            ? GestureDetector(
                key: ValueKey(_isFinalStepExpanded),
                onTap: () {
                  if (!_isFinalStepExpanded) {
                    setState(() {
                      _isFinalStepExpanded = true;
                    });
                  } else {
                    Navigator.of(context).pushNamed(
                      AppRoutes.signInUp,
                    );
                  }
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (!_isFinalStepExpanded)
                      SizedBox(
                        width: buttonSize,
                        height: buttonSize,
                        child: const CircularProgressIndicator(
                          value: 1.0,
                          strokeWidth: 4,
                          valueColor: AlwaysStoppedAnimation(AppColors.primary),
                          backgroundColor: AppColors.gray_bg_2,
                        ),
                      ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 1000),
                      curve: Curves.easeInOut,
                      width: _isFinalStepExpanded
                          ? expandedWidth
                          : buttonSize * 0.8,
                      height: _isFinalStepExpanded
                          ? buttonSize * 0.7
                          : buttonSize * 0.8,
                      decoration: BoxDecoration(
                        color: AppColors.secondary,
                        borderRadius: _isFinalStepExpanded
                            ? BorderRadius.circular(30)
                            : BorderRadius.circular(28),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (_isFinalStepExpanded)
                              Padding(
                                padding:
                                    EdgeInsets.only(left: isMobile ? 8 : 12),
                                child: Text(
                                  languageService.getText('createAccount'),
                                  style: AppFonts.mdBold(context,
                                      color: AppColors.white),
                                ),
                              ),
                            if (_isFinalStepExpanded)
                              SizedBox(width: isMobile ? 10 : 12),
                            SvgPicture.asset(
                              'assets/icons/arrow-right.svg',
                              width: isMobile ? 20 : 24,
                              height: isMobile ? 20 : 24,
                              colorFilter: const ColorFilter.mode(
                                AppColors.white,
                                BlendMode.srcIn,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : GestureDetector(
                onTap: () {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                  );
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: buttonSize,
                      height: buttonSize,
                      child: CircularProgressIndicator(
                        value: (_currentPage + 1) / stepsCount,
                        strokeWidth: 4,
                        valueColor:
                            const AlwaysStoppedAnimation(AppColors.primary),
                        backgroundColor: AppColors.gray_bg_2,
                      ),
                    ),
                    CircleAvatar(
                      radius: buttonSize * 0.4,
                      backgroundColor: AppColors.secondary,
                      child: SvgPicture.asset(
                        'assets/icons/arrow-right.svg',
                        width: isMobile ? 20 : 24,
                        height: isMobile ? 20 : 24,
                        colorFilter: const ColorFilter.mode(
                          AppColors.white,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
