//
//  LocationModel.swift
//  Appsanthu
//
//  Created by ĐINH HUY PHU on 30/07/2021.
//

import Foundation

class LocationModel: Codable{
    var lng = ""
    var name = ""
    var lat = ""
    func initLoad(_ json:  [String: Any]) -> LocationModel{
        if let temp = json["lng"] as? String { lng = temp }
        if let temp = json["lat"] as? String { lat = temp }
        if let temp = json["name"] as? String { name = temp }
        
        return self
    }
}
class DailyModel: Codable{
    var time = 0
    var icon = ""
    var temperatureHigh = 0.0
    var temperatureLow = 0.0
    func initLoad(_ json:  [String: Any]) -> DailyModel{
        if let temp = json["time"] as? Int { time = temp }
        if let temp = json["icon"] as? String { icon = temp }
        if let temp = json["temperatureHigh"] as? Double { temperatureHigh = temp }
        if let temp = json["temperatureLow"] as? Double { temperatureLow = temp }
        return self
    }
}
class TodayModel: Codable{
    var time = 0
    var icon = ""
    var temperature = 0.0
    func initLoad(_ json:  [String: Any]) -> TodayModel{
        if let temp = json["time"] as? Int { time = temp }
        if let temp = json["icon"] as? String { icon = temp }
        if let temp = json["temperature"] as? Double { temperature = temp }
        return self
    }
}
