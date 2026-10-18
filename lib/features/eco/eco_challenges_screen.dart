import 'package:flutter/material.dart';
import 'package:ecomins/core/theme/app_colors.dart';

class EcoChallengesScreen extends StatefulWidget {
  const EcoChallengesScreen({super.key});

  @override
  State<EcoChallengesScreen> createState() => _EcoChallengesScreenState();
}

class _EcoChallengesScreenState extends State<EcoChallengesScreen> {
  final Set<String> _joined = {};

  final List<_Challenge> _active = const [
    _Challenge(id: 'c1', title: 'Book 5 services this month', progress: 3, total: 5, points: 500),
    _Challenge(id: 'c2', title: 'Recycle 10kg this week', progress: 6, total: 10, points: 300),
    _Challenge(id: 'c3', title: 'Refer 2 friends', progress: 1, total: 2, points: 400),
  ];

  final List<_Challenge> _completed = const [
    _Challenge(id: 'c4', title: 'Booked first service', progress: 1, total: 1, points: 100),
  ];

  void _join(String id) {
    setState(() => _joined.add(id));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Joined!'), backgroundColor: AppColors.primary),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.onSurface,
        title: const Text('Eco Challenges'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Streak counter
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF3A2000), Color(0xFF1A1000)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Row(
              children: [
                Text('🔥', style: TextStyle(fontSize: 32)),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('7 day streak', style: TextStyle(color: Color(0xFFFFB347), fontSize: 20, fontWeight: FontWeight.w800)),
                    Text('Keep it up! You\'re on fire!', style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text('Active Challenges',
              style: TextStyle(color: AppColors.onSurface, fontWeight: FontWeight.w700, fontSize: 16)),
          const SizedBox(height: 12),
          ..._active.map((c) => _ChallengeCard(
            challenge: c,
            joined: _joined.contains(c.id),
            onJoin: () => _join(c.id),
          )),
          const SizedBox(height: 20),
          const Text('Completed',
              style: TextStyle(color: AppColors.onSurfaceVariant, fontWeight: FontWeight.w700, fontSize: 16)),
          const SizedBox(height: 12),
          ..._completed.map((c) => _CompletedChallengeCard(challenge: c)),
        ],
      ),
    );
  }
}

class _ChallengeCard extends StatelessWidget {
  const _ChallengeCard({required this.challenge, required this.joined, required this.onJoin});
  final _Challenge challenge;
  final bool joined;
  final VoidCallback onJoin;

  @override
  Widget build(BuildContext context) {
    final progress = challenge.progress / challenge.total;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(challenge.title,
                    style: const TextStyle(color: AppColors.onSurface, fontWeight: FontWeight.w600, fontSize: 14)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text('+${challenge.points} pts',
                    style: const TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: AppColors.surfaceContainerLow,
                    valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                    minHeight: 8,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text('${challenge.progress}/${challenge.total}',
                  style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: joined
                ? const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_circle, color: AppColors.primary, size: 16),
                      SizedBox(width: 4),
                      Text('Joined', style: TextStyle(color: AppColors.primary, fontSize: 13)),
                    ],
                  )
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.onPrimary,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: onJoin,
                    child: const Text('Join Challenge', style: TextStyle(fontSize: 13)),
                  ),
          ),
        ],
      ),
    );
  }
}

class _CompletedChallengeCard extends StatelessWidget {
  const _CompletedChallengeCard({required this.challenge});
  final _Challenge challenge;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: AppColors.primary, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(challenge.title,
                style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 14)),
          ),
          Text('+${challenge.points} pts',
              style: const TextStyle(color: AppColors.outline, fontSize: 12)),
        ],
      ),
    );
  }
}

class _Challenge {
  const _Challenge({required this.id, required this.title, required this.progress, required this.total, required this.points});
  final String id;
  final String title;
  final int progress;
  final int total;
  final int points;
}
