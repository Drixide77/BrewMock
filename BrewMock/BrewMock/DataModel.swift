//
//  DataModel.swift
//  BrewMock
//
//  Created by Adrià Abella on 24/10/2019.
//  Copyright © 2019 AdriaAbella. All rights reserved.
//

import Foundation

public struct Beer : Codable {
    public let name: String?
    public let tagline: String?
    public let description: String?
    public let image_url: String?
    public let abv: Float?
}

class DataModel {
    // TODO: Cache could be optimized using an LRU cache (but might be overkill for this use case?)
    private var queryCache : [String: String] = [:]
    
    public var currentData : Array<Beer> = []
    
    init() {
        loadToUserDefaults()
    }
    
    public func searchBeersForFood(_ searchTerms: String, completionHandler: (() -> Void)?) {
        if let result: String = queryCache[searchTerms] {
            print("Element found!")
            let data = result.data(using: .utf8)
            currentData = try! JSONDecoder().decode(Array<Beer>.self, from: data!)
            completionHandler?()
        } else {
            print("Query necessary")
            requestBeersForFood(searchTerms, onComplete: completionHandler)
        }
    }
    
    private func requestBeersForFood(_ searchTerms: String, onComplete: (() -> Void)?) {
        let foodParams: String = searchTerms.replacingOccurrences(of: " ", with: "_").lowercased()
        var request = URLRequest(url: URL(string: "https://api.punkapi.com/v2/beers?food="+foodParams)!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            do {
                if let empty = try JSONSerialization.jsonObject(with: data!) as? NSDictionary {
                    if empty.count == 0 {
                        self.currentData = Array<Beer>()
                    }
                    else
                    {
                        print(empty)
                    }
                }
                if let json = try JSONSerialization.jsonObject(with: data!) as? Array<Beer> {
                    print(json)
                    self.currentData = json
                }
                self.queryCache[searchTerms] = String(data: data!, encoding: String.Encoding.utf8)
                self.saveToUserDefaults()
                onComplete?()
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

// MARK: UserDefaults extension

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
