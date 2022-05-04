//
//  RegisterViewController.swift
//  Neostore_Chaitanya
//
//  Created by Neosoft on 07/01/22.
//

import UIKit

class RegisterViewController: UIViewController {

    var viewModel : RegisterViewModel = RegisterViewModel()
    
    @IBOutlet weak var firstname: UITextField!
    @IBOutlet weak var lastname: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmpass: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var Male: UIButton!
    @IBOutlet weak var Female: UIButton!
    @IBOutlet weak var TandCchckbox: UIButton!
    var Gender :String = "M"
    var t_c :Bool = false
    @IBOutlet weak var registerbtn: UIButton!
    
    let imgchckbox = UIImage(systemName: "squareshape", withConfiguration: UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 40)))

    static func loadfromnib() -> UIViewController {
        return RegisterViewController(nibName: "RegisterViewController", bundle:nil)
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
        self.title = " REGISTER"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        Male.setImage( #imageLiteral(resourceName: "chkn"), for: .normal)
        Female.setImage(#imageLiteral(resourceName: "chky"), for: .normal)
        Gender = "F"
        
        let imgc = UIImageView(image: imgchckbox)
        imgc.tintColor = .white
        TandCchckbox.setImage(imgchckbox, for: .normal)
        
        password.withImage(image: #imageLiteral(resourceName: "password_icon"))
        firstname.withImage(image: #imageLiteral(resourceName: "username_icon"))
        confirmpass.withImage(image: #imageLiteral(resourceName: "password_icon"))
        lastname.withImage(image: #imageLiteral(resourceName: "username_icon"))
        phone.withImage(image: #imageLiteral(resourceName: "cellphone_icon"))
        email.withImage(image: #imageLiteral(resourceName: "email_icon"))
        
        registerbtn.layer.cornerRadius = 7
        // Do any additional setup after loading the view.
    }

    @IBAction func Male_Select(_ sender: UIButton) {
        Male.setImage( #imageLiteral(resourceName: "chky"), for: .normal)
        Female.setImage(#imageLiteral(resourceName: "chkn"), for: .normal)
        Gender = "M"
        print(Gender)
    }
    
    @IBAction func Female_Select(_ sender: UIButton) {
        Male.setImage( #imageLiteral(resourceName: "chkn"), for: .normal)
        Female.setImage(#imageLiteral(resourceName: "chky"), for: .normal)
        Gender = "F"
        print(Gender)
    }
    
    @IBAction func TandC(_ sender: UIButton) {

        if t_c == false {
            TandCchckbox.setImage(#imageLiteral(resourceName: "checked_icon"), for: .normal)
            t_c = true
        }
        else {
            TandCchckbox.setImage(imgchckbox, for: .normal)
            t_c = false
        }
    }
    
    @IBAction func onRegister(_ sender: UIButton) {
        let fname_ip = firstname.text ?? ""
        let lname_ip = lastname.text ?? ""
        let email_ip = email.text ?? ""
        let password_ip = password.text ?? ""
        let confirmpassword_ip = confirmpass.text ?? ""
        let phone_ip = phone.text ?? ""
        var ismale_ip : Bool = false
        if Gender == "M"{
            ismale_ip = true
        }
        if validateform() {
        if t_c == false {
            alerterros("Error", "Please accept Terms and Conditions.")
        }
        else {
            let UserDataToRegister = UserModel(firstName: fname_ip, lastName: lname_ip, email: email_ip, password: password_ip, confirmPassword: confirmpassword_ip, isMale: ismale_ip, phoneNo: phone_ip)
            
            viewModel.Register(UserDataToRegister, onhandleresponse: {
                result in
                DispatchQueue.main.async {
                    if result == 1{
                        self.register_alert("Registeration Successful", "You have successfully registered in NeoSTORE")
                    }
                    else{
                        self.alerterros("Registration Unsuccessful"," Email id already exist")
                    }
                }
            })
            
                
            }
        }
    }
    
    func validateform () -> Bool {
        let email_ip = email.text ?? ""
        let password_ip = password.text ?? ""
        let confirmpassword_ip = confirmpass.text ?? ""
        let phone_ip = phone.text ?? ""
        
        if email_ip.isValidEmail() && password_ip.isValidPassword() && (password_ip == confirmpassword_ip) && phone_ip.isValidPhone(){
            return true
        }
        else{
            if email_ip.isValidEmail() != true {
                alerterros("Invalid Email", "Please enter a valid email")
            }
            if password_ip.isValidPassword() != true {
                alerterros("Invalid Password", "Password should contain minimum 8 characters at least 1 Uppercase Alphabet, 1 Lowercase Alphabet, 1 Number and 1 Special Character.")
            }
            if password_ip != confirmpassword_ip {
                alerterros("Wrong Confirm Password", "Confirm Password doesn't match with password")
            }
            if phone_ip.isValidPhone() != true {
                alerterros("Invalid Phone number", "Please Enter a 10-digit phone number in format - 9879960235")
            }
            return false
        }
    }
    func alerterros (_ title:String,_ message : String){
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
    }
    
    func register_alert(_ title:String,_ message : String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            UIApplication.shared.windows.first?.rootViewController = UINavigationController(rootViewController: RootHomeViewController())
            UIApplication.shared.windows.first?.makeKeyAndVisible()
        }))
        self.present(alert, animated: true, completion: nil)
    }

}

extension UIColor {
    convenience init(hexFromString:String, alpha:CGFloat = 1.0) {
        var cString:String = hexFromString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        var rgbValue:UInt32 = 10066329 //color #999999 if string has wrong format

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) == 6) {
            Scanner(string: cString).scanHexInt32(&rgbValue)
        }

        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
    
//    static let red = Red.self
//    static let gray = Gray.self
    
//    static let yellow = Yellow.self
}

extension UIViewController {
    open override func awakeFromNib() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}
