//
//  HexGridDelegate.swift
//  HexGrid
//
//  Created by Bruno Omella Mainieri on 22/06/17.
//  Copyright © 2017 Bruno Omella Mainieri. All rights reserved.
//

import Foundation

protocol HexGridDelegate {
    
    
    /**
    Delegate method for specifying tiles to populate a SpriteHexGrid.
    */
    func tileForHex(hex:Hex, inGrid:HexGrid) -> HexNode
    
    
    /**
    Delegate method for specifying the cost of travel or traversal for each hex in a grid. If no value is provided via this method, all hexes receive a default value of 1.0
    */
    func costForHex(hex:Hex, inGrid:HexGrid) -> Double
}

