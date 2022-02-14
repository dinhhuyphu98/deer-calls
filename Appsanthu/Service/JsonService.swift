//
//  JsonService.swift
//  Appsanthu
//
//  Created by ĐINH HUY PHU on 05/08/2021.
//

import Foundation

import Foundation
class JsonService: NSObject{
    static let shared: JsonService = JsonService()
    
    func readJsonFile() -> [AnimalModel]{
        var listAnimal = [AnimalModel]()
        if let path = Bundle.main.path(forResource: "animal", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let listData = jsonResult as? [[String: Any]] {
                    for item in listData{
                        var animalAdd = AnimalModel()
                        animalAdd = animalAdd.initLoad(item)
                        listAnimal.append(animalAdd)
                    }
                }
            } catch {
                print(error)
            }
        }
        return listAnimal
    }
//    func readJsonPlaylist() -> [PlaylistModel] {
//        var playlist = [PlaylistModel]()
//        guard let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return []}
//        do {
//            let fileURLs = try FileManager.default.contentsOfDirectory(at: documentDirectoryUrl, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
//            if fileURLs.count == 0 {
//                return []
//            }
//            for fileURL in fileURLs {
//                if fileURL.lastPathComponent.contains("(playlist)"){
//                    let data = try Data(contentsOf: URL(fileURLWithPath: fileURL.path), options: .mappedIfSafe)
//                    let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
//                    if let listData = jsonResult as? [String: Any] {
//                        var playlistAdd = PlaylistModel()
//                        playlistAdd = playlistAdd.initLoad(listData)
//                        playlist.append(playlistAdd)
//                        
//                    }
//                }
//            }
//           return playlist
//        } catch  {
//            return []
//            
//        }
//    }
    func readJsonLog() -> [LogModel] {
        var list = [LogModel]()
        guard let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return []}
        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: documentDirectoryUrl, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            if fileURLs.count == 0 {
                return []
            }
            for fileURL in fileURLs {
                if fileURL.lastPathComponent.contains("(log)"){
                    let data = try Data(contentsOf: URL(fileURLWithPath: fileURL.path), options: .mappedIfSafe)
                    let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                    if let listData = jsonResult as? [String: Any] {
                        var LogAdd = LogModel()
                        LogAdd = LogAdd.initLoad(listData)
                        list.append(LogAdd)
                        
                    }
                }
            }
           return list
        } catch  {
            return []
            
        }
    }
//    func writeOjectToJson(playlist: PlaylistModel){
//        guard let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
//        let fileUrl = documentDirectoryUrl.appendingPathComponent(playlist.name + "(playlist).json")
//        print(documentDirectoryUrl)
//        do{
//            let jsonEncoder = JSONEncoder()
//            let jsonData = try jsonEncoder.encode(playlist)
//            let json = String(data: jsonData, encoding: String.Encoding.utf8)
//            try json?.write(to: fileUrl, atomically: true, encoding: .utf8)
//            //print(fileUrl.path)
//        }catch{
//            print(error)
//        }
//    }
    func writeOjectToJson(item: LogModel){
        guard let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileUrl = documentDirectoryUrl.appendingPathComponent(item.hour + "_" + item.day + "(log).json")
        print(documentDirectoryUrl)
        print(fileUrl.path)
        do{
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(item)
            let json = String(data: jsonData, encoding: String.Encoding.utf8)
            try json?.write(to: fileUrl, atomically: true, encoding: .utf8)
            //print(fileUrl.path)
        }catch{
            print(error)
        }
    }
    func getDocumentsDirectory() -> URL? {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
