//
//  SCNNode+Util.swift
//  ARApp
//
//  Created by Khan Sharmin on 18/03/20.
//  Copyright © 2020 Khan Sharmin. All rights reserved.
//

import Foundation
import SceneKit
import ARKit

extension SCNVector3 {
    
    static func +(left: SCNVector3, right: SCNVector3) -> SCNVector3 {
        return SCNVector3(left.x + right.x, left.y + right.y, left.z + right.z)
    }
    
    static func -(left: SCNVector3, right: SCNVector3) -> SCNVector3 {
        return SCNVector3(left.x - right.x, left.y - right.y, left.z - right.z)
    }
    
    static func *(left: Float, right: SCNVector3) -> SCNVector3 {
        return SCNVector3(left * right.x, left * right.y, left * right.z)
    }
}
