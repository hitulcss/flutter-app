import 'package:flutter/foundation.dart';

class Apis {
  // Please don't remove "/api/v1/".
  static const String rootUrl = //kReleaseMode ?
      'https://backend-prod.sdcampus.com'; //: 'https://stage-backend.sdcampus.com';
  // "https://t8zv4r6j-3000.inc1.devtunnels.ms";
  static const String endUrl = '/api/v1/';
  static const String baseUrl = rootUrl + endUrl;
  static const String banner = "adminPanel/getbannerdetails";
  static const String helpandsupport = "user/needHelp";
  static const String deleteaccount = 'authentication/deleteUserAccount';
  // static const String login = 'authentication/login';
  static const String register = 'authentication/userRegister';
  static const String signup = "authentication/signup";
  static const String verifyOtp = "authentication/verifyOtp";
  static const String resendotp = "authentication/resendOtp";
  static const String resendMobileVerificationOtp = 'authentication/resendmobileverificationotp';
  static const String verifyMobileNumber = 'authentication/verifyMobileNumber';
  // static const String logout = "authentication/Logout";
  static const String requestToLogout = 'adminPanel/postRequestToLogoutUserByAdmin';
  //googleauth
  static const String postgoolgeaddnumber = "authentication/postUserMobileNumber";
  static const String googleAuth = 'authentication/googleSignIn';
  //langu
  static const String updateUserLanguage = 'authentication/updateUserLanguage';
  static const String updateUserStream = 'authentication/addCategoryDetails';
  static const String getCategoryStream = 'adminPanel/getCategory?type=Stream';
  static const String currentstream = "adminPanel/updateCurrentCategory";
  //RESET OTP
  static const String resetPassword = 'authentication/forgetpassword';
  static const String resetPasswordVerifyOtp = 'authentication/reset';
  static const String resendOtp = 'authentication/resendotp';
  static const String updatePassword = 'authentication/resetpassword';

  //user details
  static const String updateUserDetails = "authentication/UpdateUserDetails";
  static const String updateUserProfilePhoto = "authentication/UpdateUserProfilePhoto";
  // course before purchase api
  static const String getBatchesSubjects = "user/getSubjectOfBatch";
  static const String getListOfLectureOfSubject = "user/getLectureOfSubject";
  static const String getBatchesNotes = "user/getNotes";
  static const String getBatchesDpp = "user/getDPPs";
  static const String getPlanner = "user/getPlanner";

  // static const String getCoursesFilter = "adminPanel/getBatchesDetails";
  static const String getCoursesDetails = 'adminPanel/getBatchDetailswithid/';
  static const String getfreeCourses = "adminPanel/freeCourses";
  static const String getpaidCourses = "adminPanel/paidCourses";
  static const String searchCourses = "adminPanel/searchCourses";
  static const String getBatchPlan = 'user/getBatchPlan';
  static const String getAnnouncement = "adminPanel/getAnnouncementByLinkWith";
  static const String getYouTubeVideo = 'adminPanel/YouTubeDetails';
  static const String getYouTubeVideobyId = "adminPanel/getVideoById";
  static const String joinmeeting = "Streaming/JoinMeetingRTCAndRTMToken";
  static const String deleteUserDetailsFromStream = "Streaming/deleteUserDetailsFromStream/";
  static const String streamingUserDetails = "Streaming/StreamingUserDetails";
  static const String getDppByBatchId = "adminPanel/getDppByBatchId";

  static const String getResources = "adminPanel/ResourceDetails";

