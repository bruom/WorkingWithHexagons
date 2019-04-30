//
//  HexGrid.swift
//  HexGrid
//
//  Created by Bruno Omella Mainieri on 14/06/17.
//  Copyright © 2017 Bruno Omella Mainieri. All rights reserved.
//

import Foundation
import SpriteKit

public enum HexGridShape {
    case Radial(Int)
    case BiAxial(x:Int, y:Int)
    case Triangular(Int)
    case RightTriangular(Int)
    case Rectangular(x:Int, y:Int)
}

public class HexGrid {
    
    public var hexes:[Hex] = []
    public var hexesGrid:[Int:Hex] = [:]
    var radius:(Int,Int)
    var sideSize:CGFloat
    public var hexShape:HexShape
    public var gridPosition:CGPoint = CGPoint(x: 0, y: 0)
    
    public init(shape:HexGridShape, sideSize:CGFloat, hexShape:HexShape = .FlatTop){
        self.sideSize = sideSize
        self.hexShape = hexShape
        switch shape{
        case .Radial(let n):
            self.radius = (n,n)
            for i in -n...n {
                for j in -n...n {
                    if(abs(i+j) <= n){
                        let thisHex = Hex(x: i, y: j, side: sideSize, grid:self, shape:hexShape)
                        hexes.append(thisHex)
                        hexesGrid[thisHex.hashValue] = thisHex
                    }
                }
            }
        case .BiAxial(let rx, let ry):
            self.radius = (rx,ry)
            self.sideSize = sideSize
            for i in -rx...rx {
                for j in -ry...ry {
                    if(abs(i+j) <= rx){
                        hexes.append(Hex(x: i, y: j, side: sideSize, grid:self, shape:hexShape))
                    }
                }
            }
        case .Triangular(let n):
            self.radius = (n,n)
            for xi in -n...n {
                for yi in 0...n{
                    if 2*yi + xi <= n && xi + yi >= 0 {
                        let thisHex = Hex(x: xi, y: yi, side: sideSize, grid:self, shape:hexShape)
                        hexes.append(thisHex)
                        hexesGrid[thisHex.hashValue] = thisHex
                    }
                }
            }
        case .RightTriangular(let n):
            self.radius = (n,n)
            for xi in -n...n {
                for yi in 0...n{
                    if 2*yi + xi <= n {
                        let thisHex = Hex(x: xi, y: yi, side: sideSize, grid:self, shape:hexShape)
                        hexes.append(thisHex)
                        hexesGrid[thisHex.hashValue] = thisHex
                    }
                }
            }
        case .Rectangular(let x, let y):
            self.radius = (x,y)
            for xi in -x...x {
                for yi in -y...y{
                    if 2*yi + xi >= 0 && 2*yi + xi <= y {
                        let thisHex = Hex(x: xi, y: yi, side: sideSize, grid:self, shape:hexShape)
                        hexes.append(thisHex)
                        hexesGrid[thisHex.hashValue] = thisHex
                    }
                }
            }
        }
    }
    
    //Init from a HexMap entry from CoreData
//    public init(hexMapEntry: HexMap) {
//        self.sideSize = CGFloat(hexMapEntry.sideSize)
//        self.radius = (0,0)
//        var hexes:[Hex] = []
//        for entry in hexMapEntry.baseTiles?.allObjects as! [BaseTile] {
//            let aHex = Hex(x: Int(entry.indexX), y: Int(entry.indexY), side: 0, grid: self)
//            hexes.append(aHex)
//        }
//        self.hexes = hexes
//
//        for eachHex in  hexes {
//            eachHex.grid = self
//            eachHex.side = sideSize
//            hexesGrid[eachHex.hashValue] = eachHex
//        }
//
//    }
    
    
    public func hexAtCoord(x:Int,y:Int,z:Int) -> Hex? {
        return hexAtCoord(coords:(x,y,z))
    }
    
