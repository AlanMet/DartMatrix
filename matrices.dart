import 'dart:math';

class Matrix {
  late List<List<double>> _matrix;
  late int _row;
  late int _col;

  List<dynamic> operator [](int index) => _matrix[index];
  Matrix operator +(Matrix matrixB) => add(matrixB);
  Matrix operator -(dynamic value) {
    if (value is Matrix) {
      return subtract(value);
    } else {
      Matrix matrixB = Matrix(_row, _col);
      matrixB.fill(value.toDouble());
      return subtract(matrixB);
    }
  }

  Matrix operator /(dynamic value) {
    if (value is Matrix) {
      //multiplies all values from 1 matrix with the other
      return divide(value);
    } else {
      //should multiply all values from 1 matrix with
      return scalarDivide(value.toDouble());
    }
  }

  Matrix operator *(dynamic value) {
    if (value is Matrix) {
      //multiplies all values from 1 matrix with the other
      return hadamardProduct(value);
    } else {
      //should multiply all values from 1 matrix with
      return multiply(value.toDouble());
    }
  }

  /// Create a new empty matrix
  /// - [row] The number of rows in the matrix
  /// - [col] The number of columns in the matrix
  /// - Returns The matrix
  Matrix(int row, int col) {
    _row = row;
    _col = col;
    empty();
  }

  Matrix.fromList(List<List<double>> list) {
    _row = list.length;
    _col = list[0].length;
    _matrix = List<List<double>>.from(list);
  }

  int getRow() {
    return _row;
  }

  int getCol() {
    return _col;
  }

  List<List<double>> getMatrix() {
    return _matrix;
  }

  List<int> getDimensions() {
    List<int> dimensions = [_row, _col];
    return dimensions;
  }

  List<int> getSize() => getDimensions();

  double getAt(int row, int col) {
    return (_matrix[row][col]).toDouble();
  }

  /// Set the value of a matrix at a specific index
  /// - [row] The row index
  /// - [col] The column index
  /// - [value] The value to set
  /// - Example
  /// ```dart
  /// Matrix matrix = Matrix(2, 2);
  /// matrix.setAt(0, 0, value: 1);
  /// ```
  void setAt(int row, int col, {required double value}) {
    _matrix[row][col] = value;
  }

  /// Create an empty matrix
  /// - Example
  /// ```dart
  /// Matrix matrix = Matrix(2, 2); //Empty is called by default
  /// ```
  void empty() {
    _matrix = List<List<double>>.generate(_row,
        (i) => List<double>.generate(_col, (index) => 0.0, growable: false),
        growable: false);
  }

  /// Fill the matrix with a specific number
  /// - [num] The number to fill the matrix with
  /// - Example
  /// ```dart
  /// Matrix matrix = Matrix(2, 2);
  /// matrix.fill(1);
  /// ```
  void fill(double num) {
    _matrix = List<List<double>>.generate(_row,
        (i) => List<double>.generate(_col, (index) => num, growable: false),
        growable: false);
  }

  /// Fills the matrix with random doubles
  /// - [min] The minimum value
  /// - [max] The maximum value
  /// - [seed] The optional seed
  /// - Example
  /// ```dart
  /// Matrix matrix = Matrix(2, 2);
  /// matrix.generateDouble(0, 1);
  /// ```
  void generateDouble(double min, double max, {int? seed}) {
    Random rand = Random(seed);
    _matrix = List<List<double>>.generate(
        _row,
        (i) => List<double>.generate(
            _col, (index) => ((rand.nextDouble() * (max - min) + min) / 10),
            growable: false),
        growable: false);
  }

  void generateInt(int min, int max, {int? seed}) {
    Random rand = Random(seed);
    _matrix = List<List<double>>.generate(
        _row,
        (i) => List<double>.generate(
            _col, (index) => (rand.nextInt(max - min) + min).toDouble(),
            growable: false),
        growable: false);
  }

  /// Perform a function on the matrix
  /// - [function] The function to perform
  /// - Returns The new matrix
  /// - Example
  /// ```dart
  /// Matrix matrix = Matrix(2, 2);
  /// Matrix newMatrix = matrix.performFunction((a) => a * 2);
  /// ```
  /// - Note
  /// The function should take a double as input and return a double
  Matrix performFunction(Function(double) function) {
    Matrix newMatrix = Matrix(_row, _col);
    for (int i = 0; i < _row; i++) {
      for (int j = 0; j < _col; j++) {
        double result = function(getAt(i, j));
        newMatrix.setAt(i, j, value: result);
      }
    }
    return newMatrix;
  }

