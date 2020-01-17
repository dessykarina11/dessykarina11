import 'dart:convert';
import 'package:flutterr_app/user.dart';
import 'package:flutterr_app/api.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  build(context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tes Aplikasi',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: MyListScreen(),
    );
  }
}

class MyListScreen extends StatefulWidget {
  @override
  createState() => _MyListScreenState();
}

class _MyListScreenState extends State {
  var _users = List<User>();

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  GlobalKey<RefreshIndicatorState>();

  bool _isLoading = false;

  Future<dynamic> _getUsers() {
    _isLoading = true;
    return API.getUsers().then((response) {
      final List<User> usersList = [];

      final List<dynamic> usersData = json.decode(response.body);
      if (usersData == null){
        setState(() {
          _isLoading = false;
        });
      }

      for (var i = 0; i < usersData.length; i++) {
        final User user = User(
            id: usersData[i]['id'],
            name: usersData[i]['name'],
            email: usersData[i]['email'],
            phone: usersData[i]['phone'],
            website: usersData[i]['website'],
            address: usersData[i]['address']['street'] + ', ' +
                usersData[i]['address']['suite'] + ', ' +
                usersData[i]['address']['city'] + ',' + '\n' +
                usersData[i]['address']['zipcode'],
            company: usersData[i]['company']['name'] + '\n' +
                usersData[i]['company']['catchPhrase']
        );
        usersList.add(user);
      }

      setState(() {
        _users = usersList;
        _isLoading = false;
      });
    }).catchError((Object error){
      setState(() {
        _isLoading = false;
      });
    });

  }

  Future<dynamic> _onRefresh() {
    return _getUsers();
  }

  initState() {
    super.initState();
    _getUsers();
  }

  dispose() {
    super.dispose();
  }

  Widget _buildUsersList() {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      key: _refreshIndicatorKey,
      child: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: <Widget>[
              Padding(
                child: ListTile(
                  leading: Icon(Icons.account_circle, size: 50.0,),
                  trailing: Icon(Icons.favorite_border),
                  title: Text(_users[index].name),
                  subtitle: Text(_users[index].email),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) => UserPage(user: _users[index],)
                    ),);
                  },
                ),
                padding: EdgeInsets.all(5.0),
              ),
              Divider(
                height: 5.0,
              )
            ],
          );
        },
        itemCount: _users.length,
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Users List'),
      ),
      body: _isLoading ? Center(
        child: CircularProgressIndicator(),
      )
          : _buildUsersList(),
    );
  }
}

class UserPage extends StatelessWidget {
  User user;
  UserPage({Key key, @required this.user}) : super(key: key);


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(user.name),),
      body: Container(
        margin: EdgeInsets.only(left: 20.0),
        child: Column(
          children: <Widget>[
            TextFormField(
              initialValue: user.email,
              readOnly: true,
              decoration: InputDecoration(
                  labelText: 'EMAIL'
              ),
            ),
            TextFormField(
              initialValue: user.phone,
              readOnly: true,
              decoration: InputDecoration(
                  labelText: 'PHONE'
              ),
            ),
            TextFormField(
              initialValue: user.website,
              readOnly: true,
              decoration: InputDecoration(
                  labelText: 'WEBSITE'
              ),
            ),
            TextFormField(
              initialValue: user.address,
              maxLines: 2,
              readOnly: true,
              decoration: InputDecoration(
                  labelText: 'ADDRESS'
              ),
            ),
            TextFormField(
              initialValue: user.company,
              readOnly: true,
              maxLines: 2,
              decoration: InputDecoration(
                  labelText: 'COMPANY'
              ),
            )
          ],
        ),
      ),
    );
  }
}