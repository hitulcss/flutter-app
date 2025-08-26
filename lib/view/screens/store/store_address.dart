import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sd_campus_app/features/cubit/storeAddress/StoreAddress_cubit.dart';
import 'package:sd_campus_app/features/presentation/widgets/tostmessage.dart';
import 'package:sd_campus_app/main.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/util/prefconstatnt.dart';
import 'package:sd_campus_app/util/preference.dart';

class StoreAddressScreen extends StatefulWidget {
  const StoreAddressScreen({super.key});

  @override
  State<StoreAddressScreen> createState() => _StoreAddressScreenState();
}

class _StoreAddressScreenState extends State<StoreAddressScreen> {
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _pinCodeController = TextEditingController();
  final TextEditingController _AddressController = TextEditingController();
  final TextEditingController _LandMarkController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  @override
  void initState() {
    context.read<StoreAddressCubit>().getStoreAddressapi();
    super.initState();
  }

  @override
  void dispose() {
    _countryController.dispose();
    _nameController.dispose();
    _pinCodeController.dispose();
    _AddressController.dispose();
    _LandMarkController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _numberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // height: MediaQuery.sizeOf(context).height * 0.6,
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            BlocBuilder<StoreAddressCubit, StoreAddressState>(
              builder: (context, state) {
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          Preferences.appString.manageYourAddress ?? 'Manage your address',
                          style: TextStyle(
                            color: ColorResources.textblack,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (context.read<StoreAddressCubit>().data?.data?.isNotEmpty ?? false)
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              _AddressController.clear();
                              _LandMarkController.clear();
                              _cityController.clear();
                              _countryController.clear();
                              _nameController.clear();
                              _numberController.clear();
                              _pinCodeController.clear();
                              _stateController.clear();
                              address(context);
                            },
                            // style: OutlinedButton.styleFrom(
                            //     shape: RoundedRectangleBorder(
                            //       borderRadius: BorderRadius.circular(20),
                            //     ),
                            //     side: BorderSide(
                            //       color: ColorResources.buttoncolor,
                            //     )),
                            child: Text(
                              '+ Add Address',
                              style: TextStyle(
                                color: ColorResources.buttoncolor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          )
                      ],
                    ),
                    const Divider(),
                    context.read<StoreAddressCubit>().data?.data?.isEmpty ?? true
                        ? Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: [
                                const Icon(Icons.place_outlined),
                                const SizedBox(
                                  height: 10,
                                ),
                                OutlinedButton(
                                  onPressed: () {
                                    address(context);
                                  },
                                  style: OutlinedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    backgroundColor: ColorResources.buttoncolor.withValues(alpha: 0.1),
                                    elevation: 0,
                                  ),
                                  child: Text(
                                    'Add Address',
                                    style: TextStyle(
                                      color: ColorResources.buttoncolor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      height: 0,
                                      letterSpacing: -0.56,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        : ListView.separated(
                            separatorBuilder: (context, index) => const SizedBox(
                              height: 5,
                            ),
                            shrinkWrap: true,
                            itemCount: context.read<StoreAddressCubit>().data?.data?.length ?? 0,
                            itemBuilder: (context, index) => Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                // SharedPreferenceHelper.getString(Preferences.name)!,
                                                context.read<StoreAddressCubit>().data!.data![index].name!,
                                                style: GoogleFonts.notoSansDevanagari(
                                                  color: ColorResources.textblack,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                  height: 0,
                                                  letterSpacing: -0.48,
                                                ),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                _countryController.text = context.read<StoreAddressCubit>().data!.data![index].country!;
                                                _nameController.text = context.read<StoreAddressCubit>().data!.data![index].name!;
                                                _pinCodeController.text = context.read<StoreAddressCubit>().data!.data![index].pinCode!;
                                                _LandMarkController.text = context.read<StoreAddressCubit>().data!.data![index].streetAddress!;
                                                _cityController.text = context.read<StoreAddressCubit>().data!.data![index].city!;
                                                _stateController.text = context.read<StoreAddressCubit>().data!.data![index].state!;
                                                _numberController.text = context.read<StoreAddressCubit>().data!.data![index].phone!;
                                                address(context, id: context.read<StoreAddressCubit>().data!.data![index].id);
                                              },
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(
                                                  vertical: 5,
                                                  horizontal: 10,
                                                ),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10),
                                                  border: Border.all(
                                                    color: ColorResources.buttoncolor,
                                                  ),
                                                  color: ColorResources.buttoncolor.withValues(alpha: 0.1),
                                                ),
                                                child: Text(
                                                  Preferences.appString.edit ?? 'Edit',
                                                  style: GoogleFonts.notoSansDevanagari(
                                                    color: ColorResources.buttoncolor,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                    height: 0,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          '${context.read<StoreAddressCubit>().data!.data![index].streetAddress!},${context.read<StoreAddressCubit>().data!.data![index].city ?? ""},${context.read<StoreAddressCubit>().data!.data![index].state ?? ""},${context.read<StoreAddressCubit>().data!.data![index].country ?? ""},${context.read<StoreAddressCubit>().data!.data![index].pinCode ?? ""}',
                                          style: GoogleFonts.notoSansDevanagari(
                                            color: ColorResources.textBlackSec,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            height: 0,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                '+91-${context.read<StoreAddressCubit>().data!.data![index].phone!}',
                                                style: GoogleFonts.notoSansDevanagari(
                                                  color: ColorResources.textblack,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                  height: 0,
                                                ),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                analytics.logEvent(name: "app_store_address_remove", parameters: {
                                                  "id": context.read<StoreAddressCubit>().data?.data?[index].id ?? ""
                                                });
                                                context.read<StoreAddressCubit>().removefromStoreAddress(id: context.read<StoreAddressCubit>().data!.data![index].id);
                                              },
                                              child: const Text(
                                                'Remove',
                                                style: TextStyle(
                                                  color: Color(0xFFEC3863),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  height: 0,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                  ],
                );
              },
            ),
            // const Divider(),
            // Row(
            //   children: [
            //     Expanded(
            //       flex: 5,
            //       child: OutlinedButton(
            //         onPressed: () {
            //           Navigator.of(context).pop();
            //           _AddressController.clear();
            //           _LandMarkController.clear();
            //           _cityController.clear();
            //           _countryController.clear();
            //           _nameController.clear();
            //           _numberController.clear();
            //           _pinCodeController.clear();
            //           _stateController.clear();
            //           address(context);
            //         },
            //         style: OutlinedButton.styleFrom(
            //             shape: RoundedRectangleBorder(
            //               borderRadius: BorderRadius.circular(20),
            //             ),
            //             side: BorderSide(
            //               color: ColorResources.buttoncolor,
            //             )),
            //         child: Text(
            //           'Add Address',
            //           style: TextStyle(
            //             color: ColorResources.buttoncolor,
            //             fontSize: 14,
            //             fontWeight: FontWeight.w500,
            //           ),
            //         ),
            //       ),
            //     ),
            //     const Spacer(),
            //     Expanded(
            //         flex: 5,
            //         child: ElevatedButton(
            //           style: ElevatedButton.styleFrom(
            //             backgroundColor: ColorResources.buttoncolor,
            //             shape: RoundedRectangleBorder(
            //               borderRadius: BorderRadius.circular(20),
            //             ),
            //           ),
            //           onPressed: () {
            //             Navigator.of(context).pop();
            //           },
            //           child: Text(
            //             Preferences.appString.deliveryHere ?? 'Delivery Here',
            //             style: const TextStyle(
            //               color: Colors.white,
            //               fontSize: 14,
            //               fontWeight: FontWeight.w500,
            //               height: 0,
            //             ),
            //           ),
            //         ))
            //   ],
            // )
          ],
        ),
      ),
    );
  }

  address(BuildContext context, {String? id}) {
    return showModalBottomSheet(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Text(
                'Delivery Address',
                textAlign: TextAlign.center,
                style: GoogleFonts.notoSansDevanagari(
                  color: ColorResources.textblack,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  height: 0,
                  letterSpacing: -0.64,
                ),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Name',
                            style: GoogleFonts.notoSansDevanagari(
                              color: ColorResources.textblack,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              height: 0,
                              letterSpacing: -0.24,
                            ),
                          ),
                          TextSpan(
                            text: '*',
                            style: GoogleFonts.notoSansDevanagari(
                              color: const Color(0xFFFD0303),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              height: 0,
                              letterSpacing: -0.24,
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextField(
                      controller: _nameController,
                      keyboardType: TextInputType.name,
                      enableSuggestions: true,
                      autofillHints: const [
                        AutofillHints.name
                      ],
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          hintText: 'Enter Name'),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Mobile Number',
                            style: GoogleFonts.notoSansDevanagari(
                              color: ColorResources.textblack,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              height: 0,
                              letterSpacing: -0.24,
                            ),
                          ),
                          TextSpan(
                            text: '*',
                            style: GoogleFonts.notoSansDevanagari(
                              color: const Color(0xFFFD0303),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              height: 0,
                              letterSpacing: -0.24,
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextField(
                      controller: _numberController,
                      maxLength: 10,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      keyboardType: TextInputType.phone,
                      enableSuggestions: true,
                      autofillHints: const [
                        AutofillHints.telephoneNumber
                      ],
                      decoration: InputDecoration(
                          counterText: "",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          hintText: 'Enter Mobile Number'),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Pincode',
                            style: GoogleFonts.notoSansDevanagari(
                              color: ColorResources.textblack,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              height: 0,
                              letterSpacing: -0.24,
                            ),
                          ),
                          TextSpan(
                            text: '*',
                            style: GoogleFonts.notoSansDevanagari(
                              color: const Color(0xFFFD0303),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              height: 0,
                              letterSpacing: -0.24,
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextField(
                      controller: _pinCodeController,
                      maxLength: 6,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      keyboardType: TextInputType.phone,
                      enableSuggestions: true,
                      autofillHints: const [
                        AutofillHints.postalAddressExtendedPostalCode
                      ],
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          hintText: 'Pincode'),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    // Text.rich(
                    //   TextSpan(
                    //     children: [
                    //       TextSpan(
                    //         text: 'Address',
                    //         style: GoogleFonts.notoSansDevanagari(
                    //           color: ColorResources.textblack,
                    //           fontSize: 12,
                    //           fontWeight: FontWeight.w600,
                    //           height: 0,
                    //           letterSpacing: -0.24,
                    //         ),
                    //       ),
                    //       TextSpan(
                    //         text: '*',
                    //         style: GoogleFonts.notoSansDevanagari(
                    //           color: const Color(0xFFFD0303),
                    //           fontSize: 12,
                    //           fontWeight: FontWeight.w600,
                    //           height: 0,
                    //           letterSpacing: -0.24,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // TextField(
                    //   controller: _AddressController,
                    //   decoration: InputDecoration(
                    //       border: OutlineInputBorder(
                    //         borderRadius: BorderRadius.circular(10),
                    //       ),
                    //       hintText: 'Address'),
                    // ),
                    // const SizedBox(
                    //   height: 10,
                    // ),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Street',
                            style: GoogleFonts.notoSansDevanagari(
                              color: ColorResources.textblack,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              height: 0,
                              letterSpacing: -0.24,
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextField(
                      controller: _LandMarkController,
                      keyboardType: TextInputType.streetAddress,
                      enableSuggestions: true,
                      autofillHints: const [
                        AutofillHints.fullStreetAddress
                      ],
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          hintText: 'Street'),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'City',
                            style: GoogleFonts.notoSansDevanagari(
                              color: ColorResources.textblack,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              height: 0,
                              letterSpacing: -0.24,
                            ),
                          ),
                          TextSpan(
                            text: '*',
                            style: GoogleFonts.notoSansDevanagari(
                              color: const Color(0xFFFD0303),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              height: 0,
                              letterSpacing: -0.24,
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextField(
                      controller: _cityController,
                      enableSuggestions: true,
                      autofillHints: const [
                        AutofillHints.addressCity
                      ],
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          hintText: 'City'),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'State',
                            style: GoogleFonts.notoSansDevanagari(
                              color: ColorResources.textblack,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              height: 0,
                              letterSpacing: -0.24,
                            ),
                          ),
                          TextSpan(
                            text: '*',
                            style: GoogleFonts.notoSansDevanagari(
                              color: const Color(0xFFFD0303),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              height: 0,
                              letterSpacing: -0.24,
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextField(
                      controller: _stateController,
                      enableSuggestions: true,
                      autofillHints: const [
                        AutofillHints.addressState
                      ],
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          hintText: 'State'),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'country',
                            style: GoogleFonts.notoSansDevanagari(
                              color: ColorResources.textblack,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              height: 0,
                              letterSpacing: -0.24,
                            ),
                          ),
                          TextSpan(
                            text: '*',
                            style: GoogleFonts.notoSansDevanagari(
                              color: const Color(0xFFFD0303),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              height: 0,
                              letterSpacing: -0.24,
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextField(
                      controller: _countryController,
                      enableSuggestions: true,
                      autofillHints: const [
                        AutofillHints.countryName
                      ],
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          hintText: 'country'),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              if (_nameController.text.isEmpty && _numberController.text.isEmpty && _LandMarkController.text.isEmpty && _cityController.text.isEmpty && _countryController.text.isEmpty && _stateController.text.isEmpty && _pinCodeController.text.isEmpty) {
                                flutterToast("Please enter All Fields");
                              } else {
                                analytics.logEvent(name: "app_store_address_add", parameters: {
                                  "email": SharedPreferenceHelper.getString(Preferences.email)!,
                                  "name": _nameController.text,
                                  "phone": _numberController.text,
                                  "streetAddress": _LandMarkController.text,
                                  "city": _cityController.text,
                                  "country": _countryController.text,
                                  "state": _stateController.text,
                                  "pinCode": _pinCodeController.text,
                                });
                                context
                                    .read<StoreAddressCubit>()
                                    .updatefromStoreAddress(
                                      email: SharedPreferenceHelper.getString(Preferences.email)!,
                                      name: _nameController.text,
                                      phone: _numberController.text,
                                      streetAddress: _LandMarkController.text,
                                      city: _cityController.text,
                                      country: _countryController.text,
                                      state: _stateController.text,
                                      pinCode: _pinCodeController.text,
                                    )
                                    .then((value) {
                                  if (value) {
                                    Navigator.of(context).pop();
                                  }
                                });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorResources.buttoncolor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              'Save Address',
                              style: GoogleFonts.notoSansDevanagari(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                height: 0,
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
