import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomSwitch extends StatefulWidget {
  CustomSwitch({required this.value, required this.onChanged, super.key});
  bool value;
  final void Function(bool) onChanged;
  @override
  State<CustomSwitch> createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch> {
  @override
  Widget build(BuildContext context) {
    return Switch(
      activeColor: Theme.of(context).primaryColor,
      activeTrackColor: Theme.of(context).primaryColor.withOpacity(0.5),
      value: widget.value,
      onChanged: (i) {
        setState(() {
          widget.value = !widget.value;
        });
        widget.onChanged.call(i);
      },
    );
  }
}
