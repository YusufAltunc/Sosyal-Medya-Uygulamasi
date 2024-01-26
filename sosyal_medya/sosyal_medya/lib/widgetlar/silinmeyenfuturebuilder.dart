import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
//import 'package:flutter/src/widgets/placeholder.dart';

class SilinmeyenFutureBuilder extends StatefulWidget {
  final Future future;
  final AsyncWidgetBuilder builder;
  const SilinmeyenFutureBuilder(
      {super.key, required this.future, required this.builder});

  @override
  State<SilinmeyenFutureBuilder> createState() =>
      _SilinmeyenFutureBuilderState();
}

class _SilinmeyenFutureBuilderState extends State<SilinmeyenFutureBuilder>
    with AutomaticKeepAliveClientMixin<SilinmeyenFutureBuilder> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(future: widget.future, builder: widget.builder);
  }
}
