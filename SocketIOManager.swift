//
//  SocketIOManager.swift
//  SocketChat
//
//  Created by Gabriel Theodoropoulos on 1/31/16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit
import SocketIO
import CoreLocation
import MapKit

protocol delegateSocketMapProtocol{
    func mapDataUpdated(lastLatLongData data:ModelSocketIO)
    func mapUserDisconnect(disconnectLatLongData data:Model_Disconnect)
}

class SocketIOManager: NSObject,CLLocationManagerDelegate {
    
    // SHARED
    static let sharedInstance = SocketIOManager()
    
    // QUE
    let serialQueue1 = DispatchGroup()
    
    // DECLARE DELEGATE
    var delegate:delegateSocketMapProtocol?
    
    // DECLARE VARIABLE
    var socketId:String = ""
    var timer:Timer = Timer()
    var timerTemp:Timer = Timer()
    
    var locationManager:CLLocationManager = CLLocationManager()
    
    var isLocationStarted:Bool = false
    var isEmitIdentityCalled:Bool = false
    var checker:Bool = false
    var userCurrentLatitude:Double  = 0.0
    var userCurrentLongitude:Double = 0.0
    
    var userLastLatitude:Double  = 0.0
    var userLastLongitude:Double = 0.0
    
    
    var disconnectLatLongData:Model_Disconnect?
    var lastLatLongData:ModelSocketIO?
    var userType:UserRole = UserRole.none
    
    var allSocketData:[ModelSocketIO] = [ModelSocketIO]()
    
    // BACKGROUND TASK
    var backgroundTask = UIBackgroundTaskInvalid
    
    
    var socket:SocketIOClient = SocketIOClient(socketURL: URL(string: WebAccess.BASE_URL_SOCKET )!, config: [.log(true), .extraHeaders(["token":"123465"])])
    
    override init() {
        super.init()
    }
    //MARK:- CHECK INTERNET                                                                                                                                                                                                                                                       
    func methodCheckInternet(){
        guard WebAccess.checkInternetConnection() == .available else {
            ShowAlert(title: "", msg: INTERNET_NOT_AVAILABLE, view: UIApplication.topViewController() ?? UIViewController.init())
            return
        }
    }
    // START CONNECTION
    func methodStartLocation(){
        DispatchQueue.main.async {
            if (CLLocationManager.locationServicesEnabled()){
                self.locationManager.delegate = self
                self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
                //                self.locationManager.distanceFilter = 20
                self.locationManager.requestWhenInUseAuthorization()
                self.locationManager.requestAlwaysAuthorization()
                self.locationManager.allowsBackgroundLocationUpdates = true
                self.locationManager.pausesLocationUpdatesAutomatically = false
                self.locationManager.requestLocation()
            }
        }
    }
    
    //MARK:- START CONNECTION
    func establishConnection(isChecker:Bool,userType:UserRole) {
        
        // SET USRER ROLE
        self.userType = userType
        
        // SET CHECKET
        self.checker = isChecker
        
        // START LOCATION
        self.methodStartLocation()
        
        // CHECK INTERNET
        self.methodCheckInternet()
        
        // EMIT IDENTITY CALLED
        self.isEmitIdentityCalled = false
        
        // SOCKET CONNECT
        if(socket.status == .disconnected || socket.status == .notConnected){
            allSocketData.removeAll()
            socket.connect()
        }
        
        print(socket.status)
        print("----------- connetion established -----------")
        
        // PROVIDE IDENTITY
        self.methodprovideIdentity()
        
        // SET ACK IDENTITY
        self.methodprovideidentityAck()
        
        // ADD LISTINER FOR LISTEN
        if (userType == .admin){
            if (self.checker == false){
                // ADMIN LISTINER
                self.methodadminPublishedLocation()
                self.adminDisconnect()
            }
        }
        if (userType == .manager){
            
            if (self.checker == false){
                // MANAGETR LISTINER
                self.methodmanagerPublishedLocation()
                self.managerDisconnect()
            }
            
        }
        if (userType == .superadmin){
            
            if(self.checker == false){
            }
            
        }
        if (userType == .salesmen){
            if(self.checker == false){
                self.methodsalesmanPublishedLocation()
                self.salesmanDisconnect()
            }
        }
        // DISCONNECT METHODS
        self.disconnect()
    }
    
