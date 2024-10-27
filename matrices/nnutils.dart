library matrices.NetUtils;

import 'matrix.dart';
import 'utils.dart';
import 'dart:math';

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

/// Softmax of a matrix
/// - [matrix] The matrix to find the softmax
/// - Returns The new matrix
Matrix softmax(Matrix matrix) {
  Matrix result = Matrix(matrix.row, matrix.col);
  for (int i = 0; i < matrix.row; i++) {
    List<double> row = matrix[i] as List<double>;
    double maxV = row.reduce((a, b) => a > b ? a : b);
    List<double> expValues = row.map((x) => exp(x - maxV)).toList();
    double sumExp = expValues.reduce((a, b) => a + b);
    for (int j = 0; j < row.length; j++) {
      result.setAt(i, j, value: expValues[j] / sumExp);
    }
  }
  return result;
}

///derivative of a tanh matrix
/// - [matrix] The matrix to find the derivative
/// - Returns The new matrix
Matrix softmaxDeriv(Matrix matrix) {
  Matrix softmaxValues = Matrix(matrix.row, matrix.col);
  for (int i = 0; i < matrix.row; i++) {
    List<double> row = matrix[i] as List<double>;
    double maxV = row.reduce((a, b) => a > b ? a : b);

    // Calculate softmax values for the current row
    List<double> softmaxRow = row.map((x) => exp(x - maxV)).toList();
    double sumExp = softmaxRow.reduce((a, b) => a + b);
    softmaxRow = softmaxRow.map((x) => x / sumExp).toList();

    // Fill the softmaxValues matrix
    for (int j = 0; j < matrix.col; j++) {
      softmaxValues.setAt(i, j, value: softmaxRow[j]);
    }
  }

  // Create the Jacobian matrix
  Matrix jacobian = Matrix(softmaxValues.row, softmaxValues.col);
  for (int i = 0; i < softmaxValues.row; i++) {
    for (int j = 0; j < softmaxValues.col; j++) {
      if (i == j) {
        // Diagonal elements
        jacobian.setAt(i, j,
            value: softmaxValues.getAt(i, j) * (1 - softmaxValues.getAt(i, j)));
      } else {
        // Off-diagonal elements
        jacobian.setAt(i, j,
            value: -softmaxValues.getAt(i, j) * softmaxValues.getAt(j, j));
      }
    }
  }
  return jacobian;
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
  return fill(1, matrix.row, matrix.col);
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
