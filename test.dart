import 'matrices/matrices.dart';

void main() {
  Matrix matrix = Matrix.fromList([
    [1.0, 0.0],
    [3.0, 4.0]
  ]);
  Matrix result = softmaxDeriv(matrix);
  print(result);
}
