VangtiChai - Change Calculator App
=================================

TESTED DEVICE CONFIGURATIONS
============================

Primary Target Devices (Required for Full Credit):
---------------------------------------------------
1. Pixel XL Phone (411x731dp)
   - Portrait Mode: 411x731dp - Optimized 40/60 table/keypad layout
   - Landscape Mode: 731x411dp - Compact table width (220dp), responsive keypad

2. Nexus 10 Tablet (800x1280dp)  
   - Portrait Mode: 800x1280dp - Enhanced spacing, larger fonts and buttons
   - Landscape Mode: 1280x800dp - Wide table (320dp), spacious button layout

Additional Tested Devices/Screen Types:
--------------------------------------
3. Small Phone (360x640dp)
   - Portrait: Minimum button size enforced (45dp), compact spacing
   - Landscape: Ultra-compact table (220dp), efficient space usage

4. Standard Tablet (768x1024dp)
   - Portrait: Balanced proportions, medium button sizes (55dp)
   - Landscape: Standard table width (300dp), comfortable button spacing

5. Large Tablet/Desktop (1200x800dp and larger)
   - Portrait: Maximum button size capping (100dp), generous spacing
   - Landscape: Expanded table (350dp), large font sizes (32dp title, 24dp table)

6. Foldable Device Simulation (840x2208dp when unfolded)
   - Portrait: Large tablet layout with generous spacing
   - Landscape: Ultra-wide layout with optimized table positioning

Responsive Design Features:
--------------------------
- Dynamic button sizing (45dp minimum, 100dp maximum)
- Adaptive font scaling based on screen width
- Flexible table width in landscape mode
- Proportional spacing and padding adjustments
- Device-specific optimizations for Pixel XL and Nexus 10

Layout Breakpoints:
------------------
- Phone: < 600dp width
- Tablet: 600-900dp width  
- Large Tablet: > 900dp width

Key Design Decisions:
--------------------
- Portrait mode uses 40/60 table/keypad split for optimal usability
- Landscape mode uses fixed table width for consistent appearance
- All dimensions defined in app_dimensions.dart (no hardcoded values)
- Material Design color scheme with teal primary color (#009688)
- Responsive typography scaling for different screen densities

Testing Notes:
--------------
- All layouts tested in both portrait and landscape orientations
- Button accessibility maintained across all screen sizes
- Change calculation accuracy verified on all configurations
- Proper text scaling for readability on all devices
- Responsive behavior validated during orientation changes

Build Information:
------------------
- Flutter SDK: 3.41.0
- Target API: Android 28+
- Minimum screen width: 320dp
- Optimized for: Pixel XL (phone) and Nexus 10 (tablet)