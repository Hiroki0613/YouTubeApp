//
//  Channel.swift
//  YouTubeApp
//
//  Created by 近藤宏輝 on 2020/08/07.
//  Copyright © 2020 Hiroki. All rights reserved.
//

import Foundation

class Channel:  Decodable {
    
    let items: [ChannelItem]
}

class ChannelItem: Decodable {
    let snippet: ChannelSnippet
}

class ChannelSnippet: Decodable {
    
    let title: String
    let thumbnails: Thumbnail
}
