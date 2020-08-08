//
//  APIRequest.swift
//  YouTubeApp
//
//  Created by 近藤宏輝 on 2020/08/07.
//  Copyright © 2020 Hiroki. All rights reserved.
//

import Foundation
import Alamofire

class API {
          
    enum PathType: String {
        case search
        case channels
    }
    
    //シングルトン
    static let shared = API()
    
    private let baseUrl = "https://www.googleapis.com/youtube/v3/"
    
    //共通の処理、ジェネリクス
    func request<T: Decodable>(path: PathType, params: [String: Any], type: T.Type, completion: @escaping (T) -> Void) {
        //Alamofireの情報
        let path = path.rawValue
        let url = baseUrl + path + "?"
        
        var params = params
        params["key"] = "AIzaSyBS-bPWbEx2wTppybswbyx77wv9yVTutLY"
        params["part"] = "snippet"
        
        //        let params = [
        //            "key": "AIzaSyBS-bPWbEx2wTppybswbyx77wv9yVTutLY",
        //            "part": "snippet",
        //            "id" : ""
        //        ]
        
        let request = AF.request(url, method: .get, parameters: params)
        
        request.responseJSON { (response) in
            
            guard let statusCode = response.response?.statusCode else { return }
            //HTTPレスポンスの数が300を超えている場合は処理を中止
            if statusCode <= 300 {
                //tryを入れる場合は、do,try catchを入れないといけない
                do {
                    guard let data = response.data else { return }
                    let decoder = JSONDecoder()
                    let value = try decoder.decode(T.self, from: data)
                    
                    completion(value)
                } catch {
                    print("変換に失敗しました。： ", error)
                }
            }
            //            //response内容を表示
            //            print("response: ", response)
        }
    }
}
