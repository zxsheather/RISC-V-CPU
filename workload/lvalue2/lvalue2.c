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

int a[4];
int main() {
  int b[4];
  b[2] = 2;
  int *p;
  p = b;
  printInt(p[2]);
  return judgeResult % Mod;  // 175
}
