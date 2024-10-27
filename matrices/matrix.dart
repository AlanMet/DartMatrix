library matrices;

import 'dart:math';

class Matrix {
  late List<List<double>> _matrix;
  late int _row;
  late int _col;

  int get row => _row;
  int get col => _col;

  Matrix get T => transpose();

  //==========================
  //Initialization and filling
  //==========================

  /// Create a new empty matrix
  /// - [row] The number of rows in the matrix
  /// - [col] The number of columns in the matrix
  /// - Returns The matrix
  Matrix(this._row, this._col) {
    empty();
  }

  ///Creates a matrix from a list
  Matrix.fromList(List<List<double>> list) {
    _row = list.length;
    _col = list[0].length;
    _matrix = List<List<double>>.from(list);
  }

  /// Fills the matrix with random values using a specified generator function
  /// - [generator] The function to generate random values
  /// - Example
  /// ```dart
  /// Matrix matrix = Matrix(2, 2);
  /// matrix.generateDouble(0, 1);
  /// ```
  void _generateValues<T>(T Function() generator) {
    _matrix = List.generate(
        _row,
        (i) => List.generate(_col, (index) => generator() as double,
            growable: false),
        growable: false);
  }

  /// Create an empty matrix
  /// - Example
  /// ```dart
  /// Matrix matrix = Matrix(2, 2); //Empty is called by default
  /// ```
  void empty() {
    _generateValues<double>(() => 0.0);
  }

  /// Fill the matrix with a specific number
  /// - [num] The number to fill the matrix with
  /// - Example
  /// ```dart
  /// Matrix matrix = Matrix(2, 2);
  /// matrix.fill(1);
  /// ```
  void fill(double num) {
    _generateValues<double>(() => num);
  }

  /// Fills the matrix with random doubles
  /// - [min] The minimum value
  /// - [max] The maximum value
  /// - [seed] The optional seed
  void generateDouble(double min, double max, {int? seed}) {
    Random rand = Random(seed);
    _generateValues<double>(() => (rand.nextDouble() * (max - min) + min));
  }

  /// Fills the matrix with random integers
  /// - [min] The minimum value
  /// - [max] The maximum value
  /// - [seed] The optional seed
  void generateInt(int min, int max, {int? seed}) {
    Random rand = Random(seed);
    _generateValues<double>(
        () => (rand.nextInt(max - min + 1) + min).toDouble());
  }

  //==========================
  //Getters and Setters
  //==========================

  ///Gets the matrix as a list
  List<List<double>> getMatrix() {
    return _matrix;
  }

  ///Gets the dimensions of the matrix
  /// - Note
  /// The dimensions are in the form [row, col]
  List<int> getDimensions() {
    List<int> dimensions = [_row, _col];
    return dimensions;
  }

  ///Gets the size of the matrix
  List<int> getSize() => getDimensions();

  /// Get the value of a matrix at a specific index
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

  /*/// Flatten the matrix
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
  }*/

  Matrix round([int places = 8]) {
    return performFunction((a) => double.parse(a.toStringAsFixed(places)));
  }

  //==========================
  //Operators and Operations
  //==========================

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
    if (_row != matrixB.row || _col != matrixB.col) {
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

  ///sum the matrix
  /// - [axis] The axis to sum
  /// - Returns The sum
  /// - Example
  dynamic sum([int? axis = null]) {
    if (axis == null) {
      double total = 0;
      for (var i = 0; i < row; i++) {
        for (double column in _matrix[i]) {
          total += column;
        }
      }
      return total;
    }
    if (axis == 1) {
      Matrix matrix = Matrix(_row, 1);
      for (var i = 0; i < _matrix.length; i++) {
        double total = 0;
        for (double column in _matrix[i]) {
          total += column;
        }
        matrix.setAt(i, 0, value: total);
      }
      return matrix;
    } else if (axis == 0) {
      Matrix matrix = Matrix(1, _col);
      for (var i = 0; i < _col; i++) {
        double total = 0;
        for (var j = 0; j < _row; j++) {
          total += _matrix[j][i];
        }
        matrix.setAt(0, i, value: total);
      }
      return matrix;
    } else {
      throw Exception("Axis must be 0 or 1");
    }
  }

  //==========================
  //Overrides
  //==========================

  List<dynamic> operator [](int index) => _matrix[index];

  void operator []=(int index, List<num> value) {
    if (value.length != _col) {
      throw Exception("Invalid column length");
    }
    _matrix[index] = List<double>.from(value);
  }

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

  //==========================
  //
  //==========================

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

  bool contains(double value) {
    for (var row in _matrix) {
      for (var column in row) {
        if (column == value) {
          return true;
        }
      }
    }
    return false;
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
