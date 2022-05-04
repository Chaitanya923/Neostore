//
//  Login.swift
//  Neostore_Chaitanya
//
//  Created by Neosoft on 04/01/22.
//

import UIKit

class Login: UIViewController {
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var buttontoreg: UIButton!
    @IBOutlet weak var password: UITextField!
    var oplog : Int = 0
    @IBOutlet weak var login: UIButton!
    static func loadfromnib() -> UIViewController {
         return Login(nibName: "Login", bundle:nil)
     }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        //self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .fastForward, target: self, action: #selector(navigatetosidebar))
        
        let redPlaceholderText = NSAttributedString(string: "Email",attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
            
        username.attributedPlaceholder = redPlaceholderText
        
        //username.layer.borderColor = .white
        
        let Passwordpt = NSAttributedString(string: "Password",attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
                                            
        password.attributedPlaceholder = Passwordpt
        password.withImage(image: #imageLiteral(resourceName: "password_icon"))
        username.withImage(image: #imageLiteral(resourceName: "username_icon"))
        
        let largeFont = UIFont.systemFont(ofSize: 30)
        let configuration = UIImage.SymbolConfiguration(font: largeFont) // <1>

        let image = UIImage(systemName: "plus", withConfiguration: configuration)

        let imageView = UIImageView(image: image)
        imageView.tintColor = .white
        imageView.backgroundColor = UIColor(named: "")
        
        
       // login.layer.borderWidth =
        //login.layer.borderColor = UIColor.black.cgColor
        login.layer.cornerRadius = 7
        
        buttontoreg.setImage(image, for: UIControl.State.normal)
        
        // Do any additional setup after loading the view.
    }


    @IBAction func Logintap(_ sender: UIButton) {
        let email_ip = username.text ?? ""
        let password_ip = password.text ?? ""
        
        if validateform() {
            CallService(email_ip, password_ip, onhandleresponse: {
                result in
                DispatchQueue.main.async {
                    if result == 1
                    {
                        self.navigationController?.pushViewController(RootHomeViewController(), animated: true)
                    }
                    else
                    {
                        self.alerterros("User login unsuccessfull", "Email or Password is wrong. Try again!")
                    }
                }
            })
        }
    }
    @IBAction func GotoRegister(_ sender: UIButton) {
        self.navigationController?.pushViewController(RegisterViewController.loadfromnib(), animated: true)
    }
    

    @IBAction func GotoFP(_ sender: UIButton) {
        self.navigationController?.pushViewController(ForgotPasswordViewController.loadfromnib(), animated: true)
    }
    @IBAction func GotoForgotPassword(_ sender: UITapGestureRecognizer) {
    }
    func CallService(_ email : String,_ password : String,onhandleresponse:@escaping((Int)->Void))  {
        
        APIServiceDude.shared.login(email: email, password: password){
            result in
            switch result{
            case .success(let resps) :
                let dataofuser = UserModel(firstName: resps.data?.firstName ?? "", lastName: resps.data?.lastName ?? "", email: resps.data?.email ?? "", password: password, confirmPassword: password, isMale: resps.data?.gender=="M" ? true : false , phoneNo: resps.data?.phoneNo ?? "")
                KeychainManagement().addUserEmailAndPassword(userModel: dataofuser)
                KeychainManagement().addAccessToken(accessToken: resps.data?.accessToken)
                onhandleresponse(1)
                
            case .failure(let repf) :
                //self.oplog = 0
                onhandleresponse(0)
                print(repf)
                //errdisplay()
            }
        }
    }
    
    func validateform() -> Bool{
        let email_ip = username.text ?? ""
        let password_ip = password.text ?? ""
        
        //print("pass:",password_ip.isValidPassword())
        if email_ip.isValidEmail() //&& password_ip.isValidPassword()
        {
            return true
        }
        else{
            if email_ip.isValidEmail() != true {
                alerterros("Invalid Email", "Please enter a valid email")
            }
            if password_ip.isValidPassword() != true {
                alerterros("Invalid Password", "Password should contain minimum 8 characters at least 1 Uppercase Alphabet, 1 Lowercase Alphabet, 1 Number and 1 Special Character.")
            }
            return false
        }
    }
    
    func alerterros (_ title:String,_ message : String){
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
    }
    
    func errdisplay(){
        alerterros("User login unsuccessfull", "Email or Password is wrong. Try again!")
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @objc func navigatetosidebar()
    {
        self.navigationController?.pushViewController(Sidebar.loadfromnib(), animated: true)
    }
}
