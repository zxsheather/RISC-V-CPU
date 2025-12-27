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
// This file use massive recursive expression to test: Common Expression
// substitution. For my optimized version: 	All:	1397	Load:
// 86	Store:	55	Jumped:	23 For my unoptimized version:	All: 24519
// Load:	12183	Store:	55	Jumped:	23 A better result is welcomed. ------
// From JinTianxing.

int A = 1;
int B = 1;
int C = 1;

int main() {
  while (C < (1 << 29) && C > -(1 << 29)) {
    A = ((((((((C - A + B) - (A + B)) + ((C - A + B) - (A + B))) +
             (((C - A + B) - (A + B)) + (C - A + B))) -
            ((((A + B) + (C - A + B)) - (A + B)) +
             (((C - A + B) - (A + B)) + (C - A + B)))) -
           (((((A + B) + (C - A + B)) - ((A + B) + (C - A + B))) -
             (((A + B) + (C - A + B)) - (A + B))) +
            ((((C - A + B) - (A + B)) + (C - A + B)) -
             (((A + B) + (C - A + B)) - (A + B))))) +
          ((((((C - A + B) - (A + B)) + ((C - A + B) - (A + B))) +
             (((C - A + B) - (A + B)) + (C - A + B))) -
            ((((A + B) + (C - A + B)) - (A + B)) +
             (((C - A + B) - (A + B)) + (C - A + B)))) -
           (((((A + B) + (C - A + B)) - (A + B)) +
             (((C - A + B) - (A + B)) + (C - A + B))) -
            ((((A + B) + (C - A + B)) - (A + B)) +
             (((C - A + B) - (A + B)) + (C - A + B)))))) -
         (((((((A + B) + (C - A + B)) - ((A + B) + (C - A + B))) -
             (((A + B) + (C - A + B)) - (A + B))) +
            ((((C - A + B) - (A + B)) + (C - A + B)) -
             (((A + B) + (C - A + B)) - (A + B)))) +
           (((((C - A + B) - (A + B)) + (C - A + B)) -
             (((A + B) + (C - A + B)) - (A + B))) +
            ((((C - A + B) - (A + B)) + (C - A + B)) -
             (((A + B) + (C - A + B)) - (A + B))))) +
          ((((((C - A + B) - (A + B)) + ((C - A + B) - (A + B))) +
             (((C - A + B) - (A + B)) + (C - A + B))) -
            ((((A + B) + (C - A + B)) - (A + B)) +
             (((C - A + B) - (A + B)) + (C - A + B)))) -
           (((((A + B) + (C - A + B)) - (A + B)) +
             (((C - A + B) - (A + B)) + (C - A + B))) -
            ((((A + B) + (C - A + B)) - (A + B)) +
             (((C - A + B) - (A + B)) + (C - A + B)))))));
    B = ((((((((C - A + B) - (A + B)) + ((C - A + B) - (A + B))) +
             (((C - A + B) - (A + B)) + (C - A + B))) -
            ((((A + B) + (C - A + B)) - (A + B)) +
             (((C - A + B) - (A + B)) + (C - A + B)))) -
           (((((A + B) + (C - A + B)) - ((A + B) + (C - A + B))) -
             (((A + B) + (C - A + B)) - (A + B))) +
            ((((C - A + B) - (A + B)) + (C - A + B)) -
             (((A + B) + (C - A + B)) - (A + B))))) +
          ((((((C - A + B) - (A + B)) + ((C - A + B) - (A + B))) +
             (((C - A + B) - (A + B)) + (C - A + B))) -
            ((((A + B) + (C - A + B)) - (A + B)) +
             (((C - A + B) - (A + B)) + (C - A + B)))) -
           (((((A + B) + (C - A + B)) - (A + B)) +
             (((C - A + B) - (A + B)) + (C - A + B))) -
            ((((A + B) + (C - A + B)) - (A + B)) +
             (((C - A + B) - (A + B)) + (C - A + B)))))) -
         (((((((A + B) + (C - A + B)) - ((A + B) + (C - A + B))) -
             (((A + B) + (C - A + B)) - (A + B))) +
            ((((C - A + B) - (A + B)) + (C - A + B)) -
             (((A + B) + (C - A + B)) - (A + B)))) +
           (((((C - A + B) - (A + B)) + (C - A + B)) -
             (((A + B) + (C - A + B)) - (A + B))) +
            ((((C - A + B) - (A + B)) + (C - A + B)) -
             (((A + B) + (C - A + B)) - (A + B))))) +
          ((((((C - A + B) - (A + B)) + ((C - A + B) - (A + B))) +
             (((C - A + B) - (A + B)) + (C - A + B))) -
            ((((A + B) + (C - A + B)) - (A + B)) +
             (((C - A + B) - (A + B)) + (C - A + B)))) -
           (((((A + B) + (C - A + B)) - (A + B)) +
             (((C - A + B) - (A + B)) + (C - A + B))) -
            ((((A + B) + (C - A + B)) - (A + B)) +
             (((C - A + B) - (A + B)) + (C - A + B)))))));
    C = ((((((((C - A + B) - (A + B)) + ((C - A + B) - (A + B))) +
             (((C - A + B) - (A + B)) + (C - A + B))) -
            ((((A + B) + (C - A + B)) - (A + B)) +
             (((C - A + B) - (A + B)) + (C - A + B)))) -
           (((((A + B) + (C - A + B)) - ((A + B) + (C - A + B))) -
             (((A + B) + (C - A + B)) - (A + B))) +
            ((((C - A + B) - (A + B)) + (C - A + B)) -
             (((A + B) + (C - A + B)) - (A + B))))) +
          ((((((C - A + B) - (A + B)) + ((C - A + B) - (A + B))) +
             (((C - A + B) - (A + B)) + (C - A + B))) -
            ((((A + B) + (C - A + B)) - (A + B)) +
             (((C - A + B) - (A + B)) + (C - A + B)))) -
           (((((A + B) + (C - A + B)) - (A + B)) +
             (((C - A + B) - (A + B)) + (C - A + B))) -
            ((((A + B) + (C - A + B)) - (A + B)) +
             (((C - A + B) - (A + B)) + (C - A + B)))))) -
         (((((((A + B) + (C - A + B)) - ((A + B) + (C - A + B))) -
             (((A + B) + (C - A + B)) - (A + B))) +
            ((((C - A + B) - (A + B)) + (C - A + B)) -
             (((A + B) + (C - A + B)) - (A + B)))) +
           (((((C - A + B) - (A + B)) + (C - A + B)) -
             (((A + B) + (C - A + B)) - (A + B))) +
            ((((C - A + B) - (A + B)) + (C - A + B)) -
             (((A + B) + (C - A + B)) - (A + B))))) +
          ((((((C - A + B) - (A + B)) + ((C - A + B) - (A + B))) +
             (((C - A + B) - (A + B)) + (C - A + B))) -
            ((((A + B) + (C - A + B)) - (A + B)) +
             (((C - A + B) - (A + B)) + (C - A + B)))) -
           (((((A + B) + (C - A + B)) - (A + B)) +
             (((C - A + B) - (A + B)) + (C - A + B))) -
            ((((A + B) + (C - A + B)) - (A + B)) +
             (((C - A + B) - (A + B)) + (C - A + B)))))));
  }
  printInt(A);
  // print(" ");
  printInt(B);
  // print(" ");
  printInt(C);
  return judgeResult % Mod;  // 58
}