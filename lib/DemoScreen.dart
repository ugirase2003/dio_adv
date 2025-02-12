import 'package:app/EmpProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DemoScreen extends StatefulWidget {
  const DemoScreen({Key? key}) : super(key: key);

  @override
  State<DemoScreen> createState() => _DemoScreenState();
}

class _DemoScreenState extends State<DemoScreen> {
  late final _provider;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) =>
          Provider.of<EmpProvider>(context, listen: false).fetchEmployee(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Heyy Rext"),
      ),
    );
  }
}
