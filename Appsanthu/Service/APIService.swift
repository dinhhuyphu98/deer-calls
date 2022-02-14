//
//  APIService.swift
//  Appsanthu
//
//  Created by devsenior on 07/07/2021.
//

import Foundation

typealias ApiCompletion = (_ data: Any?, _ error: Error?) -> ()
typealias ApiCompletion2 = (_ data: Any?,_ data2: Any?, _ data3: Any?, _ error: Error?) -> ()
typealias ApiParam = [String: Any]

enum ApiMethod: String {
    case GET = "GET"
    case POST = "POST"
}
extension String {
    func addingPercentEncodingForURLQueryValue() -> String? {
        let allowedCharacters = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~")
        return self.addingPercentEncoding(withAllowedCharacters: allowedCharacters)
    }
}

extension Dictionary {
    func stringFromHttpParameters() -> String {
        let parameterArray = self.map { (key, value) -> String in
            let percentEscapedKey = (key as! String).addingPercentEncodingForURLQueryValue()!
            if value is String {
                let percentEscapedValue = (value as! String).addingPercentEncodingForURLQueryValue()!
                return "\(percentEscapedKey)=\(percentEscapedValue)"
            }
            else {
                return "\(percentEscapedKey)=\(value)"
            }
        }
        return parameterArray.joined(separator: "&")
    }
}
class APIService:NSObject {
    static let shared: APIService = APIService()

    func requestSON(_ url: String,
                    param: ApiParam?,
                    method: ApiMethod,
                    loading: Bool,
                    completion: @escaping ApiCompletion)
    {
        var request:URLRequest!
        
        // set method & param
        if method == .GET {
            if let paramString = param?.stringFromHttpParameters() {
                request = URLRequest(url: URL(string:"\(url)?\(paramString)")!)
            }
            else {
                request = URLRequest(url: URL(string:url)!)
            }
        }
        else if method == .POST {
            request = URLRequest(url: URL(string:url)!)
            
            // content-type
            let headers: Dictionary = ["Content-Type": "application/json"]
            request.allHTTPHeaderFields = headers
            
            do {
                if let p = param {
                    request.httpBody = try JSONSerialization.data(withJSONObject: p, options: .prettyPrinted)
                }
            } catch { }
        }
        
        request.timeoutInterval = 30
        request.httpMethod = method.rawValue
        
        //
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            DispatchQueue.main.async {
                
                // check for fundamental networking error
                guard let data = data, error == nil else {
                    completion(nil, error)
                    return
                }
                
                // check for http errors
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200,let res = response{
                }
                
                if let resJson = self.convertToJson(data) {
                    completion(resJson, nil)
                }
                else if let resString = String(data: data, encoding: .utf8) {
                    completion(resString, error)
                }
                else {
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
    
    private func convertToJson(_ byData: Data) -> Any? {
        do {
            return try JSONSerialization.jsonObject(with: byData, options: [])
        } catch {
            //            self.debug("convert to json error: \(error)")
        }
        return nil
    } 
    //https://raw.githubusercontent.com/dinhhuyphu98/github-slideshow/dinhhuyphu98-patch-1/animal.json
    
    func GetMangaAll(closure: @escaping (_ response: [AnimalModel]?, _ error: Error?) -> Void) {
        requestSON("https://raw.githubusercontent.com/dinhhuyphu98/github-slideshow/dinhhuyphu98-patch-3/animal.json", param: nil, method: .GET, loading: true) { (data , error) in
            if let data = data as? [ [String: Any]] {
                var listAnimalReturn:[AnimalModel] = [AnimalModel]()
                for item1 in data{
                    var itemAdd:AnimalModel = AnimalModel()
                    itemAdd = itemAdd.initLoad(item1)
                    listAnimalReturn.append(itemAdd)
                    if let mSounds = item1["mSounds"] as? [[String: Any]]{
                        for item2 in mSounds{
                            var itemmSoundsAdd:AnimalModel = AnimalModel()
                            itemmSoundsAdd = itemmSoundsAdd.initLoad(item2)
                            listAnimalReturn.append(itemmSoundsAdd)
                        }
                    }
                }
                

                closure(listAnimalReturn, nil)
                
            }
        
            else {
                closure(nil,nil)
            }
        }
    }

    
    func GetSoluarAPI(_ latitude : String,_ longitude: String, _ day: String,_ timeZone: String, completion: @escaping ApiCompletion) {
        requestSON("https://api.solunar.org/solunar/\(latitude),\(longitude),\(day),\(timeZone)", param: nil, method: .GET, loading: true) { (data, error) in
            if let data = data as? [String : Any] {
                var solunar = SolunarModel()
                solunar = solunar.initLoad(data)
                completion(solunar, nil)
            }
            completion(nil, nil)
        }
    }
    
    func GetFullAPI(_ latitude : String,_ longitude: String, completion: @escaping ApiCompletion2) {
        requestSON("https://api.darksky.net/forecast/f3ce92e52d7509098b59805b2e280a60/\(latitude),\(longitude)?units=si", param: nil, method: .GET, loading: true) { (data, error) in
            if let data = data as? [String : Any] {
                
                if let currentData = data["currently"] as? [String: Any]{
                    var today = TodayModel()
                    today = today.initLoad(currentData)
                    let timeZone = data["timezone"] as? String
                    if let daily = data["daily"] as? [String: Any]{
                        if let listData = daily["data"] as? [[String: Any]]{
                            var listDaily = [DailyModel]()
                            for day in listData{
                                var dayAdd = DailyModel()
                                dayAdd = dayAdd.initLoad(day)
                                listDaily.append(dayAdd)
                            }
                            completion(today, listDaily, timeZone,nil)
                        }
                    }
                }
            }
            completion(nil,nil,nil,nil)
        }
    }
    func GetLocation(_ name: String, completion: @escaping ApiCompletion) {
        let api = "http://api.geonames.org/searchJSON?username=ksuhiyp&maxRows=15&style=SHORT&name=\(name)"
        let urlString = api.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        requestSON(urlString!, param: nil, method: .GET, loading: true) { (data, error) in
            if let data = data as? [String : Any] {
                if let list = data["geonames"] as? [[String : Any]]{
                    var location = LocationModel()
                    if list.count > 0 {
                        location = location.initLoad(list[0])
                        completion(location, nil)
                    } else{
                        completion(nil,nil)
                    }
                } else{
                    completion(nil,nil)
                }
            }
            completion(nil,nil)
        }
    }
}
