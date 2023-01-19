// ignore_for_file: avoid_dynamic_calls

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_source/src/alarm/bloc/multi/random_multi_bloc.dart';
import 'package:flutter_source/src/alarm/model/random_model.dart';
import 'package:flutter_source/widget/text_field_border.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class RandomMultiPage extends StatefulWidget {
  const RandomMultiPage({super.key, required this.tabController});
  final TabController tabController;
  @override
  State<RandomMultiPage> createState() => _AlarmPageState();
}

class _AlarmPageState extends State<RandomMultiPage> {
  final startController = TextEditingController();
  final endController = TextEditingController();
  final coinController = TextEditingController();
  bool isStart = false;
  final _formKey = GlobalKey<FormState>();
  late SharedPreferences prefs;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RandomMultiBloc()
        ..add(RandomMultiInit())
        ..add(GetMultiList()),
      child: BlocConsumer<RandomMultiBloc, RandomMultiState>(
        listenWhen: (previous, current) {
          if (current is RandomMultiTimeChecked) {
            return true;
          }
          return false;
        },
        listener: (context, state) {
          if (state is RandomMultiTimeChecked) {
            if (state.isChecked) {
              BlocProvider.of<RandomMultiBloc>(context).add(
                RandomMultiEventStart(
                  start: startController.text,
                  end: endController.text,
                  coin: coinController.text,
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Vui lòng cài đặt thời gian'),
                  action: SnackBarAction(
                    label: 'Ok',
                    onPressed: () {
                      widget.tabController.animateTo(2);
                    },
                  ),
                ),
              );
            }
          }
        },
        buildWhen: (previous, current) {
          if (current is RandomMultiInitial) {
            return true;
          }
          return false;
        },
        builder: (context, state) {
          return _buildBody(context);
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  Future<void> _onPressed(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      BlocProvider.of<RandomMultiBloc>(context).add(RandomMultiCheckTime());
    }
  }

  Future<void> cancelTask(BuildContext context) async {
    BlocProvider.of<RandomMultiBloc>(context).add(RandomMultiEventStop());
  }

  Widget _buildBody(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildRandom(context),
            const SizedBox(height: 16),
            _buildCoin(context),
            const SizedBox(height: 16),
            BlocBuilder<RandomMultiBloc, RandomMultiState>(
              buildWhen: (previous, current) {
                if (current is RandomMultiStarted) {
                  return true;
                }
                return false;
              },
              builder: (context, state) {
                if (state is RandomMultiStarted) {
                  isStart = state.isStart;
                }
                return ElevatedButton(
                  onPressed: () {
                    isStart ? cancelTask(context) : _onPressed(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isStart ? Colors.red : Colors.green,
                  ),
                  child: Text(isStart ? 'Huỷ' : 'Lập lịch'),
                );
              },
            ),
            const SizedBox(height: 16),
            _buildCircle(context),
            const SizedBox(height: 16),
            _buildList(context)
          ],
        ),
      ),
    );
  }

  Widget _buildRandom(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('Khoảng random'),
        Row(
          children: [
            Expanded(
              child: TextFieldBorder(
                textType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'không được bỏ trống';
                  }
                  return null;
                },
                hint: 'Nhập số bắt đầu',
                controller: startController,
              ),
            ),
            const Text('->'),
            Expanded(
              child: TextFieldBorder(
                textType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'không được bỏ trống';
                  }
                  return null;
                },
                hint: 'Nhập số kết thúc',
                controller: endController,
              ),
            ),
          ],
        )
      ],
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
            if ((int.tryParse(value) ?? 0) > 9) {
              return 'không được lớn hơn 9';
            }
            return null;
          },
          hint: 'Nhập coin',
          controller: coinController,
        )
      ],
    );
  }

  Widget _buildCircle(BuildContext context) {
    return BlocBuilder<RandomMultiBloc, RandomMultiState>(
      buildWhen: (previous, current) {
        if (current is LastRandomMultiLoaded) {
          return true;
        }
        return false;
      },
      builder: (context, state) {
        if (state is LastRandomMultiLoaded) {
          return SizedBox(
            height: 105,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: state.item.length,
              itemBuilder: (context, index) {
                return _buildItemCircle(context, state.item[index]);
              },
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildItemCircle(BuildContext context, RandomModel model) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.green,
            ),
            child: Center(
              child: Text(
                '${model.random}',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text('coin: ${model.coin}'),
        ],
      ),
    );
  }

  Widget _buildList(BuildContext context) {
    return BlocBuilder<RandomMultiBloc, RandomMultiState>(
      buildWhen: (previous, current) {
        if (current is ListRandomMultiLoaded) {
          return true;
        }
        return false;
      },
      builder: (context, state) {
        if (state is ListRandomMultiLoaded) {
          return Expanded(
            child: ListView.builder(
              itemCount: state.list.length,
              itemBuilder: (context, index) {
                return _buildItem(context, state.list[index]);
              },
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

Widget _buildItem(BuildContext context, RandomList item) {
  final list = <Widget>[];

  for (var i = 0; i < (item.list ?? []).length; i++) {
    list.add(
      ListTile(
        title: Text('${item.list?[i].random}'),
        subtitle: Text('coin: ${item.list?[i].coin}'),
      ),
    );
  }

  return Column(
    mainAxisSize: MainAxisSize.min,
    children: list,
  );
}
