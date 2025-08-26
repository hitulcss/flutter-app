// ignore_for_file: unused_element

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_validator/form_validator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sd_campus_app/features/data/remote/data_sources/remote_data_source_impl.dart';
import 'package:sd_campus_app/features/data/remote/models/mywallet_model.dart';
import 'package:sd_campus_app/features/presentation/widgets/empty_widget.dart';
import 'package:sd_campus_app/features/presentation/widgets/errorwidget.dart';
import 'package:sd_campus_app/features/presentation/widgets/tostmessage.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/util/images_file.dart';
import 'package:sd_campus_app/util/prefconstatnt.dart';
import 'package:sd_campus_app/util/preference.dart';
import 'package:sd_campus_app/util/extenstions/string_extenstions.dart';
import 'package:sd_campus_app/view/screens/sidenav/refer/refer_and_earn.dart';

class MyWalletSceen extends StatefulWidget {
  const MyWalletSceen({super.key});

  @override
  State<MyWalletSceen> createState() => _MyWalletSceenState();
}

class _MyWalletSceenState extends State<MyWalletSceen> {
  final TextEditingController _amountcontroller = TextEditingController();
  final TextEditingController _upiidcontroller = TextEditingController();
  final _redeemform = GlobalKey<FormState>();
  @override
  void dispose() {
    _amountcontroller.dispose();
    _upiidcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorResources.textWhite,
        iconTheme: IconThemeData(color: ColorResources.textblack),
        title: Text(
          'My Wallet',
          style: GoogleFonts.notoSansDevanagari(color: ColorResources.textblack),
        ),
      ),
      body: FutureBuilder<MyWalletModel>(
          initialData: MyWalletModel(status: true, data: MyWalletModelData(transactions: [], walletAmount: '0')),
          future: RemoteDataSourceImpl().getMyWallet(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return ErrorWidgetapp(
                  image: SvgImages.error404,
                  text: "Page not found",
                );
              } else {
                SharedPreferenceHelper.setInt(Preferences.usercoins, int.parse(snapshot.data?.data?.walletAmount ?? "0"));
                return Align(
                  alignment: Alignment.topCenter,
                  child: FractionallySizedBox(
                    widthFactor: 0.9,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            padding: const EdgeInsets.all(10),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: const Color(0x26F4B44B),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: IntrinsicHeight(
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            CachedNetworkImage(
                                              placeholder: (context, url) => const Center(
                                                child: CircularProgressIndicator(),
                                              ),
                                              errorWidget: (context, url, error) => const Icon(Icons.error),
                                              imageUrl: SvgImages.wallet,
                                              height: 20,
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              '${snapshot.data?.data?.walletAmount} Point',
                                              style: TextStyle(
                                                color: ColorResources.buttoncolor,
                                                fontSize: 24,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          'Wallet balance',
                                          style: TextStyle(
                                            color: ColorResources.textblack,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        int.parse(snapshot.data?.data?.walletAmount ?? "0") > 500
                                            ? OutlinedButton(
                                                onPressed: () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) => Dialog(
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(
                                                          20,
                                                        ),
                                                      ),
                                                      elevation: 10,
                                                      child: Form(
                                                        key: _redeemform,
                                                        child: Container(
                                                          padding: const EdgeInsets.only(top: 20, right: 10, left: 10, bottom: 10),
                                                          // color: ColorResources.textWhite,
                                                          child: Column(
                                                            mainAxisSize: MainAxisSize.min,
                                                            children: [
                                                              Text(
                                                                'Redeem Coins',
                                                                style: TextStyle(
                                                                  color: ColorResources.textblack,
                                                                  fontSize: 16,
                                                                  fontWeight: FontWeight.w600,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                height: 10,
                                                              ),
                                                              TextFormField(
                                                                controller: _upiidcontroller,
                                                                keyboardType: TextInputType.emailAddress,
                                                                onChanged: (value) {
                                                                  _redeemform.currentState!.validate();
                                                                },
                                                                decoration: InputDecoration(
                                                                  border: OutlineInputBorder(
                                                                    borderRadius: BorderRadius.circular(10.0),
                                                                  ),
                                                                  hintText: 'username@bank',
                                                                ),
                                                                validator: ValidationBuilder().required().build(),
                                                              ),
                                                              const SizedBox(
                                                                height: 10,
                                                              ),
                                                              TextFormField(
                                                                controller: _amountcontroller,
                                                                keyboardType: const TextInputType.numberWithOptions(
                                                                  signed: false,
                                                                  decimal: false,
                                                                ),
                                                                onChanged: (value) {
                                                                  if (int.parse(value) > int.parse(snapshot.data!.data!.walletAmount!)) {
                                                                    flutterToast('Amount cannot exceed ${snapshot.data!.data!.walletAmount} Rupees');
                                                                  }
                                                                  _redeemform.currentState!.validate();
                                                                },
                                                                inputFormatters: <TextInputFormatter>[
                                                                  FilteringTextInputFormatter.digitsOnly
                                                                ],
                                                                decoration: InputDecoration(
                                                                  border: OutlineInputBorder(
                                                                    borderRadius: BorderRadius.circular(10.0),
                                                                  ),
                                                                  hintText: 'Enter Amount',
                                                                ),
                                                                validator: (value) {
                                                                  if (value!.isEmpty) {
                                                                    return 'Please enter an amount.';
                                                                  }
                                                                  final amount = int.tryParse(value);
                                                                  if (amount == null || amount > int.parse(snapshot.data!.data!.walletAmount!)) {
                                                                    return 'Amount cannot exceed ${snapshot.data!.data!.walletAmount!} Rupees.';
                                                                  }
                                                                  return null; // Validation passed
                                                                },
                                                              ),
                                                              const SizedBox(
                                                                height: 10,
                                                              ),
                                                              ElevatedButton(
                                                                  onPressed: () {
                                                                    Preferences.onLoading(context);
                                                                    RemoteDataSourceImpl()
                                                                        .postwithdrawalRequest(
                                                                      upiId: _upiidcontroller.text,
                                                                      amount: _amountcontroller.text,
                                                                    )
                                                                        .then((value) {
                                                                      flutterToast(value.msg!);
                                                                      Preferences.hideDialog(context);
                                                                    });
                                                                  },
                                                                  style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                                                                  child: Text(
                                                                    'Submit',
                                                                    style: TextStyle(
                                                                      color: ColorResources.textWhite,
                                                                    ),
                                                                  ))
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ).then((value) {
                                                    safeSetState() {}
                                                  });
                                                },
                                                style: OutlinedButton.styleFrom(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(20),
                                                  ),
                                                  side: BorderSide(
                                                    color: ColorResources.buttoncolor,
                                                  ),
                                                ),
                                                child: Text(
                                                  'Redeem Now',
                                                  style: TextStyle(
                                                    color: ColorResources.buttoncolor,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ))
                                            : Row(
                                                children: [
                                                  const Icon(Icons.info_outline),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  SizedBox(
                                                    width: 150,
                                                    child: Text(
                                                      'If your wallet has 500 coins will be redeemable to UPI ID. ',
                                                      style: TextStyle(
                                                        color: ColorResources.textblack.withValues(alpha: 0.7),
                                                        fontSize: 10,
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CachedNetworkImage(
                                      placeholder: (context, url) => const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                      errorWidget: (context, url, error) => const Icon(Icons.error),
                                      imageUrl: SvgImages.coin,
                                      height: 80,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          ListTile(
                            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const ReferEranScreen(),
                            )),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                            tileColor: ColorResources.buttoncolor.withValues(alpha: 0.1),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            leading: CachedNetworkImage(
                              placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator(),
                              ),
                              errorWidget: (context, url, error) => const Icon(Icons.error),
                              imageUrl: SvgImages.earnpoint,
                              height: 40,
                            ),
                            title: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Help your Friends ',
                                    style: TextStyle(
                                      color: ColorResources.buttoncolor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '& Earn points to unlock premium Content ',
                                    style: TextStyle(
                                      color: ColorResources.textblack,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            trailing: Icon(
                              Icons.arrow_right,
                              color: ColorResources.textblack,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Transaction  History',
                            style: TextStyle(
                              color: ColorResources.textblack,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          snapshot.data?.data?.transactions?.isEmpty ?? true
                              ? SizedBox(height: 500, child: EmptyWidget(image: SvgImages.emptyCard, text: 'No Transaction'))
                              : ListView.builder(
                                  itemCount: snapshot.data!.data!.transactions!.length,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) => Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: ListTile(
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                                      tileColor: Colors.white,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                      leading: CachedNetworkImage(
                                        placeholder: (context, url) => const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                        errorWidget: (context, url, error) => const Icon(Icons.error),
                                        imageUrl: SvgImages.coin,
                                        height: 30,
                                      ),
                                      title: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            snapshot.data!.data!.transactions![index].reason!.toCapitalize(),
                                            style: TextStyle(
                                              color: ColorResources.textblack,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            snapshot.data!.data!.transactions![index].reason!.toCapitalize(),
                                            style: TextStyle(
                                              color: ColorResources.textblack,
                                              fontSize: 10,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            DateFormat("dd MMM yyyy hh:mm a").format(DateFormat("yyyy-MM-dd hh:mm:ss").parse(snapshot.data!.data!.transactions![index].dateTime!)),
                                            style: TextStyle(
                                              color: ColorResources.textblack,
                                              fontSize: 10,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          )
                                        ],
                                      ),
                                      trailing: Text(
                                        '${snapshot.data!.data!.transactions![index].action == 'add' ? '+' : '-'}₹${snapshot.data!.data!.transactions![index].amount!}',
                                        style: TextStyle(
                                          color: snapshot.data!.data!.transactions![index].action == 'add' ? const Color(0xFF1e7026) : const Color(0xFFfb5259),
                                          fontSize: 22,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                );
              }
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
