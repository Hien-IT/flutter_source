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
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SettingBloc()..add(SettingEventLoad()),
      child: Form(key: _formKey, child: _buildBody()),
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
                if (_formKey.currentState!.validate()) {
                  final currentFocus = FocusScope.of(context);
                  if (!currentFocus.hasPrimaryFocus &&
                      currentFocus.focusedChild != null) {
                    FocusManager.instance.primaryFocus!.unfocus();
                  }

                  timeController.text =
                      timeController.text.replaceAll(',', '.');

                  context
                      .read<SettingBloc>()
                      .add(SettingEventSave(timeController.text));

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('L??u th??nh c??ng'),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: const Text('L??u'),
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
          const Text('Kho???ng th???i gian l???p l???i'),
          TextFieldBorder(
            textType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'kh??ng ???????c b??? tr???ng';
              }
              return null;
            },
            hint: 'Nh???p gi??y',
            controller: timeController,
          )
        ],
      ),
    );
  }
}
