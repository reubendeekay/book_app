import 'package:bookapp/constants.dart';
import 'package:bookapp/screens/providers/auth_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {
  static const routeName = '/user-profile';

  const EditProfile({Key? key}) : super(key: key);
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  // final nameController = TextEditingController();
  // final emailController = TextEditingController();
  // final phoneController = TextEditingController();
  // final idController = TextEditingController();
  // final dateofBirthController = TextEditingController();
  // final postalController = TextEditingController();

  String fullName = '';
  String email = '';
  String phoneNumber = '';
  String nationalId = '123';
  String dateofBirth = '';
  String postal = '';

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final user = Provider.of<AuthProvider>(context).user;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          leading: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Icon(
                Icons.arrow_back_ios_new,
                color: Theme.of(context).iconTheme.color,
              )),
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            const Text(
              'Edit Profile',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: kPrimaryColor),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                UserPicture(),
              ],
            ),
            SizedBox(height: size.height * 0.05),
//FORM INPUT

            Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    child: TextFormField(
                      // controller: controller,
                      initialValue: user.fullName!,
                      onChanged: (val) {
                        setState(() {
                          fullName = val;
                        });
                      },
                      validator: (val) {
                        return null;
                      },
                      onSaved: (val) {
                        setState(() {
                          fullName = val!;
                        });
                      },
                      decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 15),
                          labelText: 'Full name',
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5),
                          )),
                    ),
                  ),
                  ///////////////////////////////////////////
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    child: TextFormField(
                      // controller: controller,
                      validator: (val) {
                        return null;
                      },
                      initialValue: user.email!,
                      onChanged: (val) {
                        setState(() {
                          email = val;
                        });
                      },
                      onSaved: (val) {
                        setState(() {
                          email = val!;
                        });
                      },
                      decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 15),
                          labelText: 'Email address',
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5),
                          )),
                    ),
                  ),
                  //////////////////////////////////////////
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    child: TextFormField(
                      initialValue: user.phoneNumber!,
                      onChanged: (val) {
                        setState(() {
                          phoneNumber = val;
                        });
                      },
                      validator: (val) {
                        return null;
                      },
                      onSaved: (val) {
                        setState(() {
                          phoneNumber = val!;
                        });
                      },
                      decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 15),
                          labelText: 'Phone number',
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5),
                          )),
                    ),
                  ),
                  //////////////////////////////
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    child: TextFormField(
                      // controller: controller,
                      initialValue: user.password!,
                      obscureText: true,
                      onChanged: (val) {
                        setState(() {
                          nationalId = val;
                        });
                      },
                      onSaved: (val) {
                        setState(() {
                          nationalId = val!;
                        });
                      },
                      validator: (val) {
                        return null;
                      },
                      decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 15),
                          labelText: 'Password',
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5),
                          )),
                    ),
                  ),

                  //////////////////////////////
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    child: TextFormField(
                      // controller: controller,
                      validator: (val) {
                        return null;
                      },
                      onSaved: (val) {
                        setState(() {
                          postal = val!;
                        });
                      },
                      initialValue: 'Adress not set',
                      onChanged: (val) {
                        setState(() {
                          postal = val;
                        });
                      },
                      decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 15),
                          labelText: 'Postal Address',
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5),
                          )),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: size.height * 0.05),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 15),
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                onPressed: () async {},
                color: kPrimaryColor,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 60.0, vertical: 15),
                  child: Text(
                    'Save Changes',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            )
          ]),
        ));
  }
}

class UserPicture extends StatefulWidget {
  const UserPicture({Key? key}) : super(key: key);

  @override
  _UserPictureState createState() => _UserPictureState();
}

class _UserPictureState extends State<UserPicture> {
  // List<Media> mediaList = [];
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).user;

    return SizedBox(
      height: 110,
      width: 110,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  shape: BoxShape.circle,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 10),
                    )
                  ])),
          Center(
            child: CircleAvatar(
              radius: 50,
              backgroundImage: CachedNetworkImageProvider(user.imageUrl!),
            ),
          ),
          Positioned(
            right: -10,
            bottom: -2,
            child: GestureDetector(
              // onTap: () => openImagePicker(context),
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  shape: BoxShape.circle,
                ),
                child: const CircleAvatar(
                  backgroundColor: kPrimaryColor,
                  radius: 16,
                  child: Icon(
                    Icons.camera_alt_outlined,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

//   void openImagePicker(BuildContext context) {
//     // openCamera(onCapture: (image){
//     //   setState(()=> mediaList = [image]);
//     // });
//     showModalBottomSheet(
//         isScrollControlled: true,
//         backgroundColor: Colors.transparent,
//         shape: RoundedRectangleBorder(
//           borderRadius: const BorderRadius.only(
//               topLeft: const Radius.circular(20),
//               topRight: const Radius.circular(20)),
//         ),
//         context: context,
//         builder: (context) {
//           return GestureDetector(
//               behavior: HitTestBehavior.opaque,
//               onTap: () => Navigator.of(context).pop(),
//               child: DraggableScrollableSheet(
//                 initialChildSize: 0.6,
//                 maxChildSize: 0.95,
//                 minChildSize: 0.6,
//                 builder: (ctx, controller) => AnimatedContainer(
//                     duration: Duration(milliseconds: 500),
//                     color: Colors.white,
//                     child: MediaPicker(
//                       scrollController: controller,
//                       mediaList: mediaList,
//                       onPick: (selectedList) {
//                         setState(() => mediaList = selectedList);
//                         Navigator.pop(context);
//                       },
//                       onCancel: () => Navigator.pop(context),
//                       mediaCount: MediaCount.single,
//                       mediaType: MediaType.image,
//                       decoration: PickerDecoration(
//                         cancelIcon: Icon(Icons.close),
//                         albumTitleStyle: TextStyle(
//                             color: Colors.black, fontWeight: FontWeight.bold),
//                         actionBarPosition: ActionBarPosition.top,
//                         blurStrength: 2,
//                         completeText: 'Change',
//                       ),
//                     )),
//               ));
//         }).then((_) async {
//       if (mediaList.isNotEmpty) {
//         double mediaSize =
//             mediaList.first.file.readAsBytesSync().lengthInBytes /
//                 (1024 * 1024);

//         if (mediaSize < 1.0001) {
//           final image = await FirebaseStorage.instance
//               .ref(
//                   'userData/profilePics/${FirebaseAuth.instance.currentUser.uid}')
//               .putFile(mediaList.first.file);

//           final url = await image.ref.getDownloadURL();
//           await FirebaseFirestore.instance
//               .collection('users')
//               .doc(FirebaseAuth.instance.currentUser.uid)
//               .update({
//             'profilePic': url,
//           });
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text('Image should be less than 1 MB')));
//         }

//         showDialog(
//             context: context,
//             builder: (context) => AlertDialog(
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(15),
//                   ),
//                   content: DoneIcon(),
//                 ));

//         Future.delayed(Duration(milliseconds: 2000))
//             .then((_) => Navigator.pop(context));
//       }
//     });
//   }
}