  /// Perform an operation on the matrix
  /// - [matrixB] The matrix to perform the operation with
  /// - [operation] The operation to perform
  /// - Returns The new matrix
  /// - Example
  /// ```dart
  /// Matrix matrixA = Matrix(2, 2);
  /// Matrix matrixB = Matrix(2, 2);
  /// Matrix newMatrix = matrixA._performOperation(matrixB, (a, b) => a + b);
  /// ```
  /// - Note
  /// The operation should take two doubles as input and return a double
  Matrix _performOperation(
      Matrix matrixB, double Function(double, double) operation) {
    if (_row != matrixB.getRow() || _col != matrixB.getCol()) {
      throw Exception("Matrix dimensions must match for addition");
    }
    Matrix newMatrix = Matrix(_row, _col);

    for (var row = 0; row < _matrix.length; row++) {
      for (var col = 0; col < _matrix[0].length; col++) {
        double valueA = getAt(row, col);
        double valueB = matrixB.getAt(row, col);
        newMatrix.setAt(row, col, value: operation(valueA, valueB));
      }
    }
    return newMatrix;
  }

  /// Transpose the matrix
  /// - Returns The new matrix
  Matrix transpose() {
    Matrix newMatrix = Matrix(_col, _row);
    for (int i = 0; i < _row; i++) {
      for (int j = 0; j < _matrix[i].length; j++) {
        newMatrix.setAt(j, i, value: _matrix[i][j]);
      }
    }
    return newMatrix;
  }

  /// Flatten the matrix
  /// - Returns The new matrix
  Matrix flatten() {
    Matrix newMatrix = Matrix(_row, 1);
    for (var row in _matrix) {
      int count = 0;
      double total = 0;
      for (var column in row) {
        total += column;
      }
      newMatrix.setAt(count, 0, value: total);
      count += 1;
    }
    return newMatrix;
  }

  /// Dot product of two matrices
  /// - [matrixB] The matrix to perform the dot product with
  /// - Returns The new matrix
  Matrix dot(Matrix matrixB) {
    if (getDimensions()[1] != matrixB.getDimensions()[0]) {
      throw Exception(
          "Matrix dimensions must be in the form : MxN × NxP, ${getDimensions()[0]}x${getDimensions()[1]} × ${matrixB.getDimensions()[0]}×${matrixB.getDimensions()[1]}");
    }
    Matrix newMatrix = Matrix(getDimensions()[0], matrixB.getDimensions()[1]);
    for (int i = 0; i < _matrix.length; i++) {
      for (int j = 0; j < matrixB._matrix[0].length; j++) {
        for (int k = 0; k < matrixB._matrix.length; k++) {
          newMatrix.setAt(i, j,
              value: newMatrix.getAt(i, j) + getAt(i, k) * matrixB.getAt(k, j));
        }
      }
    }
    return newMatrix;
  }

  /// Add two matrices
  /// - [matrixB] The matrix to add
  /// - Returns The new matrix
  Matrix add(Matrix matrixB) {
    return _performOperation(matrixB, (a, b) => a + b);
  }

  /// Subtract two matrices
  /// - [matrixB] The matrix to subtract
  /// - Returns The new matrix
  Matrix subtract(Matrix matrixB) {
    return _performOperation(matrixB, (a, b) => a - b);
  }

  /// Divide two matrices
  /// - [matrixB] The matrix to divide
  /// - Returns The new matrix
  Matrix divide(Matrix matrixB) {
    return _performOperation(matrixB, (a, b) => a / b);
  }

  /// Divide the matrix by a scalar
  /// - [x] The scalar to divide by
  /// - Returns The new matrix
  Matrix scalarDivide(double x) {
    Matrix matrixB = Matrix(_row, _col);
    matrixB.fill(1 / x);
    return hadamardProduct(matrixB);
  }

  /// Multiply the matrix by a scalar
  /// - [x] The scalar to multiply by
  /// - Returns The new matrix
  Matrix multiply(double x) {
    Matrix matrixB = Matrix(_row, _col);
    matrixB.fill(x);
    return hadamardProduct(matrixB);
  }

  /// Multiply two matrices
  /// - [matrixB] The matrix to multiply
  /// - Returns The new matrix
  Matrix hadamardProduct(Matrix matrixB) {
    return _performOperation(matrixB, (a, b) {
      if (a.isNaN || b.isNaN) {
        return 0.5;
      } else {
        return a * b;
      }
    });
  }

