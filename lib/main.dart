import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'app_dimensions.dart';

void main() {
  runApp(const VangtiChaiApp());
}

class VangtiChaiApp extends StatelessWidget {
  const VangtiChaiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VangtiChai',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        primaryColor: const Color(0xFF009688),
        useMaterial3: true,
      ),
      home: const VangtiChaiHomePage(),
    );
  }
}

class VangtiChaiHomePage extends StatefulWidget {
  const VangtiChaiHomePage({super.key});

  @override
  State<VangtiChaiHomePage> createState() => _VangtiChaiHomePageState();
}

class _VangtiChaiHomePageState extends State<VangtiChaiHomePage> {
  String _currentAmount = '';
  final Map<int, int> _change = {
    500: 0,
    100: 0,
    50: 0,
    20: 0,
    10: 0,
    5: 0,
    2: 0,
    1: 0,
  };
  final List<int> _denominations = [500, 100, 50, 20, 10, 5, 2, 1];

  void _onDigitPressed(String digit) {
    setState(() {
      // Add digit to the right (as specified in requirements)
      if (_currentAmount.isEmpty) {
        _currentAmount = digit;
      } else {
        _currentAmount = _currentAmount + digit;
      }
      _calculateChange();
    });
  }

  void _onClearPressed() {
    setState(() {
      _currentAmount = '';
      // Reset all denominations to 0
      for (int denomination in _denominations) {
        _change[denomination] = 0;
      }
    });
  }

  void _calculateChange() {
    // Parse amount, default to 0 if empty or invalid
    int amount = int.tryParse(_currentAmount) ?? 0;
    
    // Initialize all denominations to 0
    for (int denomination in _denominations) {
      _change[denomination] = 0;
    }

    // Calculate minimum number of bills/coins for each denomination
    int remainingAmount = amount;
    for (int denomination in _denominations) {
      if (remainingAmount >= denomination) {
        int count = remainingAmount ~/ denomination;
        _change[denomination] = count;
        remainingAmount = remainingAmount % denomination;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VangtiChai'),
        backgroundColor: const Color(0xFF009688),
        foregroundColor: Colors.white,
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          if (orientation == Orientation.portrait) {
            return _buildPortraitLayout();
          } else {
            return _buildLandscapeLayout();
          }
        },
      ),
    );
  }

