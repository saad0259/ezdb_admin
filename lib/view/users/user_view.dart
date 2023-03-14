// import 'dart:developer';

// import 'package:flutter/material.dart';

// import '../../model/users_model.dart';
// import '../../util/snippet.dart';

// class TransactionView extends StatefulWidget {
//   const TransactionView({Key? key, required this.model}) : super(key: key);
//   final User model;

//   @override
//   State<TransactionView> createState() => _ShopDialogState();
// }

// class _ShopDialogState extends State<TransactionView> {
//   final loadingNotifier = ValueNotifier<bool>(false);

//   @override
//   Widget build(BuildContext context) {
//     const int animationDuration = 300;
//     return AlertDialog(
//       contentPadding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
//       actionsPadding:
//           const EdgeInsets.symmetric(vertical: 40, horizontal: 120) -
//               const EdgeInsets.only(top: 40),
//       actionsAlignment: MainAxisAlignment.center,
//       content: SingleChildScrollView(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(15.0),
//               child: Column(
//                 children: [
//                   Text(
//                     ('transactionDetails').tr(),
//                     style: Theme.of(context).textTheme.headline4,
//                     textAlign: TextAlign.center,
//                   ),
//                   const SizedBox(height: 10),
//                   if (widget.model.isRefunded)
//                     Text(
//                       ('refunded').tr(),
//                       style: Theme.of(context)
//                           .textTheme
//                           .bodyText1
//                           ?.copyWith(color: Colors.red.shade500),
//                       textAlign: TextAlign.center,
//                     ),
//                   const SizedBox(height: 16),
//                   amountDetailsWidget(),
//                   ShopDetailsWidget(
//                       model: widget.model,
//                       animationDuration: animationDuration),
//                   CustomerDetailsWidget(
//                       model: widget.model,
//                       animationDuration: animationDuration),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//       actions: [
//         ValueListenableBuilder<bool>(
//           valueListenable: loadingNotifier,
//           builder: (c, loading, child) => loading
//               ? getLoader()
//               : ElevatedButton.icon(
//                   onPressed: () => mounted ? pop(context) : null,
//                   icon: const Icon(Icons.close),
//                   label: const Text("Close"),
//                 ),
//         ),
//       ],
//     );
//   }

//   Column amountDetailsWidget() {
//     return Column(
//       children: [
//         Text(
//           ('amountDetails').tr(),
//           style: Theme.of(context)
//               .textTheme
//               .headline1
//               ?.copyWith(fontSize: 20, fontWeight: FontWeight.w600),
//           textAlign: TextAlign.center,
//         ),
//         const SizedBox(height: 6),
//         singleListRow(context, ('transactionType').tr(),
//             DateFormat('hh:mm a MMM-dd-yyyy').format(widget.model.createdAt)),
//         singleListRow(context, ('transactionType').tr(),
//             widget.model.transactionType.getName),
//         singleListRow(context, ('totalAmount').tr(),
//             widget.model.amount.toStringAsFixed(2)),
//         // singleListRow(appLocale.tax, widget.model.tax.toStringAsFixed(2)),
//         singleListRow(context, ('appFee').tr(),
//             (widget.model.stripeTax + widget.model.appFee).toStringAsFixed(2)),
//         // singleListRow(
//         //     appLocale.stripeFee, widget.model.stripeTax.toStringAsFixed(2)),
//         singleListRow(context, ('netProfit').tr(),
//             widget.model.netProfit.toStringAsFixed(2)),
//         const SizedBox(height: 16),
//       ],
//     );
//   }
// }

// class ShopDetailsWidget extends StatelessWidget {
//   const ShopDetailsWidget(
//       {Key? key, required this.model, required this.animationDuration})
//       : super(key: key);

//   final User model;
//   final int animationDuration;
//   Future<ShopReadModel> getShopDetails() async {
//     return await ShopRepo.instance.getShopById(model.shopId);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<ShopReadModel>(
//         future: getShopDetails(),
//         builder: (context, snapshot) {
//           ShopReadModel? shop = snapshot.data;
//           return AnimatedCrossFade(
//               firstChild: Column(
//                 children: [
//                   Text(
//                     ('shopDetails').tr(),
//                     style: Theme.of(context)
//                         .textTheme
//                         .headline1
//                         ?.copyWith(fontSize: 20, fontWeight: FontWeight.w600),
//                     textAlign: TextAlign.center,
//                   ),
//                   const SizedBox(height: 6),
//                   singleListRow(context, ('name').tr(), shop?.shopName ?? ''),
//                   singleListRow(context, ('email').tr(), shop?.email ?? ''),
//                   singleListRow(context, 'Till ${('number').tr()}',
//                       shop?.tillNumber ?? ''),
//                   const SizedBox(height: 16),
//                 ],
//               ),
//               secondChild: SizedBox(),
//               crossFadeState: (snapshot.data != null &&
//                       snapshot.connectionState == ConnectionState.done &&
//                       !snapshot.hasError)
//                   ? CrossFadeState.showFirst
//                   : CrossFadeState.showSecond,
//               duration: Duration(milliseconds: animationDuration));
//         });
//   }
// }

// class CustomerDetailsWidget extends StatelessWidget {
//   const CustomerDetailsWidget(
//       {Key? key, required this.model, required this.animationDuration})
//       : super(key: key);

//   final User model;
//   final int animationDuration;

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<User>(
//         future: CustomerRepo.instance.getUserRecord(model.customerId),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const SizedBox();
//           } else if (snapshot.hasError ||
//               !snapshot.hasData ||
//               snapshot.data == null) {
//             log(snapshot.error.toString());
//             return Center(child: Text(('error').tr()));
//           }
//           User? user = snapshot.data;

//           return AnimatedCrossFade(
//             firstChild: Column(
//               children: [
//                 Text(
//                   ('customerDetails').tr(),
//                   style: Theme.of(context)
//                       .textTheme
//                       .headline1
//                       ?.copyWith(fontSize: 20, fontWeight: FontWeight.w600),
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: 6),
//                 user?.isAnonymous ?? false
//                     ? Text(
//                         ('anonymous').tr(),
//                         style: Theme.of(context).textTheme.headline6?.copyWith(
//                             fontSize: 15, fontWeight: FontWeight.w600),
//                         textAlign: TextAlign.center,
//                       )
//                     : Column(
//                         children: [
//                           singleListRow(
//                               context, ('name').tr(), user?.name ?? ""),
//                           singleListRow(
//                               context, ('email').tr(), user?.email ?? ""),
//                         ],
//                       ),
//               ],
//             ),
//             secondChild: SizedBox(),
//             crossFadeState: (snapshot.data != null &&
//                     !snapshot.hasError &&
//                     snapshot.connectionState == ConnectionState.done)
//                 ? CrossFadeState.showFirst
//                 : CrossFadeState.showSecond,
//             duration: Duration(milliseconds: animationDuration),
//           );
//         });
//   }
// }

// Column singleListRow(BuildContext context, String title, String value) {
//   return Column(
//     children: [
//       Padding(
//         padding: const EdgeInsets.symmetric(vertical: 4.0),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               title,
//               style: Theme.of(context).textTheme.subtitle2,
//             ),
//             Text(
//               value,
//               style: Theme.of(context).textTheme.subtitle2,
//             ),
//           ],
//         ),
//       ),
//       const Divider(),
//     ],
//   );
// }
