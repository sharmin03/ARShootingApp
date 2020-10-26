//
//  BulletNode.swift
//  ARApp
//
//  Created by Khan Sharmin on 18/03/20.
//  Copyright © 2020 Khan Sharmin. All rights reserved.
//

import Foundation
import ARKit

class Bullet: SCNNode {
    override init () {
        super.init()
        let sphere = SCNSphere(radius: 0.020)
        sphere.materials.first?.diffuse.contents =  UIColor.red
        self.geometry = sphere
        let shape = SCNPhysicsShape(geometry: sphere, options: nil)
        self.physicsBody = SCNPhysicsBody(type: .dynamic, shape: shape)
        self.physicsBody?.isAffectedByGravity = false
        self.physicsBody?.categoryBitMask = CollisionCategory.bullets.rawValue
        self.physicsBody?.contactTestBitMask = CollisionCategory.enemy.rawValue
        self.physicsBody?.collisionBitMask = CollisionCategory.enemy.rawValue
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
