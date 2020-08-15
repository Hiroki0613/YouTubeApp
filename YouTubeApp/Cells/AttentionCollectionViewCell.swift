//
//  AttentionCollectionViewCell.swift
//  YouTubeApp
//
//  Created by 近藤宏輝 on 2020/08/08.
//  Copyright © 2020 Hiroki. All rights reserved.
//

import UIKit
import Nuke

class AttentionCollectionViewCell: UICollectionViewCell {
    
    var videoItem: Item? {
        didSet {
            if let url = URL(string: videoItem?.snippet.thumbnails.medium.url ?? "") {
                Nuke.loadImage(with: url, into: thumbnailImageView)
            }
            
            videoTitleLabel.text = videoItem?.snippet.title
            descriptionLabel.text = videoItem?.snippet.description
            channelTitleLabel.text = videoItem?.channel?.items[0].snippet.title
            
        }
    }
    
    
    @IBOutlet var thumbnailImageView: UIImageView!
    @IBOutlet var videoTitleLabel: UILabel!
    @IBOutlet var channelTitleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
