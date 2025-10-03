//
//  PostCellModel.swift
//  BattleGroundAssement
//
//  Created by Satyam Singh on 01/10/25.
//

import Foundation
 
struct PostCellModel: Identifiable, Hashable {
    let userID, id: Int
    let title, body: String
    var isFavorite: Bool = false
}
