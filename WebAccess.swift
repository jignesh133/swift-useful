//
//  appApiConstant.swift
//  OrangeWill
//
//  Created by Hupp Technologies on 27/05/17.
//  Copyright © 2017 Hupp Technologies. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class WebAccess: NSObject {
    
    //TIME STAMP VARIABLE
    public static var apiTimeStamp = String()
    
    public static var statusActive = 1
    public static var statusInactive = 2
    public static var statusArchive = 7
    
    public static var statusNameActive = "active"
    public static var statusNameInactive = "inactive"
    public static var statusNameArchive = "archive"
    public static var statusNamePending = "pending"
    
    public static var paginingSize = 8
    public static var maximumQty = 99999
    
    // ORDER
    public static var statusNamePlaced = "Placed"
    
    //MARK:- API URLS
    //static let reachabilityManager = Alamofire.NetworkReachabilityManager(host: "https://54.169.1.230/")

   // static let BASE_URL_SOCKET:String = "http://52.66.9.121:8080/"
    //static let BASE_URL_SOCKET:String = "http://192.168.1.105:5000/"
//    static let BASE_URL_SOCKET:String = "http://13.232.28.179:8080/"
 //   static let BASE_URL_SOCKET:String = "http://13.233.227.213:8080/"
    static let BASE_URL_SOCKET:String = "http://live-tracking-33saf.salestrendz.com:8080/"

  
    
   // static let BASE_URL:String = "http://php-cghw.hupp.in/orangewill-lv/"
//  static let BASE_URL:String = "http://ow-api-v2.orangewill.com/api/"
//   static let BASE_URL:String = "http://php-cghw.hupp.in/salestrendz-lv/"
  //  static let BASE_URL:String = "http://ow-api-v2.salestrendz.com/api/"
//    static let BASE_URL:String = "http://ec2-13-234-33-64.ap-south-1.compute.amazonaws.com/salestrendz-lv/"
        static let BASE_URL:String = "http://ow-api-v2.salestrendz.com/api/"

    
    

    static let LOGIN_URL:String = "signin"
    //static let LOGIN_URL:String = "auth/login"
    static let LOGIN_USER_STATUS:String = "user/getstatus"
    static let CHANGE_USER_NUMBER:String = "user/change/number"
    static let REQUEST_OTP:String = "register/request/otp"
    static let VERIFY_OTP:String = "register/verify/otp"

    static let CUST_SUPP_PRODUCT:String = "product/lists"

    //list
    static let DEVICE_DETAILS:String = "device/details/insert"
    static let USER_LOGOUT:String = "signout"
    
    // IMAGE ADD
    static let CUSTOMER_IMAGE_INSERT:String = "customer/image/add"
    static let SUPPLIER_IMAGE_INSERT:String = "supplier/image/add"
    static let ADMIN_IMAGE_INSERT:String = "user/image/add"
    static let MANAGER_IMAGE_INSERT:String = "user/image/add"
    static let USER_IMAGE_INSERT:String = "user/image/add"
    static let ORDER_IMAGE_ADD:String = "order/image/add"

    
    // LIVE IMAGE ADD
    static let CUSTOMER_LIVE_IMAGE_INSERT:String = "customer/liveimage/add"
    static let SUPPLIER_LIVE_IMAGE_INSERT:String = "supplier/liveimage/add"

