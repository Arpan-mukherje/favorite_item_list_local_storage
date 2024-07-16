import 'package:favorite_item_list_local_storage/Models/model.dart';
import 'package:favorite_item_list_local_storage/Screens/favorite_screen.dart';
import 'package:favorite_item_list_local_storage/Services/Api%20services/api_service.dart';
import 'package:favorite_item_list_local_storage/Services/shared_services.dart';
import 'package:flutter/material.dart';


class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  late Future<GetUserListResponseModel> futureUsers;
  GetUserListResponseModel? userList;
  List<int> favoriteIds = [];
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    futureUsers = ApiService.fetchUsers(2);
    futureUsers.then((data) {
      setState(() {
        userList = data;
      });
    });
    _loadFavorites();
  }

  _loadFavorites() async {
    final storedData = SharedServices.getData();
    setState(() {
      favoriteIds = storedData?.data
              ?.map((e) => e.id)
              .whereType<int>() // Filter out any null values
              .toList() ??
          [];
    });
  }

  _toggleFavorite(int userId) async {
    setState(() {
      if (favoriteIds.contains(userId)) {
        favoriteIds.remove(userId);
      } else {
        favoriteIds.add(userId);
      }
      final updatedUserList = GetUserListResponseModel(
        data: userList?.data
            ?.where((user) => favoriteIds.contains(user.id))
            .toList(),
      );
      SharedServices.setData(updatedUserList);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'User List',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black.withOpacity(0.8),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.favorite,
              color: Colors.red,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavoriteListScreen(
                      favoriteIds: favoriteIds, userList: userList),
                ),
              );
            },
          )
        ],
      ),
      body: FutureBuilder<GetUserListResponseModel>(
        future: futureUsers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (userList?.data == null || userList!.data!.isEmpty) {
            return const Center(child: Text('No users found'));
          } else {
            return ListView.builder(
              controller: scrollController,
              itemCount: userList!.data!.length,
              itemBuilder: (context, index) {
                final user = userList!.data![index];
                final isFavorite = favoriteIds.contains(user.id);
                return ListTile(
                  leading: CircleAvatar(
                      backgroundImage: NetworkImage(user.avatar.toString())),
                  title: Text('${user.firstName} ${user.lastName}'),
                  subtitle: Text(user.email.toString()),
                  trailing: IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : Colors.black,
                    ),
                    onPressed: () {
                      _toggleFavorite(user.id!);
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
