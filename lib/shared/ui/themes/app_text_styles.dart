// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:google_fonts/google_fonts.dart';

// 🌎 Project imports:
import '../../extensions/context_theme_mode_extensions.dart';
import 'app_colors.dart';

class TextStyles {
  BuildContext context;

  TextStyles(this.context);

  /// `fontSize:` 30,
  ///
  /// `fontWeight:` FontWeight.w600,
  ///
  /// `color:`
  ///
  /// ![585666](https://www.colorhexa.com/585666.png)
  static final titleHome = GoogleFonts.ubuntu(
    fontSize: 30,
    fontWeight: FontWeight.w600,
    // // color: AppColors.heading,
  );

  /// `fontSize:` 30,
  ///
  /// `fontWeight:` FontWeight.normal,
  ///
  /// `color:`
  ///
  /// ![585666](https://www.colorhexa.com/585666.png)
  static final titleHomeRegular = GoogleFonts.ubuntu(
    fontSize: 30,
    // color: AppColors.heading,
  );

  /// `fontSize:` 14,
  ///
  /// `fontWeight:` FontWeight.normal,
  ///
  /// `color:` "onSurface"
  ///
  /// ![585666](https://www.colorhexa.com/585666.png)
  get detailRegular => GoogleFonts.ubuntu(
        fontSize: 14,
        color: context.getApplyedColorScheme.onSurface,
      );

  /// `fontSize:` 20,
  ///
  /// `fontWeight:` FontWeight.normal,
  ///
  /// `color:`
  ///
  /// ![585666](https://www.colorhexa.com/585666.png)
  static final informationRegular = GoogleFonts.ubuntu(
    fontSize: 20,
    // color: AppColors.heading,
  );

  /// `fontSize:` 14,
  ///
  /// `fontWeight:` FontWeight.w700,
  ///
  /// `color:`
  ///
  /// ![544F4F](https://www.colorhexa.com/544F4F.png)
  static final detailBold = GoogleFonts.ubuntu(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    // color: AppColors.greySweet, //TODO: COLOR-FIX
  );

  /// `fontSize:` 18,
  ///
  /// `fontWeight:` FontWeight.normal,
  ///
  /// `color:`
  ///
  /// ![585666](https://www.colorhexa.com/585666.png)
  static final termRegular = GoogleFonts.ubuntu(
    fontSize: 18,
    // color: AppColors.greySweet, //TODO: COLOR-FIX
  );

  //* Revisado
  static final link = GoogleFonts.ubuntu(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
  );

  static final buttonPrimary = GoogleFonts.ubuntu(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.primary,
  );

  get buttonBackground => GoogleFonts.ubuntu(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: context.getApplyedColorScheme.onPrimary,
      );

  get buttonBackgroundOnLightOrSurface => GoogleFonts.ubuntu(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: context.getApplyedColorScheme.surfaceTint,
      );

  static final bodyMinRegular = GoogleFonts.ubuntu(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    // color: AppColors.body,
  );
  static final bodyMinBold = GoogleFonts.ubuntu(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    // color: AppColors.body,
  );
  get bodyRegular => GoogleFonts.ubuntu(
        fontSize: 18,
        fontWeight: FontWeight.w400,
        color: context.getApplyedColorScheme.onSurface,
      );
  static final bodyBold = GoogleFonts.ubuntu(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    // color: AppColors.body,
  );

  static final informationExperimentStepTitle = GoogleFonts.ubuntu(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    // color: AppColors.heading,
  );

  static final informationExperimentStepMessage = GoogleFonts.ubuntu(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    // color: AppColors.body,
  );

  static final titleMinRegular = GoogleFonts.ubuntu(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    // color: AppColors.white,
  );
  static final titleMinBoldHeading = GoogleFonts.ubuntu(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    // color: AppColors.heading,
  );
  static final titleMinBoldBackground = GoogleFonts.ubuntu(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static final titleRegular = GoogleFonts.ubuntu(
    fontSize: 20,
    fontWeight: FontWeight.w400,
    // color: AppColors.white,
  );
  get titleBoldHeading => GoogleFonts.ubuntu(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: context.getApplyedColorScheme.inverseSurface,
      );

  get titleMoreBoldHeadingColored => GoogleFonts.ubuntu(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: context.getApplyedColorScheme.primary,
      );

  /// `fontSize:` 20,
  ///
  /// `fontWeight:` FontWeight.w600,
  ///
  /// `color:` AppColors.background,
  titleBoldBackground({double? fontSize, FontWeight? fontWeight}) =>
      GoogleFonts.ubuntu(
        fontSize: fontSize ?? 20,
        fontWeight: fontWeight ?? FontWeight.w600,
        color: context.getApplyedColorScheme.onBackground,
      );
  static final titleListTile = GoogleFonts.ubuntu(
    fontSize: 17,
    fontWeight: FontWeight.w600,
    // color: AppColors.heading,
  );
  trailingRegular({bool isBold = false, FontStyle? fontStyle, Color? color}) =>
      GoogleFonts.ubuntu(
        fontSize: 16,
        fontStyle: fontStyle,
        fontWeight: isBold ? FontWeight.bold : FontWeight.w400,
        color: color ?? context.getApplyedColorScheme.inverseSurface,
      );
  static final trailingBold = GoogleFonts.ubuntu(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    // color: AppColors.heading,
  );
  static final xbuttonPrimary = GoogleFonts.ubuntu(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColors.primary,
  );
  static final buttonHeading = GoogleFonts.ubuntu(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    // color: AppColors.heading,
  );
  static final buttonGray = GoogleFonts.ubuntu(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    // color: AppColors.grey, //TODO: COLOR-FIX
  );

  get buttonBoldPrimary => GoogleFonts.ubuntu(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: context.getApplyedColorScheme.primary,
      );
  get buttonBoldHeading => GoogleFonts.ubuntu(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: context.getApplyedColorScheme.onSurfaceVariant,
      );
  static final buttonBoldGray = GoogleFonts.ubuntu(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    // color: AppColors.grey, //TODO: COLOR-FIX
  );
  static final buttonBold = GoogleFonts.ubuntu(
    fontSize: 15,
    fontWeight: FontWeight.w700,
  );
  get buttonBoldBackground => GoogleFonts.ubuntu(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: context.getApplyedColorScheme.onPrimary,
      );
  static final captionBackground = GoogleFonts.ubuntu(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    // color: AppColors.white,
  );
  static final captionShape = GoogleFonts.ubuntu(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    // color: AppColors.shape, //TODO: COLOR-FIX
  );
  static final captionBody = GoogleFonts.ubuntu(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    // color: AppColors.body,
  );
  static final captionBoldBackground = GoogleFonts.ubuntu(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    // color: AppColors.white,
  );
  static final captionBoldShape = GoogleFonts.ubuntu(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    // color: AppColors.shape, //TODO: COLOR-FIX
  );
  static final captionBoldBody = GoogleFonts.ubuntu(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    // color: AppColors.body,
  );

  // Card Expandable
  static final titleCardExp = GoogleFonts.ubuntu(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    // color: AppColors.body,
  );

  static final bodyCardExp = GoogleFonts.ubuntu(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    // color: AppColors.body,
  );
}
