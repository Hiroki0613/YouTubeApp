//
//  AttentionCell.swift
//  YouTubeApp
//
//  Created by 近藤宏輝 on 2020/08/08.
//  Copyright © 2020 Hiroki. All rights reserved.
//

import UIKit

class AttentionCell: UICollectionViewCell {
    
    var videoItems = [Item]()
    private let attentionId = "attentionId"
    
    lazy var attentionCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        
        return collectionView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .blue
        addSubview(attentionCollectionView)
        
        [
            attentionCollectionView.topAnchor.constraint(equalTo: self.topAnchor),
            attentionCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            attentionCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            attentionCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
            ].forEach { $0.isActive = true }
        
        
//        attentionCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: attentionId)
        attentionCollectionView.register(UINib(nibName: "AttentionCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: attentionId)
        attentionCollectionView.contentInset = .init(top: 0, left: 15, bottom: 0, right: 15)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension AttentionCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = self.frame.height
        return .init(width: height, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = attentionCollectionView.dequeueReusableCell(withReuseIdentifier: attentionId, for: indexPath) as! AttentionCollectionViewCell
        
        return cell
    }
    
    
}