// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nextseat/common/utils/DateTimeUtils.dart';
import 'package:nextseat/common/utils/Log.dart';
import 'package:nextseat/data/db/ChatDb.dart';
import 'package:nextseat/domain/model/ChatModel.dart';
import 'package:nextseat/domain/model/UserModel.dart';
import 'package:nextseat/domain/usecase/chat/GetChatMessageListUseCase.dart';
import 'package:nextseat/domain/usecase/chat/SendChatMessageUseCase.dart';
import 'package:nextseat/domain/usecase/user/GetMyInfoUseCase.dart';
import 'package:nextseat/injection/injection.dart';
import 'package:nextseat/presenter/BaseViewModel.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:nextseat/presenter/lang/LangKeys.dart';
import 'package:nextseat/presenter/lang/Messages.dart';
import 'package:nextseat/presenter/style/TextStyles.dart';
import 'package:nextseat/presenter/theme/Themes.dart';
import 'package:nextseat/presenter/widgets/SeatScaffold.dart';

// MARK: - 홈 페이지
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomePageViewModel>(
      init: HomePageViewModel(),
      builder: (model) {
        return PopScope(
          canPop: false,
          child: SeatScaffold(
            backgroundColor: SeatThemes().white,
            resizeToAvoidBottomInset: true,
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _unFocus(context: context, model: model),
                      child: RawScrollbar(
                        thumbColor: SeatThemes().black40,
                        thickness: 2,
                        radius: Radius.circular(8),
                        trackVisibility: true,
                        thumbVisibility: true,
                        scrollbarOrientation: ScrollbarOrientation.right,
                        interactive: true,
                        controller: model.scrollController,
                        child: StreamBuilder<bool>(
                          stream: ChatDb().unreadMessageStreamController.stream,
                          builder: ((context, snapshot) {
                            return Padding(
                              padding: EdgeInsets.only(
                                left: 16,
                                right: 16,
                                top: 16,
                                bottom: 4,
                              ),

                              child: CustomScrollView(
                                controller: model.scrollController,
                                reverse: true,
                                slivers: [
                                  SliverList(
                                    delegate: SliverChildBuilderDelegate(
                                          (context, index) {
                                        if (index >= model.chatList.length) return null;

                                        return ChatMessageWidget(
                                          message: model.getChatItem(index),
                                          isMy: model.getChatItem(index).userId == model.myInfo?.id,
                                          showTimeStamp: _shouldShowTimestamp(
                                            model: model,
                                            currentIndex: index,
                                          ),
                                        );
                                      },

                                      childCount: model.chatList.length,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                  ),
                  ChatInputWidget(
                    controller: model.messageController,
                    onSend: () async {
                      _unFocus(context: context, model: model);
                      await model.sendMessage();
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // MARK: - 타임스탬프 표시 여부
  bool _shouldShowTimestamp({
    required HomePageViewModel model,
    required int currentIndex,
  }) {
    final currentMessage = model.getChatItem(currentIndex);

    // 첫 번째 메시지는 항상 타임스탬프 표시
    if (currentIndex == 0) return true;

    final previousMessage = model.getChatItem(currentIndex - 1);

    // 발신자가 다른 경우 타임스탬프 표시
    if (currentMessage.userId != previousMessage.userId) return true;

    // 같은 시간대(HH:mm)의 메시지인지 확인
    final currentTimestamp = DateTimeUtils.chatViewDateTime(currentMessage.createdAt);
    final previousTimestamp = DateTimeUtils.chatViewDateTime(previousMessage.createdAt);

    // 시간이 다른 경우 타임스탬프 표시
    return currentTimestamp != previousTimestamp;
  }

  // MARK: - 포커스 해제
  void _unFocus({
    required BuildContext context,
    required HomePageViewModel model,
  }) {
    FocusScope.of(context).unfocus();
  }
}

// MARK: - 채팅 메시지 위젯
class ChatMessageWidget extends StatelessWidget {
  final ChatModel message;
  final bool isMy;
  final bool showTimeStamp;

  const ChatMessageWidget({
    super.key,
    required this.message,
    required this.isMy,
    required this.showTimeStamp,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment:
        isMy ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          BubbleNormal(
            text: message.message,
            isSender: isMy,
            color: isMy ? SeatThemes().primary : SeatThemes().secondary,
            tail: true,
            textStyle: TextStyles.regular(
              fontSize: 14,
              color: SeatThemes().surface01,
            ),
          ),
          if (showTimeStamp) ...[
            const SizedBox(height: 2),
            _buildTimestamp(),
          ],
        ],
      ),
    );
  }

  // MARK: - 타임스탬프 위젯
  Widget _buildTimestamp() {
    if (isMy) {
      return Text(
        DateTimeUtils.chatViewDateTime(message.createdAt),
        style: TextStyles.regular(
          fontSize: 8,
          color: SeatThemes().black40,
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          message.userName,
          style: TextStyles.medium(
            fontSize: 8,
            color: SeatThemes().black60,
          ),
        ),
        Text(
          Messages.get(LangKeys.toSendAnonymous),
          style: TextStyles.regular(
            fontSize: 8,
            color: SeatThemes().black40,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          DateTimeUtils.chatViewDateTime(message.createdAt),
          style: TextStyles.regular(
            fontSize: 8,
            color: SeatThemes().black40,
          ),
        ),
      ],
    );
  }
}

// MARK: - 입력 위젯
class ChatInputWidget extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const ChatInputWidget({
    super.key,
    required this.controller,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              cursorColor: SeatThemes().black40,
              decoration: InputDecoration(
                fillColor: SeatThemes().black5,
                filled: true,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 8,
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.transparent,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.transparent,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.transparent,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                hintText: Messages.get(LangKeys.inputMessage),
              ),
              style: TextStyles.regular(
                fontSize: 14,
                color: SeatThemes().surface01,
              ),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: onSend,
            style: ButtonStyle(
              padding: WidgetStateProperty.all(EdgeInsets.zero),
              backgroundColor: WidgetStateProperty.all(SeatThemes().primary),
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(1000),
                ),
              ),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              elevation: WidgetStateProperty.all(0),
              minimumSize: WidgetStateProperty.all(Size(66, 36)),
            ),
            child: Icon(
              Icons.send,
              color: SeatThemes().white,
              size: 24,
            ),
          ),
        ],
      ),
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

  // 스크롤 컨트롤러
  final ScrollController scrollController = ScrollController();

  // 내 정보
  UserModel? myInfo;

  // 채팅 목록
  List<ChatModel> get chatList => getIt<GetChatMessageListUseCase>()();

  // 메세지
  TextEditingController messageController = TextEditingController();

  // 채팅 목록을 시간대별로 정렬
  Map<String, List<ChatModel>> get chatListByTime {
    Map<String, List<ChatModel>> result = {};

    for (ChatModel chat in chatList) {
      String key = DateTimeUtils.chatViewDateTime(chat.createdAt);

      if (!result.containsKey(key)) {
        result[key] = [];
      }

      result[key]!.add(chat);
    }

    return result;
  }

  // MARK: - 채팅 전송
  Future<bool> sendMessage() async {
    try {
      if (messageController.text.isEmpty) {
        return false;
      }

      // 채팅 전송
      await getIt<SendChatMessageUseCase>()(
        message: messageController.text,
      );

      update();

      messageController.clear();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        scrollToBottom();
      });

      return true;
    } catch (e, s) {
      Log.e(e, s);
      return false;
    }
  }

  // MARK: - 스크롤을 최하단으로 이동시키는 메소드
  void scrollToBottom() {
    if (scrollController.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final position = scrollController.position;

        // 이미 최하단이라면 이동하지 않음
        if (position.pixels == 0.0) {
          return;
        }

        // 스크롤 위치에 따른 애니메이션 시간 계산
        final double scrollDistance = position.pixels;
        final double maxScroll = position.maxScrollExtent;

        // 스크롤 거리에 따른 애니메이션 시간 계산 (밀리초)
        int duration = _calculateScrollDuration(
          currentScroll: scrollDistance,
          maxScroll: maxScroll,
        );

        scrollController.animateTo(
          0.0,
          duration: Duration(milliseconds: duration),
          // 긴 거리는 더 빠른 초기 속도로 시작
          curve: scrollDistance > 5000 ? Curves.easeOutCubic : Curves.easeOutQuad,
        );
      });
    }
  }

  // MARK: - 스크롤 거리에 따른 애니메이션 시간 계산
  int _calculateScrollDuration({
    required double currentScroll,
    required double maxScroll,
  }) {
    // 기본 최소/최대 애니메이션 시간 (밀리초)
    const int minDuration = 200;
    const int maxDuration = 800;

    // 전체 스크롤 대비 현재 위치의 비율 계산
    final double scrollRatio = currentScroll / maxScroll;

    if (currentScroll < 1000) {
      // 짧은 거리는 빠르게
      return minDuration;
    } else if (currentScroll > 10000) {
      // 매우 긴 거리는 최대 시간으로 제한
      return maxDuration;
    } else {
      // 스크롤 거리에 따라 시간을 동적으로 계산
      // 거리가 멀수록 비례해서 시간이 증가하지만 maxDuration을 넘지 않음
      return (minDuration + (maxDuration - minDuration) * scrollRatio).toInt();
    }
  }

  // MARK: - Dispose
  @override
  void dispose() {
    messageController.dispose();
    scrollController.dispose();
    super.dispose();
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

    myInfo = await getIt<GetMyInfoUseCase>()();

    update();
  }

  @override
  Future<void> init() async {
    await dataUpdate();
  }
}