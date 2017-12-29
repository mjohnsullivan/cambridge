int highByte(int value) => (value & 0xFF00) >> 8;
int lowByte(int value) => value & 0x00FF;

// Algorithm for counting set bits taken from LLVM optimization proposal at:
//    https://llvm.org/bugs/show_bug.cgi?id=1488
bool isParity(int value) {
  int count = 0;

  for (; value != 0; count++) {
    value &= value - 1; // clear the least significant bit set
  }
  return (count % 2 == 0);
}

bool IsBitSet(int value, int bit) => (value & (1 << bit)) == 1 << bit;
int SetBit(int value, int bit) => (value | (1 << bit));
int ResetBit(int value, int bit) => (value & ~(1 << bit));
bool IsSign8(int value) => (value & 0x80) == 0x80;
bool IsSign16(int value) => (value & 0x8000) == 0x8000;
bool IsZero(int value) => value == 0;
