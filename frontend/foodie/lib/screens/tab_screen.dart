import 'package:flutter/material.dart';
import 'package:foodie/providers/auth_provider.dart';
import '../providers/cart_provider.dart';
import 'package:provider/provider.dart';

import './login_screen.dart';
import './profile_screen.dart';
import './home_screen.dart';
import './offer_screen.dart';
import './cart_screen.dart';
import 'package:badges/badges.dart';

class TabScreen extends StatefulWidget {
  const TabScreen({Key? key}) : super(key: key);
  static const routeName = '/tabs';

  @override
  _TabScreenState createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  bool _auth = false;
  List _tabs = [
    const HomeScreen(),
    const LoginScreen(),
  ];

  int _selectedTabsIndex = 0;

  void _selectTab(int index) {
    setState(() {
      _selectedTabsIndex = index;
    });
    if (!_auth) {
      if (index == 1) {
        Navigator.of(context).pop();
      } else {
        setState(() {
          _selectedTabsIndex = index;
        });
      }
    }
  }

  @override
  void initState() {
    _isAuth();

    super.initState();
  }

  bool _isinit = true;

  @override
  void didChangeDependencies() {
    if (_isinit) {
      Provider.of<Cart>(context).cartItems(context);
    }
    _isinit = false;
    super.didChangeDependencies();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void _isAuth() {
    if (Provider.of<Auth>(context, listen: false).isAuth) {
      setState(() {
        _auth = true;
        _tabs = [
          const HomeScreen(),
          const CartScreen(),
          const OfferScreen(),
          ProfileScreen()
        ];
      });
    } else {
      setState(() {
        _auth = false;
        _tabs = [
          const HomeScreen(),
          const LoginScreen(),
        ];
      });
    }
  }

  List<BottomNavigationBarItem> _list() {
    if (_auth) {
      return [
        const BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
            size: 30,
          ),
          label: 'home',
        ),
        BottomNavigationBarItem(
          icon: Badge(
            badgeContent: Text('${Provider.of<Cart>(context).total}'),
            child: const Icon(Icons.shopping_cart),
          ),
          label: 'Shopping_cart',
        ),
        const BottomNavigationBarItem(
          icon: Icon(
            Icons.local_offer,
            size: 30,
          ),
          label: 'offer',
        ),
        const BottomNavigationBarItem(
          icon: Icon(
            Icons.person,
            size: 30,
          ),
          label: 'account',
        ),
      ];
    } else {
      return const [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
            size: 30,
          ),
          label: 'home',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.person,
            size: 30,
          ),
          label: 'account',
        ),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // extendBodyBehindAppBar: true,
        // drawer: const Drawer(),
        // appBar: AppBar(
        //   leading: Builder(builder: (context) {
        //     return IconButton(
        //       onPressed: () => Scaffold.of(context).openDrawer(),
        //       icon: const Icon(
        //         Icons.menu,
        //         size: 30,
        //       ),
        //     );
        //   }),
        //   backgroundColor: Colors.transparent,
        //   iconTheme: const IconThemeData(color: Colors.grey),
        //   elevation: 0,
        // ),
        body: _tabs[_selectedTabsIndex],
        bottomNavigationBar: BottomNavigationBar(
          showUnselectedLabels: false,
          showSelectedLabels: false,
          onTap: _selectTab,
          currentIndex: _selectedTabsIndex,
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          items: _list(),
        ),
      ),
    );
  }
}
