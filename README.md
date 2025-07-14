# 🧮 Matrix Library for Dart

A lightweight and efficient matrix manipulation library written in Dart.  
Designed for numerical computing, neural network utilities, and general matrix operations.

can be downloaded through [pub.dev](https://pub.dev/packages/dart_matrix/install)
---

## 📂 Project Structure

test/
matrices/
├── matrix.dart # Core Matrix class and basic operations
├── matrices.dart # Higher-level matrix functions and batch operations
├── nnutils.dart # Neural network utility functions (activation, loss, etc.)
├── utils.dart # Helper functions (math helpers, validation, etc.)

yaml
Copy
Edit

---

## 🚀 Getting Started

Add the library files to your Dart project, then import the needed modules:

```dart
import 'matrices/matrix.dart';
import 'matrices/nnutils.dart';
``

## 🧰 Features
Core matrix data structure with standard operations: addition, multiplication, transpose, etc.

Neural network utilities such as activation functions and gradient calculations

Helper utilities for matrix validation and math functions

Support for common linear algebra operations

## 📖 Usage Example
```dart
import 'matrices/matrix.dart';

void main() {
  // Create two matrices
  var A = Matrix([
    [1, 2],
    [3, 4],
  ]);

  var B = Matrix([
    [5, 6],
    [7, 8],
  ]);

  // Multiply matrices
  var C = A * B;

  print('Result:\n$C');
}
```
## 📁 File Details
matrix.dart
Contains the Matrix class implementation with constructors, operators, and basic matrix algebra methods.

- matrices.dart
Contains extended matrix operations, batch processing, and utility functions operating on multiple matrices.

- nnutils.dart
Neural network helper functions such as activation (ReLU, sigmoid), loss calculations, and derivatives.

- utils.dart
General-purpose utilities like input validation, numeric helpers, and common math operations.

