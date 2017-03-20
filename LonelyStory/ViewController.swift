//
//  ViewController.swift
//  LonelyStory
//
//  Created by 石田陵 on 2017/03/12.
//  Copyright © 2017年 ryo.ishida. All rights reserved.
//

import UIKit
import SpriteKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // viewからSKViewに型変換
        let skView = self.view as! SKView
        
        // FPSを表示する
        skView.showsFPS = true
        
        // ノードの数を表示する
        skView.showsNodeCount = true
        
        // ビューと同じサイズでシーンを作成する
        let scene = GameScene(size: skView.frame.size)
//        let scene = GameView(fileNamed: "GameScene")
        
//        scene?.scaleMode = .fill
        // ビューにシーンを表示する
        skView.presentScene(scene)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // ステータスバーを消す --- ここから ---
    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }
    }

}

