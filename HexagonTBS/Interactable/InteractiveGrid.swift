//
//  InteractiveGrid.swift
//  HexagonTBS
//
//  Created by Bruno Omella Mainieri on 30/04/19.
//  Copyright © 2019 Bruno Omella Mainieri. All rights reserved.
//

import Foundation
import SpriteKit

public class InteractiveGrid : SpriteHexGrid, Interactable {
    
    enum GridState {
        case NoneSelected
        case OneSelected
        case PathFound
    }
    
    var curState:GridState = .NoneSelected
    var selectedNode:HexNode?
    
    func touchDidBegin(pos: CGPoint, numTouches: Int) {
        if let thisHex = grid.absolutePointToHex(point: pos, xScale: self.xScale, yScale: self.yScale), let thisNode = nodeForHex(hex: thisHex) {
            if curState == .NoneSelected {
                if thisNode.isSelected {
                    thisNode.deselect()
                    selectedNode = nil
                    curState = .NoneSelected
                } else {
                    thisNode.select()
                    selectedNode = thisNode
                    curState = .OneSelected
                }
            }
            
            else if curState == .OneSelected {
                if thisNode.isSelected {
                    thisNode.deselect()
                    selectedNode = nil
                    curState = .NoneSelected
                } else {
                    //Pathfind between two selected points
                    let path = grid.findPath(start: selectedNode!.gridHex, goal: thisNode.gridHex)
                    for eachHex in path {
                        nodeForHex(hex: eachHex)?.select()
                    }
                    curState = .PathFound
                }
            }
            
            else if curState == .PathFound {
                //Clear path
                clearAll()
                thisNode.select()
                selectedNode = thisNode
                curState = .OneSelected
            }
        }
    }
    
    func clearAll(){
        for eachNode in hexNodes.values {
            eachNode.deselect()
        }
    }
    
    func touchDidMove(newPos: CGPoint, numTouches: Int) {
        
    }
    
    func touchDidEnd(pos: CGPoint, numTouches: Int) {
        
    }
    
}
