import 'package:favorite_item_list_local_storage/Models/model.dart';
import 'package:flutter/material.dart';

class FavoriteListScreen extends StatelessWidget {
  final List<int> favoriteIds;
  final GetUserListResponseModel? userList;

  const FavoriteListScreen(
      {super.key, required this.favoriteIds, required this.userList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.8),
        title: const Text(
          'Favorite Users',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
      ),
      body: userList!.data == null || favoriteIds.isEmpty || favoriteIds == []
          ? const Center(child: Text('No users found'))
          : ListView.builder(
              itemCount: favoriteIds.length,
              itemBuilder: (context, index) {
                final user = userList!.data!.firstWhere(
                  (user) => user.id == favoriteIds[index],
                  orElse: () => UserModel(),
                );
                if (user.id == null) {
                  return const SizedBox.shrink();
                }
                return ListTile(
                  leading: CircleAvatar(
                      backgroundImage: NetworkImage(user.avatar.toString())),
                  title: Text('${user.firstName} ${user.lastName}'),
                  subtitle: Text(user.email.toString()),
                );
              },
            ),
    );
  }
}
