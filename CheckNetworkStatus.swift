//
//  CheckNetwork.swift
//  OrangeWill
//
//  Created by MCA 2 on 30/08/18.
//  Copyright © 2018 Hupp Technologies. All rights reserved.
//

import UIKit

class CheckNetworkStatus: NSObject {

}
//MARK : - Internet errors
enum NetworkConnection {
    case available
    case notAvailable
}

// Network check
struct CheckNetwork {
    // MARK: Reachability class
    static func isNetworkAvailable() -> Bool {
        let reachability: Reachability = Reachability.forInternetConnection()
        let networkStatus = reachability.currentReachabilityStatus().rawValue;
        var isAvailable  = false;
        switch networkStatus {
        case (NotReachable.rawValue):
            isAvailable = false;
            break;
        case (ReachableViaWiFi.rawValue):
            isAvailable = true;
            break;
        case (ReachableViaWWAN.rawValue):
            isAvailable = true;
            break;
        default:
            isAvailable = false;
            break;
        }
        return isAvailable;
    }
}

