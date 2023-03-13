import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/ui/auth/login_screen.dart';
import 'package:flutter_firebase/ui/firebase_database/add_posts.dart';

import '../../utils/utils.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final auth = FirebaseAuth.instance;
  final ref = FirebaseDatabase.instance.ref('Post');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text('Post Screen'),
          actions: [
            IconButton(
                onPressed: (){
                  auth.signOut().then((value){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()),);
                  }).onError((error, stackTrace){
                    Utils().toastMessage(error.toString());
                  });
                },
                icon: Icon(Icons.logout_outlined),
            ),
          ],
        ),
      body: Column(
        children: [
          Expanded(child: FirebaseAnimatedList(
            query: ref,
            defaultChild: Text('Loading'),
            itemBuilder: (context,snapshot,animation,index){
              return ListTile(
                title: Text(snapshot.child('title').value.toString()),
              )
            }
          ))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddPostScreen()));
        } ,
        child: Icon(Icons.add),
      ),
    );
  }
}
