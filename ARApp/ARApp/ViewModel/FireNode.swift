//
//  FireNode.swift
//  ARApp
//
//  Created by Khan Sharmin on 18/03/20.
//  Copyright © 2020 Khan Sharmin. All rights reserved.
//

import Foundation
import ARKit

class Fire: SCNNode {
    
    override init () {
        super.init()
        let particleSystem = SCNParticleSystem(named: "fire", inDirectory: "art.scnassets/")
        self.addParticleSystem(particleSystem!)
        self.name = "fire"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
