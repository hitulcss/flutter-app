import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sd_campus_app/features/cubit/pincode/pincode_cubit.dart';
import 'package:sd_campus_app/features/data/remote/data_sources/remote_data_source_impl.dart';
import 'package:sd_campus_app/features/data/remote/models/get_store_order.dart';
import 'package:sd_campus_app/features/presentation/widgets/tostmessage.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/util/extenstions/setsate_ext.dart';
import 'package:sd_campus_app/util/prefconstatnt.dart';
import 'package:sd_campus_app/util/extenstions/string_extenstions.dart';
import 'package:sd_campus_app/view/screens/store/store_product_desc.dart';
import 'package:url_launcher/url_launcher.dart';

class StoreOrderDetailScreen extends StatefulWidget {
  final GetStoreOrdersData getStoreOrdersData;
  const StoreOrderDetailScreen({super.key, required this.getStoreOrdersData});

  @override
  State<StoreOrderDetailScreen> createState() => _StoreOrderDetailScreenState();
}

class _StoreOrderDetailScreenState extends State<StoreOrderDetailScreen> {
  final TextEditingController _bankNameController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _accountNumberController = TextEditingController();
  final TextEditingController _ifscodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String getDispatchAction(String orderStatus) {
      if ([
        'shipped',
        'inTransit',
        'outForDelivery'
      ].contains(orderStatus)) {
        return 'dispatch';
      } else if ([
        'placed',
        'processing',
        'packed'
      ].contains(orderStatus)) {
        return 'placed';
      } else if (orderStatus == 'delivered') {
        return 'delivered';
      } else if ([
        'userCancelled',
        'cancelled'
      ].contains(orderStatus)) {
        return 'usercancel';
      } else {
        return 'unknown';
      }
    }

    final String dispatchAction = getDispatchAction(widget.getStoreOrdersData.deliveryStatus ?? "");