//    // LIVE IMAGE LIST
    static let CUSTOMER_LIVE_IMAGE_LISTS:String = "customer/liveimage/lists"
    static let SUPPLIER_LIVE_IMAGE_LISTS:String = "supplier/liveimage/lists"
    
    static let NOTIFICATION_LIST:String = "notification/getsettings"
    static let NOTIFICATION_SAVE:String = "notification/savesettings"
    
    static let ACTIVITY_LIST:String = "activity/lists"
    static let ACTIVITY_ACTION:String = "activity/action"
    
    static let CUST_TYPEMASTER_SET_ACT:String = "customertype/setactivity"
    static let SUP_TYPEMASTER_SET_ACT:String = "suppliertype/setactivity"
    
    static let SUPPLIER_LIST:String = "supplier/lists"
    static let SUPPLIER_TYPE_MASTER:String = "suppliertype/lists"
    static let ROUTE_LIST:String = "route/lists"
    
    static let ORGANISATION_LIST:String = "organisation/lists"
    static let PRODUCT_LIST:String = "product/lists"
    static let PRODUCT_CAT_LIST:String = "productcategory/lists"
    static let ORDER_LIST:String = "order/lists"
    static let USER_LIST:String = "user/lists"
    static let SALESMAN_LIST: String = "user/lists"
    
    static let CUSTOMERSUPPLIERTYPE_INSERT: String = "customersuppliertype/insert"
    
    //Price list
    static let PRICE_LIST:String = "pricelist/lists"
    
    //activity lists
    static let CUSTOMER_ACTIVITY:String = "customer/activitylst"
    static let SUPPLIER_ACTIVITY:String = "supplier/activitylst"
    static let USER_ACTIVITY:String = "user/activitylst"
    static let USER_SCHEDULE:String = "schedule/lists"
    static let CUSTOMER_COLLECTION_LIST: String = "customer/collection/lists"
    
    //CUSTOMER
    static let CUSTOMER_TYPE_MASTER:String = "customertype/lists"
    static let CUSTOMER_TYPE_EDIT:String = "customertype/edit/form"
    static let CUSTOMER_TYPE_INSERT:String = "customertype/insert"
    
    static let CUSTOMER_LIST:String = "customer/lists"
    static let CUSTOMER_EDIT:String = "customer/edit/save"
    
    static let CUSTOMER_ACTION:String = "customer/action"
    static let CUSTOMER_HIDE_UNHIDE:String = "customer/markhideunhide"
    
    static let CUST_COLLECTION_INSERT:String = "customer/collection/insert"
    static let CUST_RETURN_INSERT:String = "customer/returns/insert"
    static let CUST_STOCK_INSERT:String = "customer/stock/insert"
    
    
    static let CUST_MARK_VISIT:String = "customer/markvisit"
    //static let CUST_SURVEY_LIST:String = "survey/options/lists"
    static let CUST_SURVEY_LIST:String = "survey/lists"
    //static let CUST_SURVEY_OPTION_LIST:String = "allsurvey/lists"
    static let CUST_SURVEY_OPTION_LIST:String = "survey/edit/form"
    static let CUST_SURVEY_INSERT:String = "customer/survey/insert"
    static let CUST_FEEDBACK_INSERT:String = "customer/feedback/insert"
    
    static let CUST_ACCESS_LIST:String = "customer/edit/form"
    static let CUST_ACCESS_REMOVE:String = "customer/removesalesmanrep/access"
    static let CUST_ACCESS_SET:String = "customer/setsalesmanrep/access"
    
    static let CUST_GEOLOCATION_INSERT:String = "setting/setgeolocation"
    static let CUST_GEOLOCATION_LIST:String = "setting/getgeolocation"

    //GPS TRACKING
    static let CUST_NEARLOCATION:String = "customer/nearby/lists"
    static let SUP_NEARLOCATION:String = "supplier/nearby/lists"

    // FLASH MESSAGE
    static let FLASH_MESSAGE_VIEW:String = "flashmsg/view"
    static let FLASH_MESSAGE_INSERT:String = "flashmsg/insert"

    // COMMENT TEXT INSET
    static let COMMENT_MESSAGE_INSERT:String = "comment/insert"
    static let COMMENT_MESSAGE_LIST:String = "comment/internallisting"


  
    //SUPPLIER
    static let SUPP_TYPE_EDIT:String = "suppliertype/edit/form"
    static let SUPP_TYPE_INSERT:String = "suppliertype/insert"
    
    static let SUPP_ACCESS_LIST:String = "supplier/edit/form"
    static let SUPP_ACCESS_REMOVE:String = "supplier/removesupplier/access"
    
    static let SUPP_ACCESS_SET:String = "supplier/setsupplier/access"
    static let SUPPLIER_EDIT:String = "supplier/edit/save"
    
    static let SUPP_MARK_VISIT:String = "supplier/markvisit"
    static let SUPP_STOCK_INSERT:String = "supplier/stock/insert"
    
    static let SUPP_COLLECTION_INSERT:String = "supplier/collection/insert"
    static let SUPP_RETURN_INSERT:String = "supplier/returns/insert"
    
    static let SUPP_FEEDBACK_INSERT:String = "supplier/feedback/insert"
    static let SUPP_SURVEY_INSERT:String = "supplier/survey/insert"
    
    static let SUPP_INVENTORY:String = "supplier/inventory"

    
    //ROUTE
    static let ROUTE_ACCESS_REMOVE:String = "route/removeroute/access"
    static let ROUTE_ACCESS_SET:String = "route/setroute/access"
    static let ROUTE_ACCESS_EDIT:String = "route/edit/form"
    
    //SALEREP
    static let USER_ACCESS_EDIT:String = "user/edit/form"
    static let USER_ACCESS_REMOVE:String = "user/removesalesmanrep/access"
    static let USER_ACCESS_SET:String = "user/setsalesmanrep/access"
    
    //ORDER
    static let ORDER_MARK_ORD:String = "order/markord"
    static let ORDER_ACTION:String = "order/action"
    static let ORDER_EDIT:String = "order/edit/form"
    
    //FREE SAMPLE
    static let FREE_SAMPLE_INSERT:String = "freesample/insert"
    
    //insert
    static let USER_INSERT:String = "user/insert"
    static let ROUTE_INSERT:String = "route/insert"
    static let CUSTOMER_INSERT:String = "customer/insert"
    static let ORGANISATION_INSERT:String = "organisation/insert"
    static let ORDER_INSERT:String = "order/insert"
    static let SUPPLIER_INSERT: String = "supplier/insert"
    static let USER_INSERT_SCHEDULE: String = "schedule/insert"
    static let USER_OFFLINE_JOURNEY_INSERT: String = "offlineLocations"
    
    //Edit
    static let ROUTE_EDIT:String = "route/edit/save"
    static let USER_EDIT:String = "user/edit/save"
    
    //ACTION
    static let SUPPPLIER_ACTION:String = "supplier/action"
    static let ROUTE_ACTION:String = "route/action"
    static let USER_ACTION:String = "user/action"
    static let SUPPLIER_HIDE_UNHIDE:String = "supplier/markhideunhide"
    static let SCHEDULE_ACTION:String = "schedule/action"
    
    
    // CHECK IN CHECK OUT
    static let USER_CHECKIN:String = "user/checkin"
    static let USER_CHECKOUT:String = "user/checkout"
    static let USER_CHECKIN_IMAGE:String = "user/checkin/image"
    
    
    // MARK: - No Internet Connection
    static func checkInternetConnection() -> NetworkConnection {
        if CheckNetwork.isNetworkAvailable() {
            return .available
        }
        return .notAvailable
    }
    
    //MARK:- Post method
    
    static func executeRequestWithImage(method:HTTPMethod,restUrl:String,param:[String:Any]?,image:UIImage?,imagekey:String?, completionHander:@escaping ((_ isSuccess: Bool, _ response: [String: Any]?) -> ())) {
        let myUrl = try! URLRequest(url: BASE_URL+restUrl, method: method, headers: AppGlobelValues.sharedObj.headers)
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                
                if image != nil {
                    if let imageData = UIImageJPEGRepresentation(image!, 0.6)  {
                        
                        let stringFromDate = Date().iso8601    // "2016-06-18T05:18:27.935Z"
                        let strImageName: String?
                        if let dateFromString = stringFromDate.dateFromISO8601 {
                            strImageName = "img"+"\(dateFromString.iso8601)"+".jpg"
                            //                             lblOTPLabel.text = "Your verificaion code is " + "\(key)"
                        }
                        else{
                            strImageName = "img.jpg"
                        }
                        
                        multipartFormData.append(imageData, withName:imagekey!, fileName: strImageName!, mimeType: "image/jpg")
                    }
                }
                
                if param != nil
                {
                    for (key, value) in param! {
                        multipartFormData.append((value as! String).data(using: String.Encoding.utf8)!, withName: key)
                    }
                    
                    
                }
                
        },
            with: myUrl,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        switch response.result {
                        case .success(let response):
                            if let responseDict = response as? [String: Any]
                            {
                                if let status : Bool = responseDict["success"] as? Bool
                                {
                                    if status {
                                        completionHander(true, responseDict)
                                    }
                                    else {
                                        var otherProblem : [String: String] = [:]
                                        otherProblem["message"] = "Err"
                                        completionHander(false, otherProblem as [String : Any]?)
                                    }
                                }
                            }
                            break
                        default:
                            var otherProblem : [String: String] = [:]
                            otherProblem["message"] = "Err"
                            completionHander(false, otherProblem as [String : Any]?)
                            
                            break
                        }
                    }
                default:
                    var otherProblem : [String: String] = [:]
                    otherProblem["message"] = "Err"
                    completionHander(false, otherProblem as [String : Any]?)
                    
                    break
                }
        })
    }
    static func executeRequest(method:HTTPMethod,restUrl:String,param:[String:Any]?,completionHander:@escaping ((_ isSuccess: Bool, _ response: [String: Any]?) -> ())) {
        
        switch checkInternetConnection() {
        case .available:
            break
        case .notAvailable:
            var otherProblem : [String: String] = [:]
            otherProblem["error"] = INTERNET_NOT_AVAILABLE
            completionHander(false, otherProblem as [String : Any]?)
            return
        }
        Alamofire.request(
            URL(string: BASE_URL+restUrl)!,
            method: method,
            parameters: param,
             headers:AppGlobelValues.sharedObj.headers)
            .validate(statusCode: 200..<600)
            .responseJSON { (response) -> Void in
                
                guard response.result.isSuccess else {
                    var otherProblem : [String: String] = [:]
                    otherProblem["error"] = String(describing: response.result.error!.localizedDescription.description)
                    completionHander(false, otherProblem as [String : Any]?)
                    return
                }
                
                guard let value = response.result.value as? [String: Any],
                    let success = value["success"] as? Bool , let jsonData = value["response"] as? [String:Any] else {
                        var otherProblem : [String: String] = [:]
                        otherProblem["error"] = "Malformed data received"
                        completionHander(false, otherProblem as [String : Any]?)
                        return
                }
                if success{
                    self.apiTimeStamp = getStringFromAny(value["mdf_dt_time"] ?? "")
                    completionHander(true,jsonData)
                    return
                }
                else{
                    if let errorMsg = jsonData["message"] as? String{
                        var otherProblem : [String: String] = [:]
                        otherProblem["error"] = errorMsg
                        completionHander(false, otherProblem as [String : Any]?)
                        return
                    }
                    else{
                        //print(jsonData["message"])
                        if let errorMsg = jsonData["message"] as? NSDictionary{
                            
                            if let userPassMsg = errorMsg["user_number"] as? NSArray{
                                var otherProblem : [String: String] = [:]
                                otherProblem["error"] = userPassMsg.firstObject as? String
                                completionHander(false, otherProblem as [String : Any]?)
                                return
                            }
                            if let userMailMsg = errorMsg["user_mail"] as? NSArray{
                                var otherProblem : [String: String] = [:]
                                otherProblem["error"] = userMailMsg.firstObject as? String
                                completionHander(false, otherProblem as [String : Any]?)
                                return
                            }
                            else{
                                var otherProblem : [String: String] = [:]
                                otherProblem["error"] = ERROR_MSG_1
                                completionHander(false, otherProblem as [String : Any]?)
                            }
                            
                        }
                        else{
                            var otherProblem : [String: String] = [:]
                            otherProblem["error"] = ERROR_MSG_1
                            completionHander(false, otherProblem as [String : Any]?)
                        }
                    }
                }
        }
        
    }
    // NOHEADER
    static func getDataWith(_Url:String,_parameters:[String:Any], completion: @escaping(Json_Result<[[String:Any]]>) -> Void) {
        
        switch checkInternetConnection() {
        case .notAvailable:
            DispatchQueue.main.async {
                completion(.Error(INTERNET_NOT_AVAILABLE))
            }
            return
        case .available:
            break
        }
        
        let queryString = _parameters.queryString
        
        let urlStr = "\(WebAccess.BASE_URL)\(_Url)?\(queryString)"
        
       
        guard let _url = URL.init(string: urlStr) else {
            DispatchQueue.main.async {
                completion(.Error("Url not valid."))
            }
            return
        }
        
        let session = URLSession.shared
        var request = URLRequest.init(url: _url)
        request.httpMethod = "GET"
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-type")
        request.setValue(UserDefaults.standard.value(forKey: UserInfo.bearerToken.rawValue) as? String ?? "", forHTTPHeaderField: "Authorization")
        session.dataTask(with: request) { (Data, response, error) in
            
            guard let data = Data , error == nil else {
                DispatchQueue.main.async {
                    completion(.Error("\(error?.localizedDescription ?? "")"))
                }
                return
            }
            
            guard let json = try? JSONSerialization.jsonObject(with: data, options: []) else {
                DispatchQueue.main.async {
                    completion(.Error("Invalid Response."))
                }
                return
            }
            
            guard let jsonRespons = json as? [String:Any] else {
                DispatchQueue.main.async {
                    completion(.Error("Invalid Response."))
                }
                return
            }
            
            guard let responseData = jsonRespons["response"] as? [String: Any] else {
                DispatchQueue.main.async {
                    completion(.Error("Invalid Response."))
                }
                return
            }
            
            guard let resultData = responseData["result"] as? [[String: Any]] else {

                DispatchQueue.main.async {
                    completion(.Error("Invalid Response."))
                }
                return
            }
            
            DispatchQueue.main.async {
                self.apiTimeStamp = getStringFromAny(jsonRespons["mdf_dt_time"] ?? "")
                completion(.Success(resultData))
            }
            
            }.resume()
        
        
    }
    
    static func postDataWith(_Url:String,_parameters:[String:Any], completion: @escaping(Json_Result<[[String:Any]]>) -> Void) {
        
        switch checkInternetConnection() {
        case .notAvailable:
            completion(.Error(INTERNET_NOT_AVAILABLE))
            return
        case .available:
            break
        }
        
        let jsonData = try? JSONSerialization.data(withJSONObject: _parameters)
        
        guard let urlString = URL.init(string: WebAccess.BASE_URL + _Url) else {
            return completion(.Error("Url not valid."))
        }
        
        var request = URLRequest(url: urlString)
        request.httpMethod = "POST"
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-type")
        request.setValue(UserDefaults.standard.value(forKey: UserInfo.bearerToken.rawValue) as? String ?? "", forHTTPHeaderField: "Authorization")
        
        request.httpBody = jsonData
        
        let session = URLSession.shared
        session.dataTask(with: request) { (Data, response, error) in
            
            guard let data = Data , error == nil else {
                DispatchQueue.main.async {
                    completion(.Error("\(error?.localizedDescription ?? "")"))
                }
                return
            }
            
            guard let json = try? JSONSerialization.jsonObject(with: data, options: []) else {
                DispatchQueue.main.async {
                    completion(.Error("Invalid Response."))
                }
                return
            }
            
            guard let jsonRespons = json as? [String:Any] else {
                DispatchQueue.main.async {
                    completion(.Error("Invalid Response."))
                }
                return
            }
            
            guard let responseData = jsonRespons["response"] as? [String: Any] else {
                DispatchQueue.main.async {
                    completion(.Error("Invalid Response."))
                }
                return
            }
            
            guard let resultData = responseData["result"] as? [[String: Any]] else {
                DispatchQueue.main.async {
                    completion(.Error("Invalid Response."))
                }
                return
            }
            
            DispatchQueue.main.async {
                completion(.Success(resultData))
            }
            
            }.resume()
        
        
    }
    
    static func postDataWith2(_Url:String,_parameters:[String:Any], completion: @escaping(Json_Result<[String:Any]>) -> Void) {
        
       
        switch checkInternetConnection() {
            
        case .notAvailable:
            completion(.Error(INTERNET_NOT_AVAILABLE))
            return
        case .available:
            break
        }
        
        let jsonData = try? JSONSerialization.data(withJSONObject: _parameters)
        
        guard let urlString = URL.init(string: WebAccess.BASE_URL + _Url) else {
            return completion(.Error("Url not valid."))
        }
        
        var request = URLRequest(url: urlString)
        request.httpMethod = "POST"
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-type")
        request.setValue(UserDefaults.standard.value(forKey: UserInfo.bearerToken.rawValue) as? String ?? "", forHTTPHeaderField: "Authorization")

        request.httpBody = jsonData
        
        let session = URLSession.shared
        session.dataTask(with: request) { (Data, response, error) in
            
            guard let data = Data , error == nil else {
                DispatchQueue.main.async {
                    completion(.Error("\(error?.localizedDescription ?? "")"))
                }
                return
            }
            
            guard let json = try? JSONSerialization.jsonObject(with: data, options: []) else {
                DispatchQueue.main.async {
                    completion(.Error("Invalid Response."))
                }
                return
            }
            
            guard let jsonRespons = json as? [String:Any] else {
                DispatchQueue.main.async {
                    completion(.Error("Invalid Response."))
                }
                return
            }
            
            guard let responseData = jsonRespons["response"] as? [String: Any] else {
                DispatchQueue.main.async {
                    completion(.Error("Invalid Response."))
                }
                return
            }
            
            guard let success = jsonRespons["success"] as? Bool else {
                DispatchQueue.main.async {
                    completion(.Error("Invalid Response."))
                }
                return
            }
        
            if success {
                                    DispatchQueue.main.async {
                                        completion(.Success(responseData))
                                    }
            }else{
                DispatchQueue.main.async {
                    completion(.Error(responseData["message"] as? String ?? ""))
                }
            }
            
            }.resume()
        
        
    }
    //MARK:- GET
    // NO HERADER
    static func getRequest(_Url:String,_parameters:[String:Any], completion: @escaping(Json_Result<[[String:Any]]>) -> Void) {
        
        let networkStatus = CheckNetwork.isNetworkAvailable()
        
        guard networkStatus else {
            OperationQueue.main.addOperation({
                completion(.Error(INTERNET_NOT_AVAILABLE))
            })
            return
        }
        print("statement executed when internet is not availbale")
        
        let queryString = _parameters.queryString
        
        let urlStr = "\(WebAccess.BASE_URL)\(_Url)?\(queryString)"
        
        guard let mainUrl = URL.init(string: urlStr) else {
            OperationQueue.main.addOperation({
                completion(.Error("Url is not valid."))
            })
            return
        }
        
        var request = URLRequest.init(url: mainUrl)
        request.httpMethod = "GET"
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-type")
        request.setValue(UserDefaults.standard.value(forKey: UserInfo.bearerToken.rawValue) as? String ?? "", forHTTPHeaderField: "Authorization")

        
        
        let config = URLSessionConfiguration.default
        let session = URLSession.init(configuration: config)
        
        let task = session.dataTask(with: request) { (Data, response, error) in
            guard let data = Data , error == nil else {
                OperationQueue.main.addOperation({
                    completion(.Error("Error while fetching Data."))
                })
                return
            }
            
            guard let json = try? JSONSerialization.jsonObject(with: data, options: []) else {
                OperationQueue.main.addOperation({
                    completion(.Error("Invalid Response."))
                })
                return
            }
            
            guard let jsonRespons = json as? [String:Any] else {
                OperationQueue.main.addOperation({
                    completion(.Error("Invalid Response."))
                })
                return
            }
            
            guard let responseData = jsonRespons["response"] as? [String: Any] else {
                OperationQueue.main.addOperation({
                    completion(.Error("Invalid Response."))
                })
                return
            }
            
            guard let resultData = responseData["result"] as? [[String: Any]] else {
                OperationQueue.main.addOperation({
                    completion(.Error("Invalid Response."))
                })
                return
            }
            //var dictionayData = resultData
            //dictionayData["mdf_dt_time"] = jsonRespons["mdf_dt_time"]
            
            OperationQueue.main.addOperation({
                completion(.Success(resultData))
            })
            return
            
        }
        
        task.resume()
        
    }
    
    //MARK:- POST IMAGES
    class func uploadImage(img:UIImage,parameters:[String:Any],strUrl:String,completion: @escaping(Json_Result<[String:Any]>) -> Void){
        let headers: HTTPHeaders = [
            "Content-type": "multipart/form-data",
            "Authorization":UserDefaults.standard.value(forKey: UserInfo.bearerToken.rawValue) as? String ?? ""
        ]
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(UIImageJPEGRepresentation(img, 1)!, withName: "image", fileName: "photo\(arc4random()).jpg", mimeType: "image/jpeg")
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
            }}, to:strUrl,method: .post, headers: headers) { (encodingResult) in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        switch response.result {
                        case .success(let response):
                            if let responseDict = response as? [String: Any]{
                                if let status : Bool = responseDict["success"] as? Bool{
                                    if status {
                                        DispatchQueue.main.async {
                                            completion(.Success(responseDict))
                                        }
                                    }else {
                                        var otherProblem : [String: String] = [:]
                                        otherProblem["message"] = "Err"
                                        DispatchQueue.main.async {
                                            completion(.Error("Invalid Response."))
                                        }
                                    }
                                }
                            }
                            break
                        default:
                            var otherProblem : [String: String] = [:]
                            otherProblem["message"] = "Err"
                            DispatchQueue.main.async {
                                completion(.Error("Invalid Response."))
                            }
                            break
                        }
                    }
                case .failure(let encodingError):
                    print(encodingError)
                }
        }
    }

    public func uploadImage1(_Url:String,_imgData:Data,_parameters:[String:Any], completion: @escaping(Json_Result<[String:Any]>) -> Void) {
        if CheckNetwork.isNetworkAvailable() {
        }else{
            completion(.Error(INTERNET_NOT_AVAILABLE))
            return
        }
        let request = try? createRequest(parameters: _parameters, _url: WebAccess.BASE_URL + _Url, _imgData: _imgData)
        guard let _request = request  else {
            completion(.Error("Request not send."))
            return
        }
        
        let session = URLSession.shared
        session.dataTask(with: _request) { (Data, response, error) in
            guard let data = Data , error == nil else {
                DispatchQueue.main.async {
                    completion(.Error("\(error?.localizedDescription ?? "")"))
                }
                return
            }
            
            guard let json = try? JSONSerialization.jsonObject(with: data, options: []) else {
                DispatchQueue.main.async {
                    completion(.Error("Invalid Response."))
                }
                return
            }
            
            guard let jsonRespons = json as? [String:Any] else {
                DispatchQueue.main.async {
                    completion(.Error("Invalid Response."))
                }
                return
            }
            
            guard let responseData = jsonRespons["response"] as? [String: Any] else {
                DispatchQueue.main.async {
                    completion(.Error("Invalid Response."))
                }
                return
            }
            
            guard let success = jsonRespons["success"] as? Bool else {
                DispatchQueue.main.async {
                    completion(.Error("Invalid Response."))
                }
                return
            }
            if success {
                DispatchQueue.main.async {
                    completion(.Success(responseData))
                }
            }else{
                DispatchQueue.main.async {
                    completion(.Error(responseData["message"] as? String ?? ""))
                }
            }
            
            }.resume()
        
        
    }
    
    
    private func createRequest(parameters: [String : Any] , _url:String , _imgData:Data) throws -> URLRequest {
        
        let boundary = generateBoundaryString()
        
        let url = URL(string: _url)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.setValue(UserDefaults.standard.value(forKey: UserInfo.bearerToken.rawValue) as? String ?? "", forHTTPHeaderField: "Authorization")

        request.httpBody = try createBody(parameters: parameters, filePathKey: "file", imgData: _imgData, boundary: boundary)
        
        return request
    }
    
    
    private func createBody(parameters: [String: Any]?, filePathKey: String, imgData: Data, boundary: String) throws -> Data {
        var body = Data()
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.append("--\(boundary)\r\n")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.append("\(value)\r\n")
            }
        }
        
        let mimetype = "image/jpg"
        
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"\(filePathKey)\"; filename=\"\(Date().getTimeStamp).jpg\"\r\n")
        body.append("Content-Type: \(mimetype)\r\n\r\n")
        body.append(imgData)
        body.append("\r\n")
        
        body.append("--\(boundary)--\r\n")
        return body
    }
    
    /// Create boundary string for multipart/form-data request
    ///
    /// - returns:            The boundary string that consists of "Boundary-" followed by a UUID string.
    
    private func generateBoundaryString() -> String {
        return "Boundary-\(UUID().uuidString)"
    }
    
    
    static func executePostRequest(restUrl:String,param:[String:Any]?,completionHander:@escaping ((_ isSuccess: Bool, _ response: [String: Any]?) -> ())) {
        
        switch checkInternetConnection() {
        case .available:
            break
        case .notAvailable:
            var otherProblem : [String: String] = [:]
            otherProblem["error"] = INTERNET_NOT_AVAILABLE
            completionHander(false, otherProblem as [String : Any]?)
            return
        }
        
        //        Alamofire.request(
        //            URL(string: BASE_URL+restUrl)!,
        //            method: .post,
        //            parameters: param)
        Alamofire.request(BASE_URL+restUrl, method: .post, parameters: param, encoding: JSONEncoding(options: []),headers: AppGlobelValues.sharedObj.headers).responseJSON { (response) -> Void in
            
            guard response.result.isSuccess else {
                var otherProblem : [String: String] = [:]
                otherProblem["error"] = String(describing: response.result.error!.localizedDescription.description)
                completionHander(false, otherProblem as [String : Any]?)
                return
            }
            
            guard let value = response.result.value as? [String: Any],
                let success = value["success"] as? Bool , let jsonData = value["response"] as? [String:Any] else {
                    var otherProblem : [String: String] = [:]
                    otherProblem["error"] = "Malformed data received"
                    completionHander(false, otherProblem as [String : Any]?)
                    return
            }
            if success{
                self.apiTimeStamp = getStringFromAny(value["mdf_dt_time"] ?? "")
                completionHander(true,jsonData)
                return
            }
            else{
                if let errorMsg = jsonData["message"] as? String{
                    var otherProblem : [String: String] = [:]
                    otherProblem["error"] = errorMsg
                    completionHander(false, otherProblem as [String : Any]?)
                    return
                }
                else{
                    //print(jsonData["message"])
                    if let errorMsg = jsonData["message"] as? NSDictionary{
                        
                        if let userPassMsg = errorMsg["user_number"] as? NSArray{
                            var otherProblem : [String: String] = [:]
                            otherProblem["error"] = userPassMsg.firstObject as? String
                            completionHander(false, otherProblem as [String : Any]?)
                            return
                        }
                        if let userMailMsg = errorMsg["user_mail"] as? NSArray{
                            var otherProblem : [String: String] = [:]
                            otherProblem["error"] = userMailMsg.firstObject as? String
                            completionHander(false, otherProblem as [String : Any]?)
                            return
                        }
                        else{
                            var otherProblem : [String: String] = [:]
                            otherProblem["error"] = ERROR_MSG_1
                            completionHander(false, otherProblem as [String : Any]?)
                        }
                        
                    }
                    else{
                        var otherProblem : [String: String] = [:]
                        otherProblem["error"] = ERROR_MSG_1
                        completionHander(false, otherProblem as [String : Any]?)
                    }
                }
            }
        }
        
    }
    
}



extension Data {
    
    /// Append string to Data
    ///
    /// Rather than littering my code with calls to `data(using: .utf8)` to convert `String` values to `Data`, this wraps it in a nice convenient little extension to Data. This defaults to converting using UTF-8.
    ///
    /// - parameter string:       The string to be added to the `Data`.
    
    mutating func append(_ string: String, using encoding: String.Encoding = .utf8) {
        if let data = string.data(using: encoding) {
            append(data)
        }
    }
}
