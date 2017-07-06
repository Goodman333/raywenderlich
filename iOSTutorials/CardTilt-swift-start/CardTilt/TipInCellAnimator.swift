//
//  TipInCellAnimator.swift
//  CardTilt
//
//  Created by 葛佳佳 on 2017/2/28.
//  Copyright © 2017年 RayWenderlich.com. All rights reserved.
//

import UIKit
import QuartzCore

let TipInCellAnimatorStartTransform: CATransform3D = {
    let rotationDegrees: CGFloat = -15.0
    let rotationRadians: CGFloat = rotationDegrees * (CGFloat(M_PI)/180.0)
    let offset = CGPoint.init(x: -20, y: -20)
    var startTransform = CATransform3DIdentity // 2
    startTransform = CATransform3DRotate(CATransform3DIdentity,
                                         rotationRadians, 0.0, 0.0, 1.0) // 3
    startTransform = CATransform3DTranslate(startTransform, offset.x, offset.y, 0.0) // 4
    
    return startTransform
}()


class TipInCellAnimator {
    // placeholder for things to come -- only fades in for now
    class func animate(_ cell:UITableViewCell) {
        let view = cell.contentView
        
        
        // 5
        view.layer.transform = TipInCellAnimatorStartTransform
        view.layer.opacity = 0.8
        
        // 6
        UIView.animate(withDuration: 0.4) {
            view.layer.transform = CATransform3DIdentity
            view.layer.opacity = 1
        }
    }
}
