//
//  CollisionCategory.swift
//  ARApp
//
//  Created by Khan Sharmin on 18/03/20.
//  Copyright © 2020 Khan Sharmin. All rights reserved.
//

import Foundation
import ARKit

struct CollisionCategory: OptionSet {
    let rawValue: Int
    static let bullets  = CollisionCategory(rawValue: 1 << 1) // 00...01
    static let enemy = CollisionCategory(rawValue: 1 << 0) // 00..10
}
