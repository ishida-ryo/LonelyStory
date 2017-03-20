//
//  GameScene.swift
//  LonelyStory
//
//  Created by 石田陵 on 2017/03/12.
//  Copyright © 2017年 ryo.ishida. All rights reserved.
//
import SpriteKit
import AVFoundation

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // アニメーションを加えないためSKNodeの型に設定
    var scrollNode: SKNode!
    var enemyNode: SKNode!
    
    // アニメーションを加えるためSKSpriteNodeの型に設定
    var player: SKSpriteNode!
    
    let playerCategory: UInt32 = 1 << 0
    let enemyCategory: UInt32 = 1 << 1
    let clearCategory: UInt32 = 1 << 2
    
    var movePosition = 0
    
    var sound: AVAudioPlayer!
    
    let url = Bundle.main.bundleURL.appendingPathComponent("ブロリー.mp3")
    
    // SKView上にシーンが表示されたときに呼ばれるメソッド
    override func didMove(to view: SKView) {
        
        do {
            try sound = AVAudioPlayer(contentsOf: url)
            
            sound.prepareToPlay()
        } catch {
            print(error)
        }
        
        sound.volume = 0.05
        sound.play()
        
        // 重力を設定
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        // デリゲートを設定
        physicsWorld.contactDelegate = self
        
        // 背景色を設定
        backgroundColor = UIColor(colorLiteralRed: 1, green: 1, blue: 1, alpha: 1)
        
        // 親ノードを作成する
        scrollNode = SKNode()
        addChild(scrollNode)
        
        enemyNode = SKNode()
        scrollNode.addChild(enemyNode)
        
        setUpMountain()
        setUpSky()
        setUpPlayer()
        setUpCenterEnemy()
        setUpUpperEnemy()
        setUpUnderEnemy()
        setUpBuroriEnemy()
        lightButton()
    }
    
    func setUpMountain() {
        
        // 地面の画像を指定してSKTextureで処理を任せる
        let mountainTexture = SKTexture(imageNamed: "mountain")
        
        // 処理速度を高める設定
        mountainTexture.filteringMode = SKTextureFilteringMode.nearest
        
        // スクロールするアクションを作成
        // 左方向に画像一枚分スクロールさせるアクション
        let moveMountain = SKAction.moveBy(x: -mountainTexture.size().width * 1.5, y: 0, duration: 5.0)
    
        // 元の位置に戻すアクション
        let resetMountain = SKAction.moveBy(x: mountainTexture.size().width * 1.5, y: 0, duration: 0.0)
        
        // 左にスクロール->元の位置->左にスクロールと無限に繰り替えるアクション
        let repeatScrollMountain = SKAction.repeatForever(SKAction.sequence([moveMountain, resetMountain]))
        
        // 必要な枚数を計算
        let needNumber = 2.0 + (frame.size.width / mountainTexture.size().width)
        
        // groundのスプライトを配置する
        stride(from: 0.0, to: needNumber, by: 1.0).forEach { i in
            
            // テクスチャーを指定してスプライトを作成する(画像を描画)
            let mountainSprite = SKSpriteNode(texture: mountainTexture)
        
            mountainSprite.yScale = (2.0)
            mountainSprite.xScale = (1.5)
            // スプライトの表示する位置を指定する
            mountainSprite.position = CGPoint(x: i * mountainSprite.size.width, y: mountainTexture.size().height / 2)
            
            mountainSprite.zPosition = -30
            
            mountainSprite.physicsBody?.isDynamic = false
            
            // スプライトにアクションを設定する
            mountainSprite.run(repeatScrollMountain)
            
            // シーンにスプライトを表示する
            scrollNode.addChild(mountainSprite)
        }

    }
    
    func setUpSky() {
        
        let skyTexture = SKTexture(imageNamed: "sky")
        
        skyTexture.filteringMode = SKTextureFilteringMode.nearest
        
        // テクスチャを動かしたり元の位置に戻す設定
        let moveSky = SKAction.moveBy(x: -skyTexture.size().width, y: 0, duration: 5.0)
        let resetSky = SKAction.moveBy(x: skyTexture.size().width, y: 0, duration: 0.0)
        //上のやつを交互に動かすように設定
        let repeatSky = SKAction.repeatForever(SKAction.sequence([moveSky, resetSky]))
        
        // 画面のサイズ÷forestテクスチャをして2たして画像何枚いるか
        let needNumber = 2.0 + (frame.size.width / skyTexture.size().width)
        
        // 0.0からneedNumberまで1.0間隔でiに代入する　???
        stride(from: 0.0, to: needNumber, by: 1.0).forEach { i in
            let skySprite = SKSpriteNode(texture: skyTexture)
            
            skySprite.yScale = (2.1)
            
            skySprite.position = CGPoint(x: i * skySprite.size.width, y: self.frame.size.height / 2)
            
            skySprite.zPosition = -50
            
            skySprite.run(repeatSky)
            
            scrollNode.addChild(skySprite)
        }
    }
    
    func setUpPlayer() {
        
        // テクスチャを設定する
        let playerTexture = SKTexture(imageNamed: "kintounn2")
        playerTexture.filteringMode = SKTextureFilteringMode.linear
        
        // テクスチャーを指定してスプライトに設定する
        player = SKSpriteNode(texture: playerTexture)
        
        player.name = "player"
        
        player.zPosition = 10
        
        // 初期位置を設定する
        player.position = CGPoint(x: self.frame.size.width * 0.1, y: self.frame.size.height * 0.5)
        
        // 物理演算を設定する(重力を受けたり)
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.height / 2.0)
        
        // 衝突した時に回転させない
        player.physicsBody?.allowsRotation = false
        
        player.physicsBody?.categoryBitMask = playerCategory
        player.physicsBody?.collisionBitMask = enemyCategory
        player.physicsBody?.contactTestBitMask = enemyCategory | clearCategory
        
        // 画面に乗せる
        addChild(player)
        
    }
    
    func setUpCenterEnemy() {
        
        // テクスチャを設定
        let enemyTexture = SKTexture(imageNamed: "efect")
        enemyTexture.filteringMode = SKTextureFilteringMode.linear
        
        let moveDistance = CGFloat(self.frame.size.width * 2 + enemyTexture.size().width)
        
        let moveEnemy = SKAction.moveBy(x: -moveDistance, y: 0, duration: 2.0)
        
        let removeEnemy = SKAction.removeFromParent()
        
        let repeatEnemy = SKAction.sequence([moveEnemy, removeEnemy])
        
        let createEnemyAnimation = SKAction.run ({
            // enemy関連のノードを乗せるノード
            let enemy = SKNode()
            
            enemy.position = CGPoint(x: self.frame.size.width + enemyTexture.size().width / 2, y: 0.0)
            enemy.zPosition = 10
            
            // enemy本体の設定
            let enemySprite = SKSpriteNode(texture: enemyTexture)
            enemySprite.position = CGPoint(x: self.frame.size.width * 0.3, y: self.frame.size.height * 0.5)
            
            enemySprite.zPosition = 10
            
            enemySprite.physicsBody = SKPhysicsBody(circleOfRadius: enemySprite.size.height / 2)
            
            enemySprite.physicsBody?.categoryBitMask = self.enemyCategory
            
            enemySprite.physicsBody?.isDynamic = false

            // enemyにenemySpriteを乗せる
            enemy.addChild(enemySprite)
            
            // enemyにアニメーションをさせる
            enemy.run(repeatEnemy)
            
            // enemyNodeにenemyを乗せる
            self.enemyNode.addChild(enemy)
            
        })
        
        let waitAnimation = SKAction.wait(forDuration: 2)
        
        let repeatForeverAnimation = SKAction.repeatForever(SKAction.sequence([createEnemyAnimation, waitAnimation]))
        
        enemyNode.run(repeatForeverAnimation)
        
        }
    
    func setUpUpperEnemy() {
        
        let enemyTexture = SKTexture(imageNamed: "efect")
        enemyTexture.filteringMode = SKTextureFilteringMode.linear
        
        let moveDistance = CGFloat(self.frame.size.width * 2 + enemyTexture.size().width)
        
        let moveEnemy = SKAction.moveBy(x: -moveDistance, y: 0, duration: 5.0)
        
        let removeEnemy = SKAction.removeFromParent()
        
        let repeatEnemy = SKAction.sequence([moveEnemy, removeEnemy])
        
        let createEnemyAnimation = SKAction.run({
            
            let enemy = SKNode()
            
            enemy.position = CGPoint(x: self.frame.size.width + enemyTexture.size().width / 2, y: 0.0)
            
            enemy.zPosition = 10
            
            let enemySprite = SKSpriteNode(texture: enemyTexture)
            
            enemySprite.position = CGPoint(x: self.frame.size.width * 0.3, y: self.frame.size.height * 0.9)
            
            enemySprite.zPosition = 1
            
            enemySprite.physicsBody = SKPhysicsBody(circleOfRadius: enemySprite.size.height / 2)
            
            enemySprite.physicsBody?.isDynamic = false
            
            enemySprite.physicsBody?.categoryBitMask = self.enemyCategory
            
            enemy.addChild(enemySprite)
            
            enemy.run(repeatEnemy)
            
            self.enemyNode.addChild(enemy)
            
        })
        
        let waitAnimation = SKAction.wait(forDuration: 1.0)
        
        let repeatForeverAnimation = SKAction.repeatForever(SKAction.sequence([createEnemyAnimation, waitAnimation]))
        
        enemyNode.run(repeatForeverAnimation)
    }
    
    func setUpUnderEnemy() {
        
        let enemyTexture = SKTexture(imageNamed: "efect")
        enemyTexture.filteringMode = SKTextureFilteringMode.linear
        
        let moveDistance = CGFloat(self.frame.size.width * 2 + enemyTexture.size().width)
        
        let moveEnemy = SKAction.moveBy(x: -moveDistance, y: 0, duration: 1.0)
        
        let removeEnemy = SKAction.removeFromParent()
        
        let repeatEnemy = SKAction.sequence([moveEnemy, removeEnemy])
        
        let createEnemyAnimation = SKAction.run({
            
            let enemy = SKNode()
            
            enemy.position = CGPoint(x: self.frame.size.width + enemyTexture.size().width / 2, y: 0.0)
            
            enemy.zPosition = 10
            
            let enemySprite = SKSpriteNode(texture: enemyTexture)
            
            enemySprite.position = CGPoint(x: self.frame.size.width * 0.3, y: self.frame.size.height * 0.1)
            
            enemySprite.zPosition = 10
            
            enemySprite.physicsBody = SKPhysicsBody(circleOfRadius: enemySprite.size.height / 2)
            
            enemySprite.physicsBody?.isDynamic = false
            
            enemySprite.physicsBody?.categoryBitMask = self.enemyCategory
            
            enemy.addChild(enemySprite)
            
            enemy.run(repeatEnemy)
            
            self.enemyNode.addChild(enemy)
            
        })
        
        let waitAnimation = SKAction.wait(forDuration: 2.0)
        
        let repeatForeverAnimation = SKAction.repeatForever(SKAction.sequence([createEnemyAnimation, waitAnimation]))
        
        enemyNode.run(repeatForeverAnimation)
        
    }
    func setUpBuroriEnemy() {
        
        let enemyTexture = SKTexture(imageNamed: "burori")
        enemyTexture.filteringMode = SKTextureFilteringMode.linear
        
        let moveDistance = CGFloat(self.frame.size.width * 2 + enemyTexture.size().width)
        
        let moveEnemy = SKAction.moveBy(x: -moveDistance, y: 0, duration: 1.0)
        
        let repeatEnemy = SKAction.sequence([moveEnemy])
        
        let createEnemyAnimation = SKAction.run({
            
            let enemy = SKNode()
            
            enemy.position = CGPoint(x: self.frame.size.width + enemyTexture.size().width / 2, y: 0.0)
            
            enemy.zPosition = 10
            
            let enemySprite = SKSpriteNode(texture: enemyTexture)
            
            enemySprite.position = CGPoint(x: self.frame.size.width * 0.3, y: self.frame.size.height * 0.5)
            
            enemySprite.zPosition = 10
            
            enemySprite.physicsBody = SKPhysicsBody(circleOfRadius: enemySprite.size.height / 2)
            
            enemySprite.physicsBody?.isDynamic = false
            
            enemySprite.physicsBody?.categoryBitMask = self.clearCategory
            
            enemySprite.setScale(2)
            
            enemy.addChild(enemySprite)
            
            enemy.run(repeatEnemy)
            
            self.enemyNode.addChild(enemy)
            
        })
        
        let waitAnimation = SKAction.wait(forDuration: 14)
        
        let repeatForeverAnimation = SKAction.repeatForever(SKAction.sequence([waitAnimation, createEnemyAnimation]))
        
        enemyNode.run(repeatForeverAnimation, withKey: "burori")

    }

    func lightButton() {
        
        let buttonTexture = SKTexture(imageNamed: "button")
        buttonTexture.filteringMode = SKTextureFilteringMode.linear
        
        let lightButton = SKSpriteNode(texture: buttonTexture)
        lightButton.position = CGPoint(x: self.frame.size.width * 0.9, y: self.frame.size.height * 0.15)
        
        lightButton.name = "lightButton"
        lightButton.zPosition = 1
        
        addChild(lightButton)
    }
    
    // 画面をタッチした時に呼ばれる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first as UITouch? {
            
            let location = touch.location(in: self)
            
            if self.atPoint(location).name == "lightButton" {
                
                print("lightButton taped")
                if movePosition == 0 {
                    
                    let sounds = SKAction.playSoundFileNamed("瞬間移動", waitForCompletion: true)
                    
                    let playerMoving = SKAction.move(to: CGPoint(x: self.frame.size.width * 0.1, y: self.frame.size.height * 0.1), duration: 0)
                
                    player.run(playerMoving)
                    run(sounds)
                    movePosition += 1
                    
                } else if movePosition == 1 {

                    let sounds = SKAction.playSoundFileNamed("瞬間移動", waitForCompletion: true)

                    let playerMoving = SKAction.move(to: CGPoint(x: self.frame.size.width * 0.1, y: self.frame.size.height * 0.9), duration: 0)
                    
                    player.run(playerMoving)
                    run(sounds)
                    movePosition += 1
                } else if movePosition == 2 {

                    let sounds = SKAction.playSoundFileNamed("瞬間移動", waitForCompletion: true)

                    let playerMoving = SKAction.move(to: CGPoint(x: self.frame.size.width * 0.1, y: self.frame.size.height * 0.5), duration: 0)
                    
                    player.run(playerMoving)
                    run(sounds)
                    movePosition = 0
                }
            } else if player.speed == 0 {
                restart()
            }

        }
        
    }
    
    // 衝突した時に呼ばれる
    func didBegin(_ contact: SKPhysicsContact) {
        
        if (contact.bodyA.categoryBitMask & enemyCategory) == enemyCategory || (contact.bodyB.categoryBitMask & enemyCategory) == enemyCategory {
            
            print("GAME OVER")
            
            scrollNode.speed = 0
            
            player.physicsBody?.collisionBitMask = enemyCategory
            let roll = SKAction.rotate(byAngle: CGFloat (M_PI) * CGFloat(player.position.y) * 0.01, duration: 1)
            player.run(roll, completion: {
                self.player.speed = 0
            })
        } else if (contact.bodyA.categoryBitMask & clearCategory) == clearCategory || (contact.bodyB.categoryBitMask & clearCategory) == clearCategory {
            
            print("GAME CLEAR")
            
            setUpClearLabel()
            
            contact.bodyB.node!.removeFromParent()

            scrollNode.speed = 0
        }
            if scrollNode.speed <= 0 {
                return
        }
    }
    
    func restart() {

        if sound.isPlaying {
            sound.currentTime = 0
        } else {
            self.sound.play()
        }
        
        player.position = CGPoint(x: self.frame.size.width * 0.1, y: self.frame.size.height * 0.5)
        player.physicsBody?.velocity = CGVector.zero
        player.physicsBody?.collisionBitMask = enemyCategory
        player.zRotation = 0
        
        player.speed = 1
        scrollNode.speed = 1
        
        // 全ての子ノードを削除する
        enemyNode.removeAllChildren()
        enemyNode.removeAction(forKey: "burori")
        
        setUpBuroriEnemy()

    }
    
    func setUpClearLabel() {
        
        let clearLabel = SKLabelNode()
        clearLabel.position = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2)
        clearLabel.fontColor = UIColor.black
        clearLabel.zPosition = 100
        clearLabel.fontSize = 100
        clearLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        clearLabel.text = "STAGE CLEAR"
        self.addChild(clearLabel)
        
    }
    
}
