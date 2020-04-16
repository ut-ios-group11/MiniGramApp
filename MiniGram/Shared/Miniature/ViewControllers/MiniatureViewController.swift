//
//  MiniatureViewController.swift
//  MiniGram
//
//  Created by Diego Maceda on 4/10/20.
//  Copyright © 2020 Keegan Black. All rights reserved.
//

import UIKit

infix operator ???: NilCoalescingPrecedence
public func ???<T>(optional: T?, defaultValue: @autoclosure () -> String) -> String {
    return optional.map { String(describing: $0) } ?? defaultValue()
}

class MiniatureViewController: UIViewController {

    @IBOutlet weak var miniatureImage: UIImageView!
    @IBOutlet weak var unitLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var pointValueLabel: UILabel!
    @IBOutlet weak var powerLabel: UILabel!
    @IBOutlet weak var movementLabel: UILabel!
    @IBOutlet weak var weaponSkillLabel: UILabel!
    @IBOutlet weak var ballisticSkillLabel: UILabel!
    @IBOutlet weak var strengthLabel: UILabel!
    @IBOutlet weak var toughnessLabel: UILabel!
    @IBOutlet weak var woundsLabel: UILabel!
    @IBOutlet weak var attacksLabel: UILabel!
    @IBOutlet weak var leadershipLabel: UILabel!
    @IBOutlet weak var saveLabel: UILabel!
    @IBOutlet weak var weaponsLabel: UILabel!
    @IBOutlet weak var warGearLabel: UILabel!
    @IBOutlet weak var abilitiesLabel: UILabel!
    @IBOutlet weak var factionKeywordsLabel: UILabel!
    @IBOutlet weak var keywordsLabel: UILabel!
    
    var mini: GenericMini?
    var user: GenericUser?
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        refreshData()
        // Do any additional setup after loading the view.
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func refreshData() {
        if let mini = mini {
            miniatureImage.image = mini.image

            unitLabel.text = "Unit: \(mini.unit ??? "")"
            nameLabel.text = "Name: \(mini.name ??? "")"

            pointValueLabel.text = "Point Value: \(String(mini.pointValue))"
            powerLabel.text = "Power: \(String(mini.power))"
            movementLabel.text = "Movement: \(String(mini.movement))"
            weaponSkillLabel.text = "Weapon Skill: \(String(mini.weaponSkill))"
            ballisticSkillLabel.text = "Ballistic Skill: \(String(mini.ballisticSkill))"
            strengthLabel.text = "Strength: \(String(mini.strength))"
            toughnessLabel.text = "Toughness: \(String(mini.toughness))"
            woundsLabel.text = "Wounds: \(String(mini.wounds))"
            attacksLabel.text = "Attacks: \(String(mini.attacks))"
            leadershipLabel.text = "Leadership: \(String(mini.leadership))"
            saveLabel.text = "Save: \(String(mini.save))"
            
            weaponsLabel.text = "Weapons: \(mini.weapons ??? "")"
            warGearLabel.text = "War Gear: \(mini.warGear ??? "")"
            abilitiesLabel.text = "Abilities: \(mini.abilities ??? "")"
            factionKeywordsLabel.text = "Faction Keywords: \(mini.factionKeywords ??? "")"
            keywordsLabel.text = "Keywords: \(mini.keywords ??? "")"
        }
    }
}
