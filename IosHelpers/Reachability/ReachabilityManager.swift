//
//  ReachabilityManager.swift
//  Ios Helpers
//
//  Created by Insight Workshop on 10/2/18.
//  Copyright © 2018 Insight Workshop. All rights reserved.
//

import Foundation
import ReachabilitySwift

class ReachabilityManager: NSObject {
    
    //shared instance of reachability manager
    static  let shared = ReachabilityManager()
    
    //Boolean to track network reachability
    var isNetworkAvailable : Bool {
        return reachabilityStatus != .notReachable
    }
    //Tracks current NetworkStatus (notReachable, reachableViaWiFi, reachableViaWWAN)
    var reachabilityStatus: Reachability.NetworkStatus = .notReachable
    
    //Reachability instance for Network status monitoring
    let reachability = Reachability()!
    
    //Array of delegates which are interested to listen to network status change
    var listeners = [NetworkStatusListener]()
    
    /// Called whenever there is a change in NetworkReachibility Status
    ///
    /// — parameter notification: Notification with the Reachability instance
    @objc func reachabilityChanged(notification: Notification) {
        
        let reachability = notification.object as! Reachability
        reachabilityStatus = reachability.currentReachabilityStatus
        
        switch reachabilityStatus {
        case .notReachable:
            debugPrint("Network became unreachable")
        case .reachableViaWiFi:
            debugPrint("Network reachable through WiFi")
        case .reachableViaWWAN:
            debugPrint("Network reachable through Cellular Data")
        }
        
        // Sending message to each of the delegates
        for listener in listeners {
            listener.networkStatusDidChange(status: reachabilityStatus)
        }
        
    }
    
    /// Starts monitoring the network availability status
    func startMonitoring() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.reachabilityChanged),
                                               name: ReachabilityChangedNotification,
                                               object: reachability)
        do{
            try reachability.startNotifier()
        } catch {
            debugPrint("Could not start reachability notifier")
        }
    }
    
    /// Stops monitoring the network availability status
    func stopMonitoring(){
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self,
                                                  name: ReachabilityChangedNotification,
                                                  object: reachability)
    }
    
    
    /// Adds a new listener to the listeners array
    ///
    /// - parameter delegate: a new listener
    func addListener(listener: NetworkStatusListener){
        listeners.append(listener)
    }
    
    /// Removes a listener from listeners array
    ///
    /// - parameter delegate: the listener which is to be removed
    func removeListener(listener: NetworkStatusListener){
        listeners = listeners.filter{ $0 !== listener}
    }
    
}
