//
//  UIBarItem.swift
//  ReactiveControl
//
//  Created by Zhixuan Lai on 1/8/15.
//  Copyright (c) 2015 Zhixuan Lai. All rights reserved.
//

import UIKit

public extension UIBarButtonItem {
    
    convenience init(barButtonSystemItem systemItem: UIBarButtonSystemItem, action: @escaping (UIBarButtonItem) -> ()) {
        self.init(barButtonSystemItem: systemItem, target: nil, action: nil)
        addAction(action)
    }
    
    convenience init(title: String?, style: UIBarButtonItemStyle, action: @escaping (UIBarButtonItem) -> ()) {
        self.init(title: title, style: style, target: nil, action: nil)
        addAction(action)
    }
    
    convenience init(image: UIImage?, style: UIBarButtonItemStyle, action: @escaping (UIBarButtonItem) -> ()) {
        self.init(image: image, style: style, target: nil, action: nil)
        addAction(action)
    }
    
    convenience init(image: UIImage?, landscapeImagePhone: UIImage?, style: UIBarButtonItemStyle, action: @escaping (UIBarButtonItem) -> ()) {
        self.init(image: image, landscapeImagePhone: landscapeImagePhone, style: style, target: nil, action: nil)
        addAction(action)
    }
    
    func addAction(_ action: @escaping (UIBarButtonItem) -> ()) {
        removeAction()
        
        proxyTarget = ProxyTarget(action: action)
        self.target = proxyTarget
        self.action = proxyTarget?.actionSelector()
    }
    
    private func removeAction() {
        proxyTarget = nil
        self.target = nil
        self.action = nil
    }
}

internal extension UIBarButtonItem { 
    
    typealias ProxyTarget = RUIProxyTarget<UIBarButtonItem>
    
    var proxyTarget: ProxyTarget? {
        get {
            return objc_getAssociatedObject(self, &RUIProxyTargetsKey) as? ProxyTarget
        }
        set {
            objc_setAssociatedObject(self, &RUIProxyTargetsKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
