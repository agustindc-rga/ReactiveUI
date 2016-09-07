//
//  UIGestureRecognizer.swift
//  ReactiveControl
//
//  Created by Zhixuan Lai on 1/8/15.
//  Copyright (c) 2015 Zhixuan Lai. All rights reserved.
//

import UIKit

public extension UIGestureRecognizer {
    
    convenience init(action: @escaping (UIGestureRecognizer) -> ()) {
        self.init()
        addAction(action)
    }

    func addAction(_ action: @escaping (UIGestureRecognizer) -> ()) {
        removeAction()
        
        let target = ProxyTarget(action: action)
        addTarget(target, action: target.actionSelector())
        proxyTarget = target
    }
    
    func removeAction() {
        if let target = proxyTarget {
            removeTarget(target, action: target.actionSelector())
            proxyTarget = nil
        }
    }
}

internal extension UIGestureRecognizer {

    typealias ProxyTarget = RUIProxyTarget<UIGestureRecognizer>
    
    var proxyTarget: ProxyTarget? {
        get {
            return objc_getAssociatedObject(self, &RUIProxyTargetsKey) as? ProxyTarget
        }
        set {
            objc_setAssociatedObject(self, &RUIProxyTargetsKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
