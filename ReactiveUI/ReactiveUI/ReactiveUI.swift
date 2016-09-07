//
//  UIReactiveControl.swift
//  ReactiveControl
//
//  Created by Zhixuan Lai on 1/8/15.
//  Copyright (c) 2015 Zhixuan Lai. All rights reserved.
//

import UIKit

// associated object keys
internal var RUIProxyTargetsKey: UInt8 = 0

internal class RUIProxyTarget<Sender>: NSObject {
    var action: (Sender) -> ()
    
    init(action: @escaping (Sender) -> () = { _ in }) {
        self.action = action
    }
    
    @objc func performAction(_ control: Any) {
        action(control as! Sender)
    }
    
    func actionSelector() -> Selector {
        return #selector(performAction)
    }
}

internal class RUIProxyTargets<Sender>: NSObject {
    typealias Target = RUIProxyTarget<Sender>
    private typealias Key = UInt
    
    private var targets: [UInt: Target] = [:]
    
    subscript(events: UIControlEvents) -> Target? {
        get { return targets[key(forEvents: events)] }
        set { targets[key(forEvents: events)] = newValue }
    }
    
    var values: [Target] {
        return Array(targets.values)
    }
    
    private func key(forEvents events: UIControlEvents) -> UInt {
        return events.rawValue
    }
}
