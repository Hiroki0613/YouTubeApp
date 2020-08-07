//
//  Video.swift
//  YouTubeApp
//
//  Created by 近藤宏輝 on 2020/08/07.
//  Copyright © 2020 Hiroki. All rights reserved.
//

import Foundation

//YouTubeのプロパティを設定する(必要な情報のみ)
class Video: Decodable {
    let kind: String
    let items: [Item]
}

//階層でクラスを分ける
class Item: Decodable {
    let snippet: Snippet
}

class Snippet: Decodable {
    
    let publishedAt: String
    let channelId: String
    let title: String
    let description: String
    let thumbnails: Thumbnail
}

class Thumbnail: Decodable {
    
    let medium: ThumbnailInfo
    let high: ThumbnailInfo
}

class ThumbnailInfo: Decodable {
    let url: String
    let width: Int?
    let height: Int?
}
