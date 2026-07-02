enum Difficulty {
  easy(9, 9, 10),
  medium(16, 16, 40),
  hard(30, 16, 99),
  custom(0, 0, 0);

  const Difficulty(this.width, this.height, this.mines);

  final int width;
  final int height;
  final int mines;
}
