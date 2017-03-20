//
//  GameViewController.swift
//  LonelyStory
//
//  Created by 石田陵 on 2017/03/16.
//  Copyright © 2017年 ryo.ishida. All rights reserved.
//

import UIKit

var gameView: GameView!
var gameScene: GameScene!

class GameViewController: UIViewController {

    
    @IBOutlet weak var jumpButton: UIButton!
    
    @IBAction func jumpButtonAction(_ sender: Any) {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