    //MARK:- PROVIDE IDENTITY
    func methodprovideIdentity(){
        
        // CHECK INTERNET
        self.methodCheckInternet()
        
        print("----------- on provideIdentity -----------")
        // ON IDENTITY
        self.socket.on("provideIdentity") { (data, ack) in
            
            if(self.isEmitIdentityCalled == false){
                // EMIT IDENTITY
                self.methodEmitIdentity()
                self.isEmitIdentityCalled = true
            }
            
        }
    }
    
    func methodEmitIdentity(){
        
        // CHECK INTERNET
        self.methodCheckInternet()
        
        print("----------- emit identity ------------------")
        print(AppGlobelValues.sharedObj._Params_SocketIO)
        var param:[String:Any] = AppGlobelValues.sharedObj._Params_SocketIO
        param["checker"] = checker
        
        if userType == .salesmen{
            param["org_id"] = ModelManager.getOrgId()
        }
        print(param)
        // SET IDENTITY
        self.socket.emit("identity", param)
        

    }
    //MARK:- PROVIDE IDENTITY ACK
    func methodprovideidentityAck(){
        
        // CHECK INTERNET
        self.methodCheckInternet()
        
        print("----------- on identityAck ------------------")
        
        self.socket.on("identityAck") { (data, ack) in
            guard data.count > 0 else {
                return
            }
            guard let obj = data[0] as? [String:Any] else{
                return
            }
            self.socketId = obj["socketId"] as? String ?? ""
            
            
            // ADD LISTINER FOR LISTEN
            if (self.checker == true){
                self.startTimer()
            }else{
                let intLoc:[String:Any] = obj["initialLocations"] as? [String:Any] ?? [:]
                if self.userType == .admin{
                    guard let locList:[[String:Any]] = intLoc["adminsInitialLocations"] as? [[String:Any]] else {return}
                    for obj in locList{
                        let objModel =  self.allSocketData.filter({$0.userId == getIntegerFromAny(obj["_id"] ?? 0)})
                        if (objModel.count == 0){
                            
                            var data:[String:Any] = [String:Any]()
                            data["user_id"] = obj["_id"]
                            data["user_fname"] = obj["user_fname"]
                            data["comp_id"] = obj["comp_id"]
                            data["lat"] = obj["lat"]
                            data["long"] = obj["long"] 
                            
                            // MAKE MODEL FROM DATA
                            let model:ModelSocketIO = ModelSocketIO.init(fromDictionary: data)
                            // ADD OBJECT FROM MODEL
                            self.allSocketData.append(model)
                            
                            // PASS TO MAP
                            if(self.delegate != nil){
                                self.lastLatLongData = model
                                self.delegate?.mapDataUpdated(lastLatLongData:self.lastLatLongData!)
                            }
                        }
                    }
                }
                if self.userType == .manager{
                    guard let locList:[[String:Any]] = intLoc["managersInitialLocations"] as? [[String:Any]] else {return}
                    for obj in locList{
                        let objModel =  self.allSocketData.filter({$0.userId == getIntegerFromAny(obj["_id"] ?? 0)})
                        if (objModel.count == 0){
                            var data:[String:Any] = [String:Any]()
                            data["user_id"] = getIntegerFromAny(obj["_id"] ?? 0)
                            data["user_fname"] = getStringFromAny(obj["user_fname"] ?? "")
                            data["comp_id"] = getIntegerFromAny(obj["comp_id"] ?? 0)
                            data["lat"] = getStringFromAny(obj["lat"] ?? "0")
                            data["long"] = getStringFromAny(obj["long"] ?? "0")
                            
                            // MAKE MODEL FROM DATA
                            let model:ModelSocketIO = ModelSocketIO.init(fromDictionary: data)
                            
                            // ADD OBJECT FROM MODEL
                            self.allSocketData.append(model)
                            
                            // PASS TO MAP
                            if(self.delegate != nil){
                                self.lastLatLongData = model
                                self.delegate?.mapDataUpdated(lastLatLongData:self.lastLatLongData!)
                            }
                        }
                    }
                }
                if self.userType == .salesmen{
                    guard let locList:[[String:Any]] = intLoc["salesmenInitialLocations"] as? [[String:Any]] else {return}
                    for obj in locList{
                        let objModel =  self.allSocketData.filter({$0.userId == getIntegerFromAny(obj["_id"] ?? 0)})
                        if (objModel.count == 0){
                            var data:[String:Any] = [String:Any]()
                            data["user_id"] = getIntegerFromAny(obj["_id"] ?? 0)
                            data["user_fname"] = getStringFromAny(obj["user_fname"] ?? "")
                            data["comp_id"] = getIntegerFromAny(obj["comp_id"] ?? 0)
                            data["lat"] = getStringFromAny(obj["lat"] ?? "0")
                            data["long"] = getStringFromAny(obj["long"] ?? "0")
                            
                            // MAKE MODEL FROM DATA
                            let model:ModelSocketIO = ModelSocketIO.init(fromDictionary: data)
                            
                            // ADD OBJECT FROM MODEL
                            self.allSocketData.append(model)
                            
                            // PASS TO MAP
                            if(self.delegate != nil){
                                self.lastLatLongData = model
                                self.delegate?.mapDataUpdated(lastLatLongData:self.lastLatLongData!)
                            }
                        }
                    }
                }
            }
            //            if let userType:UserRole = UserRole(rawValue:UserDefaults.standard.integer(forKey: UserInfo.userTypeID.rawValue)){
            //
            //            }
            //
            // SET SOCKET ID TO USER
            UserDefaults.standard.setValue(self.socketId, forKey: UserInfo.SocketId.rawValue)
            UserDefaults.standard.synchronize()
            
        }
    }
    //MARK:- adminLocation
    func methodadminPublishedLocation(){
        
        // CHECK INTERNET
        self.methodCheckInternet()
        
        print("----------- on publishLocation ------------------")
        // SET IDENTITY
        self.socket.on("adminPublishLocation") { (data, ack) in
            
            guard data.count > 0 else {
                return
            }
            guard let objdata = data[0] as? [String:Any] else{
                return
            }
            guard let obj = objdata["locationAck"] as? [String:Any] else{
                return
            }
            // LAST LAT LONG DATA
            self.lastLatLongData = ModelSocketIO.init(fromDictionary: obj )
            
            let objModel =  self.allSocketData.filter({$0.userId == getIntegerFromAny(obj["userId"] ?? 0)})
            
            if (objModel.count == 0){
                let model = ModelSocketIO.init(fromDictionary: obj)
                self.allSocketData.append(model)
            }
            
            // SEND DATA TO MAP SCREEN FOR SHOW UPDATED LOCATION
            if(self.delegate != nil){
                self.delegate?.mapDataUpdated(lastLatLongData:self.lastLatLongData!)
            }
        }
    }
    //MARK:- publishLocation
    func methodsalesmanPublishedLocation(){
        
        // CHECK INTERNET
        self.methodCheckInternet()
        
        print("----------- on publishLocation ------------------")
        // SET IDENTITY
        self.socket.on("salesmanPublishLocation") { (data, ack) in
            
            guard data.count > 0 else {
                return
            }
            guard let objdata = data[0] as? [String:Any] else{
                return
            }
            guard let obj = objdata["locationAck"] as? [String:Any] else{
                return
            }
            // LAST LAT LONG DATA
            self.lastLatLongData = ModelSocketIO.init(fromDictionary: obj )
            
            let objModel =  self.allSocketData.filter({$0.userId == getIntegerFromAny(obj["userId"] ?? 0)})
            
            if (objModel.count == 0){
                let model = ModelSocketIO.init(fromDictionary: obj)
                self.allSocketData.append(model)
            }
            
            // SEND DATA TO MAP SCREEN FOR SHOW UPDATED LOCATION
            if(self.delegate != nil){
                self.delegate?.mapDataUpdated(lastLatLongData:self.lastLatLongData!)
            }
        }
    }
    
