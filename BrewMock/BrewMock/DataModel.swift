//
//  DataModel.swift
//  BrewMock
//
//  Created by Adrià Abella on 24/10/2019.
//  Copyright © 2019 AdriaAbella. All rights reserved.
//

import Foundation

class DataModel {
    
    private var queryCache : [String: String] = [:]
    
    init() {
        loadToUserDefaults()
    }
    
    public func searchBeersForFood(_ searchTerms: String, completionHandler: (_ result: String) -> Void) {
        if let result: String = queryCache[searchTerms] {
            print("Element found!")
            //completionHandler(result)
        } else {
            print("Query")
            requestBeersForFood(searchTerms, onComplete: completionHandler)
        }
    }
    
    // Example!
    private func requestBeersForFood(_ searchTerms: String, onComplete: (_ result: String) -> Void) {
        //let params = ["username":"john", "password":"123456"] as Dictionary<String, String>
        let foodParams: String = searchTerms.replacingOccurrences(of: " ", with: "_").lowercased()
        var request = URLRequest(url: URL(string: "https://api.punkapi.com/v2/beers?food="+foodParams)!)
        request.httpMethod = "GET"
        //request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            //print(response!)
            do {
                let json = try JSONSerialization.jsonObject(with: data!) as! Array<Dictionary<String, AnyObject>>
                print(json)
                self.queryCache[searchTerms] = String(data: data!, encoding: String.Encoding.utf8)
                self.saveToUserDefaults()
                print("A-OK")
            } catch {
                print("error")
            }
        })
        
        task.resume()
    }
    
    private func saveToUserDefaults() {
        UserDefaults.standard.set(object: queryCache, forKey: "QueryCache")
    }
    
    private func loadToUserDefaults() {
        queryCache = UserDefaults.standard.object([String: String].self, with: "QueryCache")!
    }

}

extension UserDefaults {
    func object<T: Codable>(_ type: T.Type, with key: String, usingDecoder decoder: JSONDecoder = JSONDecoder()) -> T? {
        guard let data = self.value(forKey: key) as? Data else { return nil }
        return try? decoder.decode(type.self, from: data)
    }

    func set<T: Codable>(object: T, forKey key: String, usingEncoder encoder: JSONEncoder = JSONEncoder()) {
        let data = try? encoder.encode(object)
        self.set(data, forKey: key)
    }
}
