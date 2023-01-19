import 'package:flutter/material.dart';

class SubPage extends StatefulWidget {
  const SubPage({required this.child, super.key});
  final Widget child;

  @override
  _SubPageState createState() => _SubPageState();
}

class _SubPageState extends State<SubPage> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }

  @override
  bool get wantKeepAlive => true;
}
