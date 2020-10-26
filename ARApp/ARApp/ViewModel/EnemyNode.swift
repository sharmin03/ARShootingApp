//
//  EnemyNode.swift
//  ARApp
//
//  Created by Khan Sharmin on 18/03/20.
//  Copyright © 2020 Khan Sharmin. All rights reserved.
//

import Foundation
import ARKit

class Enemy: SCNNode {
    
    static var scene: SCNScene? {
        guard let scene = SCNScene(named: "art.scnassets/ship.scn") else {
            return nil
        }
        return scene
    }
   
    override init () {
        super.init()
        guard let enemyNode = Enemy.scene?.rootNode.childNodes.first else { return }
        self.addChildNode(enemyNode)
        self.name = "enemy"
        self.physicsBody = SCNPhysicsBody(type: .static, shape: .init())
        self.physicsBody?.categoryBitMask = CollisionCategory.enemy.rawValue
        self.physicsBody?.contactTestBitMask =  CollisionCategory.bullets.rawValue
        self.physicsBody?.collisionBitMask = CollisionCategory.bullets.rawValue
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
