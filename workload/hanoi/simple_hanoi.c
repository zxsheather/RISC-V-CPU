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

void cd(int d, char *a, char *b, char *c) {
  if (d == 1) {
    // printStr("move ");
    printStr(a);
    // printStr(" --> ");
    printStr(c);
  } else {
    cd(d - 1, a, c, b);
    // printStr("move ");
    printStr(a);
    // printStr(" --> ");
    printStr(c);
    cd(d - 1, b, a, c);
  }
}

char a = 'A';
char b = 'B';
char c = 'C';
int main() {
  int d = 3;
  cd(d, &a, &b, &c);
  return judgeResult % Mod; 
}
