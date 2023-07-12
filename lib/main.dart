// ignore_for_file: unnecessary_null_comparison, unused_local_variable, duplicate_ignore

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:logger/logger.dart';

void main() => runApp(const CalculadoraApp());

class CalculadoraApp extends StatelessWidget {
  const CalculadoraApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const Calculadora(),
    );
  }
}

class Calculadora extends StatefulWidget {
  const Calculadora({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CalculadoraState createState() => _CalculadoraState();
}

class _CalculadoraState extends State<Calculadora> {
  String _displayValue = '';
  final List<String> _history = [];
  // ignore: unused_field
  final Logger _logger = Logger();

  String _resultValue = ''; // Variable para almacenar el valor del resultado
  String _selectedFunction =
      'sin'; // Variable para almacenar la función trigonométrica seleccionada
  final List<String> _functionOptions = [
    'sin',
    'cos',
    'tan'
  ]; // Opciones de función trigonométrica

  void _onDigitPress(String value) {
    setState(() {
      _displayValue += value;
    });
  }

  void _onOperatorPress(String value) {
    setState(() {
      if (value == 'x') {
        _displayValue += '*';
      } else {
        _displayValue += value;
      }
    });
  }

  void _onClearPress() {
    setState(() {
      _displayValue = '';
    });
  }

  void _onDeletePress() {
    setState(() {
      if (_displayValue.isNotEmpty) {
        _displayValue = _displayValue.substring(0, _displayValue.length - 1);
      }
    });
  }

  void _onEqualPress() {
    setState(() {
      try {
        String expression = _displayValue.replaceAll('%', '/100');
        final result = evalExpression(expression);
        _history.add('$_displayValue = $result');
        _displayValue = result.toString();
      } catch (e) {
        _displayValue = 'Error';
      }
    });
  }

  double evalExpression(String expression) {
    try {
      Parser parser = Parser();
      Expression exp = parser.parse(expression);
      ContextModel cm = ContextModel();
      double result = exp.evaluate(EvaluationType.REAL, cm);
      return result;
    } catch (e) {
      // ignore: avoid_print
      print('Error al evaluar la expresión: $e');
      return 0.0; // Valor por defecto en caso de error
    }
  }

  void _onParenthesisPress(String value) {
    setState(() {
      _displayValue += value;
    });
  }

  void addToHistory(String operation) {
    _history.add(operation);
  }

  void _showExtendedHistoryDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Historial Ampliado'),
          content: Column(
            children: _history
                .map((entry) => ListTile(
                      title: Text(entry),
                    ))
                .toList(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  void _showAdvancedOperations() {
    final advancedOperations = [
      AdvancedOperation(
        title: 'Raíz Cuadrada',
        onPressed: () {
          _performAdvancedOperation('Raíz Cuadrada');
          Navigator.of(context).pop(); // Cerrar el diálogo
        },
      ),
      AdvancedOperation(
        title: 'Potencia',
        onPressed: () {
          _performAdvancedOperation('Potencia');
          Navigator.of(context).pop(); // Cerrar el diálogo
        },
      ),
      AdvancedOperation(
        title: 'Logaritmo',
        onPressed: () {
          _performAdvancedOperation('Logaritmo');
          Navigator.of(context).pop(); // Cerrar el diálogo
        },
      ),
      AdvancedOperation(
        title: 'Función Exponencial',
        onPressed: () {
          _performAdvancedOperation('Función Exponencial');
          Navigator.of(context).pop(); // Cerrar el diálogo
        },
      ),
      AdvancedOperation(
        title: 'Proximamente',
        onPressed: () {
          Navigator.of(context).pop(); // Cerrar el diálogo
        },
      ),

      // Agrega más operaciones avanzadas aquí
    ];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Operaciones Avanzadas'),
          content: SingleChildScrollView(
            child: ListBody(
              children: _buildAdvancedOperationTiles(advancedOperations),
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildAdvancedOperationTiles(
      List<AdvancedOperation> advancedOperations) {
    return advancedOperations
        .map(
          (operation) => ListTile(
            title: Text(operation.title),
            onTap: operation.onPressed,
          ),
        )
        .toList();
  }

  void _performAdvancedOperation(String operation) {
    // Realiza la acción correspondiente a la operación avanzada seleccionada
    switch (operation) {
      case 'Raíz Cuadrada':
        double value = double.parse(_displayValue);
        double result = sqrt(value);
        setState(() {
          _displayValue = result.toString();
        });
        break;

      case 'Potencia':
        double base = double.parse(_displayValue);
        double exponent =
            2.0; // Puedes ajustar el exponente según tus necesidades
        num result = pow(base, exponent);
        setState(() {
          _displayValue = result.toDouble().toString();
        });
        break;

      case 'Logaritmo':
        double value = double.parse(_displayValue);
        double result = log(value);
        setState(() {
          _displayValue = result.toString();
        });
        break;
      case 'Función Exponencial':
        double value = double.parse(_displayValue);
        double result = exp(value);
        setState(() {
          _displayValue = result.toString();
        });
        break;

      default:
      // Acción predeterminada o manejo de operaciones desconocidas
    }
  }

  void _onSpecialOperatorPress(String operator) {
    if (operator == '%') {
      _displayValue += operator;
    } else if (operator == 'π') {
      _displayValue += operator;

      if (_displayValue.contains('π')) {
        double piValue = 3.14159;
        _displayValue = _displayValue.replaceAll('π', piValue.toString());
      }
    }

    setState(() {
      _displayValue = _displayValue;
      _resultValue = _resultValue;
    });
  }

  void _showFinancialCalculationsDialog() {
    double interestRate = 0.0;
    double presentValue = 0.0;
    double futureValue = 0.0;
    String dialogDisplayValue = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text("Cálculos Financieros"),
              content: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Tasa de Interés',
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        interestRate = double.tryParse(value) ?? 0.0;
                      });
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Valor Presente',
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        presentValue = double.tryParse(value) ?? 0.0;
                      });
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Valor Futuro',
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        futureValue = double.tryParse(value) ?? 0.0;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Resultado: $dialogDisplayValue',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text("Calcular"),
                  onPressed: () {
                    // Realiza los cálculos financieros y muestra el resultado en el diálogo emergente
                    double calculatedValue = calculateFinancialValue(
                        interestRate, presentValue, futureValue);
                    setState(() {
                      dialogDisplayValue = calculatedValue.toString();
                      interestRate = 0.0;
                      presentValue = 0.0;
                      futureValue = 0.0;
                    });
                  },
                ),
                TextButton(
                  child: const Text("Cancelar"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  double calculateFinancialValue(
      double interestRate, double presentValue, double futureValue) {
    double calculatedValue;

    // Cálculo del valor futuro: FV = PV * (1 + r)
    if (futureValue != null && presentValue != null && interestRate != null) {
      calculatedValue = presentValue * (1 + interestRate);
    }
    // Cálculo del valor presente: PV = FV / (1 + r)
    else if (futureValue != null &&
        presentValue == null &&
        interestRate != null) {
      calculatedValue = futureValue / (1 + interestRate);
    }
    // Cálculo de la tasa de interés: r = (FV / PV) - 1
    else if (futureValue != null &&
        presentValue != null &&
        interestRate == null) {
      calculatedValue = (futureValue / presentValue) - 1;
    } else {
      // Acción predeterminada o manejo de cálculos desconocidos
      calculatedValue = 0.0;
    }

    return calculatedValue;
  }

  void _showTrigonometricDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        double inputValue = 0.0;

        return AlertDialog(
          title: const Text('Funciones Trigonométricas'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButton<String>(
                value: _selectedFunction,
                onChanged: (String? value) {
                  // Corrección: Cambiar el tipo del argumento a String?
                  setState(() {
                    _selectedFunction = value ?? '';
                  });
                },
                items: _functionOptions.map((String option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
              ),
              TextFormField(
                onChanged: (String value) {
                  setState(() {
                    inputValue = double.tryParse(value) ?? 0.0;
                  });
                },
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Ingrese un valor',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                double result;
                switch (_selectedFunction) {
                  case 'sin':
                    result = sin(inputValue);
                    break;
                  case 'cos':
                    result = cos(inputValue);
                    break;
                  case 'tan':
                    result = tan(inputValue);
                    break;
                  default:
                    result = 0.0;
                }
                setState(() {
                  _displayValue = result.toString();
                });
                Navigator.pop(context);
              },
              child: const Text('Calcular'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  void _showTipCalculatorDialog() {
    double billAmount = 0.0;
    double tipPercentage = 0.0;
    double tipAmount = 0.0;
    double totalAmount = 0.0;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Calculadora de Propinas'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Total de la cuenta',
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        billAmount = double.tryParse(value) ?? 0.0;
                        tipAmount = billAmount * tipPercentage / 100;
                        totalAmount = billAmount + tipAmount;
                      });
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Porcentaje de propina',
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        tipPercentage = double.tryParse(value) ?? 0.0;
                        tipAmount = billAmount * tipPercentage / 100;
                        totalAmount = billAmount + tipAmount;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Propina: \$${tipAmount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Total: \$${totalAmount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cerrar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora'),
        actions: [
          IconButton(
            onPressed: _showExtendedHistoryDialog,
            icon: const Icon(Icons.history),
          ),
          IconButton(
            onPressed: _showAdvancedOperations,
            icon: const Icon(Icons.science),
          ),
          IconButton(
            onPressed: _showFinancialCalculationsDialog,
            icon: const Icon(Icons.account_balance_outlined),
          ),
          IconButton(
            onPressed: _showTrigonometricDialog,
            icon: const Icon(Icons.assessment_outlined),
          ),
          IconButton(
            onPressed: _showTipCalculatorDialog,
            icon: const Icon(Icons.attach_money),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 4, // Aumenta el valor de flex a 4
            child: Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.all(35),
              child: Text(
                _displayValue,
                style: const TextStyle(fontSize: 40),
              ),
            ),
          ),
          const Divider(height: 3),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildCalcButton('7'),
              _buildCalcButton('8'),
              _buildCalcButton('9'),
              _buildOperatorButton('/'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildCalcButton('4'),
              _buildCalcButton('5'),
              _buildCalcButton('6'),
              _buildOperatorButton('x'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildCalcButton('1'),
              _buildCalcButton('2'),
              _buildCalcButton('3'),
              _buildOperatorButton('-'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildCalcButton('0'),
              _buildCalcButton('.'),
              _buildCalcButton('='),
              _buildOperatorButton('+'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildOperatorButton('('),
              _buildOperatorButton(')'),
              _buildOperatorButton('%'),
              _buildOperatorButton('π')
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: _onClearPress,
                child: const Text('Clean'),
              ),
              ElevatedButton(
                onPressed: _onDeletePress,
                child: const Icon(Icons.arrow_back),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCalcButton(String label) {
    return ElevatedButton(
      onPressed: () {
        if (label == '=') {
          _onEqualPress();
        } else {
          _onDigitPress(label);
        }
      },
      child: Text(label),
    );
  }

  Widget _buildOperatorButton(String label) {
    if (label == '(' || label == ')') {
      return ElevatedButton(
        onPressed: () {
          _onParenthesisPress(label);
        },
        child: Text(label),
      );
    } else if (label == '%' || label == 'π') {
      return ElevatedButton(
        onPressed: () {
          _onSpecialOperatorPress(label);
        },
        child: Text(label),
      );
    } else {
      return ElevatedButton(
        onPressed: () {
          _onOperatorPress(label);
        },
        child: Text(label),
      );
    }
  }
}

class AdvancedOperation {
  final String title;
  final VoidCallback onPressed;

  AdvancedOperation({
    required this.title,
    required this.onPressed,
  });
}