    final steps = dispatchAction == "usercancel"
        ? [
            Step(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Placed'),
                  Text(widget.getStoreOrdersData.purchaseDate ?? "")
                ],
              ),
              content: Container(),
              isActive: dispatchAction == 'placed' || dispatchAction == 'dispatch',
              state: dispatchAction == 'placed' || dispatchAction == 'dispatch' || dispatchAction == "usercancel" || dispatchAction == "delivered" ? StepState.complete : StepState.disabled,
            ),
            Step(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Cancelled'),
                  Text(widget.getStoreOrdersData.cancelDate ?? "")
                ],
              ),
              content: const Text('Order has been cancelled.'),
              isActive: dispatchAction == 'usercancel',
              stepStyle: const StepStyle(),
              state: dispatchAction == 'usercancel' ? StepState.error : StepState.disabled,
            ),
          ]
        : [
            Step(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Placed'),
                  Text(widget.getStoreOrdersData.purchaseDate ?? "")
                ],
              ),
              content: Container(),
              isActive: dispatchAction == 'placed' || dispatchAction == 'dispatch',
              state: dispatchAction == 'placed' || dispatchAction == 'dispatch' || dispatchAction == "delivered" ? StepState.complete : StepState.disabled,
            ),
            Step(
              title: Column(
                children: [
                  const Text('Dispatch'),
                  Text(widget.getStoreOrdersData.dispatchDate ?? "")
                ],
              ),
              content: const Text('Order is being dispatched from the warehouse.'),
              isActive: dispatchAction == 'dispatch',
              state: dispatchAction == 'placed' || dispatchAction == 'dispatch' || dispatchAction == "delivered" ? StepState.complete : StepState.disabled,
            ),
            Step(
              title: Column(
                children: [
                  const Text('Delivered'),
                  Text(widget.getStoreOrdersData.deliveredDate ?? "")
                ],
              ),
              content: const Text('Order has been delivered successfully.'),
              isActive: dispatchAction == 'delivered',
              state: dispatchAction == 'delivered' ? StepState.complete : StepState.disabled,
            ),
          ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders Summary'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Flexible(
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Order Id : ',
                                  style: TextStyle(
                                    color: ColorResources.textblack,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                TextSpan(
                                  text: widget.getStoreOrdersData.orderId ?? "",
                                  style: TextStyle(
                                    color: ColorResources.textBlackSec,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        GestureDetector(
                            onTap: () {
                              Clipboard.setData(ClipboardData(text: widget.getStoreOrdersData.orderId ?? ""));
                              flutterToast('Copy to clipboard successfully');
                            },
                            child: const Icon(Icons.copy))
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Text(
                      "Order Date : ${DateFormat("dd MMM yyyy").format(DateFormat("dd-MM-yyyy").parse(widget.getStoreOrdersData.purchaseDate ?? ""))}",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: ColorResources.textblack,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Order Items',
                            style: TextStyle(
                              color: ColorResources.textblack,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const Divider(),
                        ListView.separated(
                          shrinkWrap: true,
                          itemCount: widget.getStoreOrdersData.products?.length ?? 0,
                          physics: const NeverScrollableScrollPhysics(),
                          separatorBuilder: (context, index) => const Divider(),
                          itemBuilder: (context, index) => GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => BlocProvider(
                                  create: (context) => PincodeCubit(),
                                  child: StroeProductDescScreen(
                                    id: widget.getStoreOrdersData.products?[index].id ?? "",
                                  ),
                                ),
                              ));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CachedNetworkImage(
                                    placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                    errorWidget: (context, url, error) => const Icon(Icons.error),
                                    imageUrl: widget.getStoreOrdersData.products?[index].featuredImage ?? "",
                                    height: 100,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.getStoreOrdersData.products?[index].title ?? "",
                                          style: TextStyle(
                                            color: ColorResources.textblack,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          '${Preferences.appString.quantity ?? "Quantity"}: ${widget.getStoreOrdersData.products?[index].quantity}',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: ColorResources.textBlackSec,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          'Amount: ₹${widget.getStoreOrdersData.products?[index].productAmount}',
                                          style: TextStyle(
                                            color: ColorResources.textBlackSec,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            Preferences.appString.paymentSummary ?? 'Payment Summery',
                            style: TextStyle(
                              color: ColorResources.textblack,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const Divider(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                Preferences.appString.totalAmount ?? 'Total Amount',
                                style: TextStyle(
                                  color: ColorResources.textBlackSec,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                '₹ ${widget.getStoreOrdersData.allAmount}',
                                style: TextStyle(
                                  color: ColorResources.textblack,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (double.parse(widget.getStoreOrdersData.productDiscount ?? "0") > 0)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Discount',
                                  style: TextStyle(
                                    color: ColorResources.textBlackSec,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  '- ₹ ${widget.getStoreOrdersData.productDiscount}',
                                  style: const TextStyle(
                                    color: Color(0xFF1D7025),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                )
                              ],
                            ),
                          ),
                        if (double.parse(widget.getStoreOrdersData.couponDiscount ?? "0") > 0)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Apply Coupon',
                                  style: TextStyle(
                                    color: ColorResources.textBlackSec,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  '- ₹ ${widget.getStoreOrdersData.couponDiscount}',
                                  style: const TextStyle(
                                    color: Color(0xFF1D7025),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (double.parse(widget.getStoreOrdersData.deliveryCharges ?? "0") > 1)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Delivery Charges',
                                  style: TextStyle(
                                    color: ColorResources.textBlackSec,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  '+ ₹ ${widget.getStoreOrdersData.deliveryCharges}',
                                  style: const TextStyle(
                                    color: Color(0xFF1D7025),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        const Divider(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Payable Amount',
                                style: TextStyle(
                                  color: ColorResources.textblack,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                '₹${widget.getStoreOrdersData.totalAmount}',
                                style: TextStyle(
                                  color: ColorResources.textblack,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Shipping Details',
                            style: TextStyle(
                              color: ColorResources.textblack,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const Divider(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "${widget.getStoreOrdersData.shippingAddress!.streetAddress ?? ""} , ${widget.getStoreOrdersData.shippingAddress!.city ?? ''} , ${widget.getStoreOrdersData.shippingAddress!.country ?? ''} , ${widget.getStoreOrdersData.shippingAddress!.pinCode ?? ''}",
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '+91 - ${widget.getStoreOrdersData.shippingAddress!.phone ?? ''}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: ColorResources.textblack,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Payment mode',
                                style: TextStyle(
                                  color: ColorResources.textblack,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                widget.getStoreOrdersData.orderType == "prePaid" ? "Online" : widget.getStoreOrdersData.orderType ?? "",
                                style: TextStyle(
                                  color: ColorResources.textBlackSec,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                Preferences.appString.paymentstatus ?? 'Payment Status',
                                style: TextStyle(
                                  color: ColorResources.textblack,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                widget.getStoreOrdersData.paymentStatus?.toCapitalize() ?? "",
                                style: TextStyle(
                                  color: widget.getStoreOrdersData.paymentStatus == "success"
                                      ? const Color(0xFF4CAF50)
                                      : widget.getStoreOrdersData.paymentStatus == "failed"
                                          ? const Color(0xFFFB5259)
                                          : const Color(0xFFFCA120),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  height: 0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                Preferences.appString.orderStatus ?? 'Order Status ',
                                style: TextStyle(
                                  color: ColorResources.textblack,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                widget.getStoreOrdersData.deliveryStatus?.toCapitalize() ?? "",
                                style: TextStyle(
                                  color: widget.getStoreOrdersData.deliveryStatus == "shipped"
                                      ? const Color(0xFF1D7025)
                                      : (widget.getStoreOrdersData.deliveryStatus?.toLowerCase().contains('cancelled') ?? false) || (widget.getStoreOrdersData.deliveryStatus?.toLowerCase().contains('return') ?? false)
                                          ? const Color(0xFFFB5259)
                                          : const Color(0xFFFCA120),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(),
                        Stepper(
                          steps: steps,
                          physics: const NeverScrollableScrollPhysics(),
                          currentStep: currentStep(dispatchAction),
                          controlsBuilder: (context, details) => Container(),
                          stepIconBuilder: (stepIndex, stepState) {
                            return Icon(
                              stepIndex == 0
                                  ? Icons.check_circle_outline
                                  : stepIndex == 1 && steps.length > 2
                                      ? Icons.local_shipping_outlined
                                      : steps.length == 2
                                          ? Icons.close
                                          : CupertinoIcons.cube_box,
                              color: Colors.white,
                            );
                          },
                          stepIconHeight: 40,
                          stepIconWidth: 40,
                          connectorColor: WidgetStateProperty.resolveWith(((Set<WidgetState> states) {
                            if (states.contains(WidgetState.disabled)) {
                              return Colors.grey;
                            } else {
                              return Colors.green;
                            }
                          })),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        if (dispatchAction == "dispatch" && (widget.getStoreOrdersData.trackingLink ?? "").isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text.rich(TextSpan(
                                text: "Tracking Link : ",
                                style: const TextStyle(fontSize: 14),
                                children: [
                                  TextSpan(
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        launchUrl(Uri.parse(widget.getStoreOrdersData.trackingLink ?? ""));
                                      },
                                    text: "click here",
                                    style: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                                  ),
                                ],
                              )),
                              const SizedBox(height: 10)
                            ],
                          ),
                        if (widget.getStoreOrdersData.deliveryStatus == "processing")
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                  onPressed: () async {
                                    if (widget.getStoreOrdersData.deliveryStatus == "processing") {
                                      bool? status = await showDialog<bool>(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                                content: const Text("Are you sure you want to cancel this order?"),
                                                actions: [
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context, false);
                                                      },
                                                      child: const Text("Cancel")),
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context, true);
                                                      },
                                                      child: const Text("Yes"))
                                                ],
                                              ));
                                      if (status == true) {
                                        RemoteDataSourceImpl().storeOrderscancelRequest(id: widget.getStoreOrdersData.id ?? "").then((value) {
                                          safeSetState(() {
                                            widget.getStoreOrdersData.deliveryStatus = "cancelled";
                                          });
                                        });
                                        if (widget.getStoreOrdersData.isPaid ?? false) {
                                          showBottomSheet(
                                            context: context,
                                            builder: (context) => Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                const Center(child: Text("Bank details")),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                TextField(
                                                  controller: _bankNameController,
                                                  decoration: InputDecoration(
                                                    border: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(10),
                                                    ),
                                                    hintText: 'Ex: SBI',
                                                    label: const Text("Bank Name"),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                TextField(
                                                  controller: _fullNameController,
                                                  decoration: InputDecoration(
                                                    border: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(10),
                                                    ),
                                                    hintText: 'Ex: Sai Ram',
                                                    label: const Text("Full Name"),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                TextField(
                                                  controller: _accountNumberController,
                                                  decoration: InputDecoration(
                                                    border: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(10),
                                                    ),
                                                    hintText: 'Ex: 1234567890',
                                                    label: const Text("Account Number"),
                                                  ),
                                                  keyboardType: TextInputType.number,
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                TextField(
                                                  controller: _ifscodeController,
                                                  decoration: InputDecoration(
                                                    border: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(10),
                                                    ),
                                                    hintText: 'Ex: 1234567890',
                                                    label: const Text("Account Number"),
                                                  ),
                                                  keyboardType: TextInputType.number,
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                ElevatedButton(
                                                  onPressed: () async {
                                                    if (_fullNameController.text.isNotEmpty && _bankNameController.text.isNotEmpty && _accountNumberController.text.isNotEmpty && _ifscodeController.text.isNotEmpty) {
                                                      RemoteDataSourceImpl()
                                                          .addstoreOrdersRefundRequest(
                                                        id: widget.getStoreOrdersData.orderId ?? "",
                                                        bankName: _bankNameController.text,
                                                        fullName: _fullNameController.text,
                                                        accountNumber: _accountNumberController.text,
                                                        ifsc: _ifscodeController.text,
                                                      )
                                                          .then((value) {
                                                        flutterToast(value.msg);
                                                      });
                                                    } else {
                                                      flutterToast("Please fill all details");
                                                    }
                                                  },
                                                  child: const Text("Submit"),
                                                ),
                                              ],
                                            ),
                                          );
                                        }
                                      }
                                    }
                                  },
                                  child: const Text(
                                    "Cancel",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'For Enquiries, ',
                                  style: TextStyle(
                                    color: ColorResources.textblack,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                TextSpan(
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () async {
                                      launchUrl(Uri.parse("tel:${Preferences.remoteStore["number"]}"));
                                    },
                                  text: 'Call ${Preferences.remoteStore["number"]}',
                                  style: TextStyle(
                                    color: ColorResources.buttoncolor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }

  currentStep(String dispatchAction) {
    switch (dispatchAction) {
      case "placed":
        return 0;
      case "dispatch":
        return 1;
      case "delivered":
        return 2;
      case "cancelled":
        return 1;
      case "return":
        return 4;
      default:
        return 0;
    }
  }
}
