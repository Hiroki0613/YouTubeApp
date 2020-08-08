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
    
    private var prevContentOffset: CGPoint = .init(x: 0, y: 0)
    private let headerMoveHeight: CGFloat = 7
    
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
    
    //スクロール情報を取得する,header画面をスクロールして押し出したり、押し戻したりする
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //スクロールの0.5秒前の情報を取得することで、上にスクロールしているのか、下にスクロールしているのかがわかる。
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.prevContentOffset = scrollView.contentOffset
        }
        
        //一番下にスクロールした場合に、アニメーションを止める。位置からindexPathを取得する
        guard let presentIndexPath = videoListCollectionView.indexPathForItem(at: scrollView.contentOffset) else { return }
        
        if scrollView.contentOffset.y < 0 { return }
        
        //indexPath(0からスタート)が一番下の時,その一つ前の状態でアニメーションを止めたい
        if presentIndexPath.row >= videoItems.count - 1 - 1 { return }
        
        //headerViewのalphaを宣言
        let alphaRatio = 1 / headerHeightConstraint.constant
        
        //下へスクロール
        if self.prevContentOffset.y < scrollView.contentOffset.y {
            if headerTopConstraint.constant <= -headerHeightConstraint.constant { return }
            headerTopConstraint.constant -= headerMoveHeight
            headerView.alpha -= alphaRatio * headerMoveHeight
            
        //上へスクロール
        } else if self.prevContentOffset.y > scrollView.contentOffset.y {
            if headerTopConstraint.constant >= 0 { return }
            headerTopConstraint.constant += headerMoveHeight
            headerView.alpha += alphaRatio * headerMoveHeight
        }
        
        print("self.prevContentOffset:  ",self.prevContentOffset," scrollView.contentOffset: ",scrollView.contentOffset)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        //スクロールで指をピタッと止めたときだけを呼び出す。
        if !decelerate {
            headerViewEndAnimation()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        headerViewEndAnimation()
    }
    
    
    private func headerViewEndAnimation() {
        if headerTopConstraint.constant < -headerHeightConstraint.constant / 2 {
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.8, options: [], animations: {
                self.headerTopConstraint.constant = -self.headerHeightConstraint.constant
                self.headerView.alpha = 0
                self.view.layoutIfNeeded()
            })
        } else {
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.8, options: [], animations: {
                self.headerTopConstraint.constant = 0
                self.headerView.alpha = 1
                self.view.layoutIfNeeded()
            })
        }
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
