import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'login_screen.dart';
import 'task_list_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? _selectedAvatar;
  final List<String> _availableAvatars = [
    'assets/images/avatar1.png',
    'assets/images/avatar2.png',
    'assets/images/avatar3.png',
    'assets/images/avatar4.png',
    'assets/images/avatar5.png',
  ];

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().currentUser;
    _selectedAvatar = user?.avatarUrl;
  }

  Future<void> _showAvatarPicker() async {
    final selected = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF37474F),
        title: const Text('Choose Avatar', style: TextStyle(color: Colors.white)),
        content: SizedBox(
          width: double.maxFinite,
          child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: _availableAvatars.length,
            itemBuilder: (context, index) {
              final avatar = _availableAvatars[index];
              final isSelected = avatar == _selectedAvatar;
              return GestureDetector(
                onTap: () => Navigator.pop(context, avatar),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? const Color(0xFFFFC107) : Colors.transparent,
                      width: 3,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage(avatar),
                  ),
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
          ),
        ],
      ),
    );

    if (selected != null) {
      try {
        // Save to Supabase
        await context.read<AuthProvider>().updateAvatar(selected);
        
        setState(() {
          _selectedAvatar = selected;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Avatar updated successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error updating avatar: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _handleLogout() async {
    final authProvider = context.read<AuthProvider>();
    await authProvider.signOut();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        final user = authProvider.currentUser;

        return Scaffold(
          backgroundColor: const Color(0xFF2C3E50),
          appBar: AppBar(
            backgroundColor: const Color(0xFF2C3E50),
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              'Profile',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Avatar Section
                Stack(
                  children: [
                    Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFFFFC107),
                          width: 4,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 65,
                        backgroundColor: const Color(0xFF546E7A),
                        backgroundImage: (user?.avatarUrl != null && user!.avatarUrl!.isNotEmpty)
                            ? AssetImage(user.avatarUrl!)
                            : null,
                        child: (user?.avatarUrl == null || user!.avatarUrl!.isEmpty)
                            ? Text(
                                user?.initials ?? 'U',
                                style: const TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              )
                            : null,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _showAvatarPicker,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFC107),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFF2C3E50),
                              width: 3,
                            ),
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Color(0xFF2C3E50),
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                // Name Field
                _buildProfileField(
                  icon: Icons.person_outline,
                  label: user?.displayName ?? 'User Name',
                  onTap: () {
                    // TODO: Implement name edit
                  },
                ),
                const SizedBox(height: 16),
                // Email Field
                _buildProfileField(
                  icon: Icons.email_outlined,
                  label: user?.email ?? 'email@example.com',
                  onTap: () {
                    // Email is not editable
                  },
                ),
                const SizedBox(height: 16),
                // Password Field
                _buildProfileField(
                  icon: Icons.lock_outline,
                  label: 'Password',
                  onTap: () {
                    // TODO: Implement password change
                  },
                ),
                const SizedBox(height: 16),
                // My Tasks
                _buildProfileField(
                  icon: Icons.list_alt,
                  label: 'My Tasks',
                  trailing: Icons.keyboard_arrow_down,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TaskListScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                // Privacy
                _buildProfileField(
                  icon: Icons.privacy_tip_outlined,
                  label: 'Privacy',
                  trailing: Icons.keyboard_arrow_down,
                  onTap: () {
                    // TODO: Implement privacy settings
                  },
                ),
                const SizedBox(height: 16),
                // Settings
                _buildProfileField(
                  icon: Icons.settings_outlined,
                  label: 'Setting',
                  trailing: Icons.keyboard_arrow_down,
                  onTap: () {
                    // TODO: Implement settings
                  },
                ),
                const SizedBox(height: 40),
                // Logout Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _handleLogout,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFC107),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.logout,
                          color: Color(0xFF2C3E50),
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Logout',
                          style: TextStyle(
                            color: Color(0xFF2C3E50),
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileField({
    required IconData icon,
    required String label,
    IconData? trailing,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: const Color(0xFF546E7A),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.white70,
              size: 24,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              trailing ?? Icons.edit,
              color: Colors.white70,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
