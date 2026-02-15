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
      body: SafeArea(
        child: OrientationBuilder(
          builder: (context, orientation) {
            if (orientation == Orientation.portrait) {
              return _buildPortraitLayout();
            } else {
              return _buildLandscapeLayout();
            }
          },
        ),
      ),
    );
  }

Widget _buildPortraitLayout() {
    return LayoutBuilder(
      builder: (context, constraints) {
        double screenWidth = constraints.maxWidth;

        // Use AppDimensions for consistent sizing
        double fontSize = AppDimensions.getTitleFontSize(screenWidth);
        double minButtonSize = AppDimensions.getMinButtonSize(screenWidth);
        double spacing = AppDimensions.getSpacing(screenWidth);
        double padding = AppDimensions.getPadding(screenWidth);

        // Tighten minimums on small screens so everything fits without scrolling
        double effectiveMinButton = minButtonSize;
        if (screenWidth < AppDimensions.tabletBreakpoint) {
          effectiveMinButton = AppDimensions.minButtonSizePhoneSmall;
        }

        // If the height is very short, reduce button size further to fit
        // (height-based adjustments handled in _buildAmountDisplay)

        return Column(
          children: [
            _buildAmountDisplay(fontSize),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(padding),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Change table (flexible)
                    Flexible(
                      flex: AppDimensions.portraitTableFlex,
                      child: _buildChangeTable(screenWidth),
                    ),
                    SizedBox(width: spacing),
                    // Keypad (flexible) — keypad will compute its button size based on available space
                    Flexible(
                      flex: AppDimensions.portraitKeypadFlex,
                      child: LayoutBuilder(
                        builder: (context, kConstraints) {
                          double maxW = kConstraints.maxWidth;
                          double maxH = kConstraints.maxHeight;
                          // Compute button size so 3 columns x 4 rows fit
                          double maxButtonWidth = (maxW - (spacing * 2)) / 3;
                          double maxButtonHeight = (maxH - (spacing * 3)) / 4;
                          double buttonSize = math.min(maxButtonWidth, maxButtonHeight);
                          // clamp to effective min and global max
                          buttonSize = math.max(buttonSize, effectiveMinButton);
                          buttonSize = math.min(buttonSize, AppDimensions.maxButtonSize);
                          return _buildKeypad(buttonSize, spacing);
                        },
                      ),
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
        
        // Use AppDimensions for consistent sizing
        double fontSize = AppDimensions.getTitleFontSize(screenWidth);
        double minButtonSize = AppDimensions.getMinButtonSize(screenWidth);
        double spacing = AppDimensions.getSpacing(screenWidth);
        double padding = AppDimensions.getPadding(screenWidth);
        double tableWidth = AppDimensions.getLandscapeTableWidth(screenWidth);

        // Constrain table width to a fraction of the screen so keypad has room
        tableWidth = math.min(tableWidth, screenWidth * 0.45);

        // Allow smaller button minimums on phones to fit in landscape
        double effectiveMinButton = minButtonSize;
        if (screenWidth < AppDimensions.tabletBreakpoint) {
          effectiveMinButton = AppDimensions.minButtonSizePhoneSmall;
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
                    // Keypad area: compute button size to fit available space
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, kConstraints) {
                          double maxW = kConstraints.maxWidth;
                          double maxH = kConstraints.maxHeight;
                          double maxButtonWidth = (maxW - (spacing * 2)) / 3;
                          double maxButtonHeight = (maxH - (spacing * 3)) / 4;
                          double buttonSize = math.min(maxButtonWidth, maxButtonHeight);
                          buttonSize = math.max(buttonSize, effectiveMinButton);
                          buttonSize = math.min(buttonSize, AppDimensions.maxButtonSize);
                          return _buildKeypad(buttonSize, spacing);
                        },
                      ),
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
    // Adjust display size based on available height so header doesn't consume too much space
    final media = MediaQuery.of(context);
    double height = media.size.height;
    double effectiveFont = fontSize;
    double verticalPadding = 12.0;
    if (height < 420) {
      effectiveFont = fontSize * 0.78;
      verticalPadding = 8.0;
    } else if (height < 600) {
      effectiveFont = fontSize * 0.9;
      verticalPadding = 10.0;
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: verticalPadding, horizontal: 12.0),
      color: const Color(0xFF009688),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Taka: ',
            style: TextStyle(
              color: Colors.white,
              fontSize: effectiveFont,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            _currentAmount.isEmpty ? '' : _currentAmount,
            style: TextStyle(
              color: Colors.white,
              fontSize: effectiveFont,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChangeTable(double screenWidth) {
    double fontSize = AppDimensions.getTableFontSize(screenWidth);
    double defaultRowHeight = AppDimensions.getTableRowHeight(screenWidth);
    double horizontalPadding = AppDimensions.isLargeTablet(screenWidth)
        ? AppDimensions.paddingLarge
        : AppDimensions.paddingMedium;

    // Estimate usable height to compute row height so the table fits on screen
    final media = MediaQuery.of(context);
    double usableHeight = media.size.height * 0.45; // use a fraction of total height
    double computedRowHeight = (usableHeight / _denominations.length).clamp(28.0, defaultRowHeight);

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
      ),
      // Use a scrollable list but with compact row heights calculated from screen size
      child: ListView.separated(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: _denominations.length,
        separatorBuilder: (context, index) => Divider(
          height: 0.5,
          color: Colors.grey.shade300,
        ),
        itemBuilder: (context, index) {
          final denomination = _denominations[index];
          final count = _change[denomination] ?? 0;
          return Container(
            height: computedRowHeight,
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            alignment: Alignment.centerLeft,
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
        },
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

        // Use a Wrap with fixed-size children so buttons keep their computed size
        final keys = ['1','2','3','4','5','6','7','8','9','0','CLEAR',''];
        return Center(
          child: LayoutBuilder(builder: (context, gridConstraints) {
            double maxW = gridConstraints.maxWidth;
            // compute total width needed for one row (3 buttons + 2 gaps)
            double totalRowWidth = (buttonSize * 3) + (spacing * 2);
            double horizontalPadding = 0.0;
            if (maxW > totalRowWidth) {
              horizontalPadding = (maxW - totalRowWidth) / 2;
            }
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: spacing,
                runSpacing: spacing,
                children: keys.map((k) {
                  if (k.isEmpty) return SizedBox(width: buttonSize, height: buttonSize);
                  return SizedBox(width: buttonSize, height: buttonSize, child: _buildButton(k, buttonSize));
                }).toList(),
              ),
            );
          }),
        );
      },
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