Widget _buildPortraitLayout() {
    return LayoutBuilder(
      builder: (context, constraints) {
        double screenWidth = constraints.maxWidth;
        double screenHeight = constraints.maxHeight;
        
        // Use AppDimensions for consistent sizing
        double fontSize = AppDimensions.getTitleFontSize(screenWidth);
        double minButtonSize = AppDimensions.getMinButtonSize(screenWidth);
        double spacing = AppDimensions.getSpacing(screenWidth);
        double padding = AppDimensions.getPadding(screenWidth);
        
        // Specific optimizations for target devices
        if (AppDimensions.isPixelXL(screenWidth, screenHeight)) {
          // Pixel XL specific adjustments
          minButtonSize = math.max(minButtonSize, 48.0);
        } else if (AppDimensions.isNexus10(screenWidth, screenHeight)) {
          // Nexus 10 specific adjustments
          minButtonSize = math.max(minButtonSize, 65.0);
          fontSize = math.max(fontSize, 26.0);
        }

        return Column(
          children: [
            _buildAmountDisplay(fontSize),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(padding),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Change table takes up 40% of width (2/5)
                    Expanded(
                      flex: AppDimensions.portraitTableFlex,
                      child: _buildChangeTable(screenWidth)
                    ),
                    SizedBox(width: spacing),
                    // Keypad takes up 60% of width (3/5)
                    Expanded(
                      flex: AppDimensions.portraitKeypadFlex,
                      child: _buildKeypad(minButtonSize, spacing),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

Widget _buildLandscapeLayout() {
    return LayoutBuilder(
      builder: (context, constraints) {
        double screenWidth = constraints.maxWidth;
        double screenHeight = constraints.maxHeight;
        
        // Use AppDimensions for consistent sizing
        double fontSize = AppDimensions.getTitleFontSize(screenWidth);
        double minButtonSize = AppDimensions.getMinButtonSize(screenWidth);
        double spacing = AppDimensions.getSpacing(screenWidth);
        double padding = AppDimensions.getPadding(screenWidth);
        double tableWidth = AppDimensions.getLandscapeTableWidth(screenWidth);
        
        // Specific optimizations for target devices in landscape
        if (AppDimensions.isPixelXL(screenWidth, screenHeight)) {
          // Pixel XL landscape (731x411dp) - tighter layout
          tableWidth = 220.0;
          minButtonSize = math.max(minButtonSize, 45.0);
          spacing = AppDimensions.spacingSmall;
        } else if (AppDimensions.isNexus10(screenWidth, screenHeight)) {
          // Nexus 10 landscape (1280x800dp) - more spacious
          tableWidth = 320.0;
          minButtonSize = math.max(minButtonSize, 70.0);
          fontSize = math.max(fontSize, 28.0);
        }

        return Column(
          children: [
            _buildAmountDisplay(fontSize),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(padding),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      width: tableWidth,
                      child: _buildChangeTable(screenWidth),
                    ),
                    SizedBox(width: spacing),
                    Expanded(
                      child: _buildKeypad(minButtonSize, spacing),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAmountDisplay(double fontSize) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      color: const Color(0xFF009688),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Taka: ',
            style: TextStyle(
              color: Colors.white,
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            _currentAmount.isEmpty ? '' : _currentAmount,
            style: TextStyle(
              color: Colors.white,
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

Widget _buildChangeTable(double screenWidth) {
    double fontSize = AppDimensions.getTableFontSize(screenWidth);
    double rowHeight = AppDimensions.getTableRowHeight(screenWidth);
    double horizontalPadding = AppDimensions.isLargeTablet(screenWidth) ? 
        AppDimensions.paddingLarge : AppDimensions.paddingMedium;

    return Container(
decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: _denominations.map((denomination) {
          int count = _change[denomination] ?? 0;
          return Container(
            height: rowHeight,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade300, width: AppDimensions.borderWidth),
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$denomination:',
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '$count',
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildKeypad(double minButtonSize, double spacing) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double availableWidth = constraints.maxWidth;
        double availableHeight = constraints.maxHeight;

        // Calculate maximum possible button size based on available space
        double maxButtonWidth = (availableWidth - (spacing * 2)) / 3;
        double maxButtonHeight = (availableHeight - (spacing * 3)) / 4;
        
// Use the smaller dimension but ensure minimum size
        double buttonSize = math.max(
          minButtonSize, 
          math.min(maxButtonWidth, maxButtonHeight)
        );
        
        // Cap button size using AppDimensions constant
        buttonSize = math.min(buttonSize, AppDimensions.maxButtonSize);
        
        // Ensure buttons aren't too small - use minimum from AppDimensions
        if (buttonSize < AppDimensions.minButtonSizePhone) {
          buttonSize = AppDimensions.minButtonSizePhone;
        }

        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildKeypadRow(['1', '2', '3'], buttonSize, spacing),
              SizedBox(height: spacing),
              _buildKeypadRow(['4', '5', '6'], buttonSize, spacing),
              SizedBox(height: spacing),
              _buildKeypadRow(['7', '8', '9'], buttonSize, spacing),
              SizedBox(height: spacing),
              _buildKeypadRow(['0', 'CLEAR', ''], buttonSize, spacing),
            ],
          ),
        );
      },
    );
  }

  Widget _buildKeypadRow(
    List<String> buttons,
    double buttonSize,
    double spacing,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: buttons.asMap().entries.map((entry) {
        String button = entry.value;
        if (button.isEmpty) {
          return SizedBox(width: buttonSize, height: buttonSize);
        }

        Widget buttonWidget = _buildButton(button, buttonSize);

        if (entry.key < buttons.length - 1 &&
            buttons[entry.key + 1].isNotEmpty) {
          return Row(
            children: [
              buttonWidget,
              SizedBox(width: spacing),
            ],
          );
        }

        return buttonWidget;
      }).toList(),
    );
  }

  Widget _buildButton(String label, double size) {
    bool isClear = label == 'CLEAR';

    return SizedBox(
      width: size,
      height: size,
      child: ElevatedButton(
        onPressed: () {
          if (isClear) {
            _onClearPressed();
          } else {
            _onDigitPressed(label);
          }
        },
        style: ElevatedButton.styleFrom(
backgroundColor: isClear
              ? Colors.grey.shade300
              : const Color(0xFF009688),
          foregroundColor: isClear ? Colors.black87 : Colors.white,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.borderRadius)),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            label,
style: TextStyle(
              fontSize: isClear ? size * AppDimensions.clearButtonFontRatio : size * AppDimensions.buttonFontRatio,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