  /// Sum the matrix
  /// - [axis] The axis to sum
  /// - Returns The new matrix
  Matrix sum({required int axis}) {
    Matrix matrix = Matrix(_row, 1);
    if (axis == 1) {
      for (var i = 0; i < _matrix.length; i++) {
        double total = 0;
        for (double column in _matrix[i]) {
          total += column;
        }
        matrix.setAt(i, 0, value: total);
      }
    } else if (axis == 0) {
      matrix = Matrix(1, _col);
      for (var i = 0; i < _col; i++) {
        double total = 0;
        for (var j = 0; j < _row; j++) {
          total += _matrix[j][i];
        }
        matrix.setAt(0, i, value: total);
      }
    }
    return matrix;
  }

  Matrix clip(double min, double max) {
    return performFunction((a) {
      if (a > max || a < min) {
        return 0.0;
      }
      return a;
    });
  }

  Matrix Dropout(double rate) {
    if (rate < 0 || rate > 1) {
      throw Exception("Dropout rate must be between 0 and 1");
    }
    Random random = Random();
    //usually a mask is applied
    return performFunction((a) {
      if (random.nextDouble() < rate) {
        return 0.0;
      }
      //scale the values to account for the dropout
      return a * (1.0 / (1.0 - rate));
    });
  }

  double max() {
    double max = double.negativeInfinity;
    for (var row in _matrix) {
      for (var column in row) {
        if (column > max) {
          max = column;
        }
      }
    }
    return max;
  }

  /// Check if two matrices are equivalent
  /// - [matrixB] The matrix to compare
  /// - Returns True if the matrices are equivalent
  bool isEquivalent(Matrix matrxiB) {
    if (matrxiB._col != _col && matrxiB._row != _row) {
      return false;
    } else {
      for (var row = 0; row < _matrix.length; row++) {
        for (var col = 0; col < _matrix[0].length; col++) {
          if (matrxiB.getAt(row, col) != getAt(row, col)) {
            return false;
          }
        }
      }
      return true;
    }
  }

  @override
  String toString() {
    String result = "";
    for (var i = 0; i < _row; i++) {
      result += "${_matrix[i].toString()} \n";
    }
    return result;
  }

  join(String s) {}
}

/// Create a matrix with random values
/// - [row] The number of rows in the matrix
/// - [col] The number of columns in the matrix
/// - [seed] The optional seed
/// - Returns The matrix
Matrix randn(int row, int col, {double start = -1, double end = 1, int? seed}) {
  Matrix matrix = Matrix(row, col);
  int min = (start * 10).toInt();
  int max = (end * 10).toInt();
  matrix.generateInt(min, max, seed: seed);
  return matrix / 10;
}

/// Create a matrix with zeros
/// - [row] The number of rows in the matrix
/// - [col] The number of columns in the matrix
/// - Returns The matrix
Matrix zeros(int row, int col) {
  return Matrix(row, col);
}

/// Create a matrix with a num
/// - [num] The number to fill the matrix with
/// - [row] The number of rows in the matrix
/// - [col] The number of columns in the matrix
Matrix fill(num num, int row, int col) {
  Matrix matrix = Matrix(row, col);
  matrix.fill(num.toDouble());
  return matrix;
}

/// scalar power of a matrix
/// - [matrix] The matrix to perform the operation on
/// - [x] The power to raise the matrix to
/// - Returns The new matrix
Matrix power(Matrix matrix, int x) {
  return matrix.performFunction((a) => pow(a, x));
}

///dot product of two matrices
/// - [matrixA] The first matrix
/// - [matrixB] The second matrix
/// - Returns The new matrix
Matrix dot(Matrix matrixA, Matrix matrixB) {
  return matrixA.dot(matrixB);
}

///sum of a matrix
/// - [matrix] The matrix to sum
/// - [axis] The axis to sum
/// - Returns The new matrix
dynamic sum(Matrix matrix, int axis) {
  Matrix newMatrix = matrix.sum(axis: axis);
  return newMatrix;
}

///mean of a matrix
/// - [matrix] The matrix to find the mean
/// - Returns The mean
double mean(Matrix matrix) {
  double total = matrix.sum(axis: 0).sum(axis: 1).getAt(0, 0);
  double average =
      total / (matrix.getDimensions()[0] * matrix.getDimensions()[1]);
  return average;
}

