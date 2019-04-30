//
//  GameScene.swift
//  HexagonTBS
//
//  Created by Bruno Omella Mainieri on 16/04/19.
//  Copyright © 2019 Bruno Omella Mainieri. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var gridNode:SpriteHexGrid!
    private var map:SKTileMapNode!
    private let tileGraphics:[SKTexture] = [SKTexture(image: #imageLiteral(resourceName: "Forest_Hex")),SKTexture(image: #imageLiteral(resourceName: "Farm_Hex")),SKTexture(image: #imageLiteral(resourceName: "Grassland_Hex")),SKTexture(image: #imageLiteral(resourceName: "Mountain_Hex")),SKTexture(image: #imageLiteral(resourceName: "Water_Hex"))]
    
    override init(size: CGSize) {
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        backgroundColor = .white
        
//        map = SKScene(fileNamed: "Hex.sks")?.childNode(withName: "map") as! SKTileMapNode
//        map?.removeFromParent()
//        map.position = CGPoint(x: frame.midX, y: frame.midY)
//        addChild(map)
        gridNode = InteractiveGrid(shape: .Radial(5), sideSize: 46, hexShape: .PointyTop)
        addChild(gridNode)
        
        gridNode.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        gridNode.grid.gridPosition = CGPoint(x: self.size.width/2, y: self.size.height/2)
        gridNode.redraw()
        
//        randomFill()
        fill()
    }
    
    private func randomFill(){
        for eachHexNode in gridNode.hexNodes.values {
            let rand = GKRandomDistribution(lowestValue: 0, highestValue: tileGraphics.count-1).nextInt()
            eachHexNode.texture = tileGraphics[rand]
//            eachHexNode.zRotation = CGFloat.pi/2
        }
    }
    
    private func fill(){
        for eachHexNode in gridNode.hexNodes.values{
            eachHexNode.updateTile(newTile: GameTileNode(hexNode: eachHexNode, tileId: 1))
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let nodesInTap = nodes(at: self.convertPoint(fromView: touches.first!.location(in:view!)))
        
        let tappables = nodesInTap.filter { (aNode) -> Bool in
            aNode is Interactable
            }.sorted { (nodeA, nodeB) -> Bool in
                nodeA.zPosition > nodeB.zPosition
        }
        
        if tappables.count > 0 {
            (tappables.first as! Interactable).touchDidBegin(pos: self.convertPoint(fromView: touches.first!.location(in: view)), numTouches: 1)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
