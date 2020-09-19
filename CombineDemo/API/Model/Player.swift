//
//  Player.swift
//  CombineDemo
//
//  Created by Michal Cichecki on 30/06/2019.
//

import Foundation

struct Player {
    var firstName: String
    var lastName: String
    let team: Team
}

extension Player: Decodable {
    private enum CodingKeys: String, CodingKey {
        case first_name
        case last_name
        case team
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        firstName = try container.decode(String.self, forKey: .first_name)
        lastName = try container.decode(String.self, forKey: .last_name)
        team = try container.decode(Team.self, forKey: .team)
    }
}


