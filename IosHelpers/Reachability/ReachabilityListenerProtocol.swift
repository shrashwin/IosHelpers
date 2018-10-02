//
//  ReachabilityListenerProtocol.swift
//  IosHelpers
//
//  Created by Insight Workshop on 10/2/18.
//  Copyright © 2018 Insight Workshop. All rights reserved.
//

import Foundation
import ReachabilitySwift

/// Protocol for listenig network status change
public protocol NetworkStatusListener : class {
    func networkStatusDidChange(status: Reachability.NetworkStatus)
}
