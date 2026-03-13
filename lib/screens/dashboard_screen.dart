import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/auth_provider.dart';
import '../providers/task_provider.dart';
import 'create_task_screen.dart';
import 'task_list_screen.dart';
import 'profile_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  void _navigateToCreateTask(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateTaskScreen()),
    );
  }

  void _navigateToTaskList(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TaskListScreen()),
    );
  }

  void _navigateToProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProfileScreen()),
    );
  }

  String _getMonthName(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthProvider, TaskProvider>(
      builder: (context, authProvider, taskProvider, _) {
        final user = authProvider.currentUser;
        final completedTasks = taskProvider.completedTasks;
        final ongoingTasks = taskProvider.ongoingTasks;

        return Scaffold(
          backgroundColor: AppTheme.darkBackground,
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Welcome Back!',
                                style: TextStyle(
                                  color: AppTheme.yellowAccent,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                user?.displayName ?? 'User',
                                style: const TextStyle(
                                  color: AppTheme.whiteText,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w900,
                                  fontFamily: 'PilatExtended',
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () => _navigateToProfile(context),
                            child: CircleAvatar(
                              radius: 28,
                              backgroundColor: AppTheme.yellowAccent,
                              child: Text(
                                user?.initials ?? 'U',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              decoration: BoxDecoration(
                                color: const Color(0xFF3A4A5A),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.search, color: Colors.grey.shade400),
                                  const SizedBox(width: 12),
                                  Text(
                                    'Search tasks',
                                    style: TextStyle(
                                      color: Colors.grey.shade400,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: AppTheme.yellowAccent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.tune, color: Colors.black, size: 24),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Completed Tasks', style: TextStyle(color: AppTheme.whiteText, fontSize: 20, fontWeight: FontWeight.bold)),
                              TextButton(
                                onPressed: () => _navigateToTaskList(context),
                                child: const Text('See all', style: TextStyle(color: AppTheme.yellowAccent, fontSize: 14)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          completedTasks.isEmpty
                              ? const Center(child: Padding(padding: EdgeInsets.all(20.0), child: Text('No completed tasks yet', style: TextStyle(color: Colors.grey))))
                              : SizedBox(
                                  height: 180,
                                  child: ListView.separated(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: completedTasks.length,
                                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                                    itemBuilder: (context, index) {
                                      final task = completedTasks[index];
                                      return _buildCompletedTaskCard(
                                        task.title,
                                        index % 2 == 0 ? AppTheme.yellowAccent : const Color(0xFF3A4A5A),
                                        index % 2 == 0 ? Colors.black : AppTheme.whiteText,
                                        task.teamMembers,
                                      );
                                    },
                                  ),
                                ),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Ongoing Projects', style: TextStyle(color: AppTheme.whiteText, fontSize: 20, fontWeight: FontWeight.bold)),
                              TextButton(
                                onPressed: () => _navigateToTaskList(context),
                                child: const Text('See all', style: TextStyle(color: AppTheme.yellowAccent, fontSize: 14)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          ongoingTasks.isEmpty
                              ? const Center(child: Padding(padding: EdgeInsets.all(20.0), child: Text('No ongoing tasks. Create one!', style: TextStyle(color: Colors.grey))))
                              : Column(
                                  children: ongoingTasks.map((task) {
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 12),
                                      child: _buildOngoingProjectCard(context, task.title, task.dateTime, task.progressPercentage.toInt(), task.teamMembers),
                                    );
                                  }).toList(),
                                ),
                          const SizedBox(height: 80),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: _buildBottomNavBar(context),
        );
      },
    );
  }

  Widget _buildCompletedTaskCard(String title, Color bgColor, Color textColor, List<String> teamMembers) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              title,
              style: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.w900, fontFamily: 'PilatExtended', height: 1.2),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const Spacer(),
          if (teamMembers.isNotEmpty) ...[
            const Text('Team members', style: TextStyle(color: Colors.grey, fontSize: 11)),
            const SizedBox(height: 6),
            _buildAvatarStack(teamMembers),
            const SizedBox(height: 10),
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Completed', style: TextStyle(color: textColor.withOpacity(0.7), fontSize: 11)),
              Text('100%', style: TextStyle(color: textColor, fontSize: 11, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(value: 1.0, backgroundColor: textColor.withOpacity(0.2), valueColor: AlwaysStoppedAnimation<Color>(textColor)),
        ],
      ),
    );
  }

  Widget _buildOngoingProjectCard(BuildContext context, String title, DateTime dueDate, int progress, List<String> teamMembers) {
    final dateStr = '${dueDate.day} ${_getMonthName(dueDate.month)}';
    return GestureDetector(
      onTap: () => _navigateToTaskList(context),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: const Color(0xFF3A4A5A), borderRadius: BorderRadius.circular(12)),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: AppTheme.whiteText, fontSize: 18, fontWeight: FontWeight.w900, fontFamily: 'PilatExtended')),
                  const SizedBox(height: 12),
                  if (teamMembers.isNotEmpty) ...[
                    const Text('Team members', style: TextStyle(color: Colors.grey, fontSize: 12)),
                    const SizedBox(height: 8),
                    _buildAvatarStack(teamMembers),
                    const SizedBox(height: 12),
                  ],
                  Text('Due on : $dateStr', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(width: 16),
            SizedBox(
              width: 60,
              height: 60,
              child: Stack(
                children: [
                  CircularProgressIndicator(
                    value: progress / 100,
                    strokeWidth: 6,
                    backgroundColor: Colors.grey.shade700,
                    valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.yellowAccent),
                  ),
                  Center(child: Text('$progress%', style: const TextStyle(color: AppTheme.whiteText, fontSize: 14, fontWeight: FontWeight.bold))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarStack(List<String> teamMembers) {
    return Row(
      children: teamMembers.take(3).map((member) {
        final index = teamMembers.indexOf(member);
        return Transform.translate(
          offset: Offset(index * -8.0, 0),
          child: CircleAvatar(
            radius: 14,
            backgroundColor: AppTheme.yellowAccent,
            child: Text(member[0].toUpperCase(), style: const TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold)),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2A3A4A),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, -2))],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home, 'Home', true),
              _buildNavItem(Icons.chat_bubble_outline, 'Chat', false),
              _buildNavItemCenter(context, Icons.add),
              _buildNavItem(Icons.calendar_today, 'Calendar', false),
              _buildNavItem(Icons.notifications_none, 'Notification', false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: isActive ? AppTheme.yellowAccent : Colors.grey, size: 24),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: isActive ? AppTheme.yellowAccent : Colors.grey, fontSize: 10)),
      ],
    );
  }

  Widget _buildNavItemCenter(BuildContext context, IconData icon) {
    return GestureDetector(
      onTap: () => _navigateToCreateTask(context),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: AppTheme.yellowAccent, borderRadius: BorderRadius.circular(12)),
        child: Icon(icon, color: Colors.black, size: 28),
      ),
    );
  }
}
