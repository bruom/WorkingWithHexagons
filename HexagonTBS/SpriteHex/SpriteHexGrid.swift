//
//  SpriteHexGrid.swift
//  HexGrid
//
//  Created by Bruno Omella Mainieri on 22/06/17.
//  Copyright © 2017 Bruno Omella Mainieri. All rights reserved.
//

import Foundation
import SpriteKit

public class SpriteHexGrid : SKSpriteNode{
    
    var grid:HexGrid
    var hexNodes:[Int:HexNode] = [:]
    
    var delegate:HexGridDelegate?
    
    public init(grid:HexGrid){
        self.grid = grid
        super.init(texture: SKTexture(imageNamed:"hexreg.png") , color: UIColor.white, size: CGSize.zero)
        setup()
    }
    
    //SHAPE INIT
    public init(shape:HexGridShape, sideSize: CGFloat, hexShape:HexShape = .FlatTop){
        print("Shapes other than Radial do not work! Coordinates break")
        self.grid = HexGrid(shape: shape, sideSize: sideSize, hexShape: hexShape)
        super.init(texture: SKTexture(imageNamed:"hexreg.png") , color: UIColor.white, size: CGSize.zero)
        setup()
    }
    
    //Random init
    public init(randomShapeOfSize size:Int, sideSize:CGFloat, hexShape:HexShape = .FlatTop) {
        let shapes:[HexGridShape] = [.Radial(size), .Rectangular(x: size, y: size), .BiAxial(x: size, y: size), .Triangular(size)]
        let theShape = shapes[Int(arc4random_uniform(UInt32(shapes.count)))]
        self.grid = HexGrid(shape: theShape, sideSize: sideSize, hexShape: hexShape)
        super.init(texture: SKTexture(imageNamed:"hexreg.png") , color: UIColor.white, size: CGSize.zero)
        setup()
    }
    
    //Init from pre-built map - CoreData
    public init(grid: HexGrid, hexTiles:[HexNode]) {
        self.grid = grid
        super.init(texture: SKTexture(imageNamed:"hexreg.png") , color: UIColor.white, size: CGSize.zero)
        
        for eachTile in hexTiles {
            self.addChild(eachTile)
            hexNodes[eachTile.gridHex.hashValue] = eachTile
        }
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setup(){
        for eachHex in self.grid.hexes {
            let hexSprite = HexNode(hex: eachHex, id: 0)
            self.addChild(hexSprite)
            hexNodes[eachHex.hashValue] = hexSprite
        }
    }
    
    public func nodeForHex(hex:Hex) -> HexNode?{
        if let node = hexNodes[hex.hashValue] {
            return node
        }
        return nil
    }
    
    public func nodeAtCoords(x:Int, y:Int) -> HexNode?{
        if let node = hexNodes[Hex.hashForCoords(x: x, y: y)] {
            return node
        }
        return nil
    }
    
    public func redraw(){
        if let _ = delegate {
            for eachHex in self.grid.hexes {
                //Remove previous node from scene
                hexNodes[eachHex.hashValue]?.removeFromParent()
                
                //Get node from delegate
                let newNode = delegate?.tileForHex(hex: eachHex, inGrid: self.grid)
                self.addChild(newNode!)
            
                //Replace node in dict
                hexNodes[eachHex.hashValue] = newNode
                
            }
        }
    }
    
    public func reposition(to: CGPoint){
        self.position = to
        self.grid.gridPosition = to
    }
    
    public func reposition(by x:CGFloat, y:CGFloat){
        self.position.x += x
        self.position.y += y
        self.grid.gridPosition.x = self.position.x// + scene!.size.width/2
        self.grid.gridPosition.y = self.position.y// + scene!.size.height/2
    }
    
}