  // static const String addtocart = 'adminPanel/addtocart';
  // static const String getcartdata = 'adminPanel/getCartDetails';
  static const String mycourses = 'adminPanel/myBatchDetails'; ////********************************** myBatchDetails*/
  static const String mycoursesbyid = "adminPanel/myBatchInfo";
  static const String getSubjectOfBatch = "adminPanel/getSubjectOfBatch";
  static const String mycoursesLecturebyid = "adminPanel/getLectureById";
  static const String getTodayClass = "adminPanel/getTodayClasses";
  static const String addToMyCourses = 'adminPanel/addtomybatch';
  static const String getMyOrders = 'payment/userTransactionDetails';
  // course payment api
  static const String postinitiateBatchPayment = 'payment/initiate_payment_app';
  // static const String removefromCart = "adminPanel/deleteCartDetails/";
  static const String getLecturesOfSubject = "adminPanel/getLectureOfSubject";
  static const String getRecordedVideo = "adminPanel/getRecordedVideoStudentSide";
  static const String getBatchNotes = "adminPanel/getNotes";
  static const String getCourseIndex = 'adminPanel/ResourceDetails';
  static const String getVideoByid = "adminPanel/getVideoById";
  //recorded video
  static const String postCommentForRecorded = "lecture/postCommentForRecorded";
  static const String getRecordedComments = "lecture/getRecordedComments";
  static const String editCommentForRecorded = "lecture/editCommentForRecorded";
  static const String deleteCommentForRecorded = "lecture/deleteCommentForRecorded";
  static const String markCommentToPin = "lecture/markCommentToPin";
  static const String replyToCommentForRecorded = "lecture/replyToCommentForRecorded";
  static const String markCommentToReport = "lecture/markCommentToReport";
  // doubts in courses page
  static const String getMyBatchDoubts = "user/getMyBatchDoubts";
  static const String getBatchDoubts = "user/getBatchDoubts";
  static const String createDoubt = "user/createDoubt";
  static const String editBatchDoubt = "user/editBatchDoubt";
  static const String deleteBatchDoubt = "user/deleteBatchDoubt";
  static const String getDoubtById = "user/getDoubt";
  static const String batchDoubtLikeAndDislike = "user/batchDoubtLikeAndDislike";
  static const String reportDoubt = "user/reportDoubt";
  static const String postBatchDoubtComment = "user/createBatchDoubtComment";
  static const String editDoubtComment = "user/editDoubtComment";
  static const String deleteDoubtComment = "user/deleteDoubtComment";
  static const String reportDoubtComment = "user/reportDoubtComment";

  // communities in courses page
  static const String getBatchMyCommunities = "user/getBatchMyCommunities";
  static const String createCommunity = "user/createCommunity";
  static const String editCommunity = "user/editCommunity";
  static const String getBatchCommunity = "user/getBatchCommunities";
  static const String getBatchMyCommunity = "user/getBatchMyCommunities";
  static const String deleteCommunity = "user/deleteCommunity";
  static const String getCommunityById = "user/getCommunity";
  static const String batchCommunityLikeAndDislike = "user/batchCommunityLikeAndDislike";
  static const String reportCommunity = "user/reportCommunity";
  static const String reportComment = "user/reportComment";
  static const String reportReplyComment = "user/reportReplyComment";
  static const String postBatchCommunityComment = "user/createBatchCommunityComment";
  static const String getCommunityComments = "user/getCommunityComments";
  static const String editCommunityComment = "user/editComment";
  static const String deleteCommunityComment = "user/deleteComment";
  static const String communityReplyToComments = "user/replyToComments";
  static const String editCommunityReplyComment = "user/editReplyComment";
  static const String deleteCommunityReplyComment = "user/deleteReplyComment";

  //Resources
  static const String getDailyNews = 'adminPanel/getNewsClips';
  static const String getAirResources = 'adminPanel/getallindiaradio';
  static const String getNotesDetails = 'adminPanel/getNotesDetails';
  static const String pyqs = 'adminPanel/getPYQ';
  static const String agora = "https://d1mbj426mo5twu.cloudfront.net/data/agora/";
  static const String timeSpendL = "adminPanel/createTimeSpend";
  //our result
  static const String getResultBanner = "user/getResultBanner";
  static const String successStories = "user/successStories";
  // Payment
  // course new 26-12-2024
  static const String initiateCoursePayment = 'purchase/initiateCoursePayment';
  static const String addValidityToCourse = 'purchase/addValidity';
  // old
  static const String savePaymentStatus = 'payment/verifyUserPayment';
  static const String savetestPaymentStatus = 'payment/verifyUserPaymentForTestSeries';
  static const String getOrderId = 'payment/orders';
  static const String createOrder = 'payment/createOrder';

