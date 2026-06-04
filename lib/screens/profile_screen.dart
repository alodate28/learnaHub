// ==============================
// Profile / Settings Screen
// ==============================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/courses_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _nameController;
  final _formKey = GlobalKey<FormState>(); // مفتاح الـ Form للـ validation
  bool _isEditingName = false;

  @override
  void initState() {
    super.initState();
    final provider = context.read<CoursesProvider>();
    _nameController = TextEditingController(text: provider.username);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CoursesProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: false,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // ---- Avatar ----
            Container(
              width: 90,
              height: 90,
              decoration: const BoxDecoration(
                color: Color(0xFF6C63FF),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  provider.username.isNotEmpty
                      ? provider.username[0].toUpperCase()
                      : 'S',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // ---- اسم المستخدم ----
            if (_isEditingName)
              Form(
                key: _formKey,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _nameController,
                        autofocus: true,
                        decoration: InputDecoration(
                          labelText: 'Your Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.red),
                          ),
                        ),
                        // validation: يتحقق من الاسم قبل الحفظ
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Name cannot be empty';
                          }
                          if (value.trim().length < 2) {
                            return 'Name must be at least 2 characters';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.check, color: Color(0xFF6C63FF)),
                      onPressed: () async {
                        // يحفظ فقط إذا الـ validation نجح
                        if (_formKey.currentState!.validate()) {
                          await provider.setUsername(_nameController.text);
                          setState(() => _isEditingName = false);
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.grey),
                      onPressed: () {
                        _nameController.text = provider.username;
                        setState(() => _isEditingName = false);
                      },
                    ),
                  ],
                ),
              )
            else
              GestureDetector(
                onTap: () => setState(() => _isEditingName = true),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      provider.username,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 6),
                    const Icon(Icons.edit, size: 16, color: Colors.grey),
                  ],
                ),
              ),

            const SizedBox(height: 6),
            Text('LearnHub Member',
                style: TextStyle(color: Colors.grey[500], fontSize: 13)),

            const SizedBox(height: 24),

            // ---- Stats ----
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    label: 'Enrolled',
                    value: provider.enrolledCourses.length.toString(),
                    icon: Icons.bookmark,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    label: 'Completed',
                    value: provider.enrolledCourses
                        .where((c) => provider.getProgress(c.id) == 100)
                        .length
                        .toString(),
                    icon: Icons.check_circle,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 8),

            // ---- Settings ----
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Settings',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 8),

            _SettingsTile(
              icon: Icons.dark_mode,
              title: 'Dark Mode',
              trailing: Switch(
                value: provider.isDarkMode,
                onChanged: (_) => provider.toggleDarkMode(),
                activeColor: const Color(0xFF6C63FF),
              ),
            ),

            const SizedBox(height: 8),

            _SettingsTile(
              icon: Icons.delete_outline,
              title: 'Clear All Data',
              iconColor: Colors.red,
              trailing: const Icon(Icons.chevron_right, color: Colors.grey),
              onTap: () => _showClearDataDialog(context, provider),
            ),

            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 8),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text('About',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 8),
            _SettingsTile(
              icon: Icons.info_outline,
              title: 'LearnHub v1.0.0',
              subtitle: 'Flutter Project — CS Department',
              trailing: const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  void _showClearDataDialog(BuildContext context, CoursesProvider provider) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Clear All Data'),
        content: const Text(
            'This will remove all your enrolled courses and settings. Are you sure?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await provider.clearAllData();
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('All data cleared.')),
                );
              }
            },
            child: const Text('Clear', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label, value;
  final IconData icon;
  const _StatCard({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF6C63FF).withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFF6C63FF), size: 28),
          const SizedBox(height: 6),
          Text(value,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          Text(label, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget trailing;
  final Color? iconColor;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.trailing,
    this.iconColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      leading: Icon(icon, color: iconColor ?? const Color(0xFF6C63FF)),
      title: Text(title, style: const TextStyle(fontSize: 15)),
      subtitle: subtitle != null
          ? Text(subtitle!, style: TextStyle(color: Colors.grey[500]))
          : null,
      trailing: trailing,
      onTap: onTap,
    );
  }
}
