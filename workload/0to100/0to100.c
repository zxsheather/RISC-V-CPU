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

int main() {
    int sum = 0;
    for (int i = 0; i <= 100; i++) {
        sum += i;
    }
    printInt(sum);
    return judgeResult % Mod;
}