  //Scheduler
  static const String addSchedulardetails = 'adminPanel/addSchedulardetails';
  static const String getScheduleDetails = 'adminPanel/getScheduleDetails';
  static const String deleteScheduler = 'adminPanel/deleteSchedularDetails/';
  static const String updateScheduler = 'adminPanel/updateSchedulardetails/';
  static const String classScheduler = 'adminPanel/getMySchedular';

  static const String getnotification = "Notification/getNotifications";
  static const String updateIsRead = 'Notification/updateIsRead/';
  //TestSeries
  static const String gettestseries = "adminPanel/getTestSeriesdetails";
  static const String myTests = 'adminPanel/getMyTestSeries';
  static const String myTestsoftest = 'adminPanel/getMyTestByTestseriesId';
  static const String myTestsoftestbyid = 'adminPanel/getTestById';
  static const String submittest = 'adminPanel/addAttemptedTest';
  static const String submitObjectiveTest = "adminPanel/submitesttanswers";
  static const String testResultsList = "adminPanel/getAttemptedTestSeriesTestResults/";
  static const String subnitresume = "adminPanel/resumeQuiz";
  static const String getresume = "adminPanel/getResumeQuiz/";
  //quiz
  static const String getquiz = "adminPanel/getAllQuizes";
  static const String getquizByid = "adminPanel/getQuizById";
  static const String getquizBybatchid = "adminPanel/getQuizDetailsByBatchId";
  static const String getresult = "adminPanel/getQuizResult/";
  static const String getquestionbyid = "adminPanel/getQuestionsByQuizId/";
  static const String submmitquiz = "adminPanel/attemptQuiz/";
  static const String quizreport = "adminPanel/postIssueReport/";
  static const String quizaskdoubt = "adminPanel/postDoubts/";
  static const String getLeaderboard = "adminPanel/getleaderBoard/";
  //timer
  static const String getmytimer = "adminPanel/getMyTimers";
  static const String addmytimer = "adminPanel/saveTimer";
  static const String deletemytimer = "adminPanel/deleteTimer/";
  //Coupon
  static const String getcoupans = "adminPanel/getStudentCoupon";
  static const String verifyCoupon = "user/verifyCoupon";
  //alert
  static const String getalert = 'adminPanel/getMyAlerts';
  static const String getupi = 'payment/getPaymentUpiId';
  //referal
  static const String getRefaralContent = 'adminPanel/getRefaralContent';
  static const String getMyWallet = 'adminPanel/getRefaralTxn';
  static const String withdrawalRequest = "adminPanel/withdrawalRequest";
  static const String applyreferalRequest = "authentication/applyRefaralCode";

  // short learning
  static const String getShortVideos = "learning/getShortVideos";
  static const String getShortByid = "learning/getShortVideoDetails";
  static const String postViewedShort = "learning/viewed";
  static const String likeOrRemoveLikeOfShort = "learning/likeOrRemoveLikeOfShort";
  static const String postReportShort = "learning/reportShort";
  static const String postMakeSaveOrUnsaveShort = "learning/makeSaveOrUnsave";
  static const String getMySavedShort = "learning/mySaved";
  //
  static const String getchannelProfile = "learning/channelProfile";
  static const String channelSubscribeOrUnSubscribe = "learning/channelSubscribeOrUnSubscribe";
  static const String getShortVideosByChannel = "learning/getShortVideosByChannel";
  //
  static const String getShortComments = "learning/getComments";
  static const String addCommentToShort = "learning/addCommentToShort";
  static const String editCommentToShort = "learning/editComment";
  static const String reportCommentToShort = "learning/reportComment";
  static const String deleteShortComment = "learning/deleteComment";

  static const String replyToCommentsShort = "learning/replyToComments";
  static const String editReplyCommentShort = "learning/editReplyComment";
  static const String deleteReplyCommentShort = "learning/deleteReplyComment";
  static const String reportReplyCommentToShort = "learning/reportReplyComment";

  //store
  static const String getAllProductCategory = "store/getAllProductCategory";
  static const String getStoreBanner = "store/getAllStoreBanner";
  static const String getAllStoreProduct = "store/getStoreProducts";
  static const String getProductDetailsById = "store/getProductById";
  static const String getNewArrival = "store/getNewArrival";
  static const String getMarketingCategory = "store/getMarketingCategory";

