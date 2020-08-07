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

    
    @IBOutlet var videoListCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        videoListCollectionView.delegate = self
        videoListCollectionView.dataSource = self
        
        //どのクラスのcollectionViewCellを使うかを決められる
//        videoListCollectionView.register(VideoListCell.self, forCellWithReuseIdentifier: cellId)
        
        videoListCollectionView.register(UINib(nibName: "VideoListCell", bundle: nil), forCellWithReuseIdentifier: cellId)
        
        
        
        //Alamofireの情報
        let urlString = "https://www.googleapis.com/youtube/v3/search?q=lebronjames&key=AIzaSyBS-bPWbEx2wTppybswbyx77wv9yVTutLY&part=snippet"
        
        let request = AF.request(urlString)
        
        request.responseJSON { (response) in
            
            //tryを入れる場合は、do,try catchを入れないといけない
            do {
                guard let data = response.data else { return }
                let decode = JSONDecoder()
                let video = try decode.decode(Video.self, from: data)
                print("video: " , video.items.count)
            } catch {
                print("変換に失敗しました。： ", error)
            }
            
            //response内容を表示
            print("response: ", response)
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
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = videoListCollectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! VideoListCell
        return cell
    }
    
    
}
