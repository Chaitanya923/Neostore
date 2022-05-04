//
//  EditProfileViewController.swift
//  Neostore_Chaitanya
//
//  Created by Neosoft on 10/01/22.
//

import UIKit

class EditProfileViewController: UIViewController {
    var editvall : Bool = false
    
    @IBOutlet weak var profile_pic: UIImageView!
    @IBOutlet weak var firstname: UITextField!
    
    @IBOutlet weak var Lastname: UITextField!
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var Phone: UITextField!
    @IBOutlet weak var Dob: UITextField!
    
    @IBOutlet weak var Submitbtn: UIButton!
    
    static func loadfromnib() -> UIViewController {
        return EditProfileViewController(nibName: "EditProfileViewController", bundle: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        CallService()
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.backgroundColor = UIColor(hexFromString: "E91C1A")
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.isOpaque = true
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white,NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 25)] //,NSAttributedString.Key.font: UIFont(name: "GOTHAM", size: 14)]
        self.title = "My Account"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        //setupNavBar("Account")
        firstname.placeHolderColor = .white
        Lastname.placeHolderColor = .white
        Email.placeHolderColor = .white
        Phone.placeHolderColor = .white
        Dob.placeHolderColor = .white
        profile_pic.image = #imageLiteral(resourceName: "picture-profile-icon-male-icon-human-or-people-sign-and-symbol-free-vector")

        profile_pic.layer.borderColor = CGColor(red: 1, green: 1, blue: 1, alpha: 1)
        profile_pic.layer.borderWidth = 5
        profile_pic.makeRounded()
        firstname.withImage(image: #imageLiteral(resourceName: "password_icon"))
        Lastname.withImage(image: #imageLiteral(resourceName: "username_icon"))
        Phone.withImage(image: #imageLiteral(resourceName: "cellphone_icon"))
        Email.withImage(image: #imageLiteral(resourceName: "email_icon"))
        Dob.withImage(image:#imageLiteral(resourceName: "dob_icon"))
        Submitbtn.layer.cornerRadius = 7
        
        self.Dob.datePicker(target: self,
                                          doneAction: #selector(doneAction),
                                          cancelAction: #selector(cancelAction),
                                          datePickerMode: .date)
                // Do any additional setup after loading the view.
        
    }


    @IBAction func submit(_ sender: UIButton) {
        if editvall {
            
            if validateform() {
                editvall = false
                CallService_edit()
                firstname.isUserInteractionEnabled = false
                Lastname.isUserInteractionEnabled = false
                Phone.isUserInteractionEnabled = false
                Email.isUserInteractionEnabled = false
                Dob.isUserInteractionEnabled = false
                Submitbtn.setTitle("Edit Profile", for: .normal)
                self.title = "My Account"
            }
        }
        else{
            editvall = true
            firstname.isUserInteractionEnabled = true
            Lastname.isUserInteractionEnabled = true
            Phone.isUserInteractionEnabled = true
            Email.isUserInteractionEnabled = true
            Dob.isUserInteractionEnabled = true
            Submitbtn.setTitle("Submit", for: .normal)
            self.title = "Edit Profile"
        }
    }
    
    func CallService() {
        APIServiceDude.shared.getUserDetails(accessToken: KeychainManagement().getAccessToken()) { result in
            switch result {
            case .failure(_):
                break
            case .success(let resps):
                DispatchQueue.main.async { [self] in
                    firstname.text = resps.data.userData.firstName
                    Lastname.text = resps.data.userData.lastName
                    Email.text = resps.data.userData.email
                    Phone.text = resps.data.userData.phoneNo
                    Dob.text = resps.data.userData.dob
                }
            }

        }
    }
    
    func CallService_edit() {
        let fname = firstname.text ?? ""
        let lname = Lastname.text ?? ""
        let phno = Phone.text ?? ""
        let emailtt = Email.text ?? ""
        let dob_ip = Dob.text ?? ""
        APIServiceDude.shared.updateUserDetails(accessToken: KeychainManagement().getAccessToken(), firstName: fname, lastName: lname, dob: dob_ip, phoneNo: phno, email: emailtt, profilePhoto: "") { result in
            print(result)
        }
    }
    
    func validateform () -> Bool {
        let email_ip = Email.text ?? ""
        let password_ip = firstname.text ?? ""
        let confirmpassword_ip = Lastname.text ?? ""
        let phone_ip = Phone.text ?? ""
        
        if email_ip.isValidEmail() && password_ip.isEmpty != true && (confirmpassword_ip.isEmpty != true) && phone_ip.isValidPhone(){
            return true
        }
        else{
            if email_ip.isValidEmail() != true {
                alerterros("Invalid Email", "Please enter a valid email")
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
    
    @IBAction func GoToResetPassword(_ sender: UIButton) {
        self.navigationController?.pushViewController(ResetPasswordViewController.loadfromnib(), animated: true)
    }
    @objc
        func cancelAction() {
            self.Dob.resignFirstResponder()
        }

        @objc
        func doneAction() {
            if let datePickerView = self.Dob.inputView as? UIDatePicker {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd-MM-yyyy"
                let dateString = dateFormatter.string(from: datePickerView.date)
                self.Dob.text = dateString
                
                print(datePickerView.date)
                print(dateString)
                
                self.Dob.resignFirstResponder()
            }
        }

}

extension UIImageView {

func makeRounded() {
    let radius = self.frame.width/2.0
    self.layer.cornerRadius = radius
    self.layer.masksToBounds = true
   }
}

extension UITextField{
   @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }

}

extension UITextField {
    func datePicker<T>(target: T,
                       doneAction: Selector,
                       cancelAction: Selector,
                       datePickerMode: UIDatePicker.Mode = .date) {
        let screenWidth = UIScreen.main.bounds.width
        
        func buttonItem(withSystemItemStyle style: UIBarButtonItem.SystemItem) -> UIBarButtonItem {
            let buttonTarget = style == .flexibleSpace ? nil : target
            let action: Selector? = {
                switch style {
                case .cancel:
                    return cancelAction
                case .done:
                    return doneAction
                default:
                    return nil
                }
            }()
            
            let barButtonItem = UIBarButtonItem(barButtonSystemItem: style,
                                                target: buttonTarget,
                                                action: action)
            
            return barButtonItem
        }
        
        let datePicker = UIDatePicker(frame: CGRect(x: 0,
                                                    y: 0,
                                                    width: screenWidth,
                                                    height: 216))
        datePicker.datePickerMode = datePickerMode
        self.inputView = datePicker
        
        let toolBar = UIToolbar(frame: CGRect(x: 0,
                                              y: 0,
                                              width: screenWidth,
                                              height: 44))
        toolBar.setItems([buttonItem(withSystemItemStyle: .cancel),
                          buttonItem(withSystemItemStyle: .flexibleSpace),
                          buttonItem(withSystemItemStyle: .done)],
                         animated: true)
        self.inputAccessoryView = toolBar
    }
}
/*
extension UINavigationController{
    func setupNavBar(title: String, isBack: Bool = true){
 self.isNavigationBarHidden = false
 self.navigationController?.navigationBar.isHidden = false
 self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
 self.navigationController?.navigationBar.backgroundColor = UIColor(hexFromString: "E91C1A")
 self.navigationController?.navigationBar.barTintColor = UIColor.white
 self.navigationController?.navigationBar.tintColor = UIColor.white
 self.navigationController?.navigationBar.isTranslucent = true
 self.navigationController?.navigationBar.isOpaque = true
 self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white] //,NSAttributedString.Key.font: UIFont(name: "GOTHAM", size: 14)]
 self.title = title
 self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
    }
}
*/
