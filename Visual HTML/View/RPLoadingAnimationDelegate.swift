//
//  RPLoadingAnimationDelegate.swift
//  Visual HTML
//
//  Created by 强巍 on 2018/3/18.
//  Copyright © 2018年 WeiQiang. All rights reserved.
//

import UIKit

protocol RPLoadingAnimationDelegate: class {
    func setup(_ layer: CALayer, size: CGSize, colors: [UIColor])
}