  static const String searchProduct = "store/searchProduct";

  static const String postWishlist = "store/AddOrUpdateWishlist";
  //storecart
  static const String deletStoreCart = "store/deleteProductFromCarts";
  static const String getStoreCart = "store/storeAddOrUpdateCart";
  //storeAddress
  static const String getStoreAddress = "store/getAllStoreAddress";
  static const String deleteStoreAddress = "store/deleteStoreAddress";
  static const String addStoreAddress = "store/addOrUpdateStoreAddress";

  static const String getStoreRecommend = "store/recommendProducts";
  static const String getStoreSimiliar = "store/similiarProducts";
  //store orders
  static const String getStoreOrders = "store/getOrders";
  static const String getStoreAlert = "store/getAllStoreAlerts";
  // store payment
  static const String storeGenerateOrderId = "payment/store_initiate_payment";
  static const String storeCODOrder = "payment/store_initiate_payment_for_cod";
  static const String storeCancelOrder = "store/cancelOrder";
  static const String addstoreOrderRefund = "store/addReturn";
  static const String storeverifyPayment = "payment/verify_store_payment";
  static const String saveTxnDetails = "payment/saveTxnDetails";
  static const String postProductReview = "store/postProductReview";

  static const String getAllScholarshipTest = "adminPanel/getAllScholarshipTest";
  static const String getAllScholarshipTestbyId = "adminPanel/getUserScholarshipTest";
  static const String scholarshipTestRegester = "adminPanel/registerationForScholarTest";

  static const String getpincode = "https://d1mbj426mo5twu.cloudfront.net/storeJSON/pinCode.json";
  // community/getAllPosts
  static const String getAllPosts = "community/getAllPosts";
  static const String getPostById = "community/getPostById/";
  static const String getCommentsByPostId = "community/getCommentsByPostId/";
  static const String postlikeOrRemoveLike = "community/likeOrRemoveLike";
  static const String addCommentToPost = "community/addCommentToPost";
  static const String deleteComment = "community/deleteComment";
  static const String replyToComments = "community/replyToComments";
  static const String deleteReplyComment = "community/deleteReplyComment";
  static const String markCmsCommentToReport = "community/markCmsCommentToReport";
  static const String markCmsCommentToPinOrUnpin = "community/markCmsCommentToPinOrUnpin";

  ///
  static const String postReport = "lecture/postReport";
  static const String postRating = "lecture/postRating";
  static const String getFaqs = "webContains/getFAQs";
  static const String getOrdersPdfUrl = "webContains/getInVoiceUrl";

  //E books
  static const String getAllEbooks = "ebook/getAllEbooks";
  static const String getEbookById = "ebook/getSpecficEbook";
  static const String postEbookReview = "ebook/postReview";
  static const String postEbookInitiatePayment = "ebook/ebook_initiate_payment";
  static const String postVerifyEbookPayment = "ebook/verify_ebook_payment";
  static const String getMyEbooks = "ebook/getMyEbooks";
  static const String getMyEbookById = "ebook/getMyEbookById/";
  static const String getEbookTopic = "ebook/getTopic";
  static const String getEbookReviews = "ebook/getEbookReviews";
  static const String ebookPostReview = "ebook/postReview";
  static const String freeEbookPurchase = "ebook/freeEbookPurchase";

  //Library
  static const String getLibraryPyqs = "library/getPYQs";
  static const String getLibraryNotes = "library/getNotes";
  static const String getLibrarySyllabus = "library/syllabus";
  // Library video
  static const String getLibraryVideoLearning = "library/videoLearning";
  static const String postVideoRating = "library/videoRating";
  static const String postVideoReport = "library/videoReport";
  static const String getVideoComments = "library/comments";
  static const String postVideoComment = "library/createComment";
  static const String editVideoComment = "library/editComment";
  static const String removeVideoComment = "library/removeComment/";
  static const String postVideoCommentReply = "library/createReplyComment";
  static const String editVideoCommentReply = "library/editReplyComment";

  // Library quiz
  static const String getLibraryQuizes = "library/getQuizes";
  static const String getLibraryQuizQuestion = "library/getQuizQuestion";
  static const String submitRatingQuizLibrary = "library/createQuizRating";
}
