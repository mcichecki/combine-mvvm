//
//  Team.swift
//  CombineDemo
//
//  Created by Michal Cichecki on 30/06/2019.
//  Copyright © 2019 codeuqest. All rights reserved.
//

import Foundation

struct Team {
    var abbreviation: String
}

extension Team: Decodable {
    private enum CodingKeys: String, CodingKey {
        case abbreviation
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        abbreviation = try container.decode(String.self, forKey: .abbreviation)
    }
}
