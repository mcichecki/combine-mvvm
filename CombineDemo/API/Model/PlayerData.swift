//
//  PlayerData.swift
//  CombineDemo
//
//  Created by Michal Cichecki on 30/06/2019.
//

import Foundation

struct PlayerData {
    let data: [Player]
}

extension PlayerData: Decodable {
    private enum CodingKeys: String, CodingKey {
        case data
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        data = try container.decode([Player].self, forKey: .data)
    }
}
