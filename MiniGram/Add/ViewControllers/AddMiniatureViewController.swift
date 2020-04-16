
import UIKit
import Firebase

class AddMiniatureViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var unitField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var basePointValueField: UITextField!
    @IBOutlet weak var powerField: UITextField!
    @IBOutlet weak var movementField: UITextField!
    @IBOutlet weak var weaponSkillField: UITextField!
    @IBOutlet weak var ballisticSkillField: UITextField!
    @IBOutlet weak var strengthField: UITextField!
    @IBOutlet weak var toughnessField: UITextField!
    @IBOutlet weak var woundsField: UITextField!
    @IBOutlet weak var attacksField: UITextField!
    @IBOutlet weak var leadershipField: UITextField!
    @IBOutlet weak var saveField: UITextField!
    
    @IBAction func buttonPressed(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            self.selectedButtons.insert(sender.tag)
        } else {
            self.selectedButtons.remove(sender.tag)
        }
    }
    
    @IBAction func addButton(_ sender: Any) {
        
        guard let user = UserData.shared.getDatabaseUser() else { return }
        
        let unit = self.unitField.text ?? ""
        let name = self.nameField.text ?? ""
        let pointValue = Int(basePointValueField.text ?? "0") ?? 0 + self.getWeaponsPointValue() + self.getWargearPointValue()
        let power = Int(self.powerField.text ?? "0") ?? 0
        let movement = Int(self.movementField.text ?? "0") ?? 0
        let weaponSkill = Int(self.weaponSkillField.text ?? "0") ?? 0
        let ballisticSkill = Int(self.ballisticSkillField.text ?? "0") ?? 0
        let strength = Int(self.strengthField.text ?? "0") ?? 0
        let toughness = Int(self.toughnessField.text ?? "0") ?? 0
        let wounds = Int(self.woundsField.text ?? "0") ?? 0
        let attacks = Int(self.attacksField.text ?? "0") ?? 0
        let leadership = Int(self.leadershipField.text ?? "0") ?? 0
        let save = Int(self.saveField.text ?? "0") ?? 0
        let weapons = self.getSelectedButtons(start: WEAPONS_BEG, end: WEAPONS_END)
        let wargear = self.getSelectedButtons(start: WARGEAR_BEG, end: WARGEAR_END)
        let abilities = self.getSelectedButtons(start: ABILITIES_BEG, end: ABILITIES_END)
        let factionKeywords = self.getSelectedButtons(start: FACTION_KEYWORDS_BEG, end: FACTION_KEYWORDS_END)
        let keywords = self.getSelectedButtons(start: KEYWORDS_BEG, end: KEYWORDS_END)
        
        let newMiniature = GenericMini(id: "", userId: user.id, date: Timestamp(), unit: unit, name: name, image: self.image, pointValue: pointValue, power: power, movement: movement, weaponSkill: weaponSkill, ballisticSkill: ballisticSkill, strength: strength, toughness: toughness, wounds: wounds, attacks: attacks, leadership: leadership, save: save, weapons: weapons, warGear: wargear, abilities: abilities, factionKeywords: factionKeywords, keywords: keywords)
        
        Database.shared.createMinature(image: self.image, miniature: newMiniature, onError: { (Error) in
            LogManager.logError(Error)
        }) {
            self.tabBarController?.selectedIndex = 0
            self.navigationController?.popToRootViewController(animated: false)
            LogManager.logInfo("Sucessfully created miniature")
        }
    }
    
    let WEAPONS_BEG = 0
    let WEAPONS_END = 22
    let WARGEAR_BEG = 23
    let WARGEAR_END = 30
    let ABILITIES_BEG = 31
    let ABILITIES_END = 40
    let FACTION_KEYWORDS_BEG = 41
    let FACTION_KEYWORDS_END = 52
    let KEYWORDS_BEG = 53
    let KEYWORDS_END = 58
    
    var delegate: UIViewController!
    var image: UIImage!
    
    var selectedButtons = Set<Int>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.imageView.image = self.image
        
        self.unitField.underlined()
        self.nameField.underlined()
        self.basePointValueField.underlined()
        self.powerField.underlined()
        self.movementField.underlined()
        self.weaponSkillField.underlined()
        self.ballisticSkillField.underlined()
        self.strengthField.underlined()
        self.toughnessField.underlined()
        self.woundsField.underlined()
        self.attacksField.underlined()
        self.leadershipField.underlined()
        self.saveField.underlined()
    }
    
    func getSelectedButtons(start: Int, end: Int) -> [String] {
        var result = [String]()
        for tag in start...end {
            if self.selectedButtons.contains(tag) {
                var content: String
                switch tag {
                    //WEAPONS
                    case 0: content = "Assault cannon"
                    case 1: content = "Autocannon"
                    case 2: content = "Boltgun"
                    case 3: content = "Bolt pistol"
                    case 4: content = "Combi-weapons"
                    case 5: content = "Flamer"
                    case 6: content = "Flamestorm cannon"
                    case 7: content = "Heavy bolter"
                    case 8: content = "Heavy flamer"
                    case 9: content = "Lascannon"
                    case 10: content = "Meltagun"
                    case 11: content = "Missile launcher"
                    case 12: content = "Mult-melta"
                    case 13: content = "Plasma cannon"
                    case 14: content = "Plasma gun"
                    case 15: content = "Plasma pistol"
                    case 16: content = "Sniper rifle"
                    case 17: content = "Space Marine shotgun"
                    case 18: content = "Storm bolter"
                    case 19: content = "Chainfist"
                    case 20: content = "Chainsword"
                    case 21: content = "Power fist"
                    case 22: content = "Thunder hammer"
                    //WARGEAR
                    case 23: content = "Frag grenade"
                    case 24: content = "Krak grenade"
                    case 25: content = "Melta bombs"
                    case 26: content = "Psychic hood"
                    case 27: content = "Scout armour"
                    case 28: content = "Power armour"
                    case 29: content = "Runic armour"
                    case 30: content = "Terminator armour"
                    //ABILITIES
                    case 31: content = "Acute Senses"
                    case 32: content = "Counter-attack"
                    case 33: content = "Rage"
                    case 34: content = "Independent Character"
                    case 35: content = "Mindlock"
                    case 36: content = "Thralls"
                    case 37: content = "Eternal Warrior"
                    case 38: content = "Fearless"
                    case 39: content = "Feel No Pain"
                    case 40: content = "Monster Hunter"
                    // FACTION KEYWORDS
                    case 41: content = "Imperium"
                    case 42: content = "Adeptus Astartes"
                    case 43: content = "Space Wolves"
                    case 44: content = "Ultramarines"
                    case 45: content = "Imperial Fists"
                    case 46: content = "Dark Angels"
                    case 47: content = "Blood Angels"
                    case 48: content = "White Scars"
                    case 49: content = "Black Templars"
                    case 50: content = "Salamanders"
                    case 51: content = "Crimson Fists"
                    case 52: content = "Carcharodons"
                    // KEYWORDS
                    case 53: content = "Character"
                    case 54: content = "Primaris"
                    case 55: content = "Infantry"
                    case 56: content = "Battle leader"
                    case 57: content = "Terminator"
                    case 58: content = "Cavalry"
                default:
                    fatalError("Unknown button tag!")
                }
                result.append(content)
            }
        }
        return result
    }
    
    func getWeaponsPointValue() -> Int {
        // This could be used to caluculate points automatically in the future...
        return 0
    }
    
    func getWargearPointValue() -> Int {
        // This could be used to caluculate points automatically in the future...
        return 0
    }
    
    func textFieldShouldReturn(textField:UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
