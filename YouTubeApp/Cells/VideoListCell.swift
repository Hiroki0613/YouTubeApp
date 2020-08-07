//
//  VideoListCell.swift
//  YouTubeApp
//
//  Created by 近藤宏輝 on 2020/08/07.
//  Copyright © 2020 Hiroki. All rights reserved.
//

import UIKit
import Nuke

class VideoListCell: UICollectionViewCell {
    
    var videoItem: Item? {
        didSet {
            
            //通常のURLから画像を呼び出す処理。キャッシュが使われていないので通信量がかかる
//            if let url = URL(string: videoItem?.snippet.thumbnails.medium.url ?? "") {
//                let data =  try! Data(contentsOf: url)
//                thumbnailImageView.image = UIImage(data: data)
//            }
            
            //Nukeはロードした画像をキャッシュしてくれる機能を持っている
            if let url = URL(string: videoItem?.snippet.thumbnails.medium.url ?? "") {
                Nuke.loadImage(with: url, into: thumbnailImageView)
            }
            
            if let channelUrl = URL(string: videoItem?.channel?.items[0].snippet.thumbnails.medium.url ?? "") {
                Nuke.loadImage(with: channelUrl, into: channelImageView)
            }
            
            titleLabel.text = videoItem?.snippet.title
            descriptionLabel.text = videoItem?.snippet.description
        }
    }
    
    
    @IBOutlet var thumbnailImageView: UIImageView!
    @IBOutlet var channelImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        channelImageView.layer.cornerRadius = 40 / 2
    }
    
    
}
