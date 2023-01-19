import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_source/src/alarm/view/random_multi_page.dart';
import 'package:flutter_source/src/alarm/view/random_one_page.dart';
import 'package:flutter_source/src/alarm/view/setting_page.dart';
import 'package:flutter_source/widget/sub_page.dart';

class AlarmMainPage extends StatefulWidget {
  AlarmMainPage({super.key});
  final PageStorageBucket bucket = PageStorageBucket();
  @override
  State<AlarmMainPage> createState() => _AlarmMainPageState();
}

class _AlarmMainPageState extends State<AlarmMainPage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    Future.delayed(const Duration(milliseconds: 1000), () {
      FlutterBackgroundService().invoke('stopService');
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBody: true,
      bottomNavigationBar: BottomAppBar(
        color: Colors.blue,
        child: TabBar(
          indicator: UnderlineTabIndicator(
            borderSide: BorderSide(color: Colors.yellow.shade700, width: 3),
          ),
          onTap: (i) {},
          labelPadding: const EdgeInsets.symmetric(horizontal: 5),
          tabs: const [
            Tab(
              icon: Icon(
                Icons.timeline_sharp,
              ),
            ),
            Tab(
              icon: Icon(
                Icons.attach_money,
              ),
            ),
            Tab(
              icon: Icon(
                Icons.settings,
              ),
            ),
          ],
          controller: tabController,
        ),
      ),
      body: SafeArea(
        child: PageStorage(
          bucket: widget.bucket,
          child: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            controller: tabController,
            children: [
              SubPage(
                child: RandomMultiPage(
                  tabController: tabController,
                ),
              ),
              SubPage(
                child: RandomOnePage(
                  tabController: tabController,
                ),
              ),
              const SubPage(child: SettingPage()),
            ],
          ),
        ),
      ),
    );
  }
}
