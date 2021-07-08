import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pet_adoption_app/components/petcardnew.dart';
import 'package:pet_adoption_app/screens/chatScreen.dart';
import 'package:pet_adoption_app/screens/descriptionScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pet_adoption_app/components/indianCities.dart';
import 'package:pet_adoption_app/screens/loginORregister.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:pet_adoption_app/screens/profileScreen.dart';

class CatScreen extends StatefulWidget {
  @override
  _CatScreenState createState() => new _CatScreenState();
}

class _CatScreenState extends State<CatScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  FirebaseAuth _auth;
  CollectionReference _pets;
  CollectionReference _favorite;
  List<String> description = [];
  List<int> phoneNumber = [];
  List<String> email = [];
  List<String> petNames = [];
  List<String> sex = [];
  List<String> type = [];
  List<String> address = [];
  List<String> breed = [];
  List<String> url = [];
  List<String> age = [];
  List<String> city = [];
  List<String> petIDs = [];
  List<String> favoritePetIDs = [];
  List<String> usernames = [];
  List<Timestamp> timestamps = [];
  String _selectedCityValue;
  bool myPostsCalled = false;
  int ind = 0;
  bool myPostsVisible = false;
  bool favoritesVisible = false;
  String userID;
  String username;
  // var uid;

  void cityCallback(newCityValue) {
    print(newCityValue);
    setState(() {
      _selectedCityValue = newCityValue;
      description.clear();
      phoneNumber.clear();
      email.clear();
      petNames.clear();
      sex.clear();
      type.clear();
      address.clear();
      breed.clear();
      url.clear();
      age.clear();
      city.clear();
      timestamps.clear();
      usernames.clear();
      getData();
    });
  }

  void clearData() {
    setState(() {
      description.clear();
      phoneNumber.clear();
      email.clear();
      petNames.clear();
      sex.clear();
      type.clear();
      address.clear();
      breed.clear();
      url.clear();
      age.clear();
      city.clear();
      petIDs.clear();
      favoritePetIDs.clear();
      usernames.clear();
      timestamps.clear();
    });
  }

  void myPostsCallback() {
    setState(() {
      description.clear();
      phoneNumber.clear();
      email.clear();
      petNames.clear();
      sex.clear();
      type.clear();
      address.clear();
      breed.clear();
      url.clear();
      age.clear();
      city.clear();
      timestamps.clear();
      usernames.clear();
      getMyData();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('Init gets called');
    _auth = FirebaseAuth.instance;
    _pets = FirebaseFirestore.instance.collection('Pet Data');
    //  print(_auth.currentUser.uid);
    //  uid = _auth.currentUser.uid;
    _favorite = FirebaseFirestore.instance.collection('User Data');
    if (_auth.currentUser != null) {
      getDocumentID();
    }
    getData();
    // getUsernames();
    setState(() {});
  }

  void getDocumentID() {
    _favorite.get().then((QuerySnapshot querySnapshot) => {
          querySnapshot.docs.forEach((doc) {
            if (doc['Email'] == _auth.currentUser.email) {
              userID = doc.id;
              username = doc['Name'];
              print(userID);
            }
          })
        });
  }

  void getUsernames() {
    _favorite.get().then((QuerySnapshot querySnapshot) => {
          querySnapshot.docs.forEach((doc) {
            for (int i = 0; i < email.length; i++) {
              if (email[i] == doc['Email']) usernames.add(doc['Name']);
            }
          })
        });
  }

  void getData() async {
    await _pets.get().then((QuerySnapshot querySnapshot) => {
          querySnapshot.docs.forEach((doc) {
            setState(() {
              //  print(_pets.doc().id);
              if (_selectedCityValue == null) {
                if (doc['Type'] == 'Cat') {
                  petNames.add(doc['Pet Name']);
                  petIDs.add(doc.id);
                  sex.add(doc['Sex']);
                  type.add(doc['Type']);
                  address.add(doc['Address']);
                  breed.add(doc['Breed']);
                  age.add(doc['Age']);
                  email.add(doc['Email']);
                  phoneNumber.add(doc['Phone Number']);
                  url.add(doc['url']);
                  description.add(doc['Description']);
                  city.add(doc['City']);
                  timestamps.add(doc['timestamp']);
                }
              } else {
                if (doc['Type'] == 'Cat' &&
                    doc['City'].contains(_selectedCityValue)) {
                  petNames.add(doc['Pet Name']);
                  petIDs.add(doc.id);
                  sex.add(doc['Sex']);
                  type.add(doc['Type']);
                  address.add(doc['Address']);
                  breed.add(doc['Breed']);
                  age.add(doc['Age']);
                  email.add(doc['Email']);
                  phoneNumber.add(doc['Phone Number']);
                  url.add(doc['url']);
                  description.add(doc['Description']);
                  city.add(doc['City']);
                  timestamps.add(doc['timestamp']);
                }
              }
            });
          })
        });
    getUsernames();
    setState(() {});
  }

  void savedPostsClicked() async {
    // clearData();
    await _favorite
        .doc(userID)
        .collection('Favorite Pets')
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) {
                favoritePetIDs.add(doc['Pet ID']);
              })
            });

    for (int i = 0; i < favoritePetIDs.length; i++) {
      var _document = FirebaseFirestore.instance
          .collection('Pet Data')
          .doc(favoritePetIDs[i]);
      await _document.get().then((snapshot) => {
            petNames.add(snapshot.data()['Pet Name']),
            sex.add(snapshot.data()['Sex']),
            petIDs.add(snapshot.id),
            type.add(snapshot.data()['Type']),
            address.add(snapshot.data()['Address']),
            breed.add(snapshot.data()['Breed']),
            age.add(snapshot.data()['Age']),
            email.add(snapshot.data()['Email']),
            phoneNumber.add(snapshot.data()['Phone Number']),
            url.add(snapshot.data()['url']),
            description.add(snapshot.data()['Description']),
            city.add(snapshot.data()['City']),
            timestamps.add(snapshot.data()['timestamp']),
          });
    }
    getUsernames();
    setState(() {});
    Navigator.pop(context);
  }

  void getMyData() async {
    await _pets.get().then((QuerySnapshot querySnapshot) => {
          querySnapshot.docs.forEach((doc) {
            setState(() {
              //  print(_pets.doc().id);
              if (_selectedCityValue == null) {
                if (doc['Type'] == 'Cat' &&
                    doc['Email'].contains(_auth.currentUser.email)) {
                  petNames.add(doc['Pet Name']);
                  sex.add(doc['Sex']);
                  petIDs.add(doc.id);
                  type.add(doc['Type']);
                  address.add(doc['Address']);
                  breed.add(doc['Breed']);
                  age.add(doc['Age']);
                  email.add(doc['Email']);
                  phoneNumber.add(doc['Phone Number']);
                  url.add(doc['url']);
                  description.add(doc['Description']);
                  city.add(doc['City']);
                  timestamps.add(doc['timestamp']);
                }
              } else {
                if (doc['Type'] == 'Cat' &&
                    doc['City'].contains(_selectedCityValue)) {
                  petNames.add(doc['Pet Name']);
                  sex.add(doc['Sex']);
                  petIDs.add(doc.id);
                  type.add(doc['Type']);
                  address.add(doc['Address']);
                  breed.add(doc['Breed']);
                  age.add(doc['Age']);
                  email.add(doc['Email']);
                  phoneNumber.add(doc['Phone Number']);
                  url.add(doc['url']);
                  description.add(doc['Description']);
                  city.add(doc['City']);
                  timestamps.add(doc['timestamp']);
                }
              }
            });
          })
        });
    getUsernames();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: Drawer(
          child: Column(
            children: [
              ListTile(
                title: Text(
                  'LOGOUT',
                  style: TextStyle(fontSize: 17.0),
                ),
                onTap: () {
                  if (_auth.currentUser != null) {
                    _auth.signOut();
                    setState(() {
                      username = null;
                    });
                    Navigator.pop(context);
                  }
                },
              ),
              Padding(
                padding: EdgeInsets.only(right: 15.0),
                child: ListTile(
                  title: Text(
                    'Community Chat',
                    style: TextStyle(fontSize: 17.0),
                  ),
                  trailing: Icon(
                    Icons.chat,
                    size: 25,
                  ),
                  onTap: () {
                    //   Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen()));
                    if (_auth.currentUser != null) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChatScreen()));
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginOrRegister()));
                    }
                  },
                ),
              ),
              SwitchListTile(
                onChanged: (value) {
                  myPostsVisible = value;
                  if (value == false) {
                    //all posts
                    setState(() {
                      clearData();
                      getData();
                      //  getUsernames();
                      Navigator.pop(context);
                    });
                  } else {
                    //my posts
                    setState(() {
                      myPostsCallback();
                      Navigator.pop(context);
                    });
                  }
                },
                value: myPostsVisible,
                title: Text(
                  'My Posts',
                  style: TextStyle(fontSize: 17.0),
                ),
              ),
              // ListTile(
              //   title: Text(
              //     'Home Screen',
              //     style: TextStyle(fontSize: 17),
              //   ),
              //   onTap: () {
              //     setState(() {
              //       clearData();
              //       getData();
              //       Navigator.pop(context);
              //     });
              //   },
              // ),
              // ListTile(
              //   title: Text(
              //     'My Posts',
              //     style: TextStyle(fontSize: 17),
              //   ),
              //   onTap: () {
              //     setState(() {
              //       myPostsCallback();
              //       Navigator.pop(context);
              //     });
              //   },
              // ),
              SwitchListTile(
                title: Text(
                  'Saved Posts',
                  style: TextStyle(fontSize: 17.0),
                ),
                value: favoritesVisible,
                onChanged: (value) {
                  favoritesVisible = value;
                  if (value == true) {
                    setState(() {
                      clearData();
                      savedPostsClicked();
                    });
                  } else {
                    setState(() {
                      clearData();
                      getData();
                      //    getUsernames();
                      Navigator.pop(context);
                    });
                  }
                },
              ),
              // ListTile(
              //   title: Text(
              //     'Saved Posts',
              //     style: TextStyle(fontSize: 17),
              //   ),
              //   onTap: savedPostsClicked,
              // ),
            ],
          ),
        ),
        key: _scaffoldKey,
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 2,
                    child: IconButton(
                      icon: Icon(Icons.menu),
                      onPressed: () {
                        _scaffoldKey.currentState.openDrawer();
                      },
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: Container(
                      child: Text(
                        'Pet Adoption',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        IconButton(
                          onPressed: () {
                            if (_auth.currentUser != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProfilePage(
                                    username: username,
                                  ),
                                ),
                              );
                            }
                          },
                          icon: Icon(Icons.person_rounded),
                        ),
                        Text(
                          username != null ? username : "",
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              child: Material(
                elevation: 10,
                shadowColor: Colors.black,
                // child: TextField(
                //   decoration: InputDecoration(
                //     hintText: 'Search by breed',
                //     fillColor: Colors.white,
                //     filled: true,
                //   ),
                // ),
                child: CitySearchDropdown(
                  callback: cityCallback,
                  selectedCity: _selectedCityValue,
                ),
              ),
            ),
            Expanded(
              child: Container(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children: <Widget>[
                      // GestureDetector(
                      //   child: PetCardNew(
                      //     imagePath: 'images/cat0.png',
                      //     petName: 'Bruno',
                      //     breed: 'German Shepherd',
                      //     age: '4',
                      //     distance: '5',
                      //     gender: 'Male',
                      //   ),
                      //   onTap: () {
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //         builder: (context) => DescriptionScreen(),
                      //       ),
                      //     );
                      //   },
                      // ),
                      // PetCardNew(
                      //   imagePath: 'images/cat4.png',
                      //   petName: 'Bruno',
                      //   breed: 'German Shepherd',
                      //   age: '5',
                      //   distance: '5',
                      //   gender: 'Male',
                      // ),
                      // PetCardNew(
                      //   imagePath: 'images/cat2.png',
                      //   petName: 'Bruno',
                      //   breed: 'German Shepherd',
                      //   age: '4',
                      //   distance: '5',
                      //   gender: 'Male',
                      // ),
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: petNames.length,
                        itemBuilder: (context, index) {
                          return petNames.length == 0
                              ? null
                              : GestureDetector(
                                  child: PetCardNew(
                                    petId: petIDs[index],
                                    petName: petNames[index],
                                    breed: breed[index],
                                    gender: sex[index],
                                    imagePath: url[index],
                                    age: age[index],
                                    city: city[index],
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DescriptionScreen(
                                          petID: petIDs[index],
                                          petNames: petNames[index],
                                          address: address[index],
                                          breed: breed[index],
                                          sex: sex[index],
                                          url: url[index],
                                          description: description[index],
                                          age: age[index],
                                          city: city[index],
                                          phoneNumber: phoneNumber[index],
                                          userID: userID,
                                          userName: usernames[index],
                                          timestamp: timestamps[index],
                                        ),
                                      ),
                                    );
                                  },
                                );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//Searchable City Drop Down

class CitySearchDropdown extends StatelessWidget {
  final String selectedCity;
  final Function callback;
  CitySearchDropdown({this.callback, this.selectedCity});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.0,
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      // margin: EdgeInsets.symmetric(vertical: 10.0),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border(
          top: BorderSide(color: Colors.grey),
          left: BorderSide(color: Colors.grey),
          bottom: BorderSide(color: Colors.grey),
          right: BorderSide(color: Colors.grey),
        ),
      ),
      child: Center(
        child: SearchableDropdown.single(
          items: Cities()
              .returnCities()
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          value: selectedCity,
          hint: "Search by city",
          searchHint: "Search by city",
          onChanged: callback,
          isExpanded: true,
        ),
      ),
    );
  }
}
