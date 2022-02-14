//
//  SolunarModel.swift
//  Appsanthu
//
//  Created by ĐINH HUY PHU on 19/07/2021.
//

import Foundation

class SolunarModel:NSObject {
    var sunRise = ""
    var sunSet = ""
    var moonRise = ""
    var moonUnder = ""
    var moonSet = ""
    var moonTransit = "" // overhead
    var moonIllumination = 0.0
    var minor1Start = ""
    var minor1Stop = ""
    var minor2Start = ""
    var minor2Stop = ""
    
    var major1Start = ""
    var major1Stop = ""
    var major2Start = ""
    var major2Stop = ""
    var dayRating = 0
    var day = ""
    var index = 0
    
    func initLoad(_ json:  [String: Any]) -> SolunarModel{
        if let temp = json["sunRise"] as? String { sunRise = temp }
        if let temp = json["sunSet"] as? String { sunSet = temp }
        
        if let temp = json["moonRise"] as? String { moonRise = temp }
        if let temp = json["moonUnder"] as? String { moonUnder = temp }
        if let temp = json["moonSet"] as? String { moonSet = temp }
        if let temp = json["moonTransit"] as? String { moonTransit = temp }
        
        if let temp = json["minor1Start"] as? String { minor1Start = temp }
        if let temp = json["minor1Stop"] as? String { minor1Stop = temp }
        if let temp = json["minor2Start"] as? String { minor2Start = temp }
        if let temp = json["minor2Stop"] as? String { minor2Stop = temp }
        
        if let temp = json["major1Start"] as? String { major1Start = temp }
        if let temp = json["major1Stop"] as? String { major1Stop = temp }
        if let temp = json["major2Start"] as? String { major2Start = temp }
        if let temp = json["major2Stop"] as? String { major2Stop = temp }
        
        if let temp = json["dayRating"] as? Int { dayRating = temp }
        if let temp = json["moonIllumination"] as? Double { moonIllumination = temp }
        return self
    }
}

extension String{
    func format() -> String{
        let is12 = UserDefaults.standard.bool(forKey: "is12")
        let strs = self.split(separator: ":")
        var result = ""
        if strs.count == 2 {
            if var hour = Int(strs[0]), hour >= 24{
                hour -= 24
                result = hour.description + ":" + strs[1]
            } else {
                result = self
            }
        }
        
        if is12{
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            let date = formatter.date(from: result)
            if date != nil{
                formatter.dateFormat = "h:mm a"
                return formatter.string(from: date!)
            } else {
                return result
            }
        } else{
            return result
        }
    }
}
extension Double {
    func formatUnit() -> Double{
        let isF = UserDefaults.standard.bool(forKey: "isF")
        if isF{
            return (self * 1.8) + 32
        } else {
            return self
        }
    }
}
