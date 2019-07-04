//
//  VideoView.swift
//  camera
//
//  Created by Mateus Rodrigues Santos on 02/07/19.
//  Copyright © 2019 Mateus Rodrigues Santos. All rights reserved.
//

import Foundation
import UIKit
import AVKit
import AVFoundation

class VideoView: UIView{
    let playerController = AVPlayerViewController()
    var player = AVPlayer()
    var playerLayer = AVPlayerLayer()
    
    func configurar(videoObtido: NSURL? )  {
        if videoObtido != nil{
            player = AVPlayer(url: videoObtido!  as URL)
            playerLayer = AVPlayerLayer(player: player)
            playerLayer.frame = bounds
            playerController.player = player
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
