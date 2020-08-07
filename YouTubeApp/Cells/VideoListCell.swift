//
//  VideoListCell.swift
//  YouTubeApp
//
//  Created by 近藤宏輝 on 2020/08/07.
//  Copyright © 2020 Hiroki. All rights reserved.
//

import UIKit

class VideoListCell: UICollectionViewCell {
    
    
    @IBOutlet var channelImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        channelImageView.layer.cornerRadius = 40 / 2
    }
    
    
}
