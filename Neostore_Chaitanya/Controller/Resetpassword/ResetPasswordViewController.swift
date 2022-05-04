//
//  ResetPasswordViewController.swift
//  Neostore_Chaitanya
//
//  Created by Neosoft on 10/01/22.
//

import UIKit

class ResetPasswordViewController: UIViewController {
    
    @IBOutlet weak var oldPass: UITextField!
    @IBOutlet weak var newPass: UITextField!
    @IBOutlet weak var confirmPass: UITextField!
    
    static func loadfromnib() -> UIViewController {
     return ResetPasswordViewController(nibName: "ResetPasswordViewController", bundle:nil)
 }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.backgroundColor = UIColor(hexFromString: "E91C1A")
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.isOpaque = true
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white,NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 25)] //,NSAttributedString.Key.font: UIFont(name: "GOTHAM", size: 14)]
        self.title = "Reset Password"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        oldPass.withImage(image: #imageLiteral(resourceName: "password_icon"))
        newPass.withImage(image: #imageLiteral(resourceName: "password_icon"))
        confirmPass.withImage(image: #imageLiteral(resourceName: "password_icon"))
        // Do any additional setup after loading the view.
    }

    @IBAction func Reset_Password(_ sender: UIButton) {
        let op_ip = oldPass.text ?? ""
        let np_ip = newPass.text ?? ""
        let cp_ip = confirmPass.text ?? ""
        
        if op_ip.isValidPassword() && np_ip.isValidPassword() && cp_ip == np_ip{
            CallService(op_ip, np_ip, cp_ip)
        }
        else if op_ip.isValidPassword() != true || np_ip.isValidPassword() != true{
            self.alerterros("Invalid Password","Password should contain minimum 8 characters at least 1 Uppercase Alphabet, 1 Lowercase Alphabet, 1 Number and 1 Special Character.")
        }
        else if cp_ip != np_ip{
            self.alerterros("Error", "New Password and Confirm Password don't Match")
        }
    }
    
    func CallService(_ op : String,_ np :String, _ cp :String) {
        APIServiceDude.shared.updatePassword(accessToken: KeychainManagement().getAccessToken(), oldPassword: op, newPassword: np, confirmPassword: cp) { result in
    
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    self.alerterros("Password Updated", "Password updated Successfully")
                case .failure(_):
                    self.alerterros("Password Not Updated", "Could not reset password ,please try again")
                }
            }
        }
    }

    func alerterros (_ title:String,_ message : String){
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
    }
}
