import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as image2;
import 'package:spectrum/spectrum.dart';

class Spectrum extends StatefulWidget {
  Spectrum({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SpectrumState createState() => new _SpectrumState();
}

class _SpectrumState extends State<Spectrum> {
  Z80 z80;
  Memory memory;
  int instructionCounter = 0;
  Image displayFrame;

  _SpectrumState() {
    memory = new Memory(true);
    z80 = new Z80(memory, startAddress: 0x0000);
    displayFrame = new Image.asset('assets/blank.jpg');
  }

  @override
  void dispose() {
    memory = null;
    super.dispose();
  }

  executeBatch() async {
    if (instructionCounter == 0) {
      ByteData rom = await rootBundle.load('roms/48.rom');
      memory.load(0x0000, rom.buffer.asUint8List());
      z80.reset();
      instructionCounter++;
      createSpectrumFrame();
    } else {
      setState(() {
        while (instructionCounter++ % 0x10000 != 0) {
          z80.executeNextInstruction();
        }
        createSpectrumFrame();
      });
    }
  }

  createSpectrumFrame() {
    var frame = new image2.Image(Display.Width, Display.Height);
    final buffer = Display.imageBuffer(memory);

    for (int x = 0; x < Display.Width; x++) {
      for (int y = 0; y < Display.Height; y++) {
        SpectrumColor c = new SpectrumColor(buffer[x * Display.Height + y]);
        frame.setPixelRGBA(x, y, c.red, c.green, c.blue);
      }
    }

    final jpg = image2.encodeJpg(frame, quality: 100);
    final img = new Image.memory(jpg);
    displayFrame = img;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.arrow_forward),
        onPressed: executeBatch,
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            displayFrame,
            new Text(z80 == null
                ? 'null'
                : toHex16(z80.pc)) // yeah - we're wired up :)
          ],
        ),
      ),
    );
  }
}