    public func hexAtCoord(coords: (x:Int,y:Int,z:Int)) -> Hex? {
        if(coords.x+coords.y+coords.z) != 0 {
            return nil
        }
        return hexesGrid[Hex.hashForCoords(x: coords.x, y: coords.y)]
    }
    
    
    var nDirections:[(Int,Int)] = [(1,0),(1,-1),(0,-1),(-1,0),(-1,1),(0,1)]
    public func neighbors(hex:Hex) -> [Hex]{
        var nHexes:[Hex] = []
        for dir in nDirections{
            if let aHex = hexAtCoord(coords:hex.addCoord(x: dir.0, y: dir.1)) {
                nHexes.append(aHex)
            }
        }
        return nHexes
    }
    
    public func hexToPoint(hex:Hex) -> CGPoint {
        if hexShape == .FlatTop {
            let px = sideSize * CGFloat(1.5) * CGFloat(hex.x)
            let py = sideSize * sqrt(3.0) * (CGFloat(hex.z) + CGFloat(hex.x)/2.0)
            return CGPoint(x: px, y: py)
        } else {
            let px = sideSize * sqrt(3.0) * (CGFloat(hex.x) + CGFloat(hex.z)/2.0)
            let py = sideSize * CGFloat(1.5) * CGFloat(hex.z)
            return CGPoint(x: px, y: py)
        }
    }
    
    public func hexToAbsolutePoint(hex:Hex) -> CGPoint {
//        let px = /*gridPosition.x +*/ sideSize * CGFloat(1.5) * CGFloat(hex.x)
//        let py = /*gridPosition.y +*/ sideSize * sqrt(3.0) * (CGFloat(hex.z) + CGFloat(hex.x)/2.0)
//        return CGPoint(x: px, y: py)
        return hexToPoint(hex:hex)
    }
    
    public func hexRound(x:CGFloat,y:CGFloat,z:CGFloat) -> (x:Int,y:Int,z:Int) {
        var rx = round(x)
        var ry = round(y)
        var rz = round(z)
        let dx = abs(rx - x)
        let dy = abs(ry - y)
        let dz = abs(rz - z)
        
        if dx > dy && dx > dz {
            rx = -ry-rz
        } else if dy > dz {
            ry = -rx-rz
        } else {
            rz = -rx-ry
        }
        return (Int(rx),Int(ry),Int(rz))
    }
    
    public func pointToHex(point:CGPoint) -> Hex? {
        
        if hexShape == .FlatTop {
            let px = point.x / (1.5 * sideSize)
            let auxPy = -point.x / 3.0 + 0.577 * point.y
            let py = auxPy / sideSize
            let coords = hexRound(x: px, y: -px-py, z: py)
            return hexAtCoord(coords: coords)
        } else {
            let auxPx = 0.577 * point.x - point.y/3.0
            let px = auxPx / sideSize
            let py = point.y / (1.5*sideSize)
            let coords = hexRound(x: px, y: -px-py, z: py)
            return hexAtCoord(coords: coords)
        }
    }
    
    public func absolutePointToHex(point:CGPoint, xScale:CGFloat, yScale:CGFloat) -> Hex? {
        
        if hexShape == .FlatTop {
            let px = (point.x - gridPosition.x) / (1.5 * sideSize) / xScale
            let auxPy = -(point.x - gridPosition.x) / 3.0 + 0.577 * (point.y - gridPosition.y)
            let py = auxPy / sideSize / yScale
            let coords = hexRound(x: px, y: -px-py, z: py)
            return hexAtCoord(coords: coords)
        } else {
            let auxPx = 0.577 * (point.x - gridPosition.x) - (point.y - gridPosition.y)/3.0
            let px = auxPx / sideSize / xScale
            let py = (point.y - gridPosition.y) / (1.5*sideSize) / yScale
            let coords = hexRound(x: px, y: -px-py, z: py)
            return hexAtCoord(coords: coords)
        }
    }
    
    
    /**
    Calculates the distance (in hexagons) between two hexes on the grid.
     
    - Note: this only deals in simple distance on the grid; it does not account for obstacles or variable costs for travel between hexes.
     
    - Parameter hex1: one of the hexes for comparison
    - Parameter hex2: one of the hexes for comparison
     
    - Returns: the distance in hexagons between the two input hexes.
    */
    public func distance(hex1:Hex, hex2:Hex) -> Int {
        
        return max(abs(hex1.x - hex2.x),abs(hex1.y - hex2.y),abs(hex1.z - hex2.z))
    }
    
