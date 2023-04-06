void displayRanking(IntList ranking) {
  String[] ordNums = {"1st", "2nd", "3rd", "4th"};
  ranking.reverse();
  background(0);
  fill(green);
  text("GAME OVER", width/2, 100);
  for (int i = 0; i < min(ranking.size(), 4); i++) {
    fill(colorList[ranking.get(i)]);
    text(ordNums[i] + " Player" + str(ranking.get(i) + 1), width/2, 50*i + 200);
  }
  fill(green);
  text("ESC to quit", width/2, 500);
  noLoop();
}
