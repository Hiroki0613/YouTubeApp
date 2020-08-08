//
//  ViewController.swift
//  YouTubeApp
//
//  Created by 近藤宏輝 on 2020/08/07.
//  Copyright © 2020 Hiroki. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    @IBOutlet var profileImgeView: UIImageView!
    @IBOutlet var videoListCollectionView: UICollectionView!
    @IBOutlet var headerView: UIView!
    @IBOutlet var headerHeightConstraint: NSLayoutConstraint!
    @IBOutlet var headerTopConstraint: NSLayoutConstraint!
    
    private let cellId = "cellId"
    private var videoItems = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        videoListCollectionView.delegate = self
        videoListCollectionView.dataSource = self
        
        
        profileImgeView.layer.cornerRadius = 20
        
        //どのクラスのcollectionViewCellを使うかを決められる
        //        videoListCollectionView.register(VideoListCell.self, forCellWithReuseIdentifier: cellId)
        
        videoListCollectionView.register(UINib(nibName: "VideoListCell", bundle: nil), forCellWithReuseIdentifier: cellId)
        
        fetchYouTubeSearchInfo()
        
    }
    
    private func fetchYouTubeSearchInfo() {
        let params = ["q": "lebronjames"]
        
        API.shared.request(path: .search, params: params, type: Video.self) { (video) in
            
            self.videoItems = video.items
            let id = self.videoItems[0].snippet.channelId
            self.fetchYouTubeChannelInfo(id: id)
        }
        
    }
    
    private func fetchYouTubeChannelInfo(id: String) {
        let params = [
            "id": id
        ]
        
        API.shared.request(path: .channels, params: params, type: Channel.self) { (channel) in
            self.videoItems.forEach { (item) in
                item.channel = channel
            }
            self.videoListCollectionView.reloadData()
        }
    }
    
    //スクロール情報を取得する
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("scrollView.contentOffset: ", scrollView.contentOffset)
    }
    
}


//UICollectionViewDelegateFlowLayoutはセルの大きさを決めてくれるデリゲート
extension ViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    
    //コレクションビューの個別のセルの大きさを決めることができる。
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //セルの横幅と同じ長さを縦にも適用
        let width = self.view.frame.width
        
        //セルの高さを記載している
        return .init(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videoItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = videoListCollectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! VideoListCell
        cell.videoItem = videoItems[indexPath.row]
        return cell
    }
    
    
}
