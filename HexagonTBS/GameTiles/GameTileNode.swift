//
//  GameTileNode.swift
//  HexagonTBS
//
//  Created by Bruno Omella Mainieri on 30/04/19.
//  Copyright © 2019 Bruno Omella Mainieri. All rights reserved.
//

import Foundation
import SpriteKit

public class GameTileNode: SKSpriteNode{
    
    public var moveCost:Int = 1
    public var passable:Bool = true
    public var tileName:String = "Default Tile"
    
    //Load Tiles from JSON data
    init(hexNode:HexNode, tileId:Int){
        let filePath = Bundle.main.path(forResource: "Tiles", ofType: "json", inDirectory: nil)
        var json:[[String:AnyObject]]?
        if let filePath = filePath {
            do {
                let fileUrl = URL(fileURLWithPath: filePath)
                let jsonData = try Data(contentsOf: fileUrl, options: .mappedIfSafe)
                json = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as? [[String:AnyObject]]
            } catch {
                print(error)
                
            }
        }
        
        var tex:SKTexture?
        if let json = json {
            var thisTile:[String:AnyObject]?
            for tile in json {
                if let num = tile["tileId"] as? Int {
                    if num == tileId {
                        thisTile = tile
                        break
                    }
                }
            }
            if let thisTile = thisTile{
                if let mc = thisTile["moveCost"] as? Int{
                    self.moveCost = mc
                }
                if let ps = thisTile["passable"] as? Bool{
                    self.passable = ps
                }
                if let nm = thisTile["tileName"] as? String{
                    self.tileName = nm
                }
                if let tn = thisTile["imgName"] as? String{
                    tex = SKTexture(imageNamed: tn)
                }
            }
        }
        super.init(texture: tex, color: .white, size: hexNode.size)
        
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
