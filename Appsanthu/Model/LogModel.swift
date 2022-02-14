//
//  LogModel.swift
//  Appsanthu
//
//  Created by ĐINH HUY PHU on 04/08/2021.
//

import Foundation

class LogModel: NSObject, Codable {
    var longtitue = 0.0
    var latitue = 0.0
    var day = ""
    var hour = ""
    var iconWeather = ""
    var tempurature = 0.0
    var dayRating = 0
    var note = ""
//    var listCallUsed: [SoundModel] = []
//    var listPlayList: [PlaylistModel] = []
    var listImage: [String] = []
    init(longtitue: Double, latitue: Double) {
        self.longtitue = longtitue
        self.latitue = latitue
    }
    override init() {
        
    }
    func initLoad(_ json:  [String: Any]) -> LogModel{
        if let temp = json["longtitue"] as? Double { longtitue = temp }
        if let temp = json["latitue"] as? Double { latitue = temp }
        if let temp = json["day"] as? String { day = temp}
        if let temp = json["hour"] as? String { hour = temp}
        if let temp = json["iconWeather"] as? String { iconWeather = temp}
        if let temp = json["tempurature"] as? Double { tempurature = temp}
        if let temp = json["dayRating"] as? Int { dayRating = temp}
        if let temp = json["note"] as? String { note = temp}
//        if let temp = json["listCallUsed"] as? [[String: Any]] {
//            for item in temp{
//                var soundAdd = SoundModel()
//                soundAdd = soundAdd.initLoad(item)
//                listCallUsed.append(soundAdd)
//            }
//        }
//        if let temp = json["listPlayList"] as? [[String: Any]] {
//            for item in temp{
//                var playListAdd = PlaylistModel()
//                playListAdd = playListAdd.initLoad(item)
//                listPlayList.append(playListAdd)
//            }
//        }
//        if let temp = json["listImage"] as? [String] {
//            for item in temp{
//                listImage.append(item)
//            }
//        }
        return self
    }
}
