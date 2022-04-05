import 'package:bookapp/screens/providers/auth_provider.dart';
import 'package:bookapp/src/pages/add_book/add_book.dart';
import 'package:bookapp/src/pages/profile/purchase_history.dart';
import 'package:bookapp/src/pages/profile/widgets/edit_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';

class DashboardTop extends StatelessWidget {
  const DashboardTop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final user = Provider.of<AuthProvider>(context).user;

    return SafeArea(
      child: SizedBox(
        width: size.width,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
              child: Row(
                children: [
                  const Spacer(),
                  const Text(
                    'User Profile',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: Colors.white),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      FirebaseAuth.instance.signOut();
                    },
                    child: const Icon(
                      Icons.logout_sharp,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Center(
                child: Column(
              children: [
                const Text(
                  'BALANCE',
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  'KSH. ' + user.balance!.toStringAsFixed(2),
                  style: const TextStyle(fontSize: 24, color: Colors.white),
                )
              ],
            )),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DashboardTopOption(
                  color: Colors.green,
                  icon: Icons.dashboard_customize,
                  title: 'Add a\nBook',
                  onTap: () => Get.to(() => const AddBookScreen()),
                ),
                DashboardTopOption(
                  color: Colors.brown,
                  icon: Icons.local_mall_outlined,
                  title: 'Manage\nPurchases',
                  onTap: () => Get.to(() => const PurchaseHistory()),
                ),
                DashboardTopOption(
                  color: Colors.blue,
                  icon: Icons.local_mall_outlined,
                  title: 'Your Purchase\nHistory',
                  onTap: () => Get.to(() => const PurchaseHistory()),
                ),
                DashboardTopOption(
                  color: Colors.red,
                  icon: Icons.person_search_rounded,
                  title: 'Edit\n Profile',
                  onTap: () => Get.to(() => const EditProfile()),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class DashboardTopOption extends StatelessWidget {
  final Color? color;
  final String? title;
  final IconData? icon;
  final Function? onTap;

  const DashboardTopOption(
      {Key? key, this.color, this.title, this.icon, this.onTap})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap!(),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: color,
              child: Icon(
                icon,
                color: Colors.white,
              ),
            ),
            if (title != null)
              const SizedBox(
                height: 5,
              ),
            if (title != null)
              FittedBox(
                child: Text(
                  title!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
