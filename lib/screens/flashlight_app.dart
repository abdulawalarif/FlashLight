import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:torch_controller/torch_controller.dart';
import 'package:alan_voice/alan_voice.dart';

class FlashLightApp extends StatefulWidget {
  const FlashLightApp({Key? key}) : super(key: key);

  @override
  _FlashLightAppState createState() => _FlashLightAppState();
}

class _FlashLightAppState extends State<FlashLightApp>
    with TickerProviderStateMixin {
  //alan voice assistance
  _FlashLightAppState() {
    /// Init Alan Button with project key from Alan Studio
    AlanVoice.addButton(
        "70dc5285e8310a7f8f24637781a7da692e956eca572e1d8b807a3e2338fdd0dc/stage",
        buttonAlign: AlanVoice.BUTTON_ALIGN_LEFT);

    /// Handle commands from Alan Studio
    AlanVoice.onCommand.add((command) => _handleCommand(command.data));
  }

  _handleCommand(Map<String, dynamic> command) {
    switch (command['command']) {
      case "TurnOn":
        controller.toggle();
        break;
      case "TurnOff":
        controller.toggle();
        break;
      default:
        print("Unknown command");
        break;
    }
  }

  late AnimationController _animatedcontroller;
  Color color = Colors.white;
  double fontSize = 20;
  bool isClicked = true;
  final controller = TorchController();

  final DecorationTween decorationTween = DecorationTween(
      begin: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: const [
            BoxShadow(
                color: Colors.white,
                spreadRadius: 5,
                blurRadius: 20,
                offset: Offset(0, 0))
          ],
          border: Border.all(color: Colors.black)),
      end: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black),
          boxShadow: const [
            BoxShadow(
                color: Colors.red,
                spreadRadius: 30,
                blurRadius: 15,
                offset: Offset(0, 0))
          ]));

  @override
  void initState() {
    super.initState();

    _animatedcontroller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          GestureDetector(
            onTap: () {
              if (isClicked) {
                _animatedcontroller.forward();
                fontSize = 40;
                color = Colors.red;
                HapticFeedback.lightImpact();
              } else {
                _animatedcontroller.reverse();
                fontSize = 20;
                color = Colors.white;
                HapticFeedback.lightImpact();
              }
              isClicked = !isClicked;
              controller.toggle();
              setState(() {});
            },
            child: Center(
              child: DecoratedBoxTransition(
                position: DecorationPosition.background,
                decoration: decorationTween.animate(_animatedcontroller),
                child: SizedBox(
                    width: 120,
                    height: 120,
                    child: Center(
                        child: Icon(
                      Icons.power_settings_new,
                      color: isClicked ? Colors.black : Colors.red,
                      size: 60,
                    ))),
              ),
            ),
          ),
          Container(
              height: MediaQuery.of(context).size.height / 1.4,
              alignment: Alignment.bottomCenter,
              child: AnimatedDefaultTextStyle(
                  curve: Curves.ease,
                  child: Text(!isClicked ? 'Flashlight ON' : 'Flashlight OFF'),
                  style: TextStyle(
                      color: color,
                      fontSize: fontSize,
                      letterSpacing: 0.5,
                      fontWeight: FontWeight.bold),
                  duration: const Duration(milliseconds: 200)))
        ],
      ),
    );
  }
}
