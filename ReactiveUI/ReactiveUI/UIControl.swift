//
//  UIControl.swift
//  ReactiveControl
//
//  Created by Zhixuan Lai on 1/8/15.
//  Copyright (c) 2015 Zhixuan Lai. All rights reserved.
//

import UIKit

public extension UIControl {
    
    convenience init(action: @escaping (UIControl) -> (), forControlEvents events: UIControlEvents) {
        self.init()
        addAction(action, forControlEvents: events)
    }

    convenience init(forControlEvents events: UIControlEvents, action: @escaping (UIControl) -> ()) {
        self.init()
        addAction(action, forControlEvents: events)
    }
    
    func addAction(_ action: @escaping (UIControl) -> (), forControlEvents events: UIControlEvents) {
        removeAction(forControlEvents: events)

        let proxyTarget = ProxyTargets.Target(action: action)
        proxyTargets[events] = proxyTarget
        addTarget(proxyTarget, action: proxyTarget.actionSelector(), for: events)
    }
    
    func forControlEvents(_ events: UIControlEvents, addAction action: @escaping (UIControl) -> ()) {
        addAction(action, forControlEvents: events)
    }

    func removeAction(forControlEvents events: UIControlEvents) {
        if let proxyTarget = proxyTargets[events] {
            removeTarget(proxyTarget, action: proxyTarget.actionSelector(), for: events)
            proxyTargets[events] = nil
        }
    }
    
    func actionForControlEvent(_ events: UIControlEvents) -> ((UIControl) -> ())? {
        return proxyTargets[events]?.action
    }
    
    var actions: [(UIControl) -> ()] {
        return proxyTargets.values.map { $0.action }
    }
}

internal extension UIControl {
    
    typealias ProxyTargets = RUIProxyTargets<UIControl>    
    
    var proxyTargets: ProxyTargets {
        get {
            let targets = objc_getAssociatedObject(self, &RUIProxyTargetsKey) as? ProxyTargets
            return targets ?? setProxyTargets(ProxyTargets())
        }
        set {
            setProxyTargets(newValue)
        }
    }
    
    @discardableResult
    private func setProxyTargets(_ newValue: ProxyTargets) -> ProxyTargets {
        objc_setAssociatedObject(self, &RUIProxyTargetsKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return newValue
    }
}