    /**
    An implementation of the aStar pathfinding algorithm. Given start and goal hexes on this HexGrid, this algorithm identifies distance between start and any hexes on an expanding frontier until goal is reached. This distance is calculated based on the cost of 'movement' of each Hex, as specified in the Hex's cost attribute.
     
    - Note: if you are interested in simply finding the shortest path between two hexes, use the findPath function instead.
     
    - Parameter start: the initial hex for the path. Search is done radially in a frontier that expands outwards from this hex.
    - Parameter goal: the target goal of the path. Search stops once it is first reached.
     
    - Returns: Two dictionaries; the first containing information regarding each Hex's previous neighbor, as found in the search; the second containing the distance of each searched Hex to the start. Since the search is non-exhaustive (it ends as soon as goal is reached), neither of these dictionaries are guaranteed to contain all hexes in the grid (and most likely do not).

    */
    public func aStar(start:Hex, goal:Hex) -> ([Hex:Hex?],[Hex:Double])? {
        var frontier:[(Hex,Double)] = []
        frontier.append((start, 0))
        var prev:[Hex:Hex?] = [:]
        var cost:[Hex:Double] = [:]
        prev[start] = nil
        cost[start] = 0.0
        
        var didFind = false
        
        while !frontier.isEmpty {
            let cur = frontier.first!
            frontier.remove(at: 0)
            
            if cur.0 == goal {
                didFind = true
                break
            }
            
            for nextHex in neighbors(hex: cur.0){
                
                let newCost = cost[cur.0]! + nextHex.cost
                
                if nextHex.isValid && ( cost[nextHex] == nil || newCost < cost[nextHex]! ) {
                    cost[nextHex] = newCost
                    let priority = newCost + Double(distance(hex1: goal, hex2: nextHex))
                    frontier.append((nextHex,priority))
                    prev[nextHex] = cur.0
                }
            }
        }
        
        if !didFind{return nil}
        
        return (prev,cost)
        
    }
    
    /**
    Calls the aStar algorithm implementation to find the shortest path between two hexes

     
    -  Parameter start: one of the ends of the path. These are interchangeable
    -  Parameter goal: the other end of the path. These are interchangeable
    -  Parameter randomize: if true, different paths of same length may be randomly choosen each time the function is called for the same hexes. If false, the same path will always be returned. Default: true
     
    -  returns: a list of Hex objects in which the first element is goal, the last one is start, and the others describe [one of the] shortest path between them
     
     */
    public func findPath(start:Hex, goal:Hex, randomize:Bool = true) -> [Hex] {
        var path:[Hex] = [goal]
        
        if let (prev,cost) = aStar(start: start, goal: goal) {
            while path.last! != start {
                
                if randomize{
                    //Randomized version
                    var nextOptions:[Hex] = []
                    for eachHex in neighbors(hex: path.last!){
                        if let _ = cost[eachHex] {
                            if cost[eachHex]! < cost[path.last!]!{
                                nextOptions.append(eachHex)
                            }
                        }
                    }
                    let randI:Int = Int(arc4random_uniform(UInt32(nextOptions.count)))
                    path.append(nextOptions[randI])
                }
                else {
                    //Deterministic
                    path.append(prev[path.last!]!!)
                    
                }
                
            }
            
        }
        
        
        return path
    }
    
    
}
