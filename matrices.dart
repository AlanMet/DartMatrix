import 'dart:math';

class Matrix {
  late List<List<double>> _matrix;
  late int _row;
  late int _col;

  List<dynamic> operator [](int index) => _matrix[index];
  Matrix operator +(Matrix matrixB) => add(matrixB);
  Matrix operator -(Matrix matrixB) => subtract(matrixB);
  Matrix operator /(Matrix matrixB) => divide(matrixB);
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

  void generateDouble(double min, double max, {int? seed = null}) {
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
    Matrix newMatrix = new Matrix(_row, _col);

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
    Matrix newMatrix =
        new Matrix(getDimensions()[0], matrixB.getDimensions()[1]);
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

  Matrix multiply(double x) {
    Matrix matrixB = Matrix(_row, _col);
    matrixB.fill(x);
    return hadamardProduct(matrixB);
  }

  Matrix hadamardProduct(Matrix matrixB) {
    return _performOperation(matrixB, (a, b) => a * b);
  }

  Matrix sum({required int axis}) {
    Matrix matrix = new Matrix(_row, 1);
    if (axis == 1) {
      for (var i = 0; i < _matrix.length; i++) {
        double total = 0;
        for (double column in _matrix[i]) {
          total += column;
        }
        matrix.setAt(i, 0, value: total);
      }
    } else if (axis == 0) {
      matrix = new Matrix(1, _col);
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

  @override
  String toString() {
    String result = "";
    for (var i = 0; i < _row; i++) {
      result += "${_matrix[i].toString()} \n";
    }
    return result;
  }
}

Matrix randn(int row, int col, {int? seed = null}) {
  Matrix matrix = Matrix(row, col);
  matrix.generateDouble(-1, 1, seed: seed);
  return matrix;
}

Matrix zeros(int row, int col) {
  return Matrix(row, col);
}

Matrix power(Matrix matrix, int x) {
  return matrix.performFunction((a) => pow(a, x));
}

Matrix dot(Matrix matrixA, Matrix matrixB) {
  return matrixA.dot(matrixB);
}

Matrix sum(Matrix matrix, int axis) {
  return matrix.sum(axis: axis);
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

double sigmoid(double x) {
  return 1 / (1 + exp(-x));
}

double sigmoidDeriv(double x) {
  return sigmoid(x) * (1 - sigmoid(x));
}

double tanH(double x) {
  double value = exp(2 * x);
  return (value - 1) / (value + 1);
}

double tanHDeriv(double x) {
  return 1 - pow(tanH(x), 2).toDouble();
}

double relu(double x) {
  return max(0, x);
}

double reluDeriv(double x) {
  return x > 0 ? 1.0 : 0.0;
}

double leakyRelu(double x) {
  return x > 0 ? x : 0.01 * x;
}

double leakyDeriv(double x) {
  return x > 0 ? 1.0 : 0.01;
}

double Function(double) derivative(double Function(double) activation) {
  final activationMap = {
    sigmoid: sigmoidDeriv,
    tanH: tanHDeriv,
    relu: reluDeriv,
    leakyRelu: leakyDeriv,
  };

  if (activationMap.containsKey(activation)) {
    return activationMap[activation]!;
  } else {
    throw ArgumentError(
        "No derivative available for the given activation function.");
  }
}
