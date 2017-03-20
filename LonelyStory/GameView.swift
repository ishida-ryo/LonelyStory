//
//  FirstScene.swift
//  LonelyStory
//
//  Created by 石田陵 on 2017/03/15.
//  Copyright © 2017年 ryo.ishida. All rights reserved.
//

import UIKit
import SpriteKit

class GameView: SKScene {
    
    var cloudNode: SKSpriteNode?
    var mountainNode: SKSpriteNode?
    var playerNode: SKSpriteNode?
    var enemyNode: SKSpriteNode?
    
    override func didMove(to view: SKView) {
        
        cloudNode = self.childNode(withName: "cloud") as? SKSpriteNode
        mountainNode = self.childNode(withName: "mountain") as? SKSpriteNode
        playerNode = self.childNode(withName: "kintounn") as? SKSpriteNode
        enemyNode = self.childNode(withName: "pu-aru") as? SKSpriteNode
        
        cloudNode?.size = self.size
        cloudNode?.position = self.position
//        groundNode?.size = self.size
        let xOrigin = self.frame.origin.x
        let yOrigin = self.frame.origin.y
        
        playerNode?.position = CGPoint(x: xOrigin + (playerNode!.size.width * 2), y: yOrigin + (playerNode!.size.height * 2))
    }

}
