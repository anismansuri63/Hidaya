
import 'package:flutter/material.dart';

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
    return Drawer(
      child: Container(
        color: const Color(0xFFF8F5F0),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xFF0A5E2A),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Quran Ayah',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontFamily: 'Playfair',
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Explore the wisdom of Quran',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            _buildListTile(context, Icons.line_axis, 'Search Ayah', 7),
            _buildListTile(context, Icons.book, 'Surahs(Coming Soon)', 1),
            _buildListTile(context, Icons.bookmark, 'Bookmarks (Coming Soon)', 2),
            _buildListTile(context, Icons.history, 'History', 3),
            _buildListTile(context, Icons.volume_up, 'Recitations(Coming Soon)', 4),
            _buildListTile(context, Icons.abc, 'Tasbih', 5),
            const Divider(),
            _buildListTile(context, Icons.settings, 'Settings', 8),
            _buildListTile(context, Icons.help, 'Help & Support', 9),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile(BuildContext context, IconData icon, String title, int index) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF0A5E2A)),
      title: Text(title),
      selected: selectedIndex == index,
      selectedTileColor: const Color(0xFFD4A017).withOpacity(0.2),
      onTap: () {
        Navigator.pop(context);
        onItemSelected(index);

      },
    );
  }
}
