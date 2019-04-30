//
//  Hex.swift
//  HexGrid
//
//  Created by Bruno Omella Mainieri on 14/06/17.
//  Copyright © 2017 Bruno Omella Mainieri. All rights reserved.
//

import Foundation
import SpriteKit

public enum HexShape{
    case FlatTop
    case PointyTop
}

public class Hex: Equatable, Hashable {
    
    var x:Int
    var y:Int
    var z:Int
    var side:CGFloat
    var grid:HexGrid
    var cost:Double = 1
    var isValid:Bool = true
    var shape:HexShape = .FlatTop
    
    public var hashValue: Int {
        return "\(x)#\(y)".hash
    }
    
    public static func hashForCoords(x:Int,y:Int) -> Int {
        return "\(x)#\(y)".hash
    }
    
    init(x:Int,y:Int,z:Int,side:CGFloat,grid:HexGrid, shape:HexShape = .FlatTop) {
        self.x = x
        self.y = y
        self.z = z
        self.side = side
        self.grid = grid
        self.shape = shape
    }
    
    init(x:Int, y:Int, side:CGFloat, grid:HexGrid, shape:HexShape = .FlatTop) {
        self.x = x
        self.y = y
        self.z = -x - y
        self.side = side
        self.grid = grid
        self.shape = shape
    }
    
    public func cubeCoord() -> (x:Int,y:Int,z:Int){
        return (x:x,y:y,z:z)
    }
    
    public func axisCoord() -> (x:Int,y:Int){
        return (x:x,y:y)
    }
    
    public func addCord(hex:Hex) -> (x:Int,y:Int,z:Int) {
        return addCoord(x: hex.x, y: hex.y, z: hex.z)
    }
    
    public func addCoord(x:Int,y:Int) -> (x:Int,y:Int,z:Int) {
        return addCoord(x: x, y: y, z: -x - y)
    }
    
    public func addCoord(x:Int,y:Int,z:Int) -> (x:Int,y:Int,z:Int) {
        return (self.x+x, self.y+y, self.z+z)
    }
    
    
    public func coords() -> (x:Int,y:Int,z:Int){
        return (x,y,z)
    }
    
    public static func ==(lhs:Hex, rhs:Hex) -> Bool {
        return
            lhs.x == rhs.x &&
            lhs.y == rhs.y &&
            lhs.z == rhs.z &&
            lhs.grid === rhs.grid
    }
    
    public func toggleValid(value:Bool){
        self.isValid = value
    }
    
}


