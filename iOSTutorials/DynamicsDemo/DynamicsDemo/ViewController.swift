//
//  ViewController.swift
//  DynamicsDemo
//
//  Created by 葛佳佳 on 2017/2/22.
//  Copyright © 2017年 葛佳佳. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollisionBehaviorDelegate {

    var animator: UIDynamicAnimator!
    var gravity: UIGravityBehavior!
    var collision: UICollisionBehavior!
    var firstContact = false
    var square: UIView!
    var snap: UISnapBehavior!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        square = UIView.init(frame: CGRect(x: 100, y: 100, width: 100, height: 100));
        square.backgroundColor = UIColor.gray
        view.addSubview(square)
        
        let barrier = UIView(frame: CGRect(x: 0, y: 300, width: 130, height: 20))
        barrier.backgroundColor = UIColor.red
        view.addSubview(barrier)

        
        animator = UIDynamicAnimator.init(referenceView: view)
        
        gravity = UIGravityBehavior.init(items: [square])
        animator.addBehavior(gravity)
        
//        collision = UICollisionBehavior.init(items: [square, barrier])
        collision = UICollisionBehavior.init(items: [square])
        collision.addBoundary(withIdentifier: "barrier" as NSCopying, for: UIBezierPath.init(rect: barrier.frame))
        collision.translatesReferenceBoundsIntoBoundary = true
        animator.addBehavior(collision)
        
//        collision.action = {
//            print("\(NSStringFromCGAffineTransform(square.transform)) \(NSStringFromCGPoint(square.center))")
//        }
        collision.collisionDelegate = self
        
        let itemBehaviour = UIDynamicItemBehavior(items: [square])
        itemBehaviour.elasticity = 0.6
        animator.addBehavior(itemBehaviour)
        
//        var updateCount = 0
//        collision.action = {
//            if (updateCount % 3 == 0) {
//                let outline = UIView(frame: square.bounds)
//                outline.transform = square.transform
//                outline.center = square.center
//                
//                outline.alpha = 0.5
//                outline.backgroundColor = UIColor.clear
//                outline.layer.borderColor = square.layer.presentation()?.backgroundColor
//                outline.layer.borderWidth = 1.0
//                self.view.addSubview(outline)
//            }
//            
//            updateCount += 1
//        }
    }

    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, at p: CGPoint) {
        print("Boundary contact occurred - \(identifier)")
        let collidingView = item as! UIView
        collidingView.backgroundColor = UIColor.yellow
        UIView.animate(withDuration: 0.3) { 
            collidingView.backgroundColor = UIColor.gray
        }
        
        if (!firstContact) {
            firstContact = true
            
            let square = UIView(frame: CGRect(x: 30, y: 0, width: 100, height: 100))
            square.backgroundColor = UIColor.gray
            view.addSubview(square)
            
            collision.addItem(square)
            gravity.addItem(square)
            
            let attach = UIAttachmentBehavior(item: collidingView, attachedTo:square)
            animator.addBehavior(attach)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if snap != nil {
            animator.removeBehavior(snap)
        }
        
        let touch = touches.first! as UITouch
        snap = UISnapBehavior(item: square, snapTo: touch.location(in: view))
        animator.addBehavior(snap)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

