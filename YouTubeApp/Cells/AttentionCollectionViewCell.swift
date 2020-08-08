//
//  AttentionCollectionViewCell.swift
//  YouTubeApp
//
//  Created by 近藤宏輝 on 2020/08/08.
//  Copyright © 2020 Hiroki. All rights reserved.
//

import UIKit

class AttentionCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var thumbnailImageView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .purple
    }
}
