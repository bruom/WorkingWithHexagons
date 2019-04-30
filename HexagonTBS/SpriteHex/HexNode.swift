//
//  HexNode.swift
//  HexGrid
//
//  Created by Bruno Omella Mainieri on 14/06/17.
//  Copyright © 2017 Bruno Omella Mainieri. All rights reserved.
//

import Foundation
import SpriteKit

public class HexNode: SKSpriteNode {
    
    static var tiles:[Int:UIImage] = [0:#imageLiteral(resourceName: "hexreg"), 1:#imageLiteral(resourceName: "hexregred"), 2:#imageLiteral(resourceName: "hexregfill"), 3:#imageLiteral(resourceName: "hexreggreen"), 4:#imageLiteral(resourceName: "hexregbrown"), 5:#imageLiteral(resourceName: "hexregyellow")]
    
    
    public static func idForTexture(texture: SKTexture) -> Int {
        
        if let id = (HexNode.tiles as NSDictionary).allKeys(for: texture).first{
            return id as! Int
        } else {
            return 0
        }
    }
    
    public static func textureForId(id:Int) -> SKTexture {
        if let texture = HexNode.tiles[id] {
            return SKTexture(image: texture)
        } else {
            return SKTexture(imageNamed: "hexreg.png")
        }
    }
    
    var gridHex:Hex
//    var effectNode:SKSpriteNode
    var imgId:Int?
    public var isSelected:Bool = false
    public var tile:GameTileNode?
    
    public init(hex:Hex, id:Int){
        self.gridHex = hex
        self.imgId = id
        
        var size:CGSize
        if gridHex.shape == .FlatTop{
            size = CGSize(width: 2*hex.side, height: sqrt(3)*hex.side)
        } else {
            size = CGSize(width: sqrt(3)*hex.side, height: 2*hex.side)
        }
        var tex:SKTexture = SKTexture(imageNamed: "hexreg.png")
        if let theTexture = HexNode.tiles[id] {
            tex = SKTexture(image:theTexture)
        }
//        effectNode = SKSpriteNode(texture: tex, color: UIColor.white, size: size)
//        effectNode.alpha = 0.0
        super.init(texture: tex, color: UIColor.white, size: size)
//        self.addChild(effectNode)
//        effectNode.zPosition = self.zPosition + 10
        position = gridHex.grid.hexToAbsolutePoint(hex: gridHex)
        name = "\(gridHex.x)-\(gridHex.y)"
    }
    
    public init(hex:Hex, texture: SKTexture, imgId:Int){
        self.gridHex = hex
        self.imgId = imgId
        let size = CGSize(width: 2*hex.side, height: sqrt(3)*hex.side)
        super.init(texture: texture, color: UIColor.white, size: size)
        position = gridHex.grid.hexToAbsolutePoint(hex: gridHex)
        name = "\(gridHex.x)-\(gridHex.y)"
    }
    
    public init(hex:Hex){
        self.gridHex = hex
        var size:CGSize
        if gridHex.shape == .FlatTop{
            size = CGSize(width: 2*hex.side, height: sqrt(3)*hex.side)
        } else {
            size = CGSize(width: sqrt(3)*hex.side, height: 2*hex.side)
        }
        super.init(texture: nil, color: UIColor.white, size: size)
        position = gridHex.grid.hexToAbsolutePoint(hex: gridHex)
        name = "\(gridHex.x)-\(gridHex.y)"
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func changeTexture(id:Int){
        self.texture = SKTexture(image:HexNode.tiles[id]!)
        
        self.imgId = id
        
        //Handle any issues such as non-hexagonal textures perhaps
    }
    
    public func updateTile(newTile:GameTileNode){
        for eachChild in children{
            if eachChild is GameTileNode {
                eachChild.removeFromParent()
            }
        }
        tile = newTile
        newTile.name = "Tile"
        addChild(newTile)
    }
    
    public func changeHex(newHex:Hex){
        self.gridHex = newHex
        //Perform any hex-related logic
    }
    public func becomeInvalid() {
//        effectNode.texture = SKTexture(imageNamed: "hexregred.png")
//        effectNode.alpha = 1.0
        gridHex.toggleValid(value: false)
    }
    
    public func becomeValid() {
//        effectNode.texture = SKTexture(imageNamed: "hexregfill.png")
//        effectNode.alpha = 0.0
        gridHex.toggleValid(value: true)
    }
    
    public func select(){
        isSelected = true
        alpha = 0.6
    }
    
    public func deselect(){
        isSelected = false
        alpha = 1.0
    }
    
    public func blinkInOut(durationIn:Double, durationOut:Double){
        if gridHex.isValid{
//            effectNode.run(SKAction.sequence([SKAction.fadeAlpha(to: 1.0, duration: durationIn),SKAction.fadeAlpha(to: 0.0, duration: durationOut)]))
        }
    }
    
}
