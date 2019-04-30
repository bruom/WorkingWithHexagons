//
//  Interactable.swift
//  HexagonTBS
//
//  Created by Bruno Omella Mainieri on 30/04/19.
//  Copyright © 2019 Bruno Omella Mainieri. All rights reserved.
//

import Foundation
import SpriteKit

protocol Interactable {
    
    func touchDidBegin(pos:CGPoint,numTouches:Int)
    
    func touchDidMove(newPos:CGPoint,numTouches:Int)
    
    func touchDidEnd(pos:CGPoint,numTouches:Int)
    
}
