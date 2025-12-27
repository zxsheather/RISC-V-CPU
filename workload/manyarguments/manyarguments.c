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
int a(int a1, int a2, int a3, int a4, int a5, int a6, int a7, int a8, int a9,
      int a10, int a11, int a12, int a13, int a14, int a15) {
  return a1 + a2 + a3 + a4 + a5 + a6 + a7 + a8 + a9 + a10 + a11 + a12 + a13 +
         a14 + a15;
}

int main() {
  printInt(a(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15));
  return judgeResult % Mod;  // 40
}
