


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:makefriend/core/config.dart';
import 'package:makefriend/core/service.dart';
import 'package:makefriend/core/websocket.dart';
import 'package:makefriend/data/repository/chat_repository.dart';
import 'package:makefriend/data/repository/danhgia_repository.dart';
import 'package:makefriend/data/repository/search_repository.dart';
import 'package:makefriend/logic/danhgia/danhgia_bloc.dart';
import 'package:makefriend/logic/message/chat_bloc.dart';
import 'package:makefriend/logic/search/search_bloc.dart';
import 'package:makefriend/logic/timkiem/timkiem_bloc.dart';
import 'package:makefriend/ui/message_main.dart';
import 'package:makefriend/ui/profile_page.dart';
import 'package:makefriend/ui/search_page.dart';
import 'package:makefriend/ui/vote_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {


  int curentPageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: Stack(children: [ Container(
        decoration: BoxDecoration(
          color: Colors.white,

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),

        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: NavigationBar(
            backgroundColor: Colors.white,
            height: 70,
            elevation: 0,
            selectedIndex: curentPageIndex,
            onDestinationSelected: (index) {
              setState(() {
                curentPageIndex = index;
              });
            },
            indicatorColor: Colors.blue[100],
            destinations: const [
              NavigationDestination(icon: Icon(Icons.home), label: "Tìm kiếm"),
              NavigationDestination(icon: Icon(Icons.messenger), label: "Tin nhắn"),
              NavigationDestination(icon: Icon(Icons.how_to_vote), label: "Đánh giá"),
              NavigationDestination(icon: Icon(Icons.person), label: "Thông tin"),
            ],
          ),
        ),
      ) ]),
      body: IndexedStack(
        index: curentPageIndex,
        children: [
          MultiBlocProvider(
            providers: [
              BlocProvider<SearchBloc>(
                create: (context) => SearchBloc(
                  repository: SearchRepository(apiService: ApiService()),
                ),
              ),
              BlocProvider<TimkiemBloc>(
                create: (context) => TimkiemBloc(
                repository: SearchRepository(apiService: ApiService()),
                ),
              ),
            ],
              child: SearchPage()
          ),
          BlocProvider(
            create: (_) => ChatBloc(
              ChatRepository(apiService: ApiService()),
              WebSocketService('${API_SERVER}ws'),
            ),
            child: const MessageMain(),
          ),
          BlocProvider(
            create: (_) => DanhGiaBloc(repository:
              DanhgiaRepository(apiService: ApiService()),
            ),
            child: const DanhGiaPage(),
          ),
          const ProfilePage()
        ],
      ),

    );
  }
}

