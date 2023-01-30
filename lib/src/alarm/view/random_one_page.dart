import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_source/src/alarm/bloc/one/random_one_bloc.dart';
import 'package:flutter_source/src/alarm/model/random_model.dart';
import 'package:flutter_source/widget/custom_switch.dart';
import 'package:flutter_source/widget/text_field_border.dart';

// ignore: must_be_immutable
class RandomOnePage extends StatefulWidget {
  const RandomOnePage({super.key, required this.tabController});
  final TabController tabController;
  @override
  State<RandomOnePage> createState() => _RandomOnePageState();
}

class _RandomOnePageState extends State<RandomOnePage> {
  final coinController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isStart = false;
  bool isRunnging = false;
  final listNotification = <String>[];

  Future<void> _onPressed(BuildContext context) async {
    if (listNotification.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng chọn ít nhất 1 số thông báo'),
        ),
      );
      return;
    }
    if (_formKey.currentState!.validate()) {
      BlocProvider.of<RandomOneBloc>(context).add(
        SaveNotification(listNotification),
      );
      BlocProvider.of<RandomOneBloc>(context).add(RandomOneCheckTime());
    }
  }

  Future<void> cancelTask(BuildContext context) async {
    BlocProvider.of<RandomOneBloc>(context).add(RandomOneEventStop());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RandomOneBloc()..add(GetOneList()),
      child: BlocConsumer<RandomOneBloc, RandomOneState>(
        listenWhen: (previous, current) {
          if (current is RandomOneTimeChecked) {
            return true;
          }
          return false;
        },
        listener: (context, state) {
          if (state is RandomOneTimeChecked) {
            if (state.isChecked) {
              BlocProvider.of<RandomOneBloc>(context).add(
                RandomOneEventStart(
                  start: '0',
                  end: '1',
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
          if (current is RandomOneInitial) {
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

  Widget _buildBody(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildCoin(context),
            const SizedBox(height: 8),
            const Text('Thông báo khi kết quả random bằng'),
            const SizedBox(height: 8),
            _buildSwitch(),
            const SizedBox(height: 16),
            BlocBuilder<RandomOneBloc, RandomOneState>(
              buildWhen: (previous, current) {
                if (current is RandomOneStarted) {
                  return true;
                }
                return false;
              },
              builder: (context, state) {
                if (state is RandomOneStarted) {
                  isStart = state.isStart;
                }
                return ElevatedButton(
                  onPressed: () {
                    if (isStart) {
                      cancelTask(context);
                    } else {
                      _onPressed(context);
                    }
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

  Widget _buildSwitch() {
    return Row(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('0'),
            CustomSwitch(
              value: false,
              onChanged: (i) {
                if (i) {
                  listNotification.add('0');
                } else {
                  listNotification.remove('0');
                }
              },
            )
          ],
        ),
        const SizedBox(width: 8),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('1'),
            CustomSwitch(
              value: false,
              onChanged: (i) {
                if (i) {
                  listNotification.add('1');
                } else {
                  listNotification.remove('1');
                }
              },
            )
          ],
        ),
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
            if ((int.tryParse(value) ?? 0) > 10) {
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
    return BlocBuilder<RandomOneBloc, RandomOneState>(
      buildWhen: (previous, current) {
        if (current is LastRandomOneLoaded) {
          return true;
        }
        return false;
      },
      builder: (context, state) {
        if (state is LastRandomOneLoaded) {
          return SizedBox(
            height: 80,
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
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(4),
            width: 30,
            height: 30,
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
          const SizedBox(height: 4),
          Text('${model.coin}'),
        ],
      ),
    );
  }

  Widget _buildList(BuildContext context) {
    return BlocBuilder<RandomOneBloc, RandomOneState>(
      buildWhen: (previous, current) {
        if (current is ListRandomOneLoaded) {
          return true;
        }
        return false;
      },
      builder: (context, state) {
        if (state is ListRandomOneLoaded) {
          return Expanded(
            child: ListView.builder(
              itemCount: state.list.length,
              itemBuilder: (context, index) {
                return _buildItem(context, state.list[index], index + 1);
              },
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildItem(BuildContext context, RandomList item, int index) {
    var text = '';

    for (var i = 0; i < (item.list ?? []).length; i++) {
      text += '${item.list?[i].random}, ';
    }
    if (text.endsWith(', ')) {
      text = text.substring(0, text.length - 2);
    }
    text = '$index: $text';

    return ColoredBox(
      color: index % 2 == 0 ? Colors.grey.shade200 : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Text(text),
      ),
    );
  }
}
