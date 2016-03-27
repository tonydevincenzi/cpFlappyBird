//
//  ViewController.swift
//  cpFlappyBird
//
//  Created by Anthony Devincenzi on 3/26/16.
//  Copyright © 2016 Tony DeVincenzi. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollisionBehaviorDelegate {
    
    
    @IBOutlet weak var bird: UIImageView!
    @IBOutlet weak var birdContainer: UIView!
    
    var animator: UIDynamicAnimator!
    var gravity: UIGravityBehavior!
    var push: UIPushBehavior!
    var collision: UICollisionBehavior!
    var timer: NSTimer!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        animator = UIDynamicAnimator(referenceView: self.view)
        gravity = UIGravityBehavior()
        gravity.magnitude = 1
        animator.addBehavior(gravity)

        push = UIPushBehavior()
        push = UIPushBehavior(items: [self.birdContainer], mode: .Instantaneous)
        push.pushDirection = CGVectorMake(0.0, -0.5);
        animator.addBehavior(push)

        gravity.addItem(birdContainer)
        
        collision = UICollisionBehavior()
        collision.collisionDelegate = self
        animator.addBehavior(collision)
        
        collision.addItem(birdContainer)
        
        timer = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: "addPipes", userInfo: nil, repeats: true)
        addPipes()
        
        let tap = UITapGestureRecognizer(target: self, action:Selector("didTapView:"))
        self.view.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addPipes() {
        
        let topPipe = UIImageView(image: UIImage(named: "pipeTop.png"))
        let pipeY = arc4random_uniform(150)
        topPipe.frame = CGRect(x: view.bounds.width, y: -CGFloat(pipeY), width: 52, height: 320)
        view.addSubview(topPipe)
        
        let bottomPipeOffset = arc4random_uniform(50)
        
        let bottomPipe = UIImageView(image: UIImage(named: "pipeBottom.png"))
        bottomPipe.frame = CGRect(x: view.bounds.width, y: topPipe.frame.height + 50 + CGFloat(bottomPipeOffset), width: 52, height: 320)
        view.addSubview(bottomPipe)
        
        let pipeBehavior: UIDynamicItemBehavior = UIDynamicItemBehavior(items: [topPipe, bottomPipe])
        pipeBehavior.addLinearVelocity(CGPoint(x: -70,y: 0), forItem: topPipe)
        pipeBehavior.addLinearVelocity(CGPoint(x: -70,y: 0), forItem: bottomPipe)

        pipeBehavior.friction = 0
        pipeBehavior.resistance = 0
        collision.addItem(topPipe)
        collision.addItem(bottomPipe)
        animator.addBehavior(pipeBehavior)
        
    }

    @IBAction func didTapView(sender: UITapGestureRecognizer) {
        
        push.active = false
        push.addItem(birdContainer)
        push.active = true
        
    }
    
    func collisionBehavior(behavior: UICollisionBehavior, beganContactForItem item1: UIDynamicItem, withItem item2: UIDynamicItem, atPoint p: CGPoint) {
        let view1 = item1 as! UIView
        let view2 = item2 as! UIView
        
       print("Game over.")
        animator.removeAllBehaviors()
        timer.invalidate()
    }

}

