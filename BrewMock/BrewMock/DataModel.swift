//
//  DataModel.swift
//  BrewMock
//
//  Created by Adrià Abella on 24/10/2019.
//  Copyright © 2019 AdriaAbella. All rights reserved.
//

import Foundation

class DataModel {
    
    private var queryCache : LRUCache = LRUCache<String>(1000)
    
    init() {
        queryCache.set("hello", val: "hello")
        
        print(queryCache.get("hello") as! String)
    }

}
