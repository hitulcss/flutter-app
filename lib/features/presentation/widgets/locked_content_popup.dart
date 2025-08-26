import 'package:flutter/material.dart';

import "package:sd_campus_app/features/data/remote/models/course_details_model.dart";
import 'package:sd_campus_app/features/services/payment_fun.dart';
import 'package:sd_campus_app/util/color_resources.dart';

lockedContentPopup({required BuildContext context, required Data data, required String place}) {
  showDialog(
    context: context,
    builder: (context) => Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            children: [
              SizedBox(
                height: 20,
              ),
              CircleAvatar(
                  radius: 35,
                  child: Icon(
                    Icons.lock,
                    size: 50,
                    color: ColorResources.buttoncolor,
                  )),
              SizedBox(
                height: 10,
              ),
              Text(
                'Locked!',
                style: TextStyle(
                  color: ColorResources.textblack,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  height: 0,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Purchase this batch to unlock all ${place.isNotEmpty ? place : "Content"}.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: ColorResources.textblack,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 0,
                  ),
                ),
              )
            ],
          ),
          Column(
            children: [
              Divider(),
              Padding(
                padding: const EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  bottom: 16.0,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          side: BorderSide(
                            width: 2,
                            style: BorderStyle.solid,
                            color: Color(0xFFFB5259),
                          ),
                        ),
                        child: Text(
                          'CANCEL',
                          style: TextStyle(
                            color: Color(0xFFFB5259),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          buttonOnTap(context: context, data: data.batchDetails!, isEnroll: false);
                        },
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor: ColorResources.buttoncolor),
                        child: Text(
                          'BUY NOW',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          )
        ],
      ),
    ),
  );
}
