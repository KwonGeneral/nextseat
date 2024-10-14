
// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nextseat/common/utils/Log.dart';
import 'package:nextseat/data/db/ChatDb.dart';
import 'package:nextseat/domain/model/ChatModel.dart';
import 'package:nextseat/domain/model/RoomModel.dart';
import 'package:nextseat/domain/model/UserModel.dart';
import 'package:nextseat/domain/usecase/chat/GetChatMessageListUseCase.dart';
import 'package:nextseat/domain/usecase/chat/GetCurrentChatRoomUseCase.dart';
import 'package:nextseat/domain/usecase/chat/SendChatMessageUseCase.dart';
import 'package:nextseat/domain/usecase/user/GetMyInfoUseCase.dart';
import 'package:nextseat/injection/injection.dart';
import 'package:nextseat/presenter/BaseViewModel.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:nextseat/presenter/lang/LangKeys.dart';
import 'package:nextseat/presenter/lang/Messages.dart';
import 'package:nextseat/presenter/style/TextStyles.dart';
import 'package:nextseat/presenter/theme/Themes.dart';

// MARK: - 홈 페이지
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    Log.d('HomePage Build');
    return GetBuilder<HomePageViewModel>(
      init: HomePageViewModel(),
      builder: (model) {
        return PopScope(
          canPop: false,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              child: StreamBuilder<bool>(
                stream: ChatDb().unreadMessageStreamController.stream,
                builder: ((context, snapshot) {
                  return Column(
                    children: [
                      Expanded(
                        child: Column(
                          children: List.generate(
                            model.chatList.length,
                                (index) {
                              return BubbleNormal(
                                text: model.getChatItem(index).message,
                                isSender: model.getChatItem(index).userId == model.myInfo?.id,
                                color: model.getChatItem(index).userId == model.myInfo?.id ? SeatThemes().primary : SeatThemes().white,
                                tail: true,
                                textStyle: TextStyles.regular(
                                  fontSize: 16,
                                  color: model.getChatItem(index).userId == model.myInfo?.id ? SeatThemes().surface01 : SeatThemes().surface01,
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 8,
                      ),

                      Container(
                        padding: EdgeInsets.all(8),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: Messages.get(LangKeys.inputMessage),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            ElevatedButton(
                              onPressed: () {},
                              child: Text(Messages.get(LangKeys.send),),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }),
              )
            ),
          ),
        );
      },
    );
  }
}

// MARK: - 홈 페이지 뷰모델
class HomePageViewModel extends BaseViewModel {
  HomePageViewModel()
      : super(
          updateKeys: [
            BaseViewModel.PAGE_UPDATE,
          ],
        );

  // 내 정보
  UserModel? myInfo = getIt<GetMyInfoUseCase>()();

  // 채팅 목록
  List<ChatModel> chatList = [];

  // 채팅방 정보
  RoomModel? roomInfo;

  // 메세지
  TextEditingController messageController = TextEditingController();

  // MARK: - 채팅 전송
  void sendMessage() {
    if (messageController.text.isEmpty) {
      return;
    }

    // 채팅 전송
    getIt<SendChatMessageUseCase>()(
      roomId: roomInfo?.id ?? '',
      message: messageController.text,
    );

    chatList.add(
      ChatModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        roomId: roomInfo?.id ?? '',
        userId: myInfo?.id ?? '',
        message: messageController.text,
        createdAt: DateTime.now(),
      ),
    );

    messageController.clear();
  }

  // MARK: - 채팅 아이템 조회
  ChatModel getChatItem(int index) {
    return chatList[index];
  }

  @override
  void clear({bool isInitClear = false}) {
    Log.d('HomePageViewModel clear');
    chatList.clear();
  }

  @override
  Future<void> dataUpdate() async {
    Log.d('HomePageViewModel dataUpdate');

    chatList = await getIt<GetChatMessageListUseCase>()();
    myInfo = getIt<GetMyInfoUseCase>()();
    roomInfo = await getIt<GetCurrentChatRoomUseCase>()();
    update();
  }

  @override
  Future<void> init() async {
    await dataUpdate();
  }
}
