
class Languages {
  static bool isEnglish = true;
  static String learnAbout = '';
  static String ncertBatches = '';
  static String youTube = '';
  static String telegram = '';
  static String latestNews = '';
  static String prelims = '';
  static String mains = '';
  static String interview = '';
  static String ro = '';
  static String courses = '';
  static String home = '';
  static String test = '';
  static String dailyCurrentAffaris = "";
  static String gotaQuery = "";
  //buttons
  static String explore = '';
  static String learnMore = "";
  //profile
  static String profile = '';
  static String personalInformation = '';
  static String yourTestSeries = '';
  static String yourCourses = '';
  static String editProfile = '';
  static String seeYourEnrollTest = '';
  static String seeYourEnrollCourses = '';
  static String saveChanges = '';
  static String mobile = '';

  //Drawer
  static String aboutUs = '';
  static String yourDownloads = '';
  static String myCart = '';
  static String myOrders = '';
  static String myCourses = '';
  static String myTestseries = '';
  static String ourachievements = '';
  static String mySchedule = '';
  static String classSchedule = '';
  static String resources = '';
  static String helpAndSupport = '';
  static String shareApp = '';
  static String setting = '';

  //download screen
  static String download = '';
  static String video = '';
  static String testSeries = '';

  //Cart
  static String cart = '';
  static String makePayment = '';
  static String remove = '';
  static String total = '';
  static String createdFor = '';

  //my orders

  //my courses
  static String inProgress = '';
  static String continueText = '';
  static String complete = '';

  //schedule
  static String scheduleForToday = '';
  static String selectDate = '';
  static String scheduleDetails = '';
  static String task = '';
  static String notifyAt = '';
  static String scheduleFor = '';
  static String addTask = '';

  //Help And Support
  static String freeMessage = '';
  static String emailText = '';
  static String phoneText = '';
  static String whatsApp = '';
  static String feelfree = "";
  //empty
  static String noscheduler = "";

  //test
  static String questionpaper = "";
  static String questions = "";
  static String marks = "";
  static String checkedAnswer = "";
  static String noTest = "";
  static String myTest = "";
  static String mockTests = "";
  static String dailyEditorialBasedQuiz = "";
  static String mCQdescription = "";
  static String score = "";
  static String takeLiveTest = "";
  static String oMRSheet = "";
  static String submit = "";
  static String notification = "";
  static String startTest = "";
  static String startagain = "";

  //resources
  static String courseIndex = "";
  //search
  static String searchMockTestQuizzes = "";
  static String startnow = '';
  static String contactus = '';
  static String daysRemaining = '';

