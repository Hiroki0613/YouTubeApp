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
    
    private let cellId = "cellId"
    private var videoItems = [Item]()

    
    @IBOutlet var videoListCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        videoListCollectionView.delegate = self
        videoListCollectionView.dataSource = self
        
        //どのクラスのcollectionViewCellを使うかを決められる
//        videoListCollectionView.register(VideoListCell.self, forCellWithReuseIdentifier: cellId)
        
        videoListCollectionView.register(UINib(nibName: "VideoListCell", bundle: nil), forCellWithReuseIdentifier: cellId)
        
        fetchYouTubeSearchInfo()
        
        

        
    }
    
    private func fetchYouTubeSearchInfo() {
        //Alamofireの情報
        let urlString = "https://www.googleapis.com/youtube/v3/search?q=lebronjames&key=AIzaSyBS-bPWbEx2wTppybswbyx77wv9yVTutLY&part=snippet"
        
        let request = AF.request(urlString)
        
        request.responseJSON { (response) in
            
            //tryを入れる場合は、do,try catchを入れないといけない
            do {
                guard let data = response.data else { return }
                let decode = JSONDecoder()
                let video = try decode.decode(Video.self, from: data)
                self.videoItems = video.items
                
                let id = self.videoItems[0].snippet.channelId
                self.fetchYouTubeChannelInfo(id: id)
                
            } catch {
                print("変換に失敗しました。： ", error)
            }
            
//            //response内容を表示
            //            print("response: ", response)
        }
    }
    
    private func fetchYouTubeChannelInfo(id: String) {
        //Alamofireの情報
        let urlString = "https://www.googleapis.com/youtube/v3/channels?key=AIzaSyBS-bPWbEx2wTppybswbyx77wv9yVTutLY&part=snippet&id=\(id)"
        
        let request = AF.request(urlString)
        
        request.responseJSON { (response) in
            
            //tryを入れる場合は、do,try catchを入れないといけない
            do {
                guard let data = response.data else { return }
                let decode = JSONDecoder()
                let channel = try decode.decode(Channel.self, from: data)
//                self.videoItems = video.items
                self.videoItems.forEach { (item) in
                    item.channel = channel
                }
                
                
                //このタイミングでcollectionViewをリロードしておくと、cellに情報が入る。
                self.videoListCollectionView.reloadData()
            } catch {
                print("変換に失敗しました。： ", error)
            }
            
            //            //response内容を表示
            //            print("response: ", response)
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
