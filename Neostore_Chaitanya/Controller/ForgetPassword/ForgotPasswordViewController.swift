//
//  ForgotPasswordViewController.swift
//  Neostore_Chaitanya
//
//  Created by neosoft on 28/02/22.
//

import UIKit

class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var Emaikl: UITextField!
    
    static func loadfromnib() -> UIViewController {
         return ForgotPasswordViewController(nibName: "ForgotPasswordViewController", bundle:nil)
     }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        let redPlaceholderText = NSAttributedString(string: "Email",attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
            
        Emaikl.attributedPlaceholder = redPlaceholderText
        Emaikl.withImage(image: #imageLiteral(resourceName: "username_icon"))
        
        // Do any additional setup after loading the view.
    }

    
    @IBAction func Send_mail(_ sender: UIButton) {
        print("func run")
        let emailip = Emaikl.text ?? ""
        
        if emailip.isValidEmail() {
            CallService(emailip)
        }
        else {
            self.alerterros("Invalid Email", "Please enter a valid email")
        }
    }
    func CallService(_ emailinput : String){
        
        APIServiceDude.shared.forgetPassword(email: emailinput) { result in
            DispatchQueue.main.async {
                print(result)
                switch result{
                    case .success(_):
                        self.alerterros("Success", "New Password sent on your Email")
                    case .failure(_):
                        self.alerterros("?Unsuccessful", "Please enter a valid email")
                }
            }
        }
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func alerterros (_ title:String,_ message : String){
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
    }
    
}
