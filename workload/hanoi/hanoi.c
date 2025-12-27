int judgeResult = 0;
const int Mod = 253;

void printInt(int x) {
  judgeResult ^= x;
  judgeResult += 173;
}

void printStr(const char *str) {
  for (const char *cur = str; *cur != 0; ++cur) {
    judgeResult ^= *cur;
    judgeResult += 521;
  }
}

int cd(int d, char *a, char *b, char *c, int sum) {
  if (d == 1) {
    printStr("move ");
    printStr(a);
    printStr(" --> ");
    printStr(c);
    sum++;
  } else {
    sum = cd(d - 1, a, c, b, sum);
    printStr("move ");
    printStr(a);
    printStr(" --> ");
    printStr(c);
    sum = cd(d - 1, b, a, c, sum);
    sum++;
  }
  return sum;
}

int main() {
  char a[5] = "A";
  char b[5] = "B";
  char c[5] = "C";
  int d = 10;
  int sum = cd(d, a, b, c, 0);
  printInt(sum);
  return judgeResult % Mod;  // 20
}
