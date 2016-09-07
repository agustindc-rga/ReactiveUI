//
//  NSTimer.swift
//  ReactiveUI
//
//  Created by Zhixuan Lai on 2/2/15.
//  Copyright (c) 2015 Zhixuan Lai. All rights reserved.
//

import UIKit

public extension Timer {
    // Big thanks to https://github.com/ashfurrow/Haste
    class func scheduledTimer(timeInterval seconds: TimeInterval, action: @escaping (Timer) -> (), repeats: Bool) -> Timer {
        return scheduledTimer(timeInterval: seconds, 
                              target: self, 
                              selector: #selector(_timerDidFire(_:)), 
                              userInfo: ProxyTarget(action: action), 
                              repeats: repeats)
    }
}

internal extension Timer {
    
    typealias ProxyTarget = RUIProxyTarget<Timer>
    
    class func _timerDidFire(_ timer: Timer) {
        if let proxyTarget = timer.userInfo as? ProxyTarget {
            proxyTarget.performAction(timer)
        }
    }    
}
