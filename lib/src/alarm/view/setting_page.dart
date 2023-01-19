import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_source/src/alarm/bloc/setting/setting_bloc.dart';
import 'package:flutter_source/widget/text_field_border.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final timeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SettingBloc()..add(SettingEventLoad()),
      child: _buildBody(),
    );
  }

  Widget _buildBody() {
    return BlocConsumer<SettingBloc, SettingState>(
      listenWhen: (previous, current) {
        if (current is SettingLoaded) {
          return true;
        }
        return false;
      },
      listener: (context, state) {
        if (state is SettingLoaded) {
          timeController.text = state.data;
        }
      },
      buildWhen: (previous, current) {
        if (current is SettingInitial) {
          return true;
        }
        return false;
      },
      builder: (context, state) {
        return Column(
          children: [
            _buildTime(context),
            ElevatedButton(
              onPressed: () {
                context
                    .read<SettingBloc>()
                    .add(SettingEventSave(timeController.text));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: const Text('Lưu'),
            )
          ],
        );
      },
    );
  }

  Widget _buildTime(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Khoảng thời gian lập lại'),
          TextFieldBorder(
            textType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'không được bỏ trống';
              }
              return null;
            },
            hint: 'Nhập giây',
            controller: timeController,
          )
        ],
      ),
    );
  }
}
