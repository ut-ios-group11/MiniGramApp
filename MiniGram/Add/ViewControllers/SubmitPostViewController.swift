//
//  SubmitPostViewController.swift
//  MiniGram
//
//  Created by Joseph Manahan on 4/8/20.
//  Copyright © 2020 Keegan Black. All rights reserved.
//

import UIKit
import Firebase

class SubmitPostViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var captionField: UITextField!
    @IBOutlet weak var captionFieldConstraint: NSLayoutConstraint!
    @IBOutlet weak var submitButton: UIButton!
    
    @IBAction func submitButton(_ sender: Any) {
        guard let user = UserData.shared.getDatabaseUser() else { return }
        let post = GenericPost(id: "", userId: user.id, userName: user.userName, likes: [String](), desc: captionField.text!, date: Timestamp(), image: nil)
        Database.shared.createPost(image: imageView.image!, post: post, onError: { (Error) in
            LogManager.logError(Error)
        }) {
            self.tabBarController?.selectedIndex = 0
            self.navigationController?.popToRootViewController(animated: false)
            LogManager.logInfo("Sucessfully created post")
        }
    }
    
    let CAPTION_FIELD_CONSTRAINT_CONSTANT = 4
    
    var delegate: UIViewController!
    var image: UIImage!
    
    var captionFieldContraintOriginalValue: CGFloat?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        self.imageView.image = self.image ?? UIImage(named: "placeholder")
        captionField.underlined()
        submitButton.roundCorners(4)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        captionFieldContraintOriginalValue = self.captionFieldConstraint.constant
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let newHeight: CGFloat
            let duration:TimeInterval = (notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
            if #available(iOS 11.0, *) {
                newHeight = keyboardFrame.cgRectValue.height - self.view.safeAreaInsets.bottom
            } else {
                newHeight = keyboardFrame.cgRectValue.height
            }
            let keyboardHeight = newHeight
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: {
                            self.captionFieldConstraint.constant = keyboardHeight},
                           completion: nil)
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        let newHeight = self.captionFieldContraintOriginalValue ?? CGFloat(CAPTION_FIELD_CONSTRAINT_CONSTANT)
        let duration:TimeInterval = (notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
        let animationCurveRawNSN = notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
        let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
        let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
        UIView.animate(withDuration: duration,
                        delay: TimeInterval(0),
                        options: animationCurve,
                        animations: {
                        self.captionFieldConstraint.constant = newHeight},
                        completion: nil)
    }
    
    func textFieldShouldReturn(textField:UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
