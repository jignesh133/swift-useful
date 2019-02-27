
//  AppDelegate.swift
//  OrangeWill
//
//  Created by Hupp Technologies on 16/01/17.
//  Copyright © 2017 Hupp Technologies. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation
import IQKeyboardManagerSwift
import MMDrawerController
import GoogleMaps
import GooglePlaces
import Alamofire
import Fabric
import Crashlytics
import ViewDeck
import UserNotifications
import Firebase
import FirebaseInstanceID
import FirebaseMessaging
// import AlamofireNetworkActivityLogger


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,MessagingDelegate {
    

    var window: UIWindow?
    let locationManager:CLLocationManager = CLLocationManager()
    
    var userCurrentLatitude:Double = 0.0
    var userCurrentLongitude:Double = 0.0
    var isLocationNeedToContinue = false
    var viewDeckController:IIViewDeckController!
    
    var drawerController: MMDrawerController!
    private var reachability:Reachability!
    let gcmMessageIDKey = "gcm.message_id"
    
    
    override init() {
        super.init()
        
        // INIT METHODS
        FirebaseApp.configure()
    }
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        
        
        setRootViewController()
        setupNavigationController()
        
        return true
    }
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
       
        
        // DISCONNECT
        SocketIOManager.sharedInstance.socket.disconnect()
        
        Fabric.with([Crashlytics.self])
        
        if let font = UIFont(name: "Avenir-Book", size: 15.0) {
            UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: font], for: UIControlState.normal)
        }
        //NetworkActivityLogger.shared.level = .debug
        //NetworkActivityLogger.shared.startLogging()
        
        // REGISTER FOR PUS NOTFICATIAON
        self.registerForPushNotifications()
        application.registerForRemoteNotifications()
        Messaging.messaging().delegate = self
        //  Messaging.messaging().isAutoInitEnabled = true
        Messaging.messaging().shouldEstablishDirectChannel = true
        
        if let refreshedToken = InstanceID.instanceID().token() {
            print("::: InstanceID token: \(refreshedToken)")
        }
        NotificationCenter.default.addObserver(self, selector: #selector(tokenRefreshNotification), name: NSNotification.Name.InstanceIDTokenRefresh, object: nil)
        
        UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableDebugging = true
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 15.0
        
        NotificationCenter.default.addObserver(self, selector:#selector(checkForReachability(notification:)), name: NSNotification.Name.reachabilityChanged, object: nil)
        self.reachability = Reachability.forInternetConnection();
        self.reachability.startNotifier();
        
        GMSServices.provideAPIKey("AIzaSyDQ2bBxeAI2UjL8OpHDNM-h62F3fOt0luo")
        GMSPlacesClient.provideAPIKey("AIzaSyDQ2bBxeAI2UjL8OpHDNM-h62F3fOt0luo")
        
        //google analytics configuration
        if let gai = GAI.sharedInstance() {
            gai.tracker(withTrackingId: "UA-112533065-1")
            gai.trackUncaughtExceptions = true
        }else{
            assert(false, "Google Analytics not configured correctly")
        }
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.startUpdatingLocation()
        }
        self.FetchDataFromSever()
        let queue1 = DispatchQueue.init(label: "com.orangeWill.queue1")
        return true
    }
    func applicationWillResignActive(_ application: UIApplication) {
        
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // START BACKGROUND
        self.methodStartBackground()
    }
    func methodStartBackground(){
        // CHECK FOR SOCKETS IOS
        if (SocketIOManager.sharedInstance.timer.isValid == true && SocketIOManager.sharedInstance.backgroundTask == UIBackgroundTaskInvalid){
            self.registerBackgroundTask()
        }
    }
    func registerBackgroundTask() {
        SocketIOManager.sharedInstance.backgroundTask = UIApplication.shared.beginBackgroundTask {
            [unowned self] in
            self.endBackgroundTask()
        }
    }
    func endBackgroundTask() {
        NSLog("Background task ended.")
        UIApplication.shared.endBackgroundTask(SocketIOManager.sharedInstance.backgroundTask)
        SocketIOManager.sharedInstance.backgroundTask = UIBackgroundTaskInvalid
        // START BACKGROUND
        self.methodStartBackground()
    }
    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
        Messaging.messaging().connect { error in
            print(error ?? "")
        }
    }
    func tokenRefreshNotification(_ notification: Notification) {
        if let refreshedToken = InstanceID.instanceID().token() {
            print("InstanceID token: \(refreshedToken)")
        }
    }
    func applicationWillTerminate(_ application: UIApplication) {
        
        self.saveContext()
        
        UserDefaults.standard.set(API_SYNC_Customer_START_CNT, forKey: EM_API_sync_Keys.cnt_CustSync.rawValue)
        UserDefaults.standard.set(API_SYNC_Supplier_START_CNT, forKey: EM_API_sync_Keys.cnt_SuppSync.rawValue)
        UserDefaults.standard.set(API_SYNC_Route_START_CNT, forKey: EM_API_sync_Keys.cnt_RouteSync.rawValue)
        UserDefaults.standard.set(API_SYNC_SalesRep_START_CNT, forKey: EM_API_sync_Keys.cnt_SelesRepSync.rawValue)
        UserDefaults.standard.set(API_SYNC_Order_START_CNT, forKey: EM_API_sync_Keys.cnt_OrderSync.rawValue)
        
        UserDefaults.standard.synchronize()
    }
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("backgroud callledddd......")
    }
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print(fcmToken)
        UserDefaults.standard.setValue(fcmToken, forKey: EM_DeviceInfo.deviceToken.rawValue)
        UserDefaults.standard.synchronize()
        
        let dataDict:[String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
    }
    @nonobjc func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken as Data
        //        UserDefaults.standard.setValue(Messaging.messaging().apnsToken, forKey: EM_DeviceInfo.deviceToken.rawValue)
        //        UserDefaults.standard.synchronize()
    }
    func application(_ application: UIApplication,didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        // Let FCM know about the message for analytics etc.
        Messaging.messaging().appDidReceiveMessage(userInfo)
        // handle your message
        completionHandler(UIBackgroundFetchResult.newData)
        // CALL METHODS FOR REFERESH DATA
        self.methodBackGroundAppReferesh(userInfo: userInfo);
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        print(userInfo)
        // CALL METHODS FOR REFERESH DATA
        self.methodBackGroundAppReferesh(userInfo: userInfo);
    }
    //MARK: LOCAL NOTIFICAITON
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        if ((notification.userInfo?["type"] as? String) == "flash"){
            self.methodShowFlashMessage()
        }
    }
    func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, for notification: UILocalNotification, completionHandler: @escaping () -> Void) {
        if ((notification.userInfo?["type"] as? String) == "flash"){
            self.methodShowFlashMessage()
        }
    }
    func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, for notification: UILocalNotification, withResponseInfo responseInfo: [AnyHashable : Any], completionHandler: @escaping () -> Void) {
        if ((notification.userInfo?["type"] as? String) == "flash"){
            self.methodShowFlashMessage()
        }
    }
    func methodShowFlashMessage(){
        let state = UIApplication.shared.applicationState
        if state == .active {
            // ACTIVE
            NotificationCenter.default.post(Notification.init(name: Notification.Name.init(NF_SHOW_FLASH_MESSAGE)))
        }
    }
    //MARK: HANDLE PUSH
    func methodBackGroundAppReferesh(userInfo:[AnyHashable : Any]){
        print(userInfo)
        print("============================== Notificaton Get ===========")
        let _pushData = userInfo //["alert"] as? [String:Any] else {return}
        guard let _pushType = userInfo["push_type"] as? String else {return}
        if _pushType == "add_route" {
            Model_HandlePushNotification.UpdateRouteList(_rid: getInt64FromAny(_pushData["entity_id"] ?? 0) )
        }else if _pushType == "add_customer" || _pushType == "update_cust" {
            Model_HandlePushNotification.UpdateCustomerList(_cid: getInt64FromAny(_pushData["entity_id"] ?? 0) )
        }else if _pushType == "add_supplier" || _pushType == "update_sup"{
            Model_HandlePushNotification.UpdateSupplierList(_sid: getInt64FromAny(_pushData["entity_id"] ?? 0) )
        }else if _pushType == "add_order" {
            Model_HandlePushNotification.UpdateOrderList(_oid: getInt64FromAny(_pushData["entity_id"] ?? 0))
        }else if _pushType == "cust_type_master" {
            Model_HandlePushNotification.UpdateCustTypeMaster(_cid: getIntegerFromAny(_pushData["entity_id"] ?? 0))
        }else if _pushType == "sup_type_master" {
            Model_HandlePushNotification.UpdateSuppTypeMaster(_cid: getIntegerFromAny(_pushData["entity_id"] ?? 0))
        }else if _pushType == "update_user" {
            Model_HandlePushNotification.UpdateUser(id: getIntegerFromAny(_pushData["entity_id"] ?? 0))
        }else if _pushType == "remove_customer" {
            Model_HandlePushNotification.Remove_Cust_Access(id: getIntegerFromAny(_pushData["entity_id"] ?? 0))
        }else if _pushType == "remove_supplier" {
            Model_HandlePushNotification.Remove_Sup_Access(id: getIntegerFromAny(_pushData["entity_id"] ?? 0))
        }else if _pushType == "remove_route" {
            Model_HandlePushNotification.Remove_Route_Access(id: getIntegerFromAny(_pushData["entity_id"] ?? 0))
        }else if _pushType == "add_pricelist" {
            Model_HandlePushNotification.UpdateproductList()
        }else if _pushType == "activity_type_master" {
            Model_HandlePushNotification.updateActivityTypeMaster()
        }else if _pushType == "flash_msg" {
            if (UIApplication.shared.applicationState == .background){
                let dd:[String:Any] = (_pushData["data"] as? [String:Any])!
                self.methodAddLocalNotification(strText: dd["body"] as? String ?? "")
            }
            Model_HandlePushNotification.getFlashMessage(message_id: getIntegerFromAny(_pushData["entity_id"] ?? 0))
        }
    }
    func registerForPushNotifications() {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
                (granted, error) in
                print("Permission granted: \(granted)")
                
                guard granted else { return }
                self.getNotificationSettings()
            }
        } else {
            let settings = UIUserNotificationSettings.init(types: [.alert, .sound, .badge], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    func getNotificationSettings() {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().getNotificationSettings { (settings) in
                print("Notification settings: \(settings)")
                guard settings.authorizationStatus == .authorized else { return }
                DispatchQueue.main.async(execute: {
                    UIApplication.shared.registerForRemoteNotifications()
                })
            }
        }
    }
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print(remoteMessage.appData)
        self.methodBackGroundAppReferesh(userInfo: remoteMessage.appData);
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print(userInfo)
        // CALL METHODS FOR REFERESH DATA
        self.methodBackGroundAppReferesh(userInfo: userInfo);
    }
    // MARK: - Core Data stack
    lazy var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "orangeWill", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        //var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
    //MARK:- SETTING DRAWER CONTROLLER
    func setRootViewController(){
        
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let chatStoryBoard = UIStoryboard(name: "ChatTab", bundle: nil)
        let tapContrller:mainTabBarController = mainStoryBoard.instantiateViewController(withIdentifier: "tabController") as! mainTabBarController
        
        //print(tabController().viewControllers)
        
        let chatFilterView = chatStoryBoard.instantiateViewController(withIdentifier: "chatFilter") as! chatFilter
        
        let navChatFilterView = UINavigationController(rootViewController: chatFilterView)
        
        self.drawerController = MMDrawerController(center: tapContrller, rightDrawerViewController: navChatFilterView)
        
        self.drawerController.showsShadow = false
        self.drawerController.restorationIdentifier = "MMDrawer"
        self.drawerController.maximumRightDrawerWidth = 285.0
        
        self.drawerController.closeDrawerGestureModeMask = .tapCenterView
        self.drawerController.centerHiddenInteractionMode = .none
        
        self.drawerController.setDrawerVisualStateBlock { (drawer, drawerSide, precentVisible) in
            
            //print(UIApplication.topViewController())
            let centerView = drawer?.centerViewController as! mainTabBarController
            let selectedView = centerView.selectedViewController as! UINavigationController
            
            if drawerSide == MMDrawerSide.right {
                let lastView = selectedView.viewControllers.last
                lastView?.view.alpha = 1.0
                selectedView.navigationBar.alpha = 1.0
                centerView.tabBar.alpha = 1.0
            }
        }
        
        print("login : \(UserDefaults.standard.bool(forKey: UserInfo.isLogedIN.rawValue))")
        print("isSyncAllAPI : \(UserDefaults.standard.bool(forKey: "isSyncAllAPI"))")
        
        if UserDefaults.standard.bool(forKey: UserInfo.isLogedIN.rawValue) && UserDefaults.standard.bool(forKey: "isSyncAllAPI") {
            let rootview = IIViewDeckController.init(center: tapContrller, leftViewController: nil, rightViewController: nil)
            self.window?.rootViewController = rootview//self.drawerController
            self.window?.makeKeyAndVisible()
        }
        else if UserDefaults.standard.bool(forKey: UserInfo.isLogedIN.rawValue) {
            let mainStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
            let dataSyncVCC = mainStoryboard.instantiateViewController(withIdentifier: "dataSyncVC") as! dataSyncVC
            self.window?.rootViewController = dataSyncVCC
            self.window?.makeKeyAndVisible()
        }
        else {
            
            WebApiClass.flagSetup()
            let login = mainStoryBoard.instantiateViewController(withIdentifier: "loginVC") as! loginVC
            let nav = UINavigationController(rootViewController: login)
            nav.navigationBar.isHidden = true
            self.window?.rootViewController = nav
            self.window?.makeKeyAndVisible()
        }
    }
    
    //MARK:- NAVIGATION BAR SETTING
    func setupNavigationController() {
        
        UINavigationBar.appearance().shadowImage = UIImage()
        //        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: UIBarPosition.any, barMetrics: UIBarMetrics.default)
        
        
        //       UINavigationBar.appearance().shadowImage = UIImage()
        //        UINavigationBar.appearance().tintColor = UIColor.clear
        //        UINavigationBar.appearance().barTintColor = UIColor.white
        //        UINavigationBar.appearance().isTranslucent = false
        //        UINavigationBar.appearance().clipsToBounds = false
        
    }
    
    //MARK:- FETCH DATA FROM SEVER
    
    private func FetchDataFromSever() {
        
        if UserDefaults.standard.bool(forKey: UserInfo.isLogedIN.rawValue){
            let _customer = UserDefaults.standard.bool(forKey: EM_API_sync_Keys.custSynced.rawValue)
            let _supplier = UserDefaults.standard.bool(forKey: EM_API_sync_Keys.SuppSynced.rawValue)
            let _route = UserDefaults.standard.bool(forKey: EM_API_sync_Keys.routeSynced.rawValue)
            let _salesRep = UserDefaults.standard.bool(forKey: EM_API_sync_Keys.salesRepSynced.rawValue)
            let _order = UserDefaults.standard.bool(forKey: EM_API_sync_Keys.orderSynced.rawValue)
            
            if _customer && _supplier && _route && _salesRep && _order {
                //WebApiClass.postingToServer()
                Model_Intial_Sync.shared.queue.async {
                    Model_OfflineData.PostOfflineDataToServer()
                }
                //                DispatchQueue.global(qos: .background).async {
                //                    WebApiClass.gettingFromServer()
                //                }
            }else{
                Model_Intial_Sync.shared.queue.async {
                    Model_Intial_Sync.shared.Fetch_Intial_Data()
                }
            }
        }
    }
    
    //MARK:- CHECK INTERNET
    
    func checkForReachability(notification:NSNotification)
    {
        // Remove the next two lines of code. You cannot instantiate the object
        // you want to receive notifications from inside of the notification
        // handler that is meant for the notifications it emits.
        
        //var networkReachability = Reachability.reachabilityForInternetConnection()
        //networkReachability.startNotifier()
        
        let networkReachability = notification.object as! Reachability;
        let remoteHostStatus = networkReachability.currentReachabilityStatus()
        
        if (remoteHostStatus == NotReachable){
            print("Not Reachable")
        }else if (remoteHostStatus == ReachableViaWiFi){
            print("Reachable via Wifi")
            self.methodStartSocketIfNeeded()
            self.FetchDataFromSever()
            
            // CHECK DAY LIMIT
            SocketIOManager.sharedInstance.methodChekDayLimit()
        }else{
            print("Reachable")
            self.methodStartSocketIfNeeded()
            self.FetchDataFromSever()
            
            // CHECK DAY LIMIT
            SocketIOManager.sharedInstance.methodChekDayLimit()

        }
        
        
        NotificationCenter.default.post(name: NSNotification.Name.init("changeUserStatusNotification"), object: nil)
    }
    func methodStartSocketIfNeeded(){
        if UserDefaults.standard.bool(forKey: UserInfo.isLogedIN.rawValue) == true{
            
            if UserDefaults.standard.bool(forKey: "userCheckIn") == true{

                SocketIOManager.sharedInstance.establishConnection(isChecker: true, userType: UserRole(rawValue:UserDefaults.standard.integer(forKey: UserInfo.userTypeID.rawValue)) ?? .none)

                
//                if (UIApplication.topViewController()?.isKind(of: salesMenSocketsDataMap.self))!{
//                    // STAERT CONNECTION
//                    SocketIOManager.sharedInstance.establishConnection(isChecker: true, userType: .salesmen)
//                }
//                if (UIApplication.topViewController()?.isKind(of: adminSocketsDataMap.self))!{
//                    // STAERT CONNECTION
//                    SocketIOManager.sharedInstance.establishConnection(isChecker: true, userType: .admin)
//                }
//                if (UIApplication.topViewController()?.isKind(of: managerSocketsDataMap.self))!{
//                    // STAERT CONNECTION
//                    SocketIOManager.sharedInstance.establishConnection(isChecker: true, userType: .manager)
//                }
                
                // STAERT CONNECTION
               // SocketIOManager.sharedInstance.establishConnection(isChecker: false, userType: SocketIOManager.sharedInstance.userType)
            }
            else{
                
                if (UIApplication.topViewController()?.isKind(of: salesMenSocketsDataMap.self))!{
                    // STAERT CONNECTION
                    SocketIOManager.sharedInstance.establishConnection(isChecker: false, userType: .salesmen)
                }
                if (UIApplication.topViewController()?.isKind(of: adminSocketsDataMap.self))!{
                    // STAERT CONNECTION
                    SocketIOManager.sharedInstance.establishConnection(isChecker: false, userType: .admin)
                }
                if (UIApplication.topViewController()?.isKind(of: managerSocketsDataMap.self))!{
                    // STAERT CONNECTION
                    SocketIOManager.sharedInstance.establishConnection(isChecker: false, userType: .manager)
                }
                
//                if (UIApplication.topViewController()?.isKind(of: salesMenSocketsDataMap.self))!{
//                    // STAERT CONNECTION
//                    SocketIOManager.sharedInstance.establishConnection(isChecker: false, userType: .salesmen)
//                }
//                if (UIApplication.topViewController()?.isKind(of: adminSocketsDataMap.self))!{
//                    // STAERT CONNECTION
//                    SocketIOManager.sharedInstance.establishConnection(isChecker: false, userType: .admin)
//                }
//                if (UIApplication.topViewController()?.isKind(of: managerSocketsDataMap.self))!{
//                    // STAERT CONNECTION
//                    SocketIOManager.sharedInstance.establishConnection(isChecker: false, userType: .manager)
//                }
            }
//            if let userType:UserRole = UserRole(rawValue:UserDefaults.standard.integer(forKey: UserInfo.userTypeID.rawValue)){
//                if (userType == .salesmen){
//                    // CHECK SALES CHECK IN
//
//                }else{
//                    do {
//                        if (UIApplication.topViewController()?.isKind(of: salesMenSocketsDataMap.self))!{
//                            // STAERT CONNECTION
//                            SocketIOManager.sharedInstance.establishConnection(isChecker: false, userType: SocketIOManager.sharedInstance.userType)
//                        }
//                    } catch  {
//                        print("SOCKET CLASS ETTOR FOUND")
//                    }
//                }
//            }
        }
        
    }
    
    func checkUserLocation() -> Bool {
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
            return true
        }else{
            return false
        }
    }
    
    func methodAddLocalNotification(strText:String){
        let localNotification = UILocalNotification()
        localNotification.fireDate = NSDate(timeIntervalSinceNow: 5) as Date
        localNotification.alertBody = strText
        localNotification.timeZone = NSTimeZone.default
        localNotification.applicationIconBadgeNumber = UIApplication.shared.applicationIconBadgeNumber + 1
        localNotification.userInfo = ["type": "flash"]
        UIApplication.shared.scheduleLocalNotification(localNotification)
    }
}

extension AppDelegate:CLLocationManagerDelegate{
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let locValue:CLLocationCoordinate2D = manager.location?.coordinate else {return}
        
        self.userCurrentLatitude = locValue.latitude
        self.userCurrentLongitude = locValue.longitude
        
        print("=============locations = \(locValue.latitude) \(locValue.longitude)")
        if(isLocationNeedToContinue==true){
            
        }else{
            manager.stopUpdatingLocation()
            self.locationManager.stopUpdatingLocation()
            
        }
        
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("---------- " + error.localizedDescription)
    }
    
    func resetUserLatLong()  {
        self.userCurrentLatitude = 0.0
        self.userCurrentLongitude = 0.0
    }
}

