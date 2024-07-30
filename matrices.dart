import 'dart:math';

class Matrix {
  late List<List<double>> _matrix;
  late int _row;
  late int _col;

  List<dynamic> operator [](int index) => _matrix[index];
  Matrix operator +(Matrix matrixB) => add(matrixB);
  Matrix operator -(Matrix matrixB) => subtract(matrixB);

  Matrix operator /(dynamic value) {
    if (value is Matrix) {
      //multiplies all values from 1 matrix with the other
      return divide(value);
    } else {
      //should multiply all values from 1 matrix with
      return scalarDivide(value);
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

  Matrix(int row, int col) {
    _row = row;
    _col = col;
    empty();
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

  double getAt(int row, int col) {
    return (_matrix[row][col]).toDouble();
  }

  void setAt(int row, int col, {required double value}) {
    _matrix[row][col] = value;
  }

  void empty() {
    _matrix = List<List<double>>.generate(_row,
        (i) => List<double>.generate(_col, (index) => 0.0, growable: false),
        growable: false);
  }

  void fill(double num) {
    _matrix = List<List<double>>.generate(_row,
        (i) => List<double>.generate(_col, (index) => num, growable: false),
        growable: false);
  }

  void generateDouble(double min, double max, {int? seed}) {
    Random rand = Random(seed);
    _matrix = List<List<double>>.generate(
        _row,
        (i) => List<double>.generate(
            _col, (index) => (rand.nextDouble() * (max - min) + min),
            growable: false),
        growable: false);
  }

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

  //same as above but takes a matrix as input
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

  Matrix transpose() {
    Matrix newMatrix = Matrix(_col, _row);
    for (int i = 0; i < _row; i++) {
      for (int j = 0; j < _matrix[i].length; j++) {
        newMatrix.setAt(j, i, value: _matrix[i][j]);
      }
    }
    return newMatrix;
  }

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

  Matrix add(Matrix matrixB) {
    return _performOperation(matrixB, (a, b) => a + b);
  }

  Matrix subtract(Matrix matrixB) {
    return _performOperation(matrixB, (a, b) => a - b);
  }

  Matrix divide(Matrix matrixB) {
    return _performOperation(matrixB, (a, b) => a / b);
  }

  Matrix scalarDivide(double x) {
    Matrix matrixB = Matrix(_row, _col);
    matrixB.fill(1 / x);
    return hadamardProduct(matrixB);
  }

  Matrix multiply(double x) {
    Matrix matrixB = Matrix(_row, _col);
    matrixB.fill(x);
    return hadamardProduct(matrixB);
  }

  Matrix hadamardProduct(Matrix matrixB) {
    return _performOperation(matrixB, (a, b) => a * b);
  }

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

Matrix randn(int row, int col, {int? seed}) {
  Matrix matrix = Matrix(row, col);
  matrix.generateDouble(0, 1, seed: seed);
  return matrix;
}

Matrix zeros(int row, int col) {
  return Matrix(row, col);
}

Matrix fill(num num, int row, int col) {
  Matrix matrix = Matrix(row, col);
  matrix.fill(num.toDouble());
  return matrix;
}

Matrix power(Matrix matrix, int x) {
  return matrix.performFunction((a) => pow(a, x));
}

Matrix dot(Matrix matrixA, Matrix matrixB) {
  return matrixA.dot(matrixB);
}

dynamic sum(Matrix matrix, int axis) {
  Matrix newMatrix = matrix.sum(axis: axis);
  return newMatrix;
}

double mean(Matrix matrix) {
  double total = matrix.sum(axis: 0).sum(axis: 1).getAt(0, 0);
  double average =
      total / (matrix.getDimensions()[0] * matrix.getDimensions()[1]);
  return average;
}

Matrix exponential(Matrix matrix) {
  return matrix.performFunction((a) => exp(a));
}

Matrix sigmoid(Matrix matrix) {
  return matrix.performFunction((x) => 1 / (1 + exp(-x)));
}

Matrix sigmoidDeriv(Matrix matrix) {
  return matrix.performFunction(
      (x) => ((1 / (1 + exp(-x))) * (1 - (1 / (1 + exp(-x))))));
}

Matrix softmax(Matrix matrix) {
  return exponential(matrix) / sum(exponential(matrix), 1);
}

Matrix softmaxDeriv(Matrix matrix) {
  Matrix newMatrix = fill(1, matrix.getRow(), matrix.getCol());
  return matrix * (newMatrix - matrix);
}

Matrix tanH(Matrix matrix) {
  return matrix.performFunction((x) => (exp(2 * x) - 1) / (exp(2 * x) + 1));
}

Matrix tanHDeriv(Matrix matrix) {
  return matrix.performFunction((x) => 1 - pow(x, 2));
}

Matrix relu(Matrix matrix) {
  return matrix.performFunction((x) => max(0.0, x));
}

Matrix reluDeriv(Matrix matrix) {
  return matrix.performFunction((x) => x > 0 ? 1.0 : 0.0);
}

Matrix leakyRelu(Matrix matrix) {
  return matrix.performFunction((x) => x > 0 ? x : 0.01 * x);
}

Matrix leakyDeriv(Matrix matrix) {
  return matrix.performFunction((x) => x > 0 ? 1.0 : 0.01);
}

Matrix linear(Matrix matrix) {
  return matrix;
}

Matrix linearDeriv(Matrix matrix) {
  return fill(1, matrix.getRow(), matrix.getCol());
}

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

Matrix oneHot(int value, int size) {
  Matrix matrix = zeros(1, size);
  matrix.setAt(0, value, value: 1);
  return matrix;
}

Matrix toMatrix(List<dynamic> values) {
  Matrix matrix = Matrix(1, values.length);
  for (var i = 0; i < values.length - 1; i++) {
    matrix.setAt(0, i, value: double.parse(values[i]));
  }
  return matrix;
}
