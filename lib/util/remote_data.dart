// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:sd_campus_app/util/app_icons.dart';

Map<String, dynamic> remote_data = {
  "app_info": jsonEncode({
    "about": "Welcome to SD Empire – a hub dedicated to education, growth, and empowerment. Our ventures – SD Campus, SD School, SD Abroad, SD Media, SD Publication, SD Library, and SD Hostels – shape a brighter future. Join us in creating a global network of educational and creative endeavors, making a positive impact.\n\nExplore our offerings for competitive exam prep, nurturing education, studying abroad, inspiring content, knowledge-packed publications, resourceful library, and comfortable hostels. Our commitment to integrity, innovation, and inclusivity fosters continuous learning.\n\nJoin our family – students, seekers, creatives – let's build a world where dreams come true. Embrace Empowerment, Education, Excellence with SD Empire.\n\nJai Hind- Jai Bharat ",
    "forceupdate": true,
    "fromversion": "ALL"
  }),
  "app_color": jsonEncode({
    "button_color": "BF9603F2",
    "secPrimary": "FFF2ECFF",
    "textWhite": "FFFFFFFF",
    "textblack": "FF333333",
    "gray": "FF808080",
    "borderColor": "FFD9D9D9",
    "resourcesCardColor": "FF9603F2",
    "youtube": "FFFFE6E6",
    "telegarm": "FFC0DEFF",
    "greenshad": "FF718744",
    "edit": "FF30A2E2",
    "delete": "FFFA7676"
  }),
  "social_media": jsonEncode({
    "facebook": "https://www.facebook.com/sdcampus1",
    "youtube": [
      {
        "dpImageUrl": "https://d1mbj426mo5twu.cloudfront.net/assets/sdcampus_logo.png",
        "channelName": "SD Campus",
        "youTubeUrl": "https://www.youtube.com/channel/UCXi36lfrMGc3oH-OFC_1EtA?sub_confirmation=1"
      },
      {
        "dpImageUrl": "https://d1mbj426mo5twu.cloudfront.net/assets/sdcampus_logo.png",
        "channelName": "SD Campus Teaching",
        "youTubeUrl": "https://www.youtube.com/channel/UC1o9hfvby_ns1sJIKEq9LFQ?sub_confirmation=1"
      },
      {
        "dpImageUrl": "https://d1mbj426mo5twu.cloudfront.net/assets/sd_store_logo_1721484971.jpg",
        "channelName": "SD Store",
        "youTubeUrl": "https://www.youtube.com/@sdstore_official"
      },
      {
        "dpImageUrl": "https://d1mbj426mo5twu.cloudfront.net/assets/sdcampus_logo.png",
        "channelName": "SD Campus Sainik & JNV School",
        "youTubeUrl": "https://www.youtube.com/@sdsainikschool"
      },
      {
        "dpImageUrl": "https://d1mbj426mo5twu.cloudfront.net/assets/sdcampus_logo.png",
        "channelName": "SD JNV School",
        "youTubeUrl": "https://www.youtube.com/@SDJNVST"
      },
      {
        "dpImageUrl": "https://d1mbj426mo5twu.cloudfront.net/assets/sd_study_abroad_1718430048.jpg",
        "channelName": "SD Study Abroad",
        "youTubeUrl": "https://www.youtube.com/@sdstudyabroad"
      }
    ],
    "instagram": "https://www.instagram.com/sd_campus",
    "twitter": "https://twitter.com/SdCampus",
    "telegram": "https://t.me/sd_campus",
    "linkedin": "https://www.linkedin.com/company/sd-campus/",
    "email": "info@sdcampus.co.in",
    "number": "+917428394519",
    "whatsAppNumber": "+917428394520"
  }),
  "store": jsonEncode({
    "number": "+917428186291",
    "islink": true,
    "link": "https://store.sdcampus.com/",
    "delivery": {
      "0-499": 100,
      "500-5000000": 60
    },
    "salediscount": [
      {
        "discount": 10,
        "image": "https://store.sdcampus.com/static/media/sale1.5204b35246bf666e4541.png"
      }
    ]
  }),
  "aware_app": jsonEncode({
    "title": "Important: Be Safe Online!",
    "desc": "Remember to be safe when interacting with others online. \nNot everyone you meet online is who they say they are.\nThink carefully before sharing any personal information.",
    "isActive": false,
    "inAppReview": false
  }),
  "image_urls": jsonEncode({
    "thankyou": "https://static.sdcampus.com/AIR/thank_you_1737725430.gif",
    "supportimage": "https://static.sdcampus.com/AIR/support_man_1737725381.png",
    "newFeature": "https://static.sdcampus.com/assets/new_feature_1732601005.gif",
    "banner_2": "https://d1mbj426mo5twu.cloudfront.net/images/ad+2.jpg",
    "banner_3": "https://d1mbj426mo5twu.cloudfront.net/images/ad+3.jpg",
    "banner_1": "https://d1mbj426mo5twu.cloudfront.net/images/ad+1.jpg",
    "banner_4": "https://d1mbj426mo5twu.cloudfront.net/images/ad+4.jpg",
    "avatar": "https://d1mbj426mo5twu.cloudfront.net/assets/Avtar.png",
    "logo": "assets/images/logo.png",
    "paymentfailed": "assets/images/Payment_failed.gif",
    "paymentsucess": "assets/images/payment_sucess.gif",
    "aboutLogo": "https://d1mbj426mo5twu.cloudfront.net/assets/SDCampus_logo.png",
    "google": "https://d1mbj426mo5twu.cloudfront.net/assets/Google.png",
    "apple": "https://d1mbj426mo5twu.cloudfront.net/assets/Apple.png",
    "exampen": "https://d1mbj426mo5twu.cloudfront.net/assets/Test.png",
    "pdfimage": "https://d1mbj426mo5twu.cloudfront.net/assets/pdf.png",
    "courses": "https://d1mbj426mo5twu.cloudfront.net/assets/Courses.png",
    "linkdin": "https://d1mbj426mo5twu.cloudfront.net/assets/linkdin.png",
    "authemail": "https://storage-upschindi.s3.ap-south-1.amazonaws.com/data/icons/email.png",
    "email": "https://d1mbj426mo5twu.cloudfront.net/assets/Gmail.png",
    "telegram": "https://d1mbj426mo5twu.cloudfront.net/assets/Telegram.png",
    "youtube": "https://d1mbj426mo5twu.cloudfront.net/assets/YouTube.png",
    "facebook": "https://d1mbj426mo5twu.cloudfront.net/assets/facebook.png",
    "twitter": "https://d1mbj426mo5twu.cloudfront.net/assets/Twitter-logo.png",
    "twitterbackground": "https://d1mbj426mo5twu.cloudfront.net/assets/Twitter.png",
    "whatsapp": "https://d1mbj426mo5twu.cloudfront.net/assets/whatsapp.png",
    "whatsappbackgroung": "https://d1mbj426mo5twu.cloudfront.net/assets/whatsapp_icon.png",
    "instagram": "https://d1mbj426mo5twu.cloudfront.net/assets/instagram.png",
    "backgroung": "https://d1mbj426mo5twu.cloudfront.net/assets/My_Profile_bg.png",
    "emptyCard": "https://d1mbj426mo5twu.cloudfront.net/assets/Cart.png",
    "dailyNews": "https://d1mbj426mo5twu.cloudfront.net/assets/Daily_News.png",
    "courseIndex": "https://d1mbj426mo5twu.cloudfront.net/assets/Syllabus.png",
    "shortNotes": "https://d1mbj426mo5twu.cloudfront.net/assets/PYQs.png",
    "youtubeNotes": "https://d1mbj426mo5twu.cloudfront.net/assets/Youtube_video.png",
    "sampleNotes": "https://d1mbj426mo5twu.cloudfront.net/assets/NCERT_Notes.png",
    "air": "https://d1mbj426mo5twu.cloudfront.net/assets/AIR.png",
    "comingsoon": "https://d1mbj426mo5twu.cloudfront.net/assets/Interview.gif",
    "emptycoupon": "https://d1mbj426mo5twu.cloudfront.net/assets/Coupons.png",
    "emptytestseries": "https://d1mbj426mo5twu.cloudfront.net/assets/Quizz.png",
    "emptycoursenotes": "https://d1mbj426mo5twu.cloudfront.net/assets/Courses.png",
    "emptyCourseVideo": "https://d1mbj426mo5twu.cloudfront.net/assets/Youtube_notes.png",
    "emptycourse": "https://d1mbj426mo5twu.cloudfront.net/assets/Courses.png",
    "emptydownload": "https://d1mbj426mo5twu.cloudfront.net/assets/No-Download.png",
    "emptylivelecture": "https://d1mbj426mo5twu.cloudfront.net/assets/Live-lecture.png",
    "emptymycart": "https://d1mbj426mo5twu.cloudfront.net/assets/Cart.png",
    "emptymyorders": "https://d1mbj426mo5twu.cloudfront.net/assets/My_order.png",
    "emptyresource": "https://d1mbj426mo5twu.cloudfront.net/assets/No_Resources.png",
    "emptyquiz": "https://d1mbj426mo5twu.cloudfront.net/assets/Quizz.png",
    "emptyresultcalculation": "https://d1mbj426mo5twu.cloudfront.net/assets/Waiting_Result.png",
    "emptyscdeule": "https://d1mbj426mo5twu.cloudfront.net/assets/Create-schedule.png",
    "emptyvideo": "https://d1mbj426mo5twu.cloudfront.net/assets/Youtube_notes.png",
    "error404": "assets/images/warning.png",
    "servererror": "https://d1mbj426mo5twu.cloudfront.net/data/icons/server_error.png",
    "emptyMyScdeule": "https://d1mbj426mo5twu.cloudfront.net/assets/Create-schedule.png",
    "notification": "assets/images/notification.gif",
    "notificationRec": "assets/images/notification-2.gif",
    "warning": "assets/images/warning.png",
    "dailylive": "assets/images/Daily_live.png",
    "dailynews": "assets/images/Daily-News.png",
    "syllabus": "assets/images/Syllabus.png",
    "pyq": "assets/images/Prev_Notes.png",
    "ncertNotes": "assets/images/Ncert_Notes.png",
    "dppNoteslive": "https://d1mbj426mo5twu.cloudfront.net/assets/Ncert_Notes.png",
    "emptyvideoh": "assets/images/Youtube-notes.png",
    "otpscreen": "https://d1mbj426mo5twu.cloudfront.net/assets/Enter_OTP.png",
    "resetpassword": "https://d1mbj426mo5twu.cloudfront.net/assets/Reset_password.png",
    "founder": "https://d1mbj426mo5twu.cloudfront.net/assets/Founder_logo.png",
    "referral": "https://d1mbj426mo5twu.cloudfront.net/assets/Referral.png",
    "rewards": "https://d1mbj426mo5twu.cloudfront.net/assets/Rewards.png",
    "wallet": "https://d1mbj426mo5twu.cloudfront.net/assets/Wallet.png",
    "earnpoint": "https://d1mbj426mo5twu.cloudfront.net/assets/Earn_point.png",
    "coin": "https://d1mbj426mo5twu.cloudfront.net/assets/Coin.png",
    "leaderbord_star": "https://d1mbj426mo5twu.cloudfront.net/assets/leaderboard_start.png",
    "inviteyaari": "https://d1mbj426mo5twu.cloudfront.net/assets/invite_yaari.png",
    "storecenterHome": "https://d1mbj426mo5twu.cloudfront.net/assets/store_welcome.gif",
    "emptyProduct": "https://d1mbj426mo5twu.cloudfront.net/assets/store/new_product.png",
    "emptyWishlist": "https://d1mbj426mo5twu.cloudfront.net/assets/store/Empty_Wishlist.png",
    "emptyOrder": "https://d1mbj426mo5twu.cloudfront.net/assets/store/Empty_order.png",
    "emptycart": "https://d1mbj426mo5twu.cloudfront.net/assets/store/Empty_cart.png",
    "emptybook": "https://d1mbj426mo5twu.cloudfront.net/assets/store/Empty_book.png",
    "testregbackground": "https://d1mbj426mo5twu.cloudfront.net/assets/Mock_test_img.png",
    "calenderimage": "https://d1mbj426mo5twu.cloudfront.net/assets/calendar_img.png",
    "noAccouncement": "https://d1mbj426mo5twu.cloudfront.net/assets/no_Accouncement.png",
    "noaskdoubt": "https://d1mbj426mo5twu.cloudfront.net/assets/Ask-Doubts.png",
    "nochatEmpty": "https://d1mbj426mo5twu.cloudfront.net/assets/Chat-Empty.png",
    "noPollEmpty": "https://d1mbj426mo5twu.cloudfront.net/assets/Poll-Empty.png",
    "helpandsupport": "https://d1mbj426mo5twu.cloudfront.net/assets/Help-Support.png",
    "noEbooks": "https://d1mbj426mo5twu.cloudfront.net/assets/Quizz.png",
    "priceDropRibbon": "https://store.sdcampus.com/static/media/price-drop.777aa9e11d3b4d0f01ff7e9e9c72c662.svg",
    "newArrivalRibbon": "https://store.sdcampus.com/static/media/new-arrivals.dd135345f0374a42c0a382185b50af89.svg",
    "trendingRibbon": "https://store.sdcampus.com/static/media/trending.96098fd7c392812d9d8965ae0cb6dabb.svg",
    "bestSellingRibbon": "https://store.sdcampus.com/static/media/bestselling.026865b95df2cb7f858c59179c84ea91.svg",
    "freedomsaleRibbon": "https://store.sdcampus.com/static/media/bestselling.026865b95df2cb7f858c59179c84ea91.svg",
    "storeLogo": "https://store.sdcampus.com/static/media/storelogo.f21f20e540d06335c068.jpg",
    "storeNewArrivalBackgorund": "https://store.sdcampus.com/static/media/cover2.642519b72a400e2302e7.png",
    "storeSalesBackgorund": "https://store.sdcampus.com/static/media/saleposter.f4b09430660c79ce42e2.png"
  }),
  "refer_and_earn": jsonEncode({
    "home_screen": {
      "card": {
        "isActive": true,
        "title": "REFER AND EARN",
        "subTitle": "Learn Together. Earn Together",
        "body": "Invite your Friends to join Sd Campus. You get upto 20% of the purchase amount as Paytm cashback on your friend’s purchase. Your friends get upto 10% discount on their purchase with your code",
        "sharedataButton": "🌟 Exciting news! Discovered SD Campus App - top-notch courses & online bookstore. 📚 Join using my code {myReferralCode}  for exclusive benefits! Let's boost our learning journey together! 🚀 \n\n Download Now : https://sdcampus.onelink.me/rnhk/SDCampusApp"
      }
    },
    "refer_and_earn": {
      "amount": "20",
      "link": "https://play.google.com/store/apps/details?id=com.sdcampus.app",
      "sharedata": "SD Campus is an institute of an excellence for हिन्दी as well as ENGLISH medium which aims to revolutionize education sector. SD Campus takes its motto \"सिद्धिर्भवति कर्मजा\" from \"श्रीमद्भागवत गीता\" and disseminates its essence among the students that \"Practice Leads To Success\" अर्थात् कर्मों से ही सिद्धि प्राप्त होगी \n Download Now ! \n\n  https://sdcampus.com/",
      "term_and_condition": "Cashback will be credited to your registered mobile number +91{phoneNumber} . You may change your number to get cashback in another mobile number."
    }
  }),
  "app_strings": jsonEncode({
    "slogan": "",
    "madeby": "",
    "userId": "UserId:",
    "myDownloads": "My Downloads",
    "myOrders": "My Orders",
    "mySchedules": "My Schedules",
    "resources": "Resources",
    "aboutUs": "About Us",
    "referAndEarn": "Refer and Earn",
    "myWallet": "My Wallet",
    "helpAndSupport": "Help & Support",
    "settings": "Settings",
    "logout": "Logout",
    "Videos": "Videos",
    "enrolldate": "Enrollment Date",
    "paymentstatus": "Payment Status",
    "sucessfully": "Successfull",
    "failed": "Failed",
    "downloadinvoice": "Download Invoice",
    "emi": "EMI-",
    "myschedule": "My Schedule",
    "classSchedule": "Class Schedule",
    "scheduleFor": "Schedule For",
    "today": "Today",
    "selectDate": "Select Date",
    "scheduleDetails": "Schedule Details",
    "task": "Task",
    "notifyAt": "Notify at",
    "setAlarm": "Set Alarm",
    "update": "Update",
    "cancel": "Cancel",
    "delete": "Delete",
    "dailyNews": "Daily News",
    "syllabus": "Syllabus",
    "pyqs": "PYQs",
    "youtubeVideos": "Youtube Videos",
    "ncertNotes": "Ncert Notes",
    "helpAndSupportQuote": "Feel Free to message us at",
    "learning": "Learning",
    "Courses": "Courses",
    "Feed": "Feed",
    "ebook": "E-Books",
    "Store": "Store",
    "myCourses": "My Courses",
    "myEbooks": "My E-Books",
    "freeQuiz": "Free Quiz",
    "offeringCoursesForYou": "Offering Courses For You",
    "targetedBatchFor": "Targeted Batch For",
    "start": "Start",
    "end": "End",
    "off": "OFF",
    "ViewDetails": "View Details",
    "BuyNow": "Buy Now",
    "ViewMore": "View More",
    "letsStudy": "Lets Study",
    "test": "test",
    "description": "Description",
    "todayClass": "Todays Class",
    "upcomingClass": "Upcoming Class",
    "lectureVideos": "Lecture Videos",
    "liveChat": "Live Chat",
    "rating": "Rating",
    "poll": "Poll",
    "saysomething": "Say something...",
    "tellUsMoreAboutTheIssue": "Tell us more about the issue",
    "askDoubt": "Ask Doubt",
    "video": "Video",
    "text": "Text",
    "_continue": "Continue",
    "submit": "Submit",
    "sdCampusYouTubeChannel": "SD Campus YouTube Channel",
    "needOurHelp": "Need Our Help?",
    "call": "Call",
    "chatOnWhatsApp": "Chat on WhatsApp",
    "joinUsOn": "Join Us on",
    "startAt": "Start At",
    "endAt": "End At",
    "registerForFree": "Register For Free",
    "crackYourDreamExamWith": "Crack Your Dream Exam With",
    "leaderboardWillBePublishedAfter": "Leaderboard Will Be Published After",
    "testDuration": "Test Duration",
    "testStartAt": "Test Start At",
    "resultDeclaration": "Result Declaration",
    "testGuidelines": "Test Guidelines",
    "attemptTest": "Attempt Test",
    "paidCourse": "Paid Courses",
    "freeCourse": "Free Courses",
    "info": "Info",
    "study": "Study",
    "educators": "Educators",
    "FAQs": "FAQs",
    "startOn": "Start On",
    "duration": "Duration",
    "lectures": "Lectures",
    "planner": "Planner",
    "freeDemoVideo": "Free Demo Video",
    "_class": "Class",
    "tests": "Tests",
    "notes": "Notes",
    "dPPs": "DPPs",
    "announcements": "Announcements",
    "introduction": "Introduction",
    "experience&Expertise": "Experience & Expertise",
    "orderSummary": "Order Summary",
    "applyCoupon": "Apply Coupon",
    "seeAvalableOffersAndCoupons": "See Avalable Offers And Coupons",
    "billDetails": "Bill Details",
    "totalAmount": "Total Amount",
    "discount": "Discount",
    "inclusiveAllOfTaxes": "Inclusive All Of Taxes",
    "payableAmount": "Payable Amount",
    "trustedByStudents": "Trusted By Students",
    "SecurePayment": "Secure Payment",
    "affordableEducation": "Affordable Education",
    "proceedToPay": "Proceed To Pay",
    "views": "Views",
    "comments": "Comments",
    "writeAComment": "Write A Comment",
    "reply": "Reply",
    "report": "Report",
    "pin": "Pin",
    "Pinned": "Pinned",
    "unpin": "Unpin",
    "filter": "Filter",
    "Language": "Language",
    "price": "Price",
    "apply": "Apply",
    "explore": "Explore",
    "studyMaterial": "Study Material",
    "lattestPattern": "Lattest Pattern",
    "selfPacedLearning": "Self Paced Learning",
    "devicesCompatible": "Devices Compatible",
    "freeDemoEbooks": "Free Demo Ebooks",
    "reviews": "Reviews",
    "showAllReviews": "Show All Reviews",
    "briefExplanationAboutthisQuiz": "Brief Explanation About this Quiz",
    "pleaseReadTheInstructionCarefullySoYouCanUnderstand": "Please Read The Instruction Carefully So You Can Understand",
    "startTest": "Start Test",
    "summary": "Summary",
    "difficulty": "Difficulty",
    "total": "Total",
    "questions": "Questions",
    "attempted": "Attempted",
    "skipped": "Skipped",
    "correct": "Correct",
    "incorrect": "Incorrect",
    "easy": "Easy",
    "hard": "Hard",
    "medium": "Medium",
    "explanation": "Explanation",
    "leaderboard": "Leaderboard",
    "rank": "Rank",
    "name": "Name",
    "score": "Score",
    "pleaseWait": "Please Wait...",
    "notification": "Notification",
    "noNotification": "No Notification",
    "noOrders": "No Orders",
    "noPaidCourses": "No Paid Courses",
    "noFreeCourses": "No Free Courses",
    "noFeed": "No Feed",
    "noCourses": "No Courses",
    "noTests": "No Tests",
    "noNotes": "No Notes",
    "noquiz": "No quiz",
    "noDPPs": "No DPPs",
    "noAnnouncements": "No Announcements",
    "noFaq": "No Faq",
    "noStudyMaterials": "No Study Materials",
    "noEbooks": "No Ebooks",
    "noReviews": "No Reviews",
    "noComments": "No Comments",
    "noQuestions": "No Questions",
    "noAnswers": "No Answers",
    "noSchedules": "No Schedules",
    "noClasses": "No Classes",
    "noVideos": "No Videos",
    "noResources": "No Resources",
    "noLectures": "No Lectures",
    "noPlanner": "No Planner",
    "noNews": "No News",
    "noDoubts": "No Doubts",
    "permissionDenied": "Permission Denied",
    "download": "Download",
    "inviteyourfriends": "Invite Your Friends",
    "locked": "Locked",
    "pleasePerchaseBatch": "Please purchase the batch to unlock the  content",
    "close": "Close",
    "coin": "Coin",
    "applied": "Applied",
    "couponSaving": "Coupon Saving",
    "testPerformance": "Test Performance",
    "accuracy": "Accuracy",
    "topperScore": "Topper Score",
    "viewDetailAnalysis": "View Detail Analysis",
    "reslutNotYetPublished": "Result Not Yet Published",
    "classAbouttoStart": "Class About to Start  \n Please Wait",
    "live": "Live",
    "doutrequestSent": "Doubt Request Sent",
    "requestForRealTimeComminication": "Request For Real Time Comminication",
    "pleaseWaitForDoutSession": "Please Wait For Doubt Session",
    "noDouts": "No Doubts",
    "resloved": "Resolved",
    "notResloved": "Not Resolved",
    "thanksForReporting": "Thanks For Reporting",
    "thanksForRating": "Thanks For Rating",
    "startNow": "Start Now",
    "view": "View",
    "edit": "Edit",
    "chapters": "Chapters",
    "chapter": "Chapter",
    "checkout": "Checkout",
    "paymentSummary": "Payment Summary",
    "couponAmount": "Coupon Amount",
    "readNow": "Read Now",
    "topic": "Topic",
    "topics": "Topics",
    "notopic": "No Topic",
    "exitStoreConfirmation": "Are you sure you want to exit from the SD Store?",
    "exitAppConfirmation": "Are you sure you want to exit from the App?",
    "exitTestConfirmation": "Are you sure you want to exit from the Test?",
    "popularProducts": "Popular Products",
    "highDemandCombos": "High Demand Combos",
    "booksSection": "Books Section",
    "checkDelivery": "Check Delivery",
    "enterPincode": "Enter Pincode",
    "invalidPincode": "Invalid Pincode",
    "noDelivery": "No Delivery Available",
    "addtocart": "Add to cart",
    "myCart": "My Cart",
    "quantity": "Quantity",
    "similarProducts": "Similar Products",
    "recommendProduct": "Recommend Product",
    "cashOnDelivered": "Cash On Delivery",
    "onlinePayment": "Online Payment",
    "deliveryCharges": "Delivered Charges",
    "easyReturnProduct": "Easy Return Product",
    "trustedShipping": "Trusted Shipping",
    "makePayment": "Make Payment",
    "commentsDisabledonPost": "Comments are disabled on this post",
    "commentsDisabledonlecture": "Comments are disabled on this lecture",
    "error": "Error",
    "discountProduct": "Discount Product",
    "sale": "Sale",
    "manageYourAddress": "Manage your address",
    "addAddress": "Add Address",
    "deliveryHere": "Delivery Here",
    "placeOrder": "Place Order",
    "searchForProducts": "Search For Products",
    "search": "Search",
    "homw": "Home",
    "cart": "Cart",
    "category": "Category",
    "myOrder": "My Order",
    "address": "Address",
    "newArrival": "NEW ARRIVALS",
    "exploreNewLunchProducts": "Explore New Lunch Products",
    "highDemandingProducts": "High Demanding Products",
    "shippingDetails": "Shipping Details",
    "paymentMode": "Payment Mode",
    "orderStatus": "Order Status",
    "deliveredDate": "Delivered Date",
    "amount": "Amount",
    "viewOrderDetails": "View Order Details",
    "rateThisBook": "Rate this book",
    "selectAddress": "Select Address",
    "changeAddress": "Change Address",
    "onOnlyPrepaidOrder": "On Only Prepaid Order",
    "activeOffers": "Active Offers",
    "frequentlyAskedQuestions": "Frequesntly Asked Questions",
    "yourFavourited": "Your Favourited",
    "updateAvailable": "We recommend you to update this version and improved Learning Experience exiting features.",
    "library": "Library",
    "libQuiz": "Practice Tests (Quizzes)",
    "libtoppernotes": "Topper Notes",
    "libPyqs": "Pyqs",
    "libSyllabus": "Syllabus",
    "libyoutubevideo": "Video Learning",
    "libViewAll": "View All",
    "reAttempt": "Re-Attempt",
    "storeFaqs": [
      {
        "q": "What products do you offer in your student's dream store?",
        "a": "Our store provides many study-related products, including notebooks, pens, stationery, backpacks, laptop accessories, study aids, and more."
      },
      {
        "q": "How can I place an order?",
        "a": "Ordering is easy! Simply browse our online catalogue, add the desired items to your cart, and proceed to checkout. Follow the prompts to complete your order."
      }
    ]
  }),
  "newFeatures": jsonEncode({
    "Doubt": false,
    "community": false,
    "homeShortLearning": false,
    "scholarshiptest": false,
    "quickLearningComment": false,
  }),
  "termsConditions": """<div class="terms_condition">
    <div class="contentWrapper">
        <div class="terms_condition_wrapper">
            <div class="t_c_header">
                <h1>Terms &amp; Conditions</h1>
                <p style="border: 1px solid grey; margin-top: 1rem; margin-bottom: 1rem;"></p>
                <h2 style="color: var(--textGray); font-weight: 600; font-size: 1.4rem;">Terms &amp; Conditions</h2>
                <p style="margin-top: 1rem;">Welcome to <span style="background: rgb(244, 230, 254);">SD Campus</span>!
                </p>
            </div>
            <div>
                <p>These terms and conditions outline the rules and regulations for the use of <span
                        style="background: rgb(244, 230, 254);">SD Campus</span>'s Website, located at
                    https://www.sdcampus.com/.</p>
            </div>
            <div>
                <p style="margin-bottom: 1rem;">By accessing this website we assume you accept these terms and
                    conditions. Do not continue to use <span style="background: rgb(244, 230, 254);">SD Campus</span> if
                    you do not agree to take all of the terms and conditions stated on this page.</p>
            </div>
            <div>
                <p>The following terminology applies to these Terms and Conditions, Privacy Statement and Disclaimer
                    Notice and all Agreements: "Client", "You" and "Your" refers to you, the person log on this website
                    and compliant to the Company's terms and conditions. "The Company", "Ourselves", "We", "Our" and
                    "Us", refers to our Company. "Party", "Parties", or "Us", refers to both the Client and ourselves.
                    All terms refer to the offer, acceptance and consideration of payment necessary to undertake the
                    process of our assistance to the Client in the most appropriate manner for the express purpose of
                    meeting the Client's needs in respect of provision of the Company's stated services, in accordance
                    with and subject to, prevailing law of in. Any use of the above terminology or other words in the
                    singular, plural, capitalization and/or he/she or they, are taken as interchangeable and therefore
                    as referring to same.</p>
            </div>
            <div>
                <h2 style="color: var(--textGray); font-weight: 600; font-size: 1.4rem;">Cookies</h2>
                <p>We employ the use of cookies. By accessing <span style="background: rgb(244, 230, 254);">SD
                        Campus</span>, you agreed to use cookies in agreement with the <span
                        style="background: rgb(244, 230, 254);">SD Campus</span>'s Privacy Policy.</p>
            </div>
            <div>
                <p>Most interactive websites use cookies to let us retrieve the user's details for each visit. Cookies
                    are used by our website to enable the functionality of certain areas to make it easier for people
                    visiting our website. Some of our affiliate/advertising partners may also use cookies.</p>
            </div>
            <div>
                <h2 style="color: var(--textGray); font-weight: 600; font-size: 1.4rem;">License</h2>
                <p>Unless otherwise stated, <span style="background: rgb(244, 230, 254);">SD Campus</span> and/or its
                    licensors own the intellectual property rights for all material on <span
                        style="background: rgb(244, 230, 254);">SD Campus</span>. All intellectual property rights are
                    reserved. You may access this from <span style="background: rgb(244, 230, 254);">SD Campus</span>
                    for your own personal use subjected to restrictions set in these terms and conditions.</p>
                <p>You must not:</p>
                <ul>
                    <li>Republish material from <span style="background: rgb(244, 230, 254);">SD Campus</span></li>
                    <li>Sell, rent or sub-license material from <span style="background: rgb(244, 230, 254);">SD
                            Campus</span></li>
                    <li>Reproduce, duplicate or copy material from <span style="background: rgb(244, 230, 254);">SD
                            Campus</span></li>
                    <li>Redistribute content from <span style="background: rgb(244, 230, 254);">SD Campus</span></li>
                </ul>
                <p>This Agreement shall begin on the date hereof. Our Terms and Conditions were created with the help of
                    the Free Terms and Conditions Generator.</p>
                <p>Parts of this website offer an opportunity for users to post and exchange opinions and information in
                    certain areas of the website. <span style="background: rgb(244, 230, 254);">SD Campus</span> does
                    not filter, edit, publish or review Comments prior to their presence on the website. Comments do not
                    reflect the views and opinions of <span style="background: rgb(244, 230, 254);">SD Campus</span>,its
                    agents and/or affiliates. Comments reflect the views and opinions of the person who post their views
                    and opinions. To the extent permitted by applicable laws, <span
                        style="background: rgb(244, 230, 254);">SD Campus</span> shall not be liable for the Comments or
                    for any liability, damages or expenses caused and/or suffered as a result of any use of and/or
                    posting of and/or appearance of the Comments on this website.</p>
                <p><span style="background: rgb(244, 230, 254);">SD Campus</span> reserves the right to monitor all
                    Comments and to remove any Comments which can be considered inappropriate, offensive or causes
                    breach of these Terms and Conditions.</p>
                <p>You warrant and represent that:</p>
                <ul>
                    <li>You are entitled to post the Comments on our website and have all necessary licenses and
                        consents to do so;</li>
                    <li>The Comments do not invade any intellectual property right, including without limitation
                        copyright, patent or trademark of any third party;</li>
                    <li>The Comments do not contain any defamatory, libelous, offensive, indecent or otherwise unlawful
                        material which is an invasion of privacy</li>
                    <li>The Comments will not be used to solicit or promote business or custom or present commercial
                        activities or unlawful activity.</li>
                </ul>
                <p>You hereby grant <span style="background: rgb(244, 230, 254);">SD Campus</span> a non-exclusive
                    license to use, reproduce, edit and authorize others to use, reproduce and edit any of your Comments
                    in any and all forms, formats or media.</p>
            </div>
            <div>
                <h2 style="color: var(--textGray); font-weight: 600; font-size: 1.4rem;">Hyperlinking to our Content
                </h2>
                <p>The following organizations may link to our Website without prior written approval:</p>
                <ul>
                    <li>Government agencies;</li>
                    <li>Search engines;</li>
                    <li>News organizations;</li>
                    <li>Online directory distributors may link to our Website in the same manner as they hyperlink to
                        the Websites of other listed businesses;</li>
                    <li>System wide Accredited Businesses except soliciting non-profit organizations, charity shopping
                        malls, and charity fundraising groups which may not hyperlink to our Web site.</li>
                </ul>
                <p>These organizations may link to our home page, to publications or to other Website information so
                    long as the link: (a) is not in any way deceptive; (b) does not falsely imply sponsorship,
                    endorsement or approval of the linking party and its products and/or services; and (c) fits within
                    the context of the linking party's site.</p>
                <p>We may consider and approve other link requests from the following types of organizations:</p>
                <ul>
                    <li>commonly-known consumer and/or business information sources;</li>
                    <li>dot.com community sites;</li>
                    <li>associations or other groups representing charities;</li>
                    <li>online directory distributors;</li>
                    <li>internet portals;</li>
                    <li>accounting, law and consulting firms; and</li>
                    <li>educational institutions and trade associations.</li>
                </ul>
                <p>We will approve link requests from these organizations if we decide that: (a) the link would not make
                    us look unfavorably to ourselves or to our accredited businesses; (b) the organization does not have
                    any negative records with us; (c) the benefit to us from the visibility of the hyperlink compensates
                    the absence of <span style="background: rgb(244, 230, 254);">SD Campus</span>; and (d) the link is
                    in the context of general resource information.</p>
                <p>These organizations may link to our home page so long as the link: (a) is not in any way deceptive;
                    (b) does not falsely imply sponsorship, endorsement or approval of the linking party and its
                    products or services; and (c) fits within the context of the linking party's site.</p>
                <p>If you are one of the organizations listed in paragraph 2 above and are interested in linking to our
                    website, you must inform us by sending an e-mail to <span style="background: rgb(244, 230, 254);">SD
                        Campus</span>. Please include your name, your organization name, contact information as well as
                    the URL of your site, a list of any URLs from which you intend to link to our Website, and a list of
                    the URLs on our site to which you would like to link. Wait 2-3 weeks for a response.</p>
                <p>Approved organizations may hyperlink to our Website as follows:</p>
                <ul>
                    <li>By use of our corporate name; or</li>
                    <li>By use of the uniform resource locator being linked to; or</li>
                    <li>By use of any other description of our Website being linked to that makes sense within the
                        context and format of content on the linking party's site.</li>
                    <p>No use of <span style="background: rgb(244, 230, 254);">SD Campus</span>'s logo or other artwork
                        will be allowed for linking absent a trademark license agreement.</p>
                </ul>
            </div>
            <div>
                <h2 style="color: var(--textGray); font-weight: 600; font-size: 1.4rem;">iFrames</h2>
                <p>Without prior approval and written permission, you may not create frames around our Webpages that
                    alter in any way the visual presentation or appearance of our Website.</p>
            </div>
            <div>
                <h2 style="color: var(--textGray); font-weight: 600; font-size: 1.4rem;">Content Liability</h2>
                <p>We shall not be hold responsible for any content that appears on your Website. You agree to protect
                    and defend us against all claims that is rising on your Website. No link(s) should appear on any
                    Website that may be interpreted as libelous, obscene or criminal, or which infringes, otherwise
                    violates, or advocates the infringement or other violation of, any third party rights.</p>
            </div>
            <div>
                <h2 style="color: var(--textGray); font-weight: 600; font-size: 1.4rem;">Reservation of Rights</h2>
                <p>We reserve the right to request that you remove all links or any particular link to our Website. You
                    approve to immediately remove all links to our Website upon request. We also reserve the right to
                    amen these terms and conditions and it's linking policy at any time. By continuously linking to our
                    Website, you agree to be bound to and follow these linking terms and conditions.</p>
            </div>
            <div>
                <h2 style="color: var(--textGray); font-weight: 600; font-size: 1.4rem;">Removal of links from our
                    website</h2>
                <p>If you find any link on our Website that is offensive for any reason, you are free to contact and
                    inform us any moment. We will consider requests to remove links but we are not obligated to or so or
                    to respond to you directly.</p>
                <p>We do not ensure that the information on this website is correct, we do not warrant its completeness
                    or accuracy; nor do we promise to ensure that the website remains available or that the material on
                    the website is kept up to date.</p>
            </div>
            <div>
                <h2 style="color: var(--textGray); font-weight: 600; font-size: 1.4rem;">Disclaimer</h2>
                <p>To the maximum extent permitted by applicable law, we exclude all representations, warranties and
                    conditions relating to our website and the use of this website. Nothing in this disclaimer will:</p>
                <ul>
                    <li>limit or exclude our or your liability for death or personal injury;</li>
                    <li>limit or exclude our or your liability for fraud or fraudulent misrepresentation;</li>
                    <li>limit any of our or your liabilities in any way that is not permitted under applicable law; or
                    </li>
                </ul>
                <p>The limitations and prohibitions of liability set in this Section and elsewhere in this disclaimer:
                    (a) are subject to the preceding paragraph; and (b) govern all liabilities arising under the
                    disclaimer, including liabilities arising in contract, in tort and for breach of statutory duty.</p>
                <p>including liabilities arising in contract, in tort and for breach of statutory duty. As long as the
                    website and the information and services on the website are provided free of charge, we will not be
                    liable for any loss or damage of any nature.</p>
            </div>
        </div>
    </div>
</div>""",
  "privacyPolicy": """<div class="privacy_policy">
    <div class="contentWrapper">
        <div class="privacy_policy_wrapper">
            <div class="privacy_policy_header">
                <h1>Privacy Policy</h1>
                <p>Last updated: May 2, 2024</p>
                <p>This Privacy Policy describes Our policies and procedures on the collection, use and disclosure of
                    Your information when You use the Service and tells You about Your privacy rights and how the law
                    protects You.</p>
                <p>We use Your Personal data to provide and improve the Service. By using the Service, You agree to the
                    collection and use of information in accordance with this Privacy Policy. </p>
                <div class="definition">
                    <h2>Interpretation and Definitions </h2>
                    <h3>Interpretation</h3>
                    <p> The words of which the initial letter is capitalized have meanings defined under the following
                        conditions. The following definitions shall have the same meaning regardless of whether they
                        appear in singular or in plural.</p>
                    <h3>Definitions</h3>
                    <p> For the purposes of this Privacy Policy:</p>
                    <p><span>Account</span> means a unique account created for You to access our Service or parts of our
                        Service.</p>
                    <p><span>Affiliate</span> means an entity that controls, is controlled by or is under common control
                        with a party, where "control" means ownership of 50% or more of the shares, equity interest or
                        other securities entitled to vote for election of directors or other managing authority.</p>
                    <p><span>Application</span> refers to SD Campus, the software program provided by the Company.</p>
                    <p> <span>Company</span> (referred to as either "the Company", "We", "Us" or "Our" in this
                        Agreement) refers to SD Campus, Plot No-16, Block 7, Sector 5, Rajendra Nagar, Ghaziabad, Uttar
                        Pradesh 201005.</p>
                    <p><span>Country</span> refers to: Uttar Pradesh, India</p>
                    <p><span>Device</span> means any device that can access the Service such as a computer, a cellphone
                        or a digital tablet.</p>
                    <p><span>Personal</span> Data is any information that relates to an identified or identifiable
                        individual.</p>
                    <p> <span>Service</span> refers to the Application.</p>
                    <p><span>Service</span> Provider means any natural or legal person who processes the data on behalf
                        of the Company. It refers to third-party companies or individuals employed by the Company to
                        facilitate the Service, to provide the Service on behalf of the Company, to perform services
                        related to the Service or to assist the Company in analyzing how the Service is used.</p>
                    <p> <span>Usage Data</span> refers to data collected automatically, either generated by the use of
                        the Service or from the Service infrastructure itself (for example, the duration of a page
                        visit).</p>
                    <p><span>You</span> means the individual accessing or using the Service, or the company, or other
                        legal entity on behalf of which such individual is accessing or using the Service, as
                        applicable.</p>
                </div>
                <div class="personal_data">
                    <h2>Collecting and Using Your Personal Data</h2>
                    <h3>Types of Data Collected</h3>
                    <h4> Personal Data</h4>
                    <p>We collect certain information about You to help us serve You better. The information collected
                        by Us is of the following nature:</p>
                    <p>
                    <ul>
                        <li>1. Name</li>
                        <li>2. Telephone Number</li>
                        <li>3. Email Address</li>
                        <li>4. Service Address</li>
                        <li>5. Other information about the service address which You give Us</li>
                        <li>6. Information about your device</li>
                        <li>7. Your IP address</li>
                        <li>8. Network information</li>
                        <li>9. User uploaded photo</li>
                        <li>10. Demographic information such as postcode, preferences and interests</li>
                        <li>11. Any other personal information which you give us in connection while booking a service
                            or is relevant to customer surveys and/or offers.</li>
                    </ul>
                    </p>
                    <h4>Usage Data</h4>
                    <p>Usage Data is collected automatically when using the Service.</p>
                    <p> Usage Data may include information such as Your Device's Internet Protocol address (e.g. IP
                        address), browser type, browser version, the pages of our Service that You visit, the time and
                        date of Your visit, the time spent on those pages, unique device identifiers and other
                        diagnostic data.</p>
                    <p>When You access the Service by or through a mobile device, We may collect certain information
                        automatically, including, but not limited to, the type of mobile device You use, Your mobile
                        device unique ID, the IP address of Your mobile device, Your mobile operating system, the type
                        of mobile Internet browser You use, unique device identifiers and other diagnostic data.</p>
                    <p> We may also collect information that Your browser sends whenever You visit our Service or when
                        You access the Service by or through a mobile device.</p>
                    <h4>Information Collected while Using the Application</h4>
                    <p> While using Our Application, in order to provide features of Our Application, We may collect,
                        with Your prior permission:</p>
                    <p> Information regarding your location </p>
                    <p> We use this information to provide features of Our Service, to improve and customize Our
                        Service. The information may be uploaded to the Company's servers and/or a Service Provider's
                        server or it may be simply stored on Your device.</p>
                    <p> You can enable or disable access to this information at any time, through Your Device settings.
                    </p>
                    <h3>Use of Your Personal Data</h3>
                    <p>The Company may use Personal Data for the following purposes:</p>
                    <p><span>To provide and maintain our Service</span>including to monitor the usage of our Service.
                    </p>
                    <p> <span>To manage Your Account:</span> to manage Your registration as a user of the Service. The
                        Personal Data You provide can give You access to different functionalities of the Service that
                        are available to You as a registered user.</p>
                    <p> <span>For the performance of a contract:</span> the development, compliance and undertaking of
                        the purchase contract for the products, items or services You have purchased or of any other
                        contract with Us through the Service.</p>
                    <p><span>To contact You:</span>To contact You by email, telephone calls, SMS, or other equivalent
                        forms of electronic communication, such as a mobile application's push notifications regarding
                        updates or informative communications related to the functionalities, products or contracted
                        services, including the security updates, when necessary or reasonable for their implementation.
                    </p>
                    <p><span>To provide You</span> with news, special offers and general information about other goods,
                        services and events which we offer that are similar to those that you have already purchased or
                        enquired about unless You have opted not to receive such information.</p>
                    <p><span>To manage Your requests:</span> To attend and manage Your requests to Us.</p>
                    <p> <span>For business transfers:</span> We may use Your information to evaluate or conduct a
                        merger, divestiture, restructuring, reorganization, dissolution, or other sale or transfer of
                        some or all of Our assets, whether as a going concern or as part of bankruptcy, liquidation, or
                        similar proceeding, in which Personal Data held by Us about our Service users is among the
                        assets transferred.</p>
                    <p><span>For other purposes:</span> We may use Your information for other purposes, such as data
                        analysis, identifying usage trends, determining the effectiveness of our promotional campaigns
                        and to evaluate and improve our Service, products, services, marketing and your experience.</p>
                    <p> We may share Your personal information in the following situations:</p>
                    <p>• <span> With Service Providers:</span>We may share Your personal information with Service
                        Providers to monitor and analyze the use of our Service, to contact You.</p>
                    <p><span> For business transfers:</span>We may share or transfer Your personal information in
                        connection with, or during negotiations of, any merger, sale of Company assets, financing, or
                        acquisition of all or a portion of Our business to another company.</p>
                    <p><span> With Affiliates:</span>We may share Your information with Our affiliates, in which case we
                        will require those affiliates to honor this Privacy Policy. Affiliates include Our parent
                        company and any other subsidiaries, joint venture partners or other companies that We control or
                        that are under common control with Us.</p>
                    <p><span>With business partners:</span> We may share Your information with Our business partners to
                        offer You certain products, services or promotions.</p>
                    <p><span>With other users:</span> when You share personal information or otherwise interact in the
                        public areas with other users, such information may be viewed by all users and may be publicly
                        distributed outside.</p>
                    <p>•<span> With Your consent:</span> We may disclose Your personal information for any other purpose
                        with Your consent.</p>
                    <h3>Retention of Your Personal Data</h3>
                    <p>The Company will retain Your Personal Data only for as long as is necessary for the purposes set
                        out in this Privacy Policy. We will retain and use Your Personal Data to the extent necessary to
                        comply with our legal obligations (for example, if we are required to retain your data to comply
                        with applicable laws), resolve disputes, and enforce our legal agreements and policies.</p>
                    <p>The Company will also retain Usage Data for internal analysis purposes. Usage Data is generally
                        retained for a shorter period of time, except when this data is used to strengthen the security
                        or to improve the functionality of Our Service, or We are legally obligated to retain this data
                        for longer time periods.</p>
                    <h3> Transfer of Your Personal Data</h3>
                    <p>Your information, including Personal Data, is processed at the Company's operating offices and in
                        any other places where the parties involved in the processing are located. It means that this
                        information may be transferred to — and maintained on — computers located outside of Your state,
                        province, country or other governmental jurisdiction where the data protection laws may differ
                        than those from Your jurisdiction.</p>
                    <p> Your consent to this Privacy Policy followed by Your submission of such information represents
                        Your agreement to that transfer.</p>
                    <p> The Company will take all steps reasonably necessary to ensure that Your data is treated
                        securely and in accordance with this Privacy Policy and no transfer of Your Personal Data will
                        take place to an organization or a country unless there are adequate controls in place including
                        the security of Your data and other personal information.</p>
                    <h3>Delete Your Personal Data</h3>
                    <p>You have the right to delete or request that We assist in deleting the Personal Data that We have
                        collected about You.</p>
                    <p>Our Service may give You the ability to delete certain information about You from within the
                        Service.</p>
                    <p> You may update, amend, or delete Your information at any time by signing in to Your Account, if
                        you have one, and visiting the account settings section that allows you to manage Your personal
                        information. You may also contact Us to request access to, correct, or delete any personal
                        information that You have provided to Us.</p>
                    <p>Please note, however, that We may need to retain certain information when we have a legal
                        obligation or lawful basis to do so. </p>
                    <h3> Disclosure of Your Personal Data</h3>
                    <h4> Business Transactions</h4>
                    <p> If the Company is involved in a merger, acquisition or asset sale, Your Personal Data may be
                        transferred. We will provide notice before Your Personal Data is transferred and becomes subject
                        to a different Privacy Policy.</p>
                    <h4>Law enforcement</h4>
                    <p>Under certain circumstances, the Company may be required to disclose Your Personal Data if
                        required to do so by law or in response to valid requests by public authorities (e.g. a court or
                        a government agency).</p>
                    <h4>Other legal requirements</h4>
                    <p> The Company may disclose Your Personal Data in the good faith belief that such action is
                        necessary to:</p>
                    <p>• <span> Comply with a legal obligation</span></p>
                    <p>• <span> Protect and defend the rights or property of the Company</span></p>
                    <p>• <span> Prevent or investigate possible wrongdoing in connection with the Service</span></p>
                    <p>• <span> Protect the personal safety of Users of the Service or the public</span></p>
                    <p>• <span> Protect against legal liability</span></p>
                    <h3>Security of Your Personal Data</h3>
                    <p>The security of Your Personal Data is important to Us, but remember that no method of
                        transmission over the Internet, or method of electronic storage is 100% secure. While We strive
                        to use commercially acceptable means to protect Your Personal Data, We cannot guarantee its
                        absolute security.</p>
                </div>
                <div class="children_policy">
                    <h2>Children's Privacy </h2>
                    <p> To register on the website/app, you must meet the Age Requirements specified hereinbelow. If you
                        are a ‘Minor’ or ‘Child’, i.e., an individual who does not meet the Age Requirements, then you
                        may not register on the website/app, and only your parent can register on your behalf, agree to
                        all website/app Terms and Another part of our priority is adding protection for children while
                        using the internet. We encourage parents and guardians to observe, participate in, and/or
                        monitor and guide their online activity. app does not knowingly collect any Personal
                        Identifiable Information from children under the age of 13. If you think that your child
                        provided this kind of information on our website/app, we strongly encourage you to contact us
                        immediately and we will do our best efforts to promptly remove such information from our
                        records. If you are a parent / legal guardian and you are aware that your child has provided us
                        with personal information without your consent, please contact us at info@sdempire.co.in If your
                        Child faces bullying, abuse or harassment while availing our Services, please contact us at
                        info@sdempire.co.in</p>
                    <p>If We need to rely on consent as a legal basis for processing Your information and Your country
                        requires consent from a parent, We may require Your parent's consent before We collect and use
                        that information.</p>
                </div>
                <div class="links">
                    <h2> Links to Other Websites </h2>
                    <p>Our Service may contain links to other websites that are not operated by Us. If You click on a
                        third party link, You will be directed to that third party's site. We strongly advise You to
                        review the Privacy Policy of every site You visit.</p>
                    <p>We have no control over and assume no responsibility for the content, privacy policies or
                        practices of any third party sites or services.</p>
                </div>
                <div class="dnd">
                    <h2>DND (Do Not Disturb) / NDNC (National Do Not Call)</h2>
                    <p>By using the Website and/or registering yourself at sdcampus.com you authorize us to contact you
                        via email or phone call or sms and offer you our services, imparting product knowledge, offer
                        promotional offers running on website &amp; offers offered by the associated third parties, for
                        which reasons, personally identifiable information may be collected. And irrespective of the
                        fact if you have also registered yourself under DND or DNC or NCPR service, you still authorize
                        us to give you a call from sdcampus.com for the above mentioned purposes till 365 days of your
                        registration with us.</p>
                </div>
                <div class="refund_policy">
                    <h2>Refund Policy</h2>
                    <p>At SD Campus, we want our customers to be fully satisfied with their purchases. However, we do
                        have a no refund policy for most products and services.</p>
                    <p><strong>Online Batches and Other Services</strong></p>
                    <p> All online batches, coaching services, and other intangible products are non-refundable after
                        purchase. We do not provide refunds on these services.</p>
                    <p><strong>Physical Products</strong></p>
                    <p> Physical products like books and accessories are eligible for refund or replacement only if:</p>
                    <ul>
                        <li>The item received is damaged or defective. A replacement will be provided.</li>
                        <li>The item is lost by the courier partner during transit. A replacement or refund will be
                            provided.</li>
                        <li> If you receive a wrong or damaged product, please contact our customer support team within
                            7 days along with order details and images. We will evaluate and provide a resolution.</li>
                    </ul>
                    <p><strong>Incorrect Purchases</strong></p>
                    <p> If you purchase a product or batch by mistake, you can request to change it to another batch or
                        product of the same value. This change request must be made within 10 days of the original
                        purchase.</p>
                    <p><strong>Changes/Cancellations</strong></p>
                    <p> We do not provide refunds if you change your mind or wish to cancel an order after purchase.
                        Please review products carefully before ordering.</p>
                    <p>We hope this refund policy provides clarity to our customers. Please reach out with any other
                        questions. We aim to resolve any issues to your satisfaction.</p>
                </div>
                <div class="changes">
                    <h2>Changes to this Privacy Policy</h2>
                    <p>We may update Our Privacy Policy from time to time. We will notify You of any changes by posting
                        the new Privacy Policy on this page.</p>
                    <p>We will let You know via email and/or a prominent notice on Our Service, prior to the change
                        becoming effective and update the "Last updated" date at the top of this Privacy Policy.</p>
                    <p> You are advised to review this Privacy Policy periodically for any changes. Changes to this
                        Privacy Policy are effective when they are posted on this page.</p>
                </div>
                <div class="contact_us">
                    <h3> Contact Us</h3>
                    <p>If you have any questions about this Privacy Policy, You can contact us:</p>
                    <p>By email: <a href="mailto:contact@sdempire.co.in">contact@sdempire.co.in</a></p>
                    <p>By visiting this page on our website:<a href="https://www.sdcampus.com/">
                            https://www.sdcampus.com/</a></p>
                    <p>By phone number: <a href="tel:+917428394519">+917428394519</a></p>
                </div>
            </div>
        </div>
    </div>
</div> """,
  "scolarshipGuidelines": jsonEncode([
    {
      "heading": "Only one attempt allowed",
      "description": "Test Once started can’t be  stopped| restarted.",
    },
    {
      "heading": "Complete the test in one go",
      "description": "The timer will still be running if you close the test App or pause the test",
    },
    {
      "heading": "Complete before the deadline",
      "description": "Test must be submitted on or before the submission deadline.",
    },
    {
      "heading": "Steady internet required",
      "description": "Please keep the  internet connection on for smooth functioning of the test.",
    },
  ]),
  "new_policy": jsonEncode({
    "chat_policy": "Privacy Policy Last updated: May 2, 2024 This Privacy Policy describes Our policies and procedures on the collection, use and disclosure of Your information when You use the Service and tells You about Your privacy rights and how the law protects You. We use Your Personal data to provide and improve the Service. By using the Service, You agree to the collection and use of information in accordance with this Privacy Policy. Interpretation and Definitions Interpretation The words of which the initial letter is capitalized have meanings defined under the following conditions. The following definitions shall have the same meaning regardless of whether they appear in singular or in plural. Definitions"
  }),
  "features": jsonEncode({
    "sidebar": [
      {
        "enum": "our_results",
        "title": "Our Results",
        "icon": "<svg width='16' height='16' viewBox='0 0 16 16' fill='none' xmlns='http://www.w3.org/2000/svg'><path d='M3.74835 7.51912L4.78475 6.45246L7.24116 8.90886L7.2625 8.9302V8.90003V0.5125H8.73745V8.90003V8.9302L8.75879 8.90886L11.2152 6.45246L12.2516 7.51912L7.99997 11.7707L3.74835 7.51912ZM2.3077 15.4875C1.80581 15.4875 1.38144 15.3137 1.03384 14.9661C0.686236 14.6185 0.5125 14.1941 0.5125 13.6923V10.9932H1.98747V13.6923C1.98747 13.7731 2.02129 13.8467 2.08728 13.9127C2.1533 13.9787 2.22687 14.0125 2.3077 14.0125H13.6922C13.7731 14.0125 13.8467 13.9787 13.9127 13.9127C13.9787 13.8467 14.0125 13.7731 14.0125 13.6923V10.9932H15.4875V13.6923C15.4875 14.1941 15.3137 14.6185 14.9661 14.9661C14.6185 15.3137 14.1941 15.4875 13.6922 15.4875H2.3077Z' fill='#333333' stroke='#333333' stroke-width='0.025'/></svg>",
        "isEnabled": true,
        "isNew": false,
      },
      {
        "enum": "myDownloads",
        "title": "My Downloads",
        "icon": "<svg width='16' height='16' viewBox='0 0 16 16' fill='none' xmlns='http://www.w3.org/2000/svg'><path d='M3.74835 7.51912L4.78475 6.45246L7.24116 8.90886L7.2625 8.9302V8.90003V0.5125H8.73745V8.90003V8.9302L8.75879 8.90886L11.2152 6.45246L12.2516 7.51912L7.99997 11.7707L3.74835 7.51912ZM2.3077 15.4875C1.80581 15.4875 1.38144 15.3137 1.03384 14.9661C0.686236 14.6185 0.5125 14.1941 0.5125 13.6923V10.9932H1.98747V13.6923C1.98747 13.7731 2.02129 13.8467 2.08728 13.9127C2.1533 13.9787 2.22687 14.0125 2.3077 14.0125H13.6922C13.7731 14.0125 13.8467 13.9787 13.9127 13.9127C13.9787 13.8467 14.0125 13.7731 14.0125 13.6923V10.9932H15.4875V13.6923C15.4875 14.1941 15.3137 14.6185 14.9661 14.9661C14.6185 15.3137 14.1941 15.4875 13.6922 15.4875H2.3077Z' fill='#333333' stroke='#333333' stroke-width='0.025'/></svg>",
        "isEnabled": true,
        "isNew": false,
      },
      {
        "enum": "myorders",
        "title": "My Orders",
        "icon": "<svg width='16' height='20' viewBox='0 0 16 20' fill='none' xmlns='http://www.w3.org/2000/svg'><path d='M2.30775 19.5C1.80258 19.5 1.375 19.325 1.025 18.975C0.675 18.625 0.5 18.1974 0.5 17.6923V6.30775C0.5 5.80258 0.675 5.375 1.025 5.025C1.375 4.675 1.80258 4.5 2.30775 4.5H4.25V4.25C4.25 3.21417 4.616 2.33017 5.348 1.598C6.08017 0.866 6.96417 0.5 8 0.5C9.03583 0.5 9.91983 0.866 10.652 1.598C11.384 2.33017 11.75 3.21417 11.75 4.25V4.5H13.6923C14.1974 4.5 14.625 4.675 14.975 5.025C15.325 5.375 15.5 5.80258 15.5 6.30775V17.6923C15.5 18.1974 15.325 18.625 14.975 18.975C14.625 19.325 14.1974 19.5 13.6923 19.5H2.30775ZM2.30775 18H13.6923C13.7692 18 13.8398 17.9679 13.9038 17.9038C13.9679 17.8398 14 17.7693 14 17.6923V6.30775C14 6.23075 13.9679 6.16025 13.9038 6.09625C13.8398 6.03208 13.7692 6 13.6923 6H11.75V8.25C11.75 8.46283 11.6782 8.641 11.5345 8.7845C11.391 8.92817 11.2128 9 11 9C10.7872 9 10.609 8.92817 10.4655 8.7845C10.3218 8.641 10.25 8.46283 10.25 8.25V6H5.75V8.25C5.75 8.46283 5.67817 8.641 5.5345 8.7845C5.391 8.92817 5.21283 9 5 9C4.78717 9 4.609 8.92817 4.4655 8.7845C4.32183 8.641 4.25 8.46283 4.25 8.25V6H2.30775C2.23075 6 2.16025 6.03208 2.09625 6.09625C2.03208 6.16025 2 6.23075 2 6.30775V17.6923C2 17.7693 2.03208 17.8398 2.09625 17.9038C2.16025 17.9679 2.23075 18 2.30775 18ZM5.75 4.5H10.25V4.25C10.25 3.62317 10.0317 3.09142 9.59525 2.65475C9.15875 2.21825 8.627 2 8 2C7.373 2 6.84125 2.21825 6.40475 2.65475C5.96825 3.09142 5.75 3.62317 5.75 4.25V4.5Z' fill='#333333'/></svg>",
        "isEnabled": true,
        "isNew": false,
      },
      {
        "enum": "shortLearning",
        "title": "Short Learning",
        "icon": "<svg width='20' height='21' viewBox='0 0 20 21' fill='none' xmlns='http://www.w3.org/2000/svg'><path d='M8.64625 18C8.72058 18.2563 8.82283 18.5173 8.953 18.7828C9.083 19.0481 9.2205 19.2872 9.3655 19.5H2.30775C1.80258 19.5 1.375 19.325 1.025 18.975C0.675 18.625 0.5 18.1974 0.5 17.6923V2.30775C0.5 1.80258 0.675 1.375 1.025 1.025C1.375 0.675 1.80258 0.5 2.30775 0.5H13.6923C14.1974 0.5 14.625 0.675 14.975 1.025C15.325 1.375 15.5 1.80258 15.5 2.30775V9.41725C15.2768 9.39042 15.0268 9.377 14.75 9.377C14.473 9.377 14.223 9.39042 14 9.41725V2.30775C14 2.23075 13.9679 2.16025 13.9038 2.09625C13.8398 2.03208 13.7692 2 13.6923 2H8.75V8.596L6.5 7.25L4.25 8.596V2H2.30775C2.23075 2 2.16025 2.03208 2.09625 2.09625C2.03208 2.16025 2 2.23075 2 2.30775V17.6923C2 17.7693 2.03208 17.8398 2.09625 17.9038C2.16025 17.9679 2.23075 18 2.30775 18H8.64625ZM14.75 20.346C13.5013 20.346 12.4392 19.9083 11.5635 19.0328C10.6878 18.1571 10.25 17.0949 10.25 15.8462C10.25 14.5974 10.6878 13.5353 11.5635 12.6598C12.4392 11.7841 13.5013 11.3463 14.75 11.3463C15.9987 11.3463 17.0608 11.7841 17.9365 12.6598C18.8122 13.5353 19.25 14.5974 19.25 15.8462C19.25 17.0949 18.8122 18.1571 17.9365 19.0328C17.0608 19.9083 15.9987 20.346 14.75 20.346ZM13.6923 18.0385L17.0578 15.827L13.6923 13.6155V18.0385ZM8.64625 2H2H14H8.25H8.64625Z' fill='#333333'/></svg>",
        "isEnabled": true,
        "isNew": true,
      },
      {
        "enum": "bookMarks",
        "title": "All Bookmarks",
        "icon": "<svg width='14' height='18' viewBox='0 0 14 18' fill='none' xmlns='http://www.w3.org/2000/svg'><path d='M0.5 17.2461V2.30384C0.5 1.79868 0.675 1.37109 1.025 1.02109C1.375 0.671094 1.80258 0.496094 2.30775 0.496094H11.6922C12.1974 0.496094 12.625 0.671094 12.975 1.02109C13.325 1.37109 13.5 1.79868 13.5 2.30384V17.2461L7 14.4576L0.5 17.2461ZM2 14.9461L7 12.7961L12 14.9461V2.30384C12 2.22684 11.9679 2.15634 11.9037 2.09234C11.8397 2.02818 11.7692 1.99609 11.6922 1.99609H2.30775C2.23075 1.99609 2.16025 2.02818 2.09625 2.09234C2.03208 2.15634 2 2.22684 2 2.30384V14.9461Z' fill='#333333'/></svg>",
        "isEnabled": true,
        "isNew": false,
      },
      {
        "enum": "mySchedule",
        "title": "My Schedule",
        "icon": "<svg width='18' height='20' viewBox='0 0 18 20' fill='none' xmlns='http://www.w3.org/2000/svg'><path d='M3.69233 0.372266H3.67983V0.384766V2.48764H2.3077C1.79933 2.48764 1.36856 2.6639 1.01616 3.0163C0.663764 3.3687 0.4875 3.79947 0.4875 4.30784V17.6924C0.4875 18.2008 0.663764 18.6315 1.01616 18.9839C1.36856 19.3363 1.79933 19.5126 2.3077 19.5126H15.6923C16.2006 19.5126 16.6314 19.3363 16.9838 18.9839C17.3362 18.6315 17.5125 18.2008 17.5125 17.6924V4.30784C17.5125 3.79947 17.3362 3.3687 16.9838 3.0163C16.6314 2.6639 16.2006 2.48764 15.6923 2.48764H14.3201V0.384766V0.372266H14.3076H12.8077H12.7952V0.384766V2.48764H5.24325V0.384766V0.372266H5.23075H3.69233ZM15.895 17.8951C15.8328 17.9573 15.7653 17.9876 15.6923 17.9876H2.3077C2.23467 17.9876 2.16719 17.9573 2.10496 17.8951C2.04276 17.8329 2.01248 17.7654 2.01248 17.6924V8.32034H15.9875V17.6924C15.9875 17.7654 15.9572 17.8329 15.895 17.8951ZM15.9875 6.79537H2.01248V4.30784C2.01248 4.23481 2.04276 4.16733 2.10496 4.1051L2.10496 4.10511C2.16719 4.0429 2.23467 4.01262 2.3077 4.01262H15.6923C15.7653 4.01262 15.8328 4.0429 15.895 4.1051C15.9572 4.16733 15.9875 4.23481 15.9875 4.30784V6.79537ZM8.36519 11.8272C8.53998 12.002 8.75181 12.0895 8.99998 12.0895C9.24814 12.0895 9.45998 12.002 9.63476 11.8272C9.80955 11.6524 9.89707 11.4406 9.89707 11.1924C9.89707 10.9443 9.80955 10.7324 9.63476 10.5577C9.45998 10.3829 9.24814 10.2953 8.99998 10.2953C8.75181 10.2953 8.53998 10.3829 8.36519 10.5577C8.1904 10.7324 8.10288 10.9443 8.10288 11.1924C8.10288 11.4406 8.1904 11.6524 8.36519 11.8272ZM4.36519 11.8272C4.53998 12.002 4.75181 12.0895 4.99998 12.0895C5.24814 12.0895 5.45998 12.002 5.63476 11.8272C5.80955 11.6524 5.89708 11.4406 5.89708 11.1924C5.89708 10.9443 5.80955 10.7324 5.63476 10.5577C5.45998 10.3829 5.24814 10.2953 4.99998 10.2953C4.75181 10.2953 4.53998 10.3829 4.36519 10.5577C4.1904 10.7324 4.10287 10.9443 4.10287 11.1924C4.10287 11.4406 4.1904 11.6524 4.36519 11.8272ZM12.3652 11.8272C12.54 12.002 12.7518 12.0895 13 12.0895C13.2481 12.0895 13.46 12.002 13.6348 11.8272C13.8096 11.6524 13.8971 11.4406 13.8971 11.1924C13.8971 10.9443 13.8096 10.7324 13.6348 10.5577C13.46 10.3829 13.2481 10.2953 13 10.2953C12.7518 10.2953 12.54 10.3829 12.3652 10.5577C12.1904 10.7324 12.1029 10.9443 12.1029 11.1924C12.1029 11.4406 12.1904 11.6524 12.3652 11.8272ZM8.36519 15.7503C8.53998 15.9251 8.75181 16.0126 8.99998 16.0126C9.24814 16.0126 9.45998 15.9251 9.63476 15.7503C9.80955 15.5755 9.89707 15.3637 9.89707 15.1155C9.89707 14.8673 9.80955 14.6555 9.63476 14.4807C9.45998 14.3059 9.24814 14.2184 8.99998 14.2184C8.75181 14.2184 8.53998 14.3059 8.36519 14.4807C8.1904 14.6555 8.10288 14.8673 8.10288 15.1155C8.10288 15.3637 8.1904 15.5755 8.36519 15.7503ZM4.36519 15.7503C4.53998 15.9251 4.75181 16.0126 4.99998 16.0126C5.24814 16.0126 5.45998 15.9251 5.63476 15.7503C5.80955 15.5755 5.89708 15.3637 5.89708 15.1155C5.89708 14.8673 5.80955 14.6555 5.63476 14.4807C5.45998 14.3059 5.24814 14.2184 4.99998 14.2184C4.75181 14.2184 4.53997 14.3059 4.36519 14.4807C4.1904 14.6555 4.10287 14.8673 4.10287 15.1155C4.10287 15.3637 4.1904 15.5755 4.36519 15.7503ZM12.3652 15.7503C12.54 15.9251 12.7518 16.0126 13 16.0126C13.2481 16.0126 13.46 15.9251 13.6348 15.7503C13.8096 15.5755 13.8971 15.3637 13.8971 15.1155C13.8971 14.8673 13.8096 14.6555 13.6348 14.4807C13.46 14.3059 13.2481 14.2184 13 14.2184C12.7518 14.2184 12.54 14.3059 12.3652 14.4807C12.1904 14.6555 12.1029 14.8673 12.1029 15.1155C12.1029 15.3637 12.1904 15.5755 12.3652 15.7503Z' fill='#333333' stroke='#333333' stroke-width='0.025'/></svg>",
        "isEnabled": true,
        "isNew": false,
      },
      {
        "enum": "ourResult",
        "title": "Our Result",
        "icon": "<svg width='24' height='24' viewBox='0 0 24 24' fill='none' xmlns='http://www.w3.org/2000/svg'><path d='M9 5.5C9 5.36739 9.05268 5.24021 9.14645 5.14645C9.24021 5.05268 9.36739 5 9.5 5H14.5C14.6326 5 14.7598 5.05268 14.8536 5.14645C14.9473 5.24021 15 5.36739 15 5.5C15 5.63261 14.9473 5.75979 14.8536 5.85355C14.7598 5.94732 14.6326 6 14.5 6H9.5C9.36739 6 9.24021 5.94732 9.14645 5.85355C9.05268 5.75979 9 5.63261 9 5.5ZM7.5 8C7.36739 8 7.24021 8.05268 7.14645 8.14645C7.05268 8.24021 7 8.36739 7 8.5C7 8.63261 7.05268 8.75979 7.14645 8.85355C7.24021 8.94732 7.36739 9 7.5 9H16.5C16.6326 9 16.7598 8.94732 16.8536 8.85355C16.9473 8.75979 17 8.63261 17 8.5C17 8.36739 16.9473 8.24021 16.8536 8.14645C16.7598 8.05268 16.6326 8 16.5 8H7.5ZM7 10.5C7 10.3674 7.05268 10.2402 7.14645 10.1464C7.24021 10.0527 7.36739 10 7.5 10H16.5C16.6326 10 16.7598 10.0527 16.8536 10.1464C16.9473 10.2402 17 10.3674 17 10.5C17 10.6326 16.9473 10.7598 16.8536 10.8536C16.7598 10.9473 16.6326 11 16.5 11H7.5C7.36739 11 7.24021 10.9473 7.14645 10.8536C7.05268 10.7598 7 10.6326 7 10.5ZM7.5 12C7.36739 12 7.24021 12.0527 7.14645 12.1464C7.05268 12.2402 7 12.3674 7 12.5C7 12.6326 7.05268 12.7598 7.14645 12.8536C7.24021 12.9473 7.36739 13 7.5 13H16.5C16.6326 13 16.7598 12.9473 16.8536 12.8536C16.9473 12.7598 17 12.6326 17 12.5C17 12.3674 16.9473 12.2402 16.8536 12.1464C16.7598 12.0527 16.6326 12 16.5 12H7.5Z' fill='#333333'/><path fill-rule='evenodd' clip-rule='evenodd' d='M19 18C19 18.5304 18.7893 19.0391 18.4142 19.4142C18.0391 19.7893 17.5304 20 17 20H15.5V22L14 21.25L12.5 22V20H7C6.46957 20 5.96086 19.7893 5.58579 19.4142C5.21071 19.0391 5 18.5304 5 18V4C5 3.46957 5.21071 2.96086 5.58579 2.58579C5.96086 2.21071 6.46957 2 7 2H17C17.5304 2 18.0391 2.21071 18.4142 2.58579C18.7893 2.96086 19 3.46957 19 4V18ZM7 3C6.73478 3 6.48043 3.10536 6.29289 3.29289C6.10536 3.48043 6 3.73478 6 4V18C6 18.2652 6.10536 18.5196 6.29289 18.7071C6.48043 18.8946 6.73478 19 7 19H12.5V17.823C12.2454 17.5343 12.0795 17.1783 12.0223 16.7977C11.965 16.4171 12.0188 16.0281 12.1771 15.6772C12.3355 15.3264 12.5917 15.0288 12.915 14.82C13.2384 14.6112 13.6151 14.5001 14 14.5001C14.3849 14.5001 14.7616 14.6112 15.085 14.82C15.4083 15.0288 15.6645 15.3264 15.8229 15.6772C15.9812 16.0281 16.035 16.4171 15.9777 16.7977C15.9205 17.1783 15.7546 17.5343 15.5 17.823V19H17C17.2652 19 17.5196 18.8946 17.7071 18.7071C17.8946 18.5196 18 18.2652 18 18V4C18 3.73478 17.8946 3.48043 17.7071 3.29289C17.5196 3.10536 17.2652 3 17 3H7ZM14.5 18.437C14.172 18.5217 13.828 18.5217 13.5 18.437V20.382L14 20.132L14.5 20.382V18.437ZM14 17.5C14.2652 17.5 14.5196 17.3946 14.7071 17.2071C14.8946 17.0196 15 16.7652 15 16.5C15 16.2348 14.8946 15.9804 14.7071 15.7929C14.5196 15.6054 14.2652 15.5 14 15.5C13.7348 15.5 13.4804 15.6054 13.2929 15.7929C13.1054 15.9804 13 16.2348 13 16.5C13 16.7652 13.1054 17.0196 13.2929 17.2071C13.4804 17.3946 13.7348 17.5 14 17.5Z' fill='#333333'/></svg>",
        "isEnabled": false,
        "isNew": false,
      },
      {
        "enum": "dailyNews",
        "title": "Daily News",
        "icon": "<svg width='20' height='20' viewBox='0 0 20 20' fill='none' xmlns='http://www.w3.org/2000/svg'><path d='M5.50011 17.6919V7.29187C5.50011 6.79321 5.67928 6.36987 6.03761 6.02187C6.39594 5.67371 6.82444 5.49962 7.32311 5.49962H17.6924C18.191 5.49962 18.617 5.67621 18.9704 6.02937C19.3235 6.38271 19.5001 6.80871 19.5001 7.30737V14.7881L14.7886 19.4996H7.30786C6.80919 19.4996 6.38319 19.323 6.02986 18.9699C5.67669 18.6165 5.50011 18.1905 5.50011 17.6919ZM0.525111 4.42262C0.431611 3.92396 0.528778 3.47462 0.816611 3.07462C1.10428 2.67462 1.49753 2.42787 1.99636 2.33437L12.2309 0.524623C12.7295 0.431123 13.1789 0.528289 13.5789 0.816122C13.9789 1.10379 14.2257 1.49704 14.3194 1.99587L14.5501 3.30737H13.0194L12.8251 2.21112C12.8123 2.14062 12.7738 2.08454 12.7096 2.04287C12.6456 2.00121 12.5751 1.98679 12.4981 1.99962L2.25986 3.81887C2.17003 3.83171 2.10269 3.87337 2.05786 3.94387C2.01303 4.01437 1.99694 4.09454 2.00961 4.18437L3.30786 11.5171V15.9726C3.06036 15.842 2.84878 15.6628 2.67311 15.4351C2.49761 15.2076 2.38486 14.9484 2.33486 14.6574L0.525111 4.42262ZM7.00011 7.30737V17.6919C7.00011 17.7817 7.02894 17.8555 7.08661 17.9131C7.14428 17.9708 7.21803 17.9996 7.30786 17.9996H14.0001V13.9996H18.0001V7.30737C18.0001 7.21754 17.9713 7.14379 17.9136 7.08612C17.8559 7.02846 17.7822 6.99962 17.6924 6.99962H7.30786C7.21803 6.99962 7.14428 7.02846 7.08661 7.08612C7.02894 7.14379 7.00011 7.21754 7.00011 7.30737Z' fill='#333333'/></svg>",
        "isEnabled": true,
        "isNew": false,
      },
      {
        "enum": "about",
        "title": "About Us",
        "icon": "<svg width='20' height='20' viewBox='0 0 20 20' fill='none' xmlns='http://www.w3.org/2000/svg'><path d='M9.25 14.75H10.75V9H9.25V14.75ZM10 7.2885C10.2288 7.2885 10.4207 7.21108 10.5755 7.05625C10.7303 6.90142 10.8077 6.70958 10.8077 6.48075C10.8077 6.25192 10.7303 6.06008 10.5755 5.90525C10.4207 5.75058 10.2288 5.67325 10 5.67325C9.77117 5.67325 9.57933 5.75058 9.4245 5.90525C9.26967 6.06008 9.19225 6.25192 9.19225 6.48075C9.19225 6.70958 9.26967 6.90142 9.4245 7.05625C9.57933 7.21108 9.77117 7.2885 10 7.2885ZM10.0017 19.5C8.68775 19.5 7.45267 19.2507 6.2965 18.752C5.14033 18.2533 4.13467 17.5766 3.2795 16.7218C2.42433 15.8669 1.74725 14.8617 1.24825 13.706C0.749417 12.5503 0.5 11.3156 0.5 10.0017C0.5 8.68775 0.749333 7.45267 1.248 6.2965C1.74667 5.14033 2.42342 4.13467 3.27825 3.2795C4.13308 2.42433 5.13833 1.74725 6.294 1.24825C7.44967 0.749417 8.68442 0.5 9.99825 0.5C11.3123 0.5 12.5473 0.749333 13.7035 1.248C14.8597 1.74667 15.8653 2.42342 16.7205 3.27825C17.5757 4.13308 18.2528 5.13833 18.7518 6.294C19.2506 7.44967 19.5 8.68442 19.5 9.99825C19.5 11.3123 19.2507 12.5473 18.752 13.7035C18.2533 14.8597 17.5766 15.8653 16.7218 16.7205C15.8669 17.5757 14.8617 18.2528 13.706 18.7518C12.5503 19.2506 11.3156 19.5 10.0017 19.5ZM10 18C12.2333 18 14.125 17.225 15.675 15.675C17.225 14.125 18 12.2333 18 10C18 7.76667 17.225 5.875 15.675 4.325C14.125 2.775 12.2333 2 10 2C7.76667 2 5.875 2.775 4.325 4.325C2.775 5.875 2 7.76667 2 10C2 12.2333 2.775 14.125 4.325 15.675C5.875 17.225 7.76667 18 10 18Z' fill='#333333'/></svg>",
        "isEnabled": true,
        "isNew": false,
      },
      {
        "enum": "referandEarn",
        "title": "Refer and Earn",
        "icon": "<svg width='20' height='20' viewBox='0 0 20 20' fill='none' xmlns='http://www.w3.org/2000/svg'><path d='M11.4672 15.3943H13.3095L13.3193 15.3193L9.31925 11.0483L9.34425 10.975H9.59425C10.5328 10.975 11.3042 10.7128 11.9087 10.1885C12.5131 9.66417 12.8692 9.00967 12.977 8.225H13.9578V7.23275H12.9505C12.9015 6.93142 12.8032 6.65225 12.6557 6.39525C12.5082 6.13808 12.3237 5.90117 12.102 5.6845H13.9578V4.69225H6.04225V5.8385H9.5865C10.1288 5.8385 10.5743 5.96608 10.923 6.22125C11.2718 6.47625 11.4962 6.81342 11.5962 7.23275H6.04225V8.225H11.6212C11.5341 8.68017 11.3119 9.051 10.9548 9.3375C10.5977 9.624 10.1263 9.76725 9.54025 9.76725H7.4635V11.05L11.4672 15.3943ZM10.0017 19.5C8.68775 19.5 7.45267 19.2507 6.2965 18.752C5.14033 18.2533 4.13467 17.5766 3.2795 16.7218C2.42433 15.8669 1.74725 14.8617 1.24825 13.706C0.749417 12.5503 0.5 11.3156 0.5 10.0017C0.5 8.68775 0.749333 7.45267 1.248 6.2965C1.74667 5.14033 2.42342 4.13467 3.27825 3.2795C4.13308 2.42433 5.13833 1.74725 6.294 1.24825C7.44967 0.749417 8.68442 0.5 9.99825 0.5C11.3123 0.5 12.5473 0.749333 13.7035 1.248C14.8597 1.74667 15.8653 2.42342 16.7205 3.27825C17.5757 4.13308 18.2528 5.13833 18.7518 6.294C19.2506 7.44967 19.5 8.68442 19.5 9.99825C19.5 11.3123 19.2507 12.5473 18.752 13.7035C18.2533 14.8597 17.5766 15.8653 16.7218 16.7205C15.8669 17.5757 14.8617 18.2528 13.706 18.7518C12.5503 19.2506 11.3156 19.5 10.0017 19.5ZM10 18C12.2333 18 14.125 17.225 15.675 15.675C17.225 14.125 18 12.2333 18 10C18 7.76667 17.225 5.875 15.675 4.325C14.125 2.775 12.2333 2 10 2C7.76667 2 5.875 2.775 4.325 4.325C2.775 5.875 2 7.76667 2 10C2 12.2333 2.775 14.125 4.325 15.675C5.875 17.225 7.76667 18 10 18Z' fill='#333333'/></svg>",
        "isEnabled": true,
        "isNew": false,
      },
      {
        "enum": "wallet",
        "title": "Wallet",
        "icon": "<svg width='19' height='18' viewBox='0 0 19 18' fill='none' xmlns='http://www.w3.org/2000/svg'><mask id='path-1-inside-1_10_8064' fill='white'><path d='M2.3077 17.5C1.80898 17.5 1.38302 17.3233 1.02982 16.9701C0.676608 16.6169 0.5 16.191 0.5 15.6923V2.3077C0.5 1.80898 0.676608 1.38302 1.02982 1.02982C1.38302 0.676608 1.80898 0.5 2.3077 0.5H15.6923C16.191 0.5 16.6169 0.676608 16.9701 1.02982C17.3233 1.38302 17.5 1.80898 17.5 2.3077V5.02885H16V2.3077C16 2.21795 15.9711 2.14423 15.9134 2.08653C15.8557 2.02883 15.782 1.99998 15.6923 1.99998H2.3077C2.21795 1.99998 2.14423 2.02883 2.08653 2.08653C2.02883 2.14423 1.99997 2.21795 1.99997 2.3077V15.6923C1.99997 15.782 2.02883 15.8557 2.08653 15.9134C2.14423 15.9711 2.21795 16 2.3077 16H15.6923C15.782 16 15.8557 15.9711 15.9134 15.9134C15.9711 15.8557 16 15.782 16 15.6923V12.9711H17.5V15.6923C17.5 16.191 17.3233 16.6169 16.9701 16.9701C16.6169 17.3233 16.191 17.5 15.6923 17.5H2.3077ZM10.3077 13.5C9.80898 13.5 9.38303 13.3233 9.02983 12.9701C8.67661 12.6169 8.5 12.191 8.5 11.6923V6.3077C8.5 5.80898 8.67661 5.38303 9.02983 5.02983C9.38303 4.67661 9.80898 4.5 10.3077 4.5H16.6922C17.191 4.5 17.6169 4.67661 17.9701 5.02983C18.3233 5.38303 18.5 5.80898 18.5 6.3077V11.6923C18.5 12.191 18.3233 12.6169 17.9701 12.9701C17.6169 13.3233 17.191 13.5 16.6922 13.5H10.3077ZM16.6922 12C16.782 12 16.8557 11.9711 16.9134 11.9134C16.9711 11.8557 17 11.782 17 11.6923V6.3077C17 6.21795 16.9711 6.14423 16.9134 6.08653C16.8557 6.02883 16.782 5.99998 16.6922 5.99998H10.3077C10.218 5.99998 10.1442 6.02883 10.0865 6.08653C10.0288 6.14423 9.99998 6.21795 9.99998 6.3077V11.6923C9.99998 11.782 10.0288 11.8557 10.0865 11.9134C10.1442 11.9711 10.218 12 10.3077 12H16.6922ZM13 10.5C13.4166 10.5 13.7708 10.3541 14.0625 10.0625C14.3541 9.77081 14.5 9.41664 14.5 8.99998C14.5 8.58331 14.3541 8.22914 14.0625 7.93748C13.7708 7.64581 13.4166 7.49998 13 7.49998C12.5833 7.49998 12.2291 7.64581 11.9375 7.93748C11.6458 8.22914 11.5 8.58331 11.5 8.99998C11.5 9.41664 11.6458 9.77081 11.9375 10.0625C12.2291 10.3541 12.5833 10.5 13 10.5Z'/></mask><path d='M2.3077 17.5C1.80898 17.5 1.38302 17.3233 1.02982 16.9701C0.676608 16.6169 0.5 16.191 0.5 15.6923V2.3077C0.5 1.80898 0.676608 1.38302 1.02982 1.02982C1.38302 0.676608 1.80898 0.5 2.3077 0.5H15.6923C16.191 0.5 16.6169 0.676608 16.9701 1.02982C17.3233 1.38302 17.5 1.80898 17.5 2.3077V5.02885H16V2.3077C16 2.21795 15.9711 2.14423 15.9134 2.08653C15.8557 2.02883 15.782 1.99998 15.6923 1.99998H2.3077C2.21795 1.99998 2.14423 2.02883 2.08653 2.08653C2.02883 2.14423 1.99997 2.21795 1.99997 2.3077V15.6923C1.99997 15.782 2.02883 15.8557 2.08653 15.9134C2.14423 15.9711 2.21795 16 2.3077 16H15.6923C15.782 16 15.8557 15.9711 15.9134 15.9134C15.9711 15.8557 16 15.782 16 15.6923V12.9711H17.5V15.6923C17.5 16.191 17.3233 16.6169 16.9701 16.9701C16.6169 17.3233 16.191 17.5 15.6923 17.5H2.3077ZM10.3077 13.5C9.80898 13.5 9.38303 13.3233 9.02983 12.9701C8.67661 12.6169 8.5 12.191 8.5 11.6923V6.3077C8.5 5.80898 8.67661 5.38303 9.02983 5.02983C9.38303 4.67661 9.80898 4.5 10.3077 4.5H16.6922C17.191 4.5 17.6169 4.67661 17.9701 5.02983C18.3233 5.38303 18.5 5.80898 18.5 6.3077V11.6923C18.5 12.191 18.3233 12.6169 17.9701 12.9701C17.6169 13.3233 17.191 13.5 16.6922 13.5H10.3077ZM16.6922 12C16.782 12 16.8557 11.9711 16.9134 11.9134C16.9711 11.8557 17 11.782 17 11.6923V6.3077C17 6.21795 16.9711 6.14423 16.9134 6.08653C16.8557 6.02883 16.782 5.99998 16.6922 5.99998H10.3077C10.218 5.99998 10.1442 6.02883 10.0865 6.08653C10.0288 6.14423 9.99998 6.21795 9.99998 6.3077V11.6923C9.99998 11.782 10.0288 11.8557 10.0865 11.9134C10.1442 11.9711 10.218 12 10.3077 12H16.6922ZM13 10.5C13.4166 10.5 13.7708 10.3541 14.0625 10.0625C14.3541 9.77081 14.5 9.41664 14.5 8.99998C14.5 8.58331 14.3541 8.22914 14.0625 7.93748C13.7708 7.64581 13.4166 7.49998 13 7.49998C12.5833 7.49998 12.2291 7.64581 11.9375 7.93748C11.6458 8.22914 11.5 8.58331 11.5 8.99998C11.5 9.41664 11.6458 9.77081 11.9375 10.0625C12.2291 10.3541 12.5833 10.5 13 10.5Z' fill='#333333'/><path d='M2.01248 16V1.99998H1.98747V16H2.01248ZM1.02982 16.9701L1.0475 16.9524H1.0475L1.02982 16.9701ZM1.02982 1.02982L1.0475 1.0475L1.0475 1.0475L1.02982 1.02982ZM16.9701 1.02982L16.9524 1.0475V1.0475L16.9701 1.02982ZM17.5 5.02885V5.05385H17.525V5.02885H17.5ZM16 5.02885H15.975V5.05385H16V5.02885ZM16 12.9711V12.9461H15.975V12.9711H16ZM17.5 12.9711H17.525V12.9461H17.5V12.9711ZM16.9701 16.9701L16.9524 16.9524L16.9701 16.9701ZM9.02983 12.9701L9.0475 12.9524L9.0475 12.9524L9.02983 12.9701ZM9.02983 5.02983L9.0475 5.0475L9.0475 5.0475L9.02983 5.02983ZM17.9701 5.02983L17.9524 5.0475V5.0475L17.9701 5.02983ZM17.9701 12.9701L17.9524 12.9524V12.9524L17.9701 12.9701ZM2.3077 17.475C1.81563 17.475 1.39602 17.301 1.0475 16.9524L1.01215 16.9878C1.37003 17.3457 1.80234 17.525 2.3077 17.525V17.475ZM1.0475 16.9524C0.698966 16.6039 0.525 16.1843 0.525 15.6923H0.475C0.475 16.1976 0.654251 16.6299 1.01215 16.9878L1.0475 16.9524ZM0.525 15.6923V2.3077H0.475V15.6923H0.525ZM0.525 2.3077C0.525 1.81563 0.698966 1.39602 1.0475 1.0475L1.01215 1.01215C0.654251 1.37003 0.475 1.80234 0.475 2.3077H0.525ZM1.0475 1.0475C1.39602 0.698966 1.81563 0.525 2.3077 0.525V0.475C1.80234 0.475 1.37003 0.654251 1.01215 1.01215L1.0475 1.0475ZM2.3077 0.525H15.6923V0.475H2.3077V0.525ZM15.6923 0.525C16.1843 0.525 16.6039 0.698966 16.9524 1.0475L16.9878 1.01215C16.6299 0.654251 16.1976 0.475 15.6923 0.475V0.525ZM16.9524 1.0475C17.301 1.39602 17.475 1.81563 17.475 2.3077H17.525C17.525 1.80234 17.3457 1.37003 16.9878 1.01215L16.9524 1.0475ZM17.475 2.3077V5.02885H17.525V2.3077H17.475ZM17.5 5.00385H16V5.05385H17.5V5.00385ZM16.025 5.02885V2.3077H15.975V5.02885H16.025ZM16.025 2.3077C16.025 2.21205 15.994 2.13173 15.9311 2.06885L15.8957 2.1042C15.9483 2.15672 15.975 2.22385 15.975 2.3077H16.025ZM15.9311 2.06885C15.8682 2.00597 15.7879 1.97498 15.6923 1.97498V2.02498C15.7761 2.02498 15.8432 2.05168 15.8957 2.1042L15.9311 2.06885ZM15.6923 1.97498H2.3077V2.02498H15.6923V1.97498ZM2.3077 1.97498C2.21205 1.97498 2.13173 2.00597 2.06885 2.06885L2.1042 2.1042C2.15672 2.05168 2.22385 2.02498 2.3077 2.02498V1.97498ZM2.06885 2.06885C2.00597 2.13173 1.97497 2.21205 1.97497 2.3077H2.02497C2.02497 2.22385 2.05168 2.15672 2.1042 2.1042L2.06885 2.06885ZM1.97497 2.3077V15.6923H2.02497V2.3077H1.97497ZM1.97497 15.6923C1.97497 15.7879 2.00597 15.8682 2.06885 15.9311L2.1042 15.8957C2.05168 15.8432 2.02497 15.7761 2.02497 15.6923H1.97497ZM2.06885 15.9311C2.13173 15.994 2.21205 16.025 2.3077 16.025V15.975C2.22385 15.975 2.15672 15.9483 2.1042 15.8957L2.06885 15.9311ZM2.3077 16.025H15.6923V15.975H2.3077V16.025ZM15.6923 16.025C15.7879 16.025 15.8682 15.994 15.9311 15.9311L15.8957 15.8957C15.8432 15.9483 15.7761 15.975 15.6923 15.975V16.025ZM15.9311 15.9311C15.994 15.8682 16.025 15.7879 16.025 15.6923H15.975C15.975 15.7761 15.9483 15.8432 15.8957 15.8957L15.9311 15.9311ZM16.025 15.6923V12.9711H15.975V15.6923H16.025ZM16 12.9961H17.5V12.9461H16V12.9961ZM17.475 12.9711V15.6923H17.525V12.9711H17.475ZM17.475 15.6923C17.475 16.1843 17.301 16.6039 16.9524 16.9524L16.9878 16.9878C17.3457 16.6299 17.525 16.1976 17.525 15.6923H17.475ZM16.9524 16.9524C16.6039 17.301 16.1843 17.475 15.6923 17.475V17.525C16.1976 17.525 16.6299 17.3457 16.9878 16.9878L16.9524 16.9524ZM15.6923 17.475H2.3077V17.525H15.6923V17.475ZM10.3077 13.475C9.81563 13.475 9.39602 13.301 9.0475 12.9524L9.01215 12.9878C9.37003 13.3457 9.80234 13.525 10.3077 13.525V13.475ZM9.0475 12.9524C8.69897 12.6039 8.525 12.1843 8.525 11.6923H8.475C8.475 12.1976 8.65425 12.6299 9.01215 12.9878L9.0475 12.9524ZM8.525 11.6923V6.3077H8.475V11.6923H8.525ZM8.525 6.3077C8.525 5.81563 8.69897 5.39602 9.0475 5.0475L9.01215 5.01215C8.65425 5.37003 8.475 5.80234 8.475 6.3077H8.525ZM9.0475 5.0475C9.39602 4.69897 9.81563 4.525 10.3077 4.525V4.475C9.80234 4.475 9.37003 4.65425 9.01215 5.01215L9.0475 5.0475ZM10.3077 4.525H16.6922V4.475H10.3077V4.525ZM16.6922 4.525C17.1843 4.525 17.6039 4.69897 17.9524 5.0475L17.9878 5.01215C17.6299 4.65425 17.1976 4.475 16.6922 4.475V4.525ZM17.9524 5.0475C18.301 5.39602 18.475 5.81563 18.475 6.3077H18.525C18.525 5.80234 18.3457 5.37003 17.9878 5.01215L17.9524 5.0475ZM18.475 6.3077V11.6923H18.525V6.3077H18.475ZM18.475 11.6923C18.475 12.1843 18.301 12.6039 17.9524 12.9524L17.9878 12.9878C18.3457 12.6299 18.525 12.1976 18.525 11.6923H18.475ZM17.9524 12.9524C17.6039 13.301 17.1843 13.475 16.6922 13.475V13.525C17.1976 13.525 17.6299 13.3457 17.9878 12.9878L17.9524 12.9524ZM16.6922 13.475H10.3077V13.525H16.6922V13.475ZM16.6922 12.025C16.7879 12.025 16.8682 11.994 16.9311 11.9311L16.8957 11.8957C16.8432 11.9483 16.7761 11.975 16.6922 11.975V12.025ZM16.9311 11.9311C16.994 11.8682 17.025 11.7879 17.025 11.6923H16.975C16.975 11.7761 16.9483 11.8432 16.8957 11.8957L16.9311 11.9311ZM17.025 11.6923V6.3077H16.975V11.6923H17.025ZM17.025 6.3077C17.025 6.21205 16.994 6.13173 16.9311 6.06885L16.8957 6.1042C16.9483 6.15672 16.975 6.22385 16.975 6.3077H17.025ZM16.9311 6.06885C16.8682 6.00597 16.7879 5.97498 16.6922 5.97498V6.02498C16.7761 6.02498 16.8432 6.05168 16.8957 6.1042L16.9311 6.06885ZM16.6922 5.97498H10.3077V6.02498H16.6922V5.97498ZM10.3077 5.97498C10.212 5.97498 10.1317 6.00597 10.0688 6.06885L10.1042 6.1042C10.1567 6.05168 10.2239 6.02498 10.3077 6.02498V5.97498ZM10.0688 6.06885C10.006 6.13173 9.97498 6.21205 9.97498 6.3077H10.025C10.025 6.22385 10.0517 6.15672 10.1042 6.1042L10.0688 6.06885ZM9.97498 6.3077V11.6923H10.025V6.3077H9.97498ZM9.97498 11.6923C9.97498 11.7879 10.006 11.8682 10.0688 11.9311L10.1042 11.8957C10.0517 11.8432 10.025 11.7761 10.025 11.6923H9.97498ZM10.0688 11.9311C10.1317 11.994 10.212 12.025 10.3077 12.025V11.975C10.2239 11.975 10.1567 11.9483 10.1042 11.8957L10.0688 11.9311ZM10.3077 12.025H16.6922V11.975H10.3077V12.025ZM13 10.525C13.4232 10.525 13.7837 10.3766 14.0802 10.0802L14.0448 10.0448C13.7579 10.3317 13.4101 10.475 13 10.475V10.525ZM14.0802 10.0802C14.3766 9.78375 14.525 9.4232 14.525 8.99998H14.475C14.475 9.41009 14.3317 9.75787 14.0448 10.0448L14.0802 10.0802ZM14.525 8.99998C14.525 8.57675 14.3766 8.21621 14.0802 7.9198L14.0448 7.95515C14.3317 8.24208 14.475 8.58986 14.475 8.99998H14.525ZM14.0802 7.9198C13.7837 7.62339 13.4232 7.47498 13 7.47498V7.52498C13.4101 7.52498 13.7579 7.66823 14.0448 7.95515L14.0802 7.9198ZM13 7.47498C12.5768 7.47498 12.2162 7.62339 11.9198 7.9198L11.9552 7.95515C12.2421 7.66823 12.5899 7.52498 13 7.52498V7.47498ZM11.9198 7.9198C11.6234 8.21621 11.475 8.57675 11.475 8.99998H11.525C11.525 8.58986 11.6682 8.24208 11.9552 7.95515L11.9198 7.9198ZM11.475 8.99998C11.475 9.4232 11.6234 9.78375 11.9198 10.0802L11.9552 10.0448C11.6682 9.75787 11.525 9.41009 11.525 8.99998H11.475ZM11.9198 10.0802C12.2162 10.3766 12.5768 10.525 13 10.525V10.475C12.5899 10.475 12.2421 10.3317 11.9552 10.0448L11.9198 10.0802Z' fill='#333333' mask='url(#path-1-inside-1_10_8064)'/></svg>",
        "isEnabled": true,
        "isNew": false,
      },
      {
        "enum": "helpandSupport",
        "title": "Help & Support",
        "icon": "<svg width='18' height='21' viewBox='0 0 18 21' fill='none' xmlns='http://www.w3.org/2000/svg'><path d='M8.948 14.6058C9.234 14.6058 9.47533 14.5073 9.672 14.3105C9.86883 14.1137 9.96725 13.8723 9.96725 13.5865C9.96725 13.3007 9.86883 13.0593 9.672 12.8625C9.47533 12.6657 9.234 12.5673 8.948 12.5673C8.66217 12.5673 8.42083 12.6657 8.224 12.8625C8.02717 13.0593 7.92875 13.3007 7.92875 13.5865C7.92875 13.8723 8.02717 14.1137 8.224 14.3105C8.42083 14.5073 8.66217 14.6058 8.948 14.6058ZM8.2405 11.025H9.648C9.6545 10.7737 9.67183 10.5577 9.7 10.377C9.72817 10.1962 9.78392 10.0205 9.86725 9.85C9.95058 9.6795 10.0563 9.51508 10.1845 9.35675C10.3128 9.19842 10.484 9.01217 10.698 8.798C11.2302 8.266 11.6107 7.81375 11.8395 7.44125C12.0683 7.06892 12.1827 6.64558 12.1827 6.17125C12.1827 5.33908 11.8987 4.66825 11.3307 4.15875C10.7627 3.64908 10.0313 3.39425 9.1365 3.39425C8.3225 3.39425 7.62667 3.60158 7.049 4.01625C6.4715 4.43108 6.06092 4.97117 5.81725 5.6365L7.102 6.152C7.24433 5.72767 7.48083 5.38117 7.8115 5.1125C8.14233 4.84383 8.55708 4.7095 9.05575 4.7095C9.59558 4.7095 10.0171 4.856 10.3203 5.149C10.6234 5.442 10.775 5.79808 10.775 6.21725C10.775 6.52625 10.6833 6.8295 10.5 7.127C10.3167 7.42433 10.034 7.7455 9.652 8.0905C9.38783 8.32383 9.16825 8.54975 8.99325 8.76825C8.81825 8.98692 8.67242 9.21158 8.55575 9.44225C8.43908 9.67308 8.35733 9.91317 8.3105 10.1625C8.26383 10.4118 8.2405 10.6993 8.2405 11.025ZM9 20.2885L6.2115 17.5H2.30775C1.80258 17.5 1.375 17.325 1.025 16.975C0.675 16.625 0.5 16.1974 0.5 15.6923V2.30775C0.5 1.80258 0.675 1.375 1.025 1.025C1.375 0.675 1.80258 0.5 2.30775 0.5H15.6923C16.1974 0.5 16.625 0.675 16.975 1.025C17.325 1.375 17.5 1.80258 17.5 2.30775V15.6923C17.5 16.1974 17.325 16.625 16.975 16.975C16.625 17.325 16.1974 17.5 15.6923 17.5H11.7885L9 20.2885ZM2.30775 16H6.81925L9 18.1807L11.1807 16H15.6923C15.7821 16 15.8558 15.9712 15.9135 15.9135C15.9712 15.8558 16 15.7821 16 15.6923V2.30775C16 2.21792 15.9712 2.14417 15.9135 2.0865C15.8558 2.02883 15.7821 2 15.6923 2H2.30775C2.21792 2 2.14417 2.02883 2.0865 2.0865C2.02883 2.14417 2 2.21792 2 2.30775V15.6923C2 15.7821 2.02883 15.8558 2.0865 15.9135C2.14417 15.9712 2.21792 16 2.30775 16Z' fill='#333333'/></svg>",
        "isEnabled": true,
        "isNew": false,
      },
      {
        "enum": "termandSupport",
        "title": "Term and Support",
        "icon": "<svg width='18' height='20' viewBox='0 0 18 20' fill='none' xmlns='http://www.w3.org/2000/svg'><path d='M7.58075 14.723L14.3038 8L13.25 6.94625L7.58075 12.6155L4.73075 9.7655L3.677 10.8193L7.58075 14.723ZM2.30775 19.5C1.80908 19.5 1.38308 19.3234 1.02975 18.9703C0.676583 18.6169 0.5 18.1909 0.5 17.6923V4.30775C0.5 3.80908 0.676583 3.38308 1.02975 3.02975C1.38308 2.67658 1.80908 2.5 2.30775 2.5H6.75775C6.82058 1.94483 7.06292 1.47275 7.48475 1.08375C7.90642 0.694583 8.4115 0.5 9 0.5C9.59483 0.5 10.1032 0.694583 10.525 1.08375C10.9468 1.47275 11.1859 1.94483 11.2423 2.5H15.6923C16.1909 2.5 16.6169 2.67658 16.9703 3.02975C17.3234 3.38308 17.5 3.80908 17.5 4.30775V17.6923C17.5 18.1909 17.3234 18.6169 16.9703 18.9703C16.6169 19.3234 16.1909 19.5 15.6923 19.5H2.30775ZM2.30775 18H15.6923C15.7692 18 15.8398 17.9679 15.9038 17.9038C15.9679 17.8398 16 17.7693 16 17.6923V4.30775C16 4.23075 15.9679 4.16025 15.9038 4.09625C15.8398 4.03208 15.7692 4 15.6923 4H2.30775C2.23075 4 2.16025 4.03208 2.09625 4.09625C2.03208 4.16025 2 4.23075 2 4.30775V17.6923C2 17.7693 2.03208 17.8398 2.09625 17.9038C2.16025 17.9679 2.23075 18 2.30775 18ZM9 3.34625C9.21667 3.34625 9.39583 3.27542 9.5375 3.13375C9.67917 2.99208 9.75 2.81292 9.75 2.59625C9.75 2.37958 9.67917 2.20042 9.5375 2.05875C9.39583 1.91708 9.21667 1.84625 9 1.84625C8.78333 1.84625 8.60417 1.91708 8.4625 2.05875C8.32083 2.20042 8.25 2.37958 8.25 2.59625C8.25 2.81292 8.32083 2.99208 8.4625 3.13375C8.60417 3.27542 8.78333 3.34625 9 3.34625Z' fill='#333333'/></svg>",
        "isEnabled": true,
        "isNew": false,
      },
      {
        "enum": "privacy",
        "title": "Privacy Policy",
        "icon": "<svg width='16' height='20' viewBox='0 0 16 20' fill='none' xmlns='http://www.w3.org/2000/svg'><path d='M6.7405 12.7496H9.2595L8.69425 9.59184C9.00825 9.45717 9.26108 9.246 9.45275 8.95834C9.64442 8.6705 9.74025 8.35092 9.74025 7.99959C9.74025 7.52009 9.57008 7.11017 9.22975 6.76984C8.88942 6.4295 8.4795 6.25934 8 6.25934C7.5205 6.25934 7.11058 6.4295 6.77025 6.76984C6.42992 7.11017 6.25975 7.52009 6.25975 7.99959C6.25975 8.35092 6.35558 8.6705 6.54725 8.95834C6.73892 9.246 6.99175 9.45717 7.30575 9.59184L6.7405 12.7496ZM8 19.4803C5.83717 18.8905 4.0465 17.6174 2.628 15.6611C1.20933 13.7048 0.5 11.5176 0.5 9.09959V3.34584L8 0.538086L15.5 3.34584V9.09959C15.5 11.5176 14.7907 13.7048 13.372 15.6611C11.9535 17.6174 10.1628 18.8905 8 19.4803ZM8 17.8996C9.73333 17.3496 11.1667 16.2496 12.3 14.5996C13.4333 12.9496 14 11.1163 14 9.09959V4.37459L8 2.13409L2 4.37459V9.09959C2 11.1163 2.56667 12.9496 3.7 14.5996C4.83333 16.2496 6.26667 17.3496 8 17.8996Z' fill='#333333'/></svg>",
        "isEnabled": true,
        "isNew": false,
      }
    ]
  }),
  "alerts": jsonEncode([]),
  "appIcons": jsonEncode(appIcons),
  "tutorvideo": jsonEncode({
    "enumtype": "network",
    "url": "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
    "isEnabled": false,
    "autoplay": false
  }),
  "appTour": jsonEncode({
    "topcatagory": {
      "title": "Batch Category",
      "des": "Select your course category to explore batches."
    },
    "sideMenu": {
      "title": "Menu",
      "des": "Tap to open the menu and explore features."
    },
    "courseSearchbar": {
      "title": "Search",
      "des": "Find courses using the search bar."
    },
    "notification": {
      "title": "Notifications",
      "des": "Get updates and important alerts."
    },
    "learning": {
      "title": "Learning Zone",
      "des": "Your personalized learning space."
    },
    "coursebottom": {
      "title": "Courses",
      "des": "Browse all available courses."
    },
    "feed": {
      "title": "Feed",
      "des": "Stay updated with events and announcements."
    },
    "ebookbottom": {
      "title": "E-Books",
      "des": "Access your purchased SD Publication e-books."
    },
    "storebottom": {
      "title": "Books",
      "des": "Buy SD Publication books."
    },
    "homegroupFeature": {
      "title": "Student Zone",
      "des": "Explore your learning tools and resources."
    },
    "mycourse": {
      "title": "My Courses",
      "des": "View and access your enrolled courses."
    },
    "myDownloads": {
      "title": "My Downloads",
      "des": "Access downloaded notes, DPPs, and videos."
    },
    "myebooks": {
      "title": "My E-Books",
      "des": "View your purchased e-books."
    },
    "library": {
      "title": "Free Library",
      "des": "Access free tests, notes, PYQs, syllabus, and videos."
    },
    "mycourseinfo": {
      "title": "Course Info",
      "des": "View class schedule and course details."
    },
    "mycourseLecture": {
      "title": "Lectures",
      "des": "Watch subject-wise lecture videos."
    },
    "mycourseTest": {
      "title": "Practice Tests",
      "des": "Attempt MCQ-based tests."
    },
    "mycourseannouncement": {
      "title": "Announcements",
      "des": "Check important class updates."
    },
    "mycourseDoubt": {
      "title": "Doubts",
      "des": "Ask questions directly to subject teachers."
    },
    "mycourseCommunity": {
      "title": "Batch Community",
      "des": "Discuss and interact with classmates."
    },
    "lectureVideoTab": {
      "title": "Lecture Info",
      "des": "Details about the lecture."
    },
    "notesTab": {
      "title": "Notes",
      "des": "Download and review class notes."
    },
    "dppsTab": {
      "title": "DPPs",
      "des": "Access Daily Practice Problems."
    },
    "infoLectureTab": {
      "title": "Lecture Info",
      "des": "Get information related to the class."
    },
    "resourcesLectureTab": {
      "title": "Lecture Resources",
      "des": "Materials shared during live class."
    },
    "askDoubtLectureTab": {
      "title": "Ask Doubts",
      "des": "Submit your doubts during live class."
    },
    "pollLectureTab": {
      "title": "Poll",
      "des": "Participate in live class polls."
    },
    "chatLectureTab": {
      "title": "Live Chat",
      "des": "Engage in chat during live class."
    },
    "ratingLectureTab": {
      "title": "Lecture Rating",
      "des": "Rate your learning experience."
    },
    "reportLectureTab": {
      "title": "Report",
      "des": "Report any issues faced during class."
    },
    "libraryTestCardKey": {
      "title": "Practice Tests",
      "des": "Free tests to practice and improve."
    },
    "libraryNoteCardKey": {
      "title": "Important Notes",
      "des": "Access key class notes."
    },
    "libraryPyqsCardKey": {
      "title": "PYQs",
      "des": "Previous Year Question Papers."
    },
    "librarySyllabusCardKey": {
      "title": "Syllabus",
      "des": "Check the complete syllabus."
    },
    "libraryVideoLearnCardKey": {
      "title": "Free Video Lectures",
      "des": "Watch subject-wise lectures with notes."
    }
  })
};
