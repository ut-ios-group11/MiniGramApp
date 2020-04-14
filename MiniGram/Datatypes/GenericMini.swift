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
    var date: Timestamp?
    
    var unit: String?
    var name: String?
    var image: UIImage?
    
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
        date = doc.get("date") as? Timestamp ?? Timestamp()
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
    
    init(id: String, userId: String, date: Timestamp, unit: String, name: String, image: UIImage, pointValue: Int, power: Int, movement: Int, weaponSkill: Int, ballisticSkill: Int, strength: Int, toughness: Int, wounds: Int, attacks: Int, leadership: Int, save: Int, weapons: [String], warGear: [String], abilities: [String], factionKeywords: [String], keywords: [String]) {
        self.id = id
        self.userId = userId
        self.date = date
        self.unit = unit
        self.name = name
        self.image = image
        self.pointValue = pointValue
        self.power = power
        self.movement = movement
        self.weaponSkill = weaponSkill
        self.ballisticSkill = ballisticSkill
        self.strength = strength
        self.toughness = toughness
        self.wounds = wounds
        self.attacks = attacks
        self.leadership = leadership
        self.save = save
        self.weapons = weapons
        self.warGear = warGear
        self.abilities = abilities
        self.factionKeywords = factionKeywords
        self.keywords = keywords
    }
    
    func toDict() -> [String : Any] {
        return [
            "unit": unit ?? "",
            "name": name ?? "",
            "pointValue": pointValue,
            "power": power,
            "movement": movement,
            "weaponSkill": weaponSkill,
            "ballisticSkill": ballisticSkill,
            "strength": strength,
            "toughness": toughness,
            "wounds": wounds,
            "attacks": attacks,
            "leadership": leadership,
            "save": save,
            "weapons": weapons ?? [String](),
            "warGear": warGear ?? [String](),
            "abilities": abilities ?? [String](),
            "factionKeywords": factionKeywords ?? [String](),
            "keywords": keywords ?? [String](),
            "date": Timestamp()
        ]
    }
    
    func downloadImageIfMissing(onComplete: ((UIImage)-> Void)? = nil) {
        if image == nil {
            downloadImage(onComplete: onComplete)
        }
    }
    
    func downloadImageForced() {
        downloadImage()
    }
    
    private func downloadImage(onComplete: ((UIImage)-> Void)? = nil) {
        Database.shared.downloadMiniatureImage(id: id, onError: { (error) in
            LogManager.logError(error)
        }) { (image) in
            self.image = image
            LogManager.logInfo("Image for miniature \(self.id) downloaded")
            onComplete?(image)
        }
    }
    
    func update(with mini: GenericMini) {
        unit = mini.unit
        name = mini.name
        
        pointValue = mini.pointValue
        power = mini.power
        movement = mini.movement
        weaponSkill = mini.weaponSkill
        ballisticSkill = mini.ballisticSkill
        strength = mini.strength
        toughness = mini.toughness
        wounds = mini.wounds
        attacks = mini.attacks
        leadership = mini.leadership
        save = mini.save
        
        weapons = mini.weapons
        warGear = mini.warGear
        abilities = mini.abilities
        factionKeywords = mini.factionKeywords
        keywords = mini.keywords
    }
}