  static String noresources = '';
  static String nocourse = '';
  static String novideo = '';
  static String noOrders = '';
  static String notestseries = '';
  static String duration = "";
  static String demovideo = "";
  static String starts = "";
  static String view = "";
  static String days = "";
  static String date = '';
  static String to = '';
  static String retry = '';
  static String info = "";
  static String notes = '';
  static String ourteams = '';
  static String dailynews = "";
  static String shortnotes = "";
  static String youtubenote = '';
  static String samplenote = "";
  static String coursedetails = '';
  static String addtocart = '';
  static String email = "";
  static String address = "";
  static String youranswersheet = '';
  static String description = "";
  static String videolectures = "";
  static String readings = "";
  static String online = "";
  static String bestrecommended = "";
  static String startingon = "";
  static String testdetails = "";
  static String totalamount = "";
  static String checkout = "";
  static String payableamount = "";
  static String go = "";
  static String youtubevideo = "";
  static String objectivetype = "";
  static String chooseAnswer = "";
  static String submittest = "";
  static String attemptedQuiz = "";
  static String todaysQuizisempty = "";
  static String uploadomr = "";
  static String uploadanswersheet = "";
  static String orderSummary = "";
  static String billDetails = "";
  static String discount = "";
  static String notimer = "";
  static String cartempty = "";
  static String nonews = "";
  static String timer = "";
  static String newtimer = "";
  static String result = "";
  static String viewall = "";
  static String play = "";
  static String quit = "";
  static String pause = "";
  static String applycoupon = "";
  static String seeoffers = "";
  static String availablecoupons = "";
  static String couponcode = "";
  static String apply = "";
  static String expire = "";
  static String resultnotpublishyet = "";
  static String newsfortoday = "";
  static String createdate = "";
  static String areyousure = "";
  static String yes = "";
  static String no = "";
  static String knowmore = "";
  static String negtiveMarketing = "";
  static String startquiz = "";
  static String audioplay = "";
  static String areyousuretosubmit = "";
  static String resume = "";
  static String attempted = "";
  static String skipped = "";
  static String or = "";
  static String payment = "";
  static String upiid = "";
  static String paywithupi = "";
  static String paymentdesc = "";
  static String afterpayment = "";
  static String paymentscreenshot = "";
  static String summary = "";
  static String difficulty = "";
  static String correctness = "";
  static String quizPerformance = '';
  static String questionsSummary = '';
  static String easy = '';
  static String medium = '';
  static String hard = '';
  static String reportanIssue = '';
  static String askaDoubt = '';
  static String incorrect = '';
  static String accuracy = '';
  static String topperScore = '';
  static String saveTimer = '';
  static String title = '';
  static String cancel = '';
  static String confirm = '';
  static String offlinetest = '';
  static String onlineTest = '';
  static String viewDetailedAnalysis = '';
  static String underReview = '';
  static String reAttemptLiveTest = '';
  static String reAttemptOMRTest = '';
  static String startOMRTest = '';
  static String viewResult = '';
  static String nodatalecture = '';
  static String areyousuretoexitthisApp = '';
  static initState() {
    // Languages.isEnglish = SharedPreferenceHelper.getString(Preferences.language)! == "en" ? true : false;
    areyousuretoexitthisApp = isEnglish ? 'Are you sure to exit this App?' : 'क्या आप निश्चित रूप से इस ऐप से बाहर निकलेंगे?';
    nodatalecture = isEnglish ? 'No data in this lecture' : 'इस लेक्चर में कोई डेटा नहीं है';
    viewResult = isEnglish ? "View Result" : "रिजल्ट देखें";
    offlinetest = isEnglish ? 'Offline test' : 'ऑफलाइन टेस्ट';
    onlineTest = isEnglish ? 'Online Test' : 'ऑनलाइन टेस्ट';
    viewDetailedAnalysis = isEnglish ? 'View Detailed Analysis' : 'संपूर्ण विश्लेषण देखें';
    underReview = isEnglish ? 'Under Review' : 'समीक्षा के अंतर्गत';
    reAttemptLiveTest = isEnglish ? 'Re-Attempt Live Test' : 'लाइव टेस्ट पुनः प्रयास करें';
    reAttemptOMRTest = isEnglish ? 'Re-Attempt OMR Test' : 'ओएमआर टेस्ट  पुनः प्रयास करें';
    startOMRTest = isEnglish ? 'Start OMR Test' : 'ओएमआर टेस्ट शुरू करें';
    difficulty = isEnglish ? 'Difficulty' : "कठिनता";
    confirm = isEnglish ? 'Confirm' : 'पुष्टि करें';
    cancel = isEnglish ? 'Cancel' : 'रद्द करें';
    title = isEnglish ? 'Title' : 'शीर्षक';
    saveTimer = isEnglish ? 'Save Timer' : 'सेव टाइमर';
    topperScore = isEnglish ? "Topper's Score" : "टॉपर स्कोर";
    accuracy = isEnglish ? 'Accuracy' : 'यथार्थता';
    correctness = isEnglish ? 'Correct' : 'सही';
    incorrect = isEnglish ? 'Incorrect' : 'गलत';
    askaDoubt = isEnglish ? 'Ask a Doubt' : 'Doubt पूछे';
    reportanIssue = isEnglish ? 'Report an Issue' : 'समस्या रिपोर्ट करें';
    hard = isEnglish ? 'Hard' : 'कठिन';
    medium = isEnglish ? "Medium" : 'मध्यम';
    easy = isEnglish ? "Easy" : "आसान";
    questionsSummary = isEnglish ? 'Questions Summary' : "प्रश्नों का विवरण";
    quizPerformance = isEnglish ? 'Test Performance' : 'प्रश्नोत्तरी प्रदर्शन';
    summary = isEnglish ? 'Summary' : 'विवरण';
    payment = isEnglish ? "Payment" : 'भुगतान करे';
    upiid = isEnglish ? "UPI Id :-" : 'यूपीआई आईडी :-';
    paywithupi = isEnglish ? "Payment With UPI" : 'भुगतान करें यूपीआई से';
    paymentdesc = isEnglish ? "Payments made to this QR Through Paytm,GPay, Phonepe, or any other UPI app will be Send." : 'पेटीएम के माध्यम से इस क्यूआर को किए गए भुगतान,GPay, Phonepe, या किसी अन्य UPI ऐप को भेजा जाएगा।';
    afterpayment = isEnglish ? "After Payment, Please Send Payment Transaction Screenshot to UPSC Hindi on WhatsApp." : 'भुगतान के बाद, कृपया भुगतान लेनदेन भेजें व्हाट्सएप पर यूपीएससी हिंदी का स्क्रीनशॉट.';
    paymentscreenshot = isEnglish ? "Send Screenshot on WhatsApp" : 'व्हाट्सएप पर स्क्रीनशॉट भेजें';
    newsfortoday = isEnglish ? "News for today" : 'आज की न्यूज';
    createdate = isEnglish ? "Create date" : 'तिथि बनाएं';
    areyousure = isEnglish ? "Are you sure ?" : 'क्या आप सहमत हैं ?';
    yes = isEnglish ? "Yes" : 'हां';
    no = isEnglish ? "No" : 'नहीं';
    knowmore = isEnglish ? "Know more..." : 'अधिक जाने';
    negtiveMarketing = isEnglish ? "Negtive Marketing" : 'नकारात्मक अंक';
    startquiz = isEnglish ? "Start Test" : 'प्रश्नोत्तरी शुरू करें';
    audioplay = isEnglish ? "Audio play" : 'ऑडियो प्ले';
    areyousuretosubmit = isEnglish ? "Are you sure to submit ?" : 'क्या आप जमा करना सुनिश्चित करते हैं?';
    resume = isEnglish ? "Resume" : 'फिर शुरू करे';
    attempted = isEnglish ? "Attempted" : 'प्रयास किया';
    skipped = isEnglish ? "Skipped" : 'छोड़ें';
    or = isEnglish ? "Or" : 'या';
    resultnotpublishyet = isEnglish ? "Result is not published yet" : 'परिणाम अभी तक प्रकाशित नहीं हुआ है';
    notimer = isEnglish ? "There is no timer." : " कोई टाइमर नहीं है.";
    cartempty = isEnglish ? "Your cart is empty." : " कार्ट खाली है।";
    nonews = isEnglish ? "No News available for selected date." : "आज के लिए कोई न्यूज़ नहीं है ।";
    timer = isEnglish ? "Timer" : "टाइमर";
    newtimer = isEnglish ? "New timer" : "नया टाइमर";
    result = isEnglish ? "Result" : "रिज़ल्ट";
    viewall = isEnglish ? "View all" : "सभी देखें";
    play = isEnglish ? "Play" : "प्ले";
    quit = isEnglish ? "Quit" : "बाहर निकले";
    pause = isEnglish ? "Pause" : "रोके";
    applycoupon = isEnglish ? "Apply coupon" : "अप्लाई कूपन";
    seeoffers = isEnglish ? "See available offers and cashback" : " उपलब्ध ऑफ़र और कैशबैक देखें";
    availablecoupons = isEnglish ? "Available coupons" : "उपलब्ध  कूपन";
    couponcode = isEnglish ? "Enter coupon code" : "कूपन कोड डाले";
    apply = isEnglish ? "Apply" : "अप्लाई";
    expire = isEnglish ? "Expire :" : "समय सीमा समाप्त :";
    discount = isEnglish ? "Discount" : "छूट";
    billDetails = isEnglish ? "Bill Details" : "बिल विवरण";
    orderSummary = isEnglish ? "Order Summary" : "ऑर्डर विवरण";
    uploadanswersheet = isEnglish ? "Upload answersheet" : "अपलोड आंसरशीट";
    uploadomr = isEnglish ? "Upload OMR" : "अपलोड OMR";
    attemptedQuiz = isEnglish ? "Attempted Tests" : "अटेंपटेड Tests";
    submittest = isEnglish ? "Submit test" : "टेस्ट सबमिट करें";
    objectivetype = isEnglish ? "Objective Type" : "वस्तुनिष्ठ प्रकार";
    chooseAnswer = isEnglish ? "Choose Answer" : "उत्तर चुनें ";

    youtubevideo = isEnglish ? "YouTube Video" : "यूट्यूब वीडियो";
    go = isEnglish ? "Go" : "शुरु करें";
    payableamount = isEnglish ? "Payable amount" : "पेयबल अमाउंट";
    checkout = isEnglish ? "Checkout" : "चेकआउट";
    totalamount = isEnglish ? "Total amount" : "टोटल अमाउंट";
    testdetails = isEnglish ? "  Test details  " : "टेस्ट डिटेल्स";
    startingon = isEnglish ? "Starting on" : "शुरू करे";
    bestrecommended = isEnglish ? "Best recommended" : "बेस्ट रिकॉमएंडेड";
    readings = isEnglish ? "Readings" : "रीडिंग्स";
    online = isEnglish ? "Online" : "ऑनलाइन";
    videolectures = isEnglish ? "Video lectures" : "वीडियो लेक्चर्स";
    description = isEnglish ? "Description" : "विवरण";
    youranswersheet = isEnglish ? "Your Answer Sheet" : "आपकी उत्तर पुस्तिका";
    address = isEnglish ? "Address" : "पता";
    email = isEnglish ? "Email" : "ईमेल";
    addtocart = isEnglish ? "Add to Cart" : "कार्ट में डालें";
    coursedetails = isEnglish ? "  Course Details  " : "पाठ्यक्रम विवरण";
    samplenote = isEnglish ? "NCERT Notes" : "NCERT नोट्स";
    dailynews = isEnglish ? "Daily News" : "दैनिक समाचार";
    shortnotes = isEnglish ? "PYQs" : "अल्प टिप्पणियां ";
    youtubenote = isEnglish ? "Youtube Notes" : "यूट्यूब नोट्स";
    retry = isEnglish ? "Re-Try" : "पुन: प्रयास";
    ourteams = isEnglish ? "Our Team" : "हमारी टीम";
    info = isEnglish ? "Info" : "जानकारी";
    notes = isEnglish ? 'Notes' : "नोट्स";
    to = isEnglish ? "to" : "से";
    date = isEnglish ? "Date" : "दिनांक";
    days = isEnglish ? "Days" : "दिन";
    view = isEnglish ? "View" : "देखे";
    starts = isEnglish ? "Starts" : "शूरू";
    demovideo = isEnglish ? "Demo Video" : "डेमो वीडियो";
    duration = isEnglish ? '  Duration  ' : " अवधि ";
    todaysQuizisempty = isEnglish ? "Today's Tests is empty!" : "टुडे क्विज खाली है  !";
    noOrders = isEnglish ? 'There is no Order.' : 'कोई ऑर्डर्स नहीं है';
    nocourse = isEnglish ? "There is no course." : "कोई कोर्स नहीं है";
    novideo = isEnglish ? 'There is no Video.' : "कोई वीडियो नहीं है";
    notestseries = isEnglish ? 'There is no Test Series.' : 'कोई टेस्ट नहीं है';
    noresources = isEnglish ? 'There is no resources.' : "कोई संसाधन नहीं है";
    //buttons
    daysRemaining = isEnglish ? 'Days Remaining' : 'दिन में समाप्त हो रहा है';
    contactus = isEnglish ? 'Contact us' : 'संपर्क करें';
    startnow = isEnglish ? 'Start Now' : "शुरु  करें";
    explore = isEnglish ? 'Explore' : 'और खोंज़े';
    learnAbout = isEnglish ? 'Learn About' : 'जानिए ...';
    learnMore = isEnglish ? "Learn More " : "और जाने";
    ncertBatches = isEnglish ? 'Join Us On' : 'हमसे जुड़ें';
    youTube = isEnglish ? 'On YouTube' : 'यूट्यूब पर ';
    telegram = isEnglish ? 'On Telegram' : 'टेलीग्राम पर ';
    latestNews = isEnglish ? 'Our Videos ' : 'हमारे वीडियो';
    notification = isEnglish ? "Notification " : "सूचना";
    //search
    searchMockTestQuizzes = isEnglish ? "Search Mock Test,Quizzes" : "मॉकटेस्ट/क्विज खोजे";
    //tab bar course
    prelims = isEnglish ? 'Prelims' : 'प्रीलिम्स';
    mains = isEnglish ? 'Mains' : 'मेंस';
    interview = isEnglish ? 'Interview' : 'इंटरव्यू ';
    ro = isEnglish ? 'Ro' : 'आर ओ ';

    //bottom bar
    courses = isEnglish ? 'Courses' : 'कोर्स';
    home = isEnglish ? 'Home' : 'होम ';
    profile = isEnglish ? 'Profile' : 'प्रोफ़ाइल ';
    test = isEnglish ? 'Tests' : 'टेस्ट';
    dailyCurrentAffaris = isEnglish ? "Daily Current Affaris " : "डेली करेंट अफेयर्स";
    gotaQuery = isEnglish ? "Got a Query ?" : "कोई समस्या ?";
    //profile info
    personalInformation = isEnglish ? 'Personal Information' : 'व्यक्तिगत जानकारी';
    yourTestSeries = isEnglish ? 'My Test Series' : 'टेस्ट सीरीज';
    yourCourses = isEnglish ? 'Your Courses' : 'कोर्सेस';
    editProfile = isEnglish ? 'Phone, Email,Edit Profile Name' : 'फ़ोन, ईमेल, प्रोफ़ाइल नाम संपादित करें';
    seeYourEnrollTest = isEnglish ? 'See your enrolled tests' : 'अपने दाखिल टेस्ट देखे';
    seeYourEnrollCourses = isEnglish ? 'See your enrolled courses' : 'अपने दाखिल कोर्स देखे';
    saveChanges = isEnglish ? 'Save Changes' : 'बदलाव सहजें';
    mobile = isEnglish ? 'Mobile' : 'मोबाइल';

    //Drawer
    aboutUs = isEnglish ? 'About Us' : 'हमारे बारे में';
    yourDownloads = isEnglish ? 'My Downloads' : 'आपके डाउनलोड्स';
    myCart = isEnglish ? 'My Cart' : 'मेरा कार्ट';
    myOrders = isEnglish ? 'My Orders' : 'मेरे ऑर्डर्स';
    myCourses = isEnglish ? 'My Courses' : 'मेरे कोर्स';
    myTestseries = isEnglish ? 'My Test Series' : 'मेरी टेस्ट सीरीज';
    ourachievements = isEnglish ? 'Our Achievements' : 'हमारी उपलब्धियां';
    mySchedule = isEnglish ? 'My Schedule' : 'मेरे शेड्यूल';
    classSchedule = isEnglish ? "Class Schedule" : "कक्षा शेडयूल";
    resources = isEnglish ? 'Resources' : 'संसाधन ';
    helpAndSupport = isEnglish ? 'Help & Support' : 'हेल्प एंड सपोर्ट';
    shareApp = isEnglish ? 'Share App' : 'एप शेयर करें ';
    setting = isEnglish ? 'Settings' : 'सेटिंग्स ';

    //Download screen
    download = isEnglish ? 'Downloads' : 'डाउनलोड';
    video = isEnglish ? 'Videos' : 'वीडियो ';
    testSeries = isEnglish ? 'Test Series' : 'टेस्ट सीरीज';

    //cart
    cart = isEnglish ? 'My Cart' : 'कार्ट ';
    makePayment = isEnglish ? 'Make Payment' : 'भुगतान करें';
    remove = isEnglish ? 'Remove' : 'हटाएं';
    total = isEnglish ? 'Total' : 'कुलs';
    //resources
    courseIndex = isEnglish ? "Syllabus" : "पाठ्यक्रम";
    //courses
    inProgress = isEnglish ? 'In Progress' : 'प्रगति मे';
    continueText = isEnglish ? 'Continue' : 'जारी रखे';
    complete = isEnglish ? 'Complete' : 'पूर्ण';

    //my schedule
    scheduleForToday = isEnglish ? 'Schedule For Today' : 'आज की शेडयूल';
    scheduleFor = isEnglish ? 'Schedule For ' : 'आज की ';
    selectDate = isEnglish ? 'Select Date' : 'तारीख चुने';
    scheduleDetails = isEnglish ? 'Schedule Details' : 'अनुसूची विवरण';
    task = isEnglish ? 'Task' : 'कार्य ';
    notifyAt = isEnglish ? 'Notify at' : 'पर सूचित करें';
    createdFor = isEnglish ? 'Set Alarm' : 'अलार्म सेट करें';
    addTask = isEnglish ? '+ Add Task' : '+ कार्य जोड़ें';

    //help and support
    feelfree = isEnglish ? "We are Here to Solve" : "आपकी सहायता हेतु हम उपस्थित है";
    freeMessage = isEnglish ? 'Feel free to message us at' : 'बेझिझक हमें इन पर संपर्क करें';
    emailText = isEnglish ? 'Mail us at' : 'हमे ईमेल करें';
    whatsApp = isEnglish ? 'WhatsApp us' : 'व्हाट्सअप पर सम्पर्क करें';
    //empty
    noscheduler = isEnglish ? "There is no scheduler" : "कोई शेडयूल नहीं है";

    //test
    checkedAnswer = isEnglish ? "Your Checked Answer Sheet" : "आपकी जांची गई उत्तर पुस्तिका";
    questionpaper = isEnglish ? "Question Paper" : "प्रश्न पत्र";
    score = isEnglish ? "Score" : " अंक";
    marks = isEnglish ? "Marks" : "अंक";
    questions = isEnglish ? "Questions" : "प्रश्न";
    noTest = isEnglish ? "Tests" : "टेस्ट";
    myTest = isEnglish ? "My Tests" : "मेरे टेस्ट";
    mockTests = isEnglish ? "All Test Series" : "सभी टेस्ट सीरीज";
    dailyEditorialBasedQuiz = isEnglish ? "Daily Tests" : "दैनिक Tests";
    mCQdescription = isEnglish ? "Current Affairs Questions & Quizzes for Daily Practice" : "दैनिक प्रैक्टिस के लिए करेंट अफेयर्स प्रश्न और क्विज ";
    score = isEnglish ? "Score" : "स्कोर";
    takeLiveTest = isEnglish ? "Start Live Test" : "लाइव टेस्ट शुरू करें";
    oMRSheet = isEnglish ? "OMR Sheet" : "ओएमआर शीट";
    submit = isEnglish ? "Submit" : "जमा  करें";
    startTest = isEnglish ? "Start Test" : "शुरू कर टेस्ट";
    startagain = isEnglish ? "Start Again" : "फिर से शुरू करें";
  }
}
