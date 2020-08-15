//
//  VideoViewController.swift
//  YouTubeApp
//
//  Created by 近藤宏輝 on 2020/08/15.
//  Copyright © 2020 Hiroki. All rights reserved.
//

import UIKit
import Nuke

class VideoViewController: UIViewController {
    
    var selectedItem: Item?
    
    @IBOutlet var videoImageView: UIImageView!
    @IBOutlet var channelImgeView: UIImageView!
    @IBOutlet var videoTitleLabel: UILabel!
    @IBOutlet var channelTitleLabel: UILabel!    
    @IBOutlet var baseBackGroundView: UIView!
    @IBOutlet var backView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.3) {
            self.baseBackGroundView.alpha = 1
        }
    }
    
    private func setupViews() {
        
        channelImgeView.layer.cornerRadius = 45 / 2
        
        if let url = URL(string: selectedItem?.snippet.thumbnails.medium.url ?? "") {
            Nuke.loadImage(with: url, into: videoImageView)
            
        }
        if let channelUrl = URL(string: selectedItem?.channel?.items[0].snippet.thumbnails.medium.url ?? "") {
            Nuke.loadImage(with: channelUrl, into: channelImgeView)
        }
        
        videoTitleLabel.text = selectedItem?.snippet.title
        channelTitleLabel.text = selectedItem?.channel?.items[0].snippet.title
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panVideoImageView))
        videoImageView.addGestureRecognizer(panGesture)
    }
    
    @objc private func panVideoImageView(gesture: UIPanGestureRecognizer) {
        
        guard let imageView = gesture.view else { return }
        let move = gesture.translation(in: imageView)
        
        if gesture.state == .changed {
            imageView.transform = CGAffineTransform(translationX: 0, y: move.y)
        } else if gesture.state == .ended {
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: [], animations: {
                //元の場所に戻る
                imageView.transform = .identity
                self.view.layoutIfNeeded()
            })
          
        }
        
//        print("gesture.translation: ", gesture.translation(in: imageView))
    }
}
