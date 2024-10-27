library matrices.utils;

import 'matrix.dart';
import 'dart:math';

/// Create a matrix with random values
/// - [row] The number of rows in the matrix
/// - [col] The number of columns in the matrix
/// - [seed] The optional seed
/// - Returns The matrix
Matrix randn(int row, int col, {double start = -1, double end = 1, int? seed}) {
  Matrix matrix = Matrix(row, col);
  matrix.generateDouble(start, end, seed: seed);
  return matrix;
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

/// dot product of two matrices
/// - [matrixA] The first matrix
/// - [matrixB] The second matrix
/// - Returns The new matrix
Matrix dot(Matrix matrixA, Matrix matrixB) {
  return matrixA.dot(matrixB);
}

/// sum of a matrix
/// - [matrix] The matrix to sum
/// - [axis] The axis to sum
/// - Returns The new matrix
dynamic sum(Matrix matrix, int axis) {
  Matrix newMatrix = matrix.sum(axis);
  return newMatrix;
}

/// mean of a matrix
/// - [matrix] The matrix to find the mean
/// - Returns The mean
double mean(Matrix matrix) {
  double total = matrix.sum(0).sum(1).getAt(0, 0);
  double average =
      total / (matrix.getDimensions()[0] * matrix.getDimensions()[1]);
  return average;
}

/// converts a list to a matrix
/// - [values] The list of values
/// - Returns The new matrix
Matrix toMatrix(List<dynamic> values) {
  Matrix matrix = Matrix(1, values.length);
  for (var i = 0; i < values.length - 1; i++) {
    matrix.setAt(0, i, value: double.parse(values[i]));
  }
  return matrix;
}

/// Find the index of the maximum value in the matrix
/// - [matrix] The matrix to find the maximum value index
/// - Returns A list containing the row and column index of the maximum value
List<int> maxIndex(Matrix matrix) {
  int maxRow = 0;
  int maxCol = 0;
  double maxValue = matrix.getAt(0, 0);

  for (int i = 0; i < matrix.row; i++) {
    for (int j = 0; j < matrix.col; j++) {
      double currentValue = matrix.getAt(i, j);
      if (currentValue > maxValue) {
        maxValue = currentValue;
        maxRow = i;
        maxCol = j;
      }
    }
  }

  return [maxRow, maxCol];
}

double maxValue(Matrix matrix) {
  List<int> location = maxIndex(matrix);
  return matrix.getAt(location[0], location[1]);
}

/// Find the index of the maximum value in the matrix
/// - [matrix] The matrix to find the maximum value index
/// - Returns A list containing the row and column index of the maximum value
List<int> minIndex(Matrix matrix) {
  int maxRow = 0;
  int maxCol = 0;
  double minValue = matrix.getAt(0, 0);

  for (int i = 0; i < matrix.row; i++) {
    for (int j = 0; j < matrix.col; j++) {
      double currentValue = matrix.getAt(i, j);
      if (currentValue < minValue) {
        minValue = currentValue;
        maxRow = i;
        maxCol = j;
      }
    }
  }

  return [maxRow, maxCol];
}

double minValue(Matrix matrix) {
  List<int> location = minIndex(matrix);
  return matrix.getAt(location[0], location[1]);
}
