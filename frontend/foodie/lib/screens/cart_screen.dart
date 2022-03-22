import 'package:flutter/material.dart';
import 'package:foodie/providers/cart_provider.dart';
import 'package:foodie/providers/foods_provider.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  Color green = const Color.fromARGB(255, 43, 164, 0);
  bool _isinit = true;
  bool isLoading = true;
  @override
  void didChangeDependencies() {
    if (_isinit) {
      Provider.of<Cart>(context).cartItems(context).then((_) => setState(() {
            isLoading = false;
          }));
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

  @override
  Widget build(BuildContext context) {
    var list = Provider.of<Cart>(context).items;
    return isLoading
        ? SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: const Center(child: CircularProgressIndicator()))
        : Scaffold(
            appBar: AppBar(title: const Text('Your Cart')),
            body: ListView.builder(
              itemBuilder: (context, index) {
                // return Column(
                //   children: [
                //     Container(
                //       height: MediaQuery.of(context).size.height * 0.05,
                //       color: Colors.grey,
                //       child: Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //         children: [
                //           Text(list[index].restaurantname!),
                //           const Icon(Icons.close)
                //         ],
                //       ),
                //     ),
                //     Row(
                //       children: [
                //         SizedBox(
                //             width: MediaQuery.of(context).size.width * 0.5,
                //             child: const Center(child: Text('ITEM'))),
                //         SizedBox(
                //             width: MediaQuery.of(context).size.width * 0.2,
                //             child: Center(child: const Text('QTY'))),
                //         SizedBox(
                //             width: MediaQuery.of(context).size.width * 0.3,
                //             child: Center(child: const Text('PRICE'))),
                //       ],
                //     ),
                //     const Divider(
                //       thickness: 1,
                //     ),
                //     ...list[index].foodlist!.map((food) {
                //       return Row(
                //         children: [
                //           SizedBox(
                //               width: MediaQuery.of(context).size.width * 0.5,
                //               child: Row(
                //                 children: [
                //                   const Icon(
                //                     Icons.close,
                //                     size: 10,
                //                   ),
                //                   Center(child: Text(food.name!)),
                //                 ],
                //               )),
                //           SizedBox(
                //               width: MediaQuery.of(context).size.width * 0.2,
                //               child: Center(child: Text((food.quantity).toString()))),
                //           SizedBox(
                //               width: MediaQuery.of(context).size.width * 0.3,
                //               child: Center(child: Text(food.price!)))
                //         ],
                //       );
                //     }).toList()
                //   ],
                // );
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Card(
                      elevation: 5,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  list[index].restaurantname!,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => Provider.of<Cart>(context,
                                          listen: false)
                                      .deleterestaurant(
                                          context, list[index].restaurantid!),
                                  child: const Icon(Icons.close),
                                ),
                              ],
                            ),
                          ),
                          ...list[index].foodlist!.map((food) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              child: ListTile(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  side: const BorderSide(color: Colors.black),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 16,
                                ),
                                leading: CircleAvatar(
                                  radius: 30,
                                  child: ClipOval(
                                    child: Image.network(
                                      '${Provider.of<Foods>(context).findById(food.foodid!).image}',
                                      height: 60,
                                      width: 60,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  backgroundColor: Colors.transparent,
                                ),
                                title: Text(food.name!),
                                subtitle: FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        OutlinedButton(
                                          style: ElevatedButton.styleFrom(
                                            shape: const CircleBorder(),
                                            side: BorderSide(
                                                color: green, width: 1),
                                            // <-- Button color
                                            onPrimary:
                                                green, // <-- Splash color
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              if (food.quantity! <= 1) {
                                                return;
                                              } else {
                                                food.quantity =
                                                    food.quantity! - 1;
                                              }
                                            });
                                          },
                                          child: Text(
                                            '-',
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: green,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Center(
                                          child: Text(
                                            '${food.quantity}',
                                            style: const TextStyle(
                                              // fontSize: 20,
                                              color: Colors.black,
                                              // fontWeight: FontWeight.bold
                                            ),
                                          ),
                                        ),
                                        OutlinedButton(
                                          style: ElevatedButton.styleFrom(
                                            shape: const CircleBorder(),
                                            side: BorderSide(
                                                color: green, width: 1),
                                            onPrimary: green,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              food.quantity =
                                                  food.quantity! + 1;
                                            });
                                          },
                                          child: Text(
                                            '+',
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: green,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ]),
                                ),
                                trailing: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      child: const Icon(Icons.close),
                                      onTap: () => Provider.of<Cart>(context,
                                              listen: false)
                                          .deletefood(context, food.id!),
                                    ),
                                    Text(
                                      'Rs: ${food.quantity! * double.parse(food.price!)}',
                                    )
                                  ],
                                ),
                              ),
                            );
                          }).toList()
                        ],
                      )),
                );
              },
              itemCount: list.length,
            ),
          );
  }
}
