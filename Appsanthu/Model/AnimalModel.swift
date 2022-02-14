//
//  AnimailModel.swift
//  Appsanthu
//
//  Created by devsenior on 07/07/2021.
//

import UIKit
class MSoundModel: NSObject {
    var name : String = ""
    var soundFile : String = ""
    var timeLength: Double = 0.0
    var uniqueID: Int = 0
    func initLoad(_ json:  [String: Any]) -> MSoundModel{
        if let temp = json["name"] as? String{ name = temp}
        if let temp = json["timeLength"] as? Double { timeLength = temp }
        if let temp = json["soundFile"] as? String { soundFile = temp }
        if let temp = json["uniqueID"] as? Int { uniqueID = temp }
        return self
    }

}

class AnimalModel: NSObject {
    var Description : String = ""
    var animalName : String = ""
    var image : String = ""
    var idRes : Int = 0
    var name: String = ""
    var mSound:[MSoundModel] = [MSoundModel]()
    func initLoad(_ json:  [String: Any]) -> AnimalModel{
        if let temp = json["Description"] as? String { Description = temp }
        if let temp = json["animalName"] as? String { animalName = temp }
        if let temp = json["image"] as? String { image = temp }
        if let temp = json["idRes"] as? Int { idRes = temp }
        if let temp = json["name"] as? String{ name = temp}
        if let tempPro = json["mSounds"] as? [[String:Any]] {
            for item in tempPro{
                var sonitem:MSoundModel = MSoundModel()
                sonitem = sonitem.initLoad(item)
                self.mSound.append(sonitem)
            }
        }
        return self
    }

}
