import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ecomins/core/theme/app_colors.dart';
import 'package:ecomins/data/models/personalization_models.dart';
import 'package:ecomins/providers/personalization_providers.dart';

class WorkerChatScreen extends ConsumerStatefulWidget {
  const WorkerChatScreen({super.key, required this.bookingId});
  final String bookingId;

  @override
  ConsumerState<WorkerChatScreen> createState() => _WorkerChatScreenState();
}

class _WorkerChatScreenState extends ConsumerState<WorkerChatScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  bool _isTyping = false;

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    final msg = ChatMessage(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      text: text,
      senderId: 'mock_user_001',
      time: DateTime.now(),
      isWorker: false,
    );
    final current = ref.read(workerChatProvider);
    ref.read(workerChatProvider.notifier).state = [...current, msg];
    _controller.clear();
    setState(() => _isTyping = false);
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(workerChatProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.onSurface,
        title: Row(
          children: [
            const Text('👨', style: TextStyle(fontSize: 22)),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Ravi Kumar',
                    style: TextStyle(
                        color: AppColors.onSurface,
                        fontSize: 15,
                        fontWeight: FontWeight.w700)),
                Row(
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Text('Online',
                        style: TextStyle(
                            color: AppColors.primary, fontSize: 11)),
                  ],
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Calling Ravi Kumar...')),
              );
            },
            icon: const Icon(Icons.call, color: AppColors.primary, size: 18),
            label: const Text('Call',
                style: TextStyle(color: AppColors.primary, fontSize: 13)),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (_isTyping && index == messages.length) {
                  return const _TypingIndicator();
                }
                final msg = messages[index];
                return _ChatBubble(message: msg);
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
            decoration: const BoxDecoration(
              color: AppColors.surfaceContainerLow,
              border: Border(
                  top: BorderSide(color: Color(0x333C4A3C))),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: const TextStyle(color: AppColors.onSurface),
                    onChanged: (v) =>
                        setState(() => _isTyping = v.isNotEmpty),
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      hintStyle:
                          const TextStyle(color: AppColors.outline),
                      filled: true,
                      fillColor: AppColors.surfaceContainer,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _sendMessage,
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.send,
                        color: AppColors.onPrimary, size: 20),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({required this.message});
  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final isWorker = message.isWorker;
    return Align(
      alignment: isWorker ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.72),
        decoration: BoxDecoration(
          color: isWorker
              ? AppColors.surfaceContainer
              : AppColors.primary.withValues(alpha: 0.2),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isWorker ? 4 : 16),
            bottomRight: Radius.circular(isWorker ? 16 : 4),
          ),
          border: isWorker
              ? null
              : Border.all(
                  color: AppColors.primary.withValues(alpha: 0.4)),
        ),
        child: Column(
          crossAxisAlignment: isWorker
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.end,
          children: [
            Text(
              message.text,
              style: const TextStyle(
                  color: AppColors.onSurface, fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              '${message.time.hour.toString().padLeft(2, '0')}:${message.time.minute.toString().padLeft(2, '0')}',
              style: const TextStyle(
                  color: AppColors.onSurfaceVariant, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}

class _TypingIndicator extends StatelessWidget {
  const _TypingIndicator();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainer,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _Dot(delay: 0),
            SizedBox(width: 4),
            _Dot(delay: 200),
            SizedBox(width: 4),
            _Dot(delay: 400),
          ],
        ),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.delay});
  final int delay;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: const BoxDecoration(
        color: AppColors.onSurfaceVariant,
        shape: BoxShape.circle,
      ),
    );
  }
}
