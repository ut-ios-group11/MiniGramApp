
import UIKit

class AddMiniatureViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func buttonPressed(sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    var delegate: UIViewController!
    var image: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView.image = self.image
    }
    
    func textFieldShouldReturn(textField:UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
