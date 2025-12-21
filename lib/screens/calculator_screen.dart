import "package:shadcn_flutter/shadcn_flutter.dart";
import "package:math_expressions/math_expressions.dart";

const double tabletBreakpoint = 700;
const double desktopBreakpoint = 1100;

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => CalculatorScreenState();
}

class CalculatorScreenState extends State<CalculatorScreen> {
  String _calculatorInput = "";
  String _calculatorOutput = "";
  String _calculatorError = "";

  static const List<List<String>> _buttons = [
    ["AC", "⌫", "%", "÷"],
    ["7", "8", "9", "×"],
    ["4", "5", "6", "-"],
    ["1", "2", "3", "+"],
    ["0", ".", "="],
  ];

  void _handleButtonClick(String value) {
    setState(() {
      // Clear errors
      _calculatorError = "";

      if (value == "AC") {
        _calculatorInput = "";
        _calculatorOutput = "";
        _calculatorError = "";
      } else if (value == "⌫") {
        if (_calculatorInput.isNotEmpty) {
          _calculatorInput = _calculatorInput.substring(
            0,
            _calculatorInput.length - 1,
          );
        }
      } else if (value == "=") {
        if (_calculatorInput.isEmpty) return;

        try {
          // Replace screen symbols with math symbols
          String expressionSymbols = _calculatorInput
              .replaceAll("÷", "/")
              .replaceAll("×", "*")
              .replaceAll("%", "*0.01");

          // Parse and evaluate expression
          ExpressionParser parser = ShuntingYardParser();
          Expression expression = parser.parse(expressionSymbols);
          ContextModel contextModel = ContextModel();

          var evaluator = RealEvaluator(contextModel);
          num result = evaluator.evaluate(expression);

          // Format the result
          _calculatorOutput = _formatNumber(result);

          // Set the result as new input for further calculations
          _calculatorInput = _calculatorOutput;
        } catch (e) {
          _calculatorError = "Invalid expression";
          _calculatorOutput = "Error";
        }
      } else {
        // Prevent multiple decimal points in a number
        if (value == "." && _endsWithNumberContainingDecimal()) {
          return;
        }

        // Prevent operators at the start
        if (_isOperator(value) && _calculatorInput.isEmpty && value != "-") {
          return;
        }

        // Prevent consecutive operators
        if (_isOperator(value) && _endsWithOperator()) {
          return;
        }

        _calculatorInput += value;
      }
    });
  }

  bool _isOperator(String value) {
    return ["+", "-", "×", "÷", "%"].contains(value);
  }

  bool _endsWithOperator() {
    if (_calculatorInput.isEmpty) return false;

    final lastCharacter = _calculatorInput[_calculatorInput.length - 1];

    return _isOperator(lastCharacter);
  }

  bool _endsWithNumberContainingDecimal() {
    if (_calculatorInput.isEmpty) return false;

    // Find the last number in the expression
    final numbers = _calculatorInput.split(RegExp(r"[+\-×÷%]"));

    if (numbers.isEmpty) return false;

    final lastNumber = numbers.last;

    return lastNumber.contains(".");
  }

  String _formatNumber(num number) {
    // If it's an integer, remove decimal
    if (number % 1 == 0) {
      return number.toInt().toString();
    }

    // Remove trailing zeros
    String string = number.toString();
    if (string.contains(".")) {
      string = string.replaceAll(RegExp(r"0+$"), "");
      string = string.replaceAll(RegExp(r"\.$"), "");
    }

    // Handle very large/small numbers with scientific notation
    if (string.length > 12) {
      return number.toStringAsExponential();
    }

    return string;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;

          if (width >= 1100) {
            return _buildDesktopLayout();
          } else if (width >= 700) {
            return _buildTabletLayout();
          } else {
            return _buildMobileLayout();
          }
        },
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildCalculatorDisplay(),
          const SizedBox(height: 12),
          Expanded(child: _buildButtonGrid()),
        ],
      ),
    );
  }

  Widget _buildTabletLayout() {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Padding(
          padding: const .all(24),
          child: Column(
            children: [
              _buildCalculatorDisplay(),
              const SizedBox(height: 20),
              Expanded(child: _buildButtonGrid(buttonSpacing: 10)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520, maxHeight: 720),
        child: Padding(
          padding: const .all(32),
          child: Column(
            children: [
              _buildCalculatorDisplay(),
              const SizedBox(height: 24),
              Expanded(child: _buildButtonGrid(buttonSpacing: 12)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButtonGrid({double buttonSpacing = 6}) {
    return Column(
      children: _buttons.map((row) {
        return Expanded(
          child: Row(
            children: row.map((button) {
              if (button == "=") {
                return Expanded(
                  flex: 2,
                  child: _buildButton(button, spacing: buttonSpacing),
                );
              }

              final isSpecialCharacter = ["AC", "⌫", "%"].contains(button);

              return Expanded(
                child: _buildButton(
                  button,
                  isSpecialCharacter: isSpecialCharacter,
                  spacing: buttonSpacing,
                ),
              );
            }).toList(),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCalculatorDisplay() {
    return Container(
      width: double.infinity,
      padding: const .symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: .circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.4), blurRadius: 20),
        ],
      ),
      child: Column(
        crossAxisAlignment: .end,
        children: [
          // Input
          Text(
            _calculatorInput.isEmpty ? "0" : _calculatorInput,
            maxLines: 1,
            overflow: .ellipsis,
            style: TextStyle(
              fontSize: 24,
              color: Colors.white.withValues(alpha: 0.7),
              fontWeight: .w300,
              fontFamily: "monospace",
            ),
          ),

          const SizedBox(height: 8),
          Divider(color: Colors.white.withValues(alpha: 1.2)),

          // Result / Error
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Text(
              key: ValueKey(_calculatorOutput + _calculatorError),
              _calculatorError.isNotEmpty
                  ? _calculatorError
                  : (_calculatorOutput.isEmpty ? "" : _calculatorOutput),
              style: TextStyle(
                fontSize: 42,
                fontWeight: .bold,
                color: _calculatorError.isNotEmpty ? Colors.red : Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(
    String text, {
    bool isSpecialCharacter = false,
    double spacing = 6,
  }) {
    final isEquals = text == "=";
    final isOperator = _isOperator(text) && !isEquals;

    final Color background = isEquals
        ? Colors.blue
        : isOperator
        ? Colors.orange
        : isSpecialCharacter
        ? Colors.gray.shade700
        : Colors.gray.shade900;

    return Padding(
      padding: EdgeInsets.all(spacing),
      child: Button(
        onPressed: () {
          _handleButtonClick(text);
        },
        style: const ButtonStyle.primary()
            .withBackgroundColor(color: background)
            .withForegroundColor(color: Colors.white)
            .withBorderRadius(
              borderRadius: .circular(999),
              hoverBorderRadius: .circular(999),
            ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: isEquals ? 26 : 22,
            fontWeight: isEquals || isOperator
                ? FontWeight.bold
                : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
