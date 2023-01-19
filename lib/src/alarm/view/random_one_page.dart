import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_source/src/alarm/bloc/one/random_one_bloc.dart';
import 'package:flutter_source/widget/text_field_border.dart';

// ignore: must_be_immutable
class RandomOnePage extends StatefulWidget {
  const RandomOnePage({super.key, required this.tabController});
  final TabController tabController;
  @override
  State<RandomOnePage> createState() => _RandomOnePageState();
}

class _RandomOnePageState extends State<RandomOnePage> {
  final startController = TextEditingController();
  final endController = TextEditingController();
  final coinController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isStart = false;
  Future<void> _onPressed() async {
    if (_formKey.currentState!.validate()) {}
  }

  Future<void> cancelTask() async {}

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RandomOneBloc(),
      child: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildCoin(context),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: isStart ? cancelTask : _onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: isStart ? Colors.red : Colors.green,
            ),
            child: Text(isStart ? 'Huỷ' : 'Lập lịch'),
          )
        ],
      ),
    );
  }

  Widget _buildCoin(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Nhập số coin'),
        TextFieldBorder(
          textType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'không được bỏ trống';
            }
            return null;
          },
          hint: 'Nhập coin',
          controller: coinController,
        )
      ],
    );
  }
}
