//
//  SearchQuery.swift
//  EducationalProjectIvanRep
//
//  Created by Undabot Rep on 04/07/16.
//  Copyright © 2016 Undabot. All rights reserved.
//

import Foundation

/// Query used to filter timeline tweets
class SearchQuery: NSObject, NSCoding {
    let name: String
    let query: String

    /// SearchQuery currently being used
    var inUse: Bool

    init(name: String, query: String, inUse: Bool) {
        self.name = name
        self.query = query
        self.inUse = inUse

        super.init()
    }

    required convenience init?(coder decoder: NSCoder) {
        guard let name = decoder.decodeObjectForKey("name") as? String,
            query = decoder.decodeObjectForKey("query") as? String
            else { return nil }

        let inUse = decoder.decodeBoolForKey("in_use")

        self.init(name: name, query: query, inUse: inUse)
    }

    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(self.name, forKey: "name")
        coder.encodeObject(self.query, forKey: "query")
        coder.encodeBool(self.inUse, forKey: "in_use")
    }
}

class SearchQueries: NSObject, NSCoding {

    var searchQueries: NSArray

    init(searchQueries: [SearchQuery] = []) {
        self.searchQueries = searchQueries

        super.init()
    }

    required convenience init?(coder decoder: NSCoder) {
        guard let queries = decoder.decodeObjectForKey("queries") as? [SearchQuery]
            else { return nil }

        self.init(searchQueries: queries)
    }

    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(self.searchQueries, forKey: "queries")
    }
}
