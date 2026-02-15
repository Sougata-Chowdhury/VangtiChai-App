/// App dimension constants for VangtiChai
/// Target devices: Pixel XL (411x731dp) and Nexus 10 (800x1280dp)
class AppDimensions {
  // Screen size breakpoints
  static const double tabletBreakpoint = 600.0;  // dp
  static const double largeTabletBreakpoint = 900.0;  // dp
  
  // Specific device dimensions
  static const double pixelXLWidth = 411.0;  // dp
  static const double pixelXLHeight = 731.0;  // dp
  static const double nexus10Width = 800.0;  // dp
  static const double nexus10Height = 1280.0;  // dp
  
  // Font sizes
  static const double titleFontSizePhone = 24.0;
  static const double titleFontSizeTablet = 28.0;
  static const double titleFontSizeLargeTablet = 32.0;
  
  static const double tableFontSizePhone = 18.0;
  static const double tableFontSizeTablet = 22.0;
  static const double tableFontSizeLargeTablet = 24.0;
  
  // Button dimensions
  static const double minButtonSizePhone = 45.0;
  // Allow a smaller min when space is tight (phones in landscape)
  static const double minButtonSizePhoneSmall = 36.0;
  static const double minButtonSizeTablet = 55.0;
  static const double minButtonSizeLargeTablet = 70.0;
  
  static const double maxButtonSize = 100.0;
  static const double buttonFontRatio = 0.35;
  static const double clearButtonFontRatio = 0.18;
  
  // Spacing and padding
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 12.0;
  static const double paddingLarge = 16.0;
  static const double paddingExtraLarge = 20.0;
  
  static const double spacingSmall = 8.0;
  static const double spacingMedium = 12.0;
  static const double spacingLarge = 16.0;
  
  // Layout proportions
  static const int portraitTableFlex = 2;  // 40% width
  static const int portraitKeypadFlex = 3;  // 60% width
  
  // Fixed widths for landscape mode
  static const double landscapeTableWidthPhone = 240.0;
  static const double landscapeTableWidthTablet = 300.0;
  static const double landscapeTableWidthLargeTablet = 350.0;
  
  // Table row dimensions
  static const double tableRowHeightPhone = 40.0;
  static const double tableRowHeightTablet = 50.0;
  static const double tableRowHeightLargeTablet = 55.0;
  
  // Border radius
  static const double borderRadius = 8.0;
  static const double borderWidth = 0.5;
  
  /// Get font size based on device type and element
  static double getTitleFontSize(double screenWidth) {
    if (screenWidth >= largeTabletBreakpoint) return titleFontSizeLargeTablet;
    if (screenWidth >= tabletBreakpoint) return titleFontSizeTablet;
    return titleFontSizePhone;
  }
  
  static double getTableFontSize(double screenWidth) {
    if (screenWidth >= largeTabletBreakpoint) return tableFontSizeLargeTablet;
    if (screenWidth >= tabletBreakpoint) return tableFontSizeTablet;
    return tableFontSizePhone;
  }
  
  static double getMinButtonSize(double screenWidth) {
    if (screenWidth >= largeTabletBreakpoint) return minButtonSizeLargeTablet;
    if (screenWidth >= tabletBreakpoint) return minButtonSizeTablet;
    return minButtonSizePhone;
  }
  
  static double getTableRowHeight(double screenWidth) {
    if (screenWidth >= largeTabletBreakpoint) return tableRowHeightLargeTablet;
    if (screenWidth >= tabletBreakpoint) return tableRowHeightTablet;
    return tableRowHeightPhone;
  }
  
  static double getLandscapeTableWidth(double screenWidth) {
    if (screenWidth >= largeTabletBreakpoint) return landscapeTableWidthLargeTablet;
    if (screenWidth >= tabletBreakpoint) return landscapeTableWidthTablet;
    return landscapeTableWidthPhone;
  }
  
  static double getSpacing(double screenWidth) {
    if (screenWidth >= largeTabletBreakpoint) return spacingLarge;
    if (screenWidth >= tabletBreakpoint) return spacingMedium;
    return spacingSmall;
  }
  
  static double getPadding(double screenWidth) {
    if (screenWidth >= largeTabletBreakpoint) return paddingExtraLarge;
    if (screenWidth >= tabletBreakpoint) return paddingLarge;
    return paddingMedium;
  }
  
  /// Device type identification
  static bool isPhone(double screenWidth) => screenWidth < tabletBreakpoint;
  static bool isTablet(double screenWidth) => screenWidth >= tabletBreakpoint && screenWidth < largeTabletBreakpoint;
  static bool isLargeTablet(double screenWidth) => screenWidth >= largeTabletBreakpoint;
  
  /// Specific device detection
  static bool isPixelXL(double screenWidth, double screenHeight) {
    return (screenWidth >= pixelXLWidth - 20 && screenWidth <= pixelXLWidth + 20) ||
           (screenHeight >= pixelXLWidth - 20 && screenHeight <= pixelXLWidth + 20);
  }
  
  static bool isNexus10(double screenWidth, double screenHeight) {
    return (screenWidth >= nexus10Width - 50 && screenWidth <= nexus10Width + 50) ||
           (screenHeight >= nexus10Width - 50 && screenHeight <= nexus10Width + 50);
  }
}