///exponential of a matrix
/// - [matrix] The matrix to find the exponential
/// - Returns The new matrix
Matrix exponential(Matrix matrix) {
  return matrix.performFunction((a) => exp(a));
}

///sigmoid of a matrix
/// - [matrix] The matrix to find the sigmoid
/// - Returns The new matrix
Matrix sigmoid(Matrix matrix) {
  return matrix.performFunction((x) => 1 / (1 + exp(-x)));
}

///derivative of a sigmoid matrix
/// - [matrix] The matrix to find the derivative
/// - Returns The new matrix
Matrix sigmoidDeriv(Matrix matrix) {
  return matrix.performFunction(
      (x) => ((1 / (1 + exp(-x))) * (1 - (1 / (1 + exp(-x))))));
}

///tanh of a matrix
/// - [matrix] The matrix to find the tanh
/// - Returns The new matrix
Matrix softmax(Matrix matrix) {
  matrix = matrix.clip(1e-15, 1e10);
  var max = matrix.max();
  var exp = exponential(matrix - max);
  return exp / sum(exp, 1).getAt(0, 0);
}

///derivative of a tanh matrix
/// - [matrix] The matrix to find the derivative
/// - Returns The new matrix
Matrix softmaxDeriv(Matrix matrix) {
  Matrix newMatrix = fill(1, matrix.getRow(), matrix.getCol());
  return matrix * (newMatrix - matrix);
}

///tanh of a matrix
/// - [matrix] The matrix to find the tanh
/// - Returns The new matrix
Matrix tanH(Matrix matrix) {
  return matrix.performFunction((x) => (exp(2 * x) - 1) / (exp(2 * x) + 1));
}

///derivative of a tanh matrix
/// - [matrix] The matrix to find the derivative
/// - Returns The new matrix
Matrix tanHDeriv(Matrix matrix) {
  return matrix.performFunction((x) => 1 - pow(x, 2));
}

///relu of a matrix
/// - [matrix] The matrix to find the relu
/// - Returns The new matrix
Matrix relu(Matrix matrix) {
  return matrix.performFunction((x) => max(0.0, x));
}

///derivative of a relu matrix
/// - [matrix] The matrix to find the derivative
/// - Returns The new matrix
Matrix reluDeriv(Matrix matrix) {
  return matrix.performFunction((x) => x > 0 ? 1.0 : 0.0);
}

///leaky relu of a matrix
/// - [matrix] The matrix to find the leaky relu
/// - Returns The new matrix
Matrix leakyRelu(Matrix matrix) {
  return matrix.performFunction((x) => x > 0 ? x : 0.01 * x);
}

///derivative of a leaky relu matrix
/// - [matrix] The matrix to find the derivative
/// - Returns The new matrix
Matrix leakyDeriv(Matrix matrix) {
  return matrix.performFunction((x) => x > 0 ? 1.0 : 0.01);
}

///linear of a matrix
/// - [matrix] The matrix to find the linear
/// - Returns The new matrix
Matrix linear(Matrix matrix) {
  return matrix;
}

///derivative of a linear matrix
/// - [matrix] The matrix to find the derivative
/// - Returns The new matrix
Matrix linearDeriv(Matrix matrix) {
  return fill(1, matrix.getRow(), matrix.getCol());
}

///finds the derivative function
/// - [activation] The activation function
/// - Returns The derivative function
Matrix Function(Matrix) derivative(Matrix Function(Matrix) activation) {
  final activationMap = {
    sigmoid: sigmoidDeriv,
    tanH: tanHDeriv,
    relu: reluDeriv,
    leakyRelu: leakyDeriv,
    softmax: softmaxDeriv,
    linear: linearDeriv,
  };

  if (activationMap.containsKey(activation)) {
    return activationMap[activation]!;
  } else {
    throw ArgumentError(
        "No derivative available for the given activation function.");
  }
}

///one hot encoding of a matrix
/// - [value] The value to encode
/// - [size] The size of the matrix
/// - Returns The new matrix
Matrix oneHot(int value, int size) {
  Matrix matrix = zeros(1, size);
  matrix.setAt(0, value, value: 1);
  return matrix;
}

///converts a list to a matrix
/// - [values] The list of values
/// - Returns The new matrix
Matrix toMatrix(List<dynamic> values) {
  Matrix matrix = Matrix(1, values.length);
  for (var i = 0; i < values.length - 1; i++) {
    matrix.setAt(0, i, value: double.parse(values[i]));
  }
  return matrix;
}