    //MARK:- publishLocation
    func methodmanagerPublishedLocation(){
        
        // CHECK INTERNET
        self.methodCheckInternet()
        
        print("----------- on publishLocation ------------------")
        
        // SET IDENTITY
        self.socket.on("managerPublishLocation") { (data, ack) in
            
            guard data.count > 0 else {
                return
            }
            guard let objdata = data[0] as? [String:Any] else{
                return
            }
            guard let obj = objdata["locationAck"] as? [String:Any] else{
                return
            }
            // LAST LAT LONG DATA
            self.lastLatLongData = ModelSocketIO.init(fromDictionary: obj )
            
            let objModel =  self.allSocketData.filter({$0.userId == getIntegerFromAny(obj["userId"] ?? 0)})
            
            if (objModel.count == 0){
                let model = ModelSocketIO.init(fromDictionary: obj)
                self.allSocketData.append(model)
            }
            
            // SEND DATA TO MAP SCREEN FOR SHOW UPDATED LOCATION
            if(self.delegate != nil){
                self.delegate?.mapDataUpdated(lastLatLongData:self.lastLatLongData!)
            }
        }
    }
    
    //MARK:- METHOD START STOP SCREEN
    func startTimer(){
        
        // PRINT
        print("TIMER STARTED")
        
        // START LOCATION
        guard isLocationStarted == false else {
            return
        }
        isLocationStarted = true
        
        // START LOCATION
        //self.methodStartLocation()
        self.locationManager.requestLocation()
        
        // INIT TIMER
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 5,target: self,selector: #selector(self.methodShareLocation),userInfo: nil,repeats: true)
        }
        
    }
    func stopTimer(){
        isLocationStarted = false
        self.userLastLatitude  = 0.0
        self.userLastLongitude = 0.0
        
        DispatchQueue.main.async {
            self.timer.invalidate()
        }
    }
    
    @objc func methodShareLocation(){
        
        
        let coordinate0 = CLLocation(latitude: self.userCurrentLatitude, longitude: self.userCurrentLongitude)
        let coordinate1 = CLLocation(latitude: self.userLastLatitude, longitude: self.userLastLongitude)
        let distanceInMeters = coordinate0.distance(from: coordinate1)
        
        // REQUEST LOCAOTION
        self.locationManager.requestLocation()
        
        if distanceInMeters.isLessThanOrEqualTo(20){
            return
        }
       
        // CHECK LIMIT
        self.methodChekDayLimit()
        
        if WebAccess.checkInternetConnection() == .available && self.socketId != "" {
            
            var myParam:[String:Any] = [String:Any]()
            myParam["lat"] = self.userCurrentLatitude
            myParam["long"] = self.userCurrentLongitude
            myParam["socketId"] = self.socketId
            myParam["user_id"] = UserDefaults.standard.integer(forKey: UserInfo.user_id.rawValue)
            
            if userType == .salesmen{
                myParam["org_id"] = ModelManager.getOrgId()
            }
            myParam["user_type"] = UserDefaults.standard.integer(forKey:UserInfo.userTypeID.rawValue)
            myParam["comp_id"] = UserDefaults.standard.integer(forKey: UserInfo.company_id.rawValue)
            myParam["user_fname"] = UserDefaults.standard.value(forKey: UserInfo.user_Fname.rawValue) as? String ?? ""
            
            // current time
            myParam["time"] =  (methodGetDate().changeDateFormatWithTimeZone(strDateFormate: "yyyy-MM-dd HH:mm:ss", timeZone: TimeZone.current))
            print("----------- on location ------------------")
            
            // CHECK SOCKET
            if (self.userCurrentLatitude == 0 && self.userCurrentLongitude == 0){
                return;
            }
            
            self.socket.emit("location", myParam)
            //  UIApplication.topViewController()?.methodShowToast(strText: "Location emiting")
            
            // UPDATE LAST LAT LONG
            self.userLastLatitude = self.userCurrentLatitude
            self.userLastLongitude = self.userCurrentLongitude
            
            
        }
        else{
            // GET DATE UTC
            let strDate = methodGetDate().changeDateFormatWithTimeZone(strDateFormate: "yyyy-MM-dd HH:mm:ss", timeZone: TimeZone.init(abbreviation: "UTC")!)
            
            // CREATE OFFLINE DATA ENTRY
            let data:NSMutableDictionary = NSMutableDictionary()
            data.setValue(true, forKey: "isOffline")
            data.setValue(self.userCurrentLatitude, forKey: "lat")
            data.setValue(self.userCurrentLongitude, forKey: "long")
            data.setValue(self.socketId, forKey: "socketId")
            data.setValue(UserDefaults.standard.integer(forKey: UserInfo.user_id.rawValue), forKey: "user_id")
            data.setValue(UserDefaults.standard.integer(forKey: UserInfo.userTypeID.rawValue), forKey: "user_type")
            data.setValue(UserDefaults.standard.integer(forKey: UserInfo.company_id.rawValue), forKey: "comp_id")
            data.setValue(ModelManager.getOrgId(), forKey: "org_id")
            data.setValue(UserDefaults.standard.value(forKey: UserInfo.user_Fname.rawValue) as? String ?? "", forKey: "user_fname")
            data.setValue(strDate, forKey: "time")
            
            // CREATE JOURNEY
            En_SalesMenJourney.createJourneyEntry(dataDict:data )
            
            
        }
    }
    
    //MARK:- EXIT SOCKET
    func viewerExitSocket(){
        
        
        var exitData:[String:Any] = [String:Any]()
        
        var myLocParam:[String:Any] = [String:Any]()
        myLocParam["lat"] = self.userCurrentLatitude
        myLocParam["long"] = self.userCurrentLongitude
        
        exitData["socketId"] = socketId
        
        if userType == .salesmen {
            exitData["location"] = myLocParam
        }
        
        print("----------- on exit ------------------")
        
        self.stopTimer()
        
        self.socket.emit("viewerExit",exitData)
        
        self.methodRemoveListiner()
        
        //self.socket.disconnect()
        
    }
    func methodRemoveListiner(){
        self.socket.off("provideIdentity")
        self.socket.off("identityAck")
        
        self.socket.off("salesmanPublishLocation")
        self.socket.off("salesmanDisconnect")
        
        self.socket.off("adminPublishLocation")
        self.socket.off("adminDisconnect")
        
        self.socket.off("managerPublishLocation")
        self.socket.off("managerDisconnect")
        
    }
    func checkerExitSocket(){
        
        var exitData:[String:Any] = [String:Any]()
        
        var myLocParam:[String:Any] = [String:Any]()
        myLocParam["lat"] = self.userCurrentLatitude
        myLocParam["long"] = self.userCurrentLongitude
        
        exitData["socketId"] = socketId
        exitData["location"] = myLocParam
        
        self.stopTimer()
        
        print("----------- on exit ------------------")
        self.socket.emit("checkerExit",exitData)
        
        self.methodRemoveListiner()
        
        //        self.socket.disconnect()
        
        
    }
    
    
    //MARK:- DISCONNECT
    // WILL CALL WHEN INTERNET DISCONNECT
    func disconnect() {
        print("----------- on disconnect ------------------")
        socket.on("disconnect") { (data, ack) in
            print("**************************** ISSUE FOUND " + getStringFromAny(data) + getStringFromAny(ack))
            //            self.stopTimer()
            //
            //            // self.locationManager.stopUpdatingLocation()
            //            self.socket.disconnect()
            
        }
    }
    
    //MARK:- ADMIN DISCONNECT
    func adminDisconnect(){
        print("----------- on adminDisconnect ------------------")
        socket.on("adminDisconnect") { (data, ack) in
            print(data)
            print("----------- on adminDisconnect ------------------")
            guard data.count > 0 else {
                return
            }
            guard let objdata = data[0] as? [String:Any] else{
                return
            }
            guard let obj = objdata["disconnectedClientInfo"] as? [String:Any] else{
                return
            }
            
            // LAST LAT LONG DATA
            self.disconnectLatLongData = Model_Disconnect.init(fromDictionary: obj )
            
            if(self.delegate != nil){
                self.delegate?.mapUserDisconnect(disconnectLatLongData:self.disconnectLatLongData!)
            }		
            
            // self.closeConnection()
        }
    }
    
    //MARK:- MANAGER DISCONNECT
    func managerDisconnect(){
        print("----------- on managerDisconnect ------------------")
        socket.on("managerDisconnect") { (data, ack) in
            print(data)
            print("----------- on managerDisconnect ------------------")
            guard data.count > 0 else {
                return
            }
            guard let objdata = data[0] as? [String:Any] else{
                return
            }
            guard let obj = objdata["disconnectedClientInfo"] as? [String:Any] else{
                return
            }
            
            // LAST LAT LONG DATA
            self.disconnectLatLongData = Model_Disconnect.init(fromDictionary: obj )
            
            if(self.delegate != nil){
                self.delegate?.mapUserDisconnect(disconnectLatLongData:self.disconnectLatLongData!)
            }
            
            // self.closeConnection()
        }
    }
    
    //MARK:- SALESMAN DISCONNECT
    func salesmanDisconnect(){
        print("----------- on salesmanDisconnect ------------------")
        socket.on("salesmanDisconnect") { (data, ack) in
            print(data)
            print("----------- on salesmanDisconnect ------------------")
            guard data.count > 0 else {
                return
            }
            guard let objdata = data[0] as? [String:Any] else{
                return
            }
            guard let obj = objdata["disconnectedClientInfo"] as? [String:Any] else{
                return
            }
            
            // LAST LAT LONG DATA
            self.disconnectLatLongData = Model_Disconnect.init(fromDictionary: obj )
            
            if(self.delegate != nil){
                self.delegate?.mapUserDisconnect(disconnectLatLongData:self.disconnectLatLongData!)
            }
            
            // self.closeConnection()
        }
    }
    //MARK:- LOCATION UPDATE
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //guard let locValue:CLLocationCoordinate2D = manager.location?.coordinate else {return}
        let locValue = locations.last!
        
        self.userCurrentLatitude = locValue.coordinate.latitude
        self.userCurrentLongitude = locValue.coordinate.longitude
        print("Did update location cassled")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Errors: " + error.localizedDescription)
        
        
        if let clErr = error as? CLError {
            switch clErr {
            case CLError.locationUnknown:
                print("location unknown")
            case CLError.denied:
                print("denied")
            default:
                print("other Core Location error")
            }
        } else {
            print("other error:", error.localizedDescription)
        }
        
    }
    func locationManager(_ manager: CLLocationManager, didFinishDeferredUpdatesWithError error: Error?) {
        print("didFinishDeferredUpdatesWithError: " + (error?.localizedDescription)!)
        // SHOW SOCKET ON
    }
    //MARK:- METHOD DAY LIMIT
    func methodChekDayLimit() {
        let isCheckIn = UserDefaults.standard.bool(forKey: "userCheckIn")
        if isCheckIn == true {
            let checkin:String = UserDefaults.standard.value(forKey: "checkintime") as? String ?? ""
            let arr:[String] = checkin.components(separatedBy: " ")
            if arr.count > 0 {
                let today:String = methodGetDate().changeDateFormatWithTimeZone(strDateFormate: "yyyy-MM-dd", timeZone: TimeZone.current)!
                let checkInTime:String = arr[0]
                if (today != checkInTime){
                    
                    
                    // SET CHECK IN
                    UserDefaults.standard.set(false, forKey: "userCheckIn")
                    UserDefaults.standard.synchronize()
                    
                    // STOP SOCKET IO
                    SocketIOManager.sharedInstance.checkerExitSocket()
                    
                }
            }
        }
        
    }
}
