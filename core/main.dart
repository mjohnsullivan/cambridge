import 'dart:io';

import 'z80.dart';
import 'memory.dart';

void main() {
  Memory memory = new Memory(true);
  Z80 z80 = new Z80(memory);

  var rom = new File('roms/48.rom').readAsBytesSync();
  memory.load(0x0000, rom);

  int instructionsExecuted = 0;

  while(!z80.cpuSuspended) {
    z80.executeNextInstruction();

    if (instructionsExecuted++ % 0x1000 == 0)
    {
      print("Program Counter: ${z80.pc}");
    }
  }
}