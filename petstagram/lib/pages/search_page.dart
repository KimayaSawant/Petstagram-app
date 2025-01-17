import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:petstagram/pages/profile_page.dart';
import 'package:petstagram/utils/colors.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>


 {
  final TextEditingController searchController = TextEditingController();
  bool isShowUsers = false;

  @override
  void dispose(){
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: TextFormField(
          decoration: const InputDecoration(
            labelText: 'Search for your furry friend'
          ),

          onFieldSubmitted: (String _){
            setState(() {
              isShowUsers = true;
            });
          
          },
        ),
      ),

      body: isShowUsers? FutureBuilder(
        future: FirebaseFirestore.instance.collection('users').where('username', isGreaterThanOrEqualTo: searchController.text).get(),

        builder: (context, snapshot){
          if(!snapshot.hasData){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
            itemCount: (snapshot.data! as dynamic).docs.length,
            itemBuilder: (context, index){
              return InkWell(
                onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ProfilePage(uid: (snapshot.data! as dynamic).docs[index]['uid'],),),),
                child: ListTile(
                  // leading: CircleAvatar(
                  //   backgroundImage: NetworkImage(
                  //     // (snapshot.data! as dynamic).docs[index]['photoUrl']
                  //   ),
                  // ),
                  title: Text((snapshot.data! as dynamic).docs[index]['username'],),
                ),
              );
            },
            );
        },
        
         ) : FutureBuilder(
          future: FirebaseFirestore.instance.collection('posts').get(),
           builder: (context, snapshot){
            if(!snapshot.hasData){
              return const Center( child:  CircularProgressIndicator()
              );
            }

            return MasonryGridView.count(
              crossAxisCount: 3,
              itemCount: (snapshot.data! as dynamic).docs.length,
              itemBuilder: (context, index) => Image.network(
                (snapshot.data! as dynamic).docs[index]['postUrl'],
              ),

              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,

            );

           },
           
           
           ),
    );
  }
}