//
//  GenericMini.swift
//  MiniGram
//
//  Created by Keegan Black on 2/26/20.
//  Copyright © 2020 Keegan Black. All rights reserved.
//

import Foundation
import Firebase

class GenericMini: FireInitable {
    
    var id: String
    var userId: String?
    
    var unit: String?
    var name: String?
    
    var pointValue: Int
    var power: Int
    var movement: Int
    var weaponSkill: Int
    var ballisticSkill: Int
    var strength: Int
    var toughness: Int
    var wounds: Int
    var attacks: Int
    var leadership: Int
    var save: Int
    
    var weapons: [String]?
    var warGear: [String]?
    var abilities: [String]?
    var factionKeywords: [String]?
    var keywords: [String]?
    
    required init(doc: DocumentSnapshot) {
        id = doc.documentID
        userId = doc.get("userId") as? String
        name = doc.get("name") as? String
        unit = doc.get("unit") as? String
        
        pointValue = doc.get("pointValue") as? Int ?? 0
        power = doc.get("power") as? Int ?? 0
        movement = doc.get("movement") as? Int ?? 0
        weaponSkill = doc.get("weaponSkill") as? Int ?? 0
        ballisticSkill = doc.get("ballisticSkill") as? Int ?? 0
        strength = doc.get("strength") as? Int ?? 0
        toughness = doc.get("toughness") as? Int ?? 0
        wounds = doc.get("wounds") as? Int ?? 0
        attacks = doc.get("attacks") as? Int ?? 0
        leadership = doc.get("leadership") as? Int ?? 0
        save = doc.get("save") as? Int ?? 0
        
        weapons = doc.get("weapons") as? [String]
        warGear = doc.get("warGear") as? [String]
        abilities = doc.get("abilities") as? [String]
        factionKeywords = doc.get("factionKeywords") as? [String]
        keywords = doc.get("keywords") as? [String]
    }
    
}
