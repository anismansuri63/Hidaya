
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class AppDrawer extends StatelessWidget {
  final Function(int) onItemSelected;
  final int selectedIndex;

  const AppDrawer({
    super.key,
    required this.onItemSelected,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppColors.of(context);

    return Drawer(
      child: Container(
        color: theme.accent,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: theme.primary,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quran Ayah',
                    style: TextStyle(
                      color: theme.textWhite,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Explore the wisdom of Quran',
                    style: TextStyle(
                      color: theme.textWhite.withOpacity(0.8),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            _buildListTile(context, Icons.line_axis, 'Search Ayah', 7),
            _buildListTile(context, Icons.book, 'Surahs', 1),
            _buildListTile(context, Icons.bookmark, 'Bookmarks', 2),
            _buildListTile(context, Icons.history, 'History', 3),
            _buildListTile(context, Icons.volume_up, 'Recitations', 4),
            _buildListTile(context, Icons.abc, 'Tasbih', 5),
            _buildListTile(context, Icons.abc, 'Flash Cards', 6),
            const Divider(),
            _buildListTile(context, Icons.settings, 'Settings', 8),
            _buildListTile(context, Icons.help, 'Help & Support', 9),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile(BuildContext context, IconData icon, String title, int index) {
    final theme = AppColors.of(context);
    return ListTile(
      leading: Icon(icon, color: theme.primary),
      title: Text(title),
      selected: selectedIndex == index,
      selectedTileColor: theme.secondary,
      onTap: () {
        Navigator.pop(context);
        onItemSelected(index);

      },
    );
  }
}
