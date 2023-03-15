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
  final searchfilter = TextEditingController();
  final editController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
        centerTitle: true,
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
          SizedBox(height: 10,),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: TextFormField(
              controller: searchfilter,
              decoration: InputDecoration(
                hintText: 'Search',
                border: OutlineInputBorder(),
              ),
              onChanged: (String value){
                setState(() {

                });
              },
            ),
          ),
          Expanded(child: FirebaseAnimatedList(
            query: ref,
            defaultChild: Text('Loading'),
            itemBuilder: (context,snapshot,animation,index){
              final title = snapshot.child('title').value.toString();
              if(searchfilter.text.isEmpty){
                return ListTile(
                  title: Text(snapshot.child('title').value.toString()),
                  subtitle: Text(snapshot.child('id').value.toString()),
                  trailing: PopupMenuButton(
                    icon: Icon(Icons.more_vert),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value:1,
                          child: ListTile(
                            onTap: (){
                              Navigator.pop(context);
                              showMyDialog(title,snapshot.child('id').value.toString());
                            },
                        leading: Icon(Icons.edit),
                            title: Text('Edit'),
                      )
                      ),
                      PopupMenuItem(
                          value:1,
                          child: ListTile(
                            onTap: (){
                              Navigator.pop(context);
                             ref.child(snapshot.child('id').value.toString()).remove();
                            },
                            leading: Icon(Icons.delete),
                            title: Text('Delete'),
                          )
                      )
                    ],
                  ),
                );
              }else if(title.toLowerCase().contains(searchfilter.text.toLowerCase().toLowerCase())){
                return ListTile(
                  title: Text(snapshot.child('title').value.toString()),
                  subtitle: Text(snapshot.child('id').value.toString()),
                );
              } else {
                      return Container();
                    }
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

  Future<void> showMyDialog(String title,String id)async{
    editController.text = title;
    return showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text('Update'),
            content: Container(
              child: TextField(
                controller: editController,
                decoration: InputDecoration(
                  hintText: 'Edit'
                ),
              ),
            ),
            actions: [
              TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text('Cancel')
              ),
              TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                    ref.child(id).update({
                      'title' : editController.text.toLowerCase()
                    }).then(
                            (value) {
                              Utils().toastMessage('Post Updated');
                            }).onError((error, stackTrace){
                            Utils().toastMessage(error.toString());
                    });
                  },
                  child: Text('Update')
              ),
            ],
          )
        }
    )

  }
}
