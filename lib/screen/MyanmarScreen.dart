import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mal/Http/Api.dart';
import 'package:mal/Model/MyanmarModel.dart';
import 'package:mal/Model/StreamModel.dart';
import 'package:mal/screen/VideoPlayer.dart';
import 'package:dim_loading_dialog/dim_loading_dialog.dart';

class MyanmarScreen extends StatefulWidget {
  const MyanmarScreen({super.key});

  @override
  State<MyanmarScreen> createState() => _MyanmarScreenState();
}

class _MyanmarScreenState extends State<MyanmarScreen> {
  List<MyanmarModel> _list = [];
  List<MyanmarModel> _result = [];
  var controller = ScrollController();
  int page = 1;
  bool bol = false;
  

  TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    loading();
    result();
    super.initState();
  }

  

  loading() async {
    setState(() {
      page = 1;
    });
    List<MyanmarModel> list = await Api.GetMyanmar(page);
    setState(() {
      _list = list;
      _result = _list;
    });
  }

  result() {
    controller.addListener(() async {
      if (controller.position.maxScrollExtent == controller.offset) {
        setState(() {
          page = page + 1;
          bol = true;
        });
        List<MyanmarModel> list = await Api.GetMyanmar(page);
        _list.addAll(list);
        if (list.isNotEmpty) {
          setState(() {
            bol = false;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    DimLoadingDialog dimDialog = DimLoadingDialog(context,
        blur: 2,
        dismissable: true,
        backgroundColor: const Color(0x33000000),
        animationDuration: const Duration(milliseconds: 500));
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        title: const Text(
          "Buu Mal(ဘူးမယ်)",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.grey, borderRadius: BorderRadius.circular(100)),
              child: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: TextField(
                  onChanged: (value) => _runfilter(value),
                  controller: searchController,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.search,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                      prefixIconColor: Colors.white,
                      prefixIcon: Icon(Icons.search),
                      border: InputBorder.none,
                      hintText: "Search...",
                      hintStyle: TextStyle(color: Colors.white)),
                ),
              ),
            ),
          ),
          Expanded(
              child: _result.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : RefreshIndicator(
                      onRefresh: () => loading(),
                      child: AlignedGridView.count(
                        controller: controller,
                        crossAxisCount: 3,
                        mainAxisSpacing: 3,
                        crossAxisSpacing: 3,
                        itemCount: _result.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () async {
                              dimDialog.show();
                             
                              List<StreamModel> list =
                                  await Api.GetStream(_list[index].link);
                              if (list.isNotEmpty) {
                                dimDialog.dismiss();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: ((context) => VideoPlayer(
                                              url: list[0].link,
                                              refer: list[0].referer,
                                              title: _list[index].title,
                                              time: _list[index].time,
                                              mx_player_link:
                                                  list[0].mx_player_link,
                                            ))));
                              }
                            },
                            child: Container(
                              width: 120,
                              margin: const EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5)),
                              child: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(5.0),
                                    child: Container(
                                      decoration: const BoxDecoration(
                                          color: Colors.grey),
                                      child: Image.network(
                                        _result[index].profile,
                                        fit: BoxFit.fill,
                                        width:
                                            MediaQuery.of(context).size.width /
                                                4 *
                                                1.5,
                                        height:
                                            MediaQuery.of(context).size.height /
                                                4,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Image.asset(
                                            'lib/images/logo.png',
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                4 *
                                                1.5,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                4,
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    _result[index].title,
                                    style: const TextStyle(color: Colors.black),
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ))
        ],
      ),
      bottomNavigationBar: Visibility(
          visible: bol,
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 23),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Loading...",
                  style: TextStyle(fontSize: 25),
                )
              ],
            ),
          )),
    );
  }

  _runfilter(String value) {
    List<MyanmarModel> list = [];
    if (value.isEmpty) {
      setState(() {
        list = _list;
      });
    } else {
      setState(() {
        list = _list
            .where((element) => element.title
                .toString()
                .toLowerCase()
                .contains(value.toLowerCase().toString()))
            .toList();
      });
    }
    setState(() {
      _result = list;
    });
  }
}
