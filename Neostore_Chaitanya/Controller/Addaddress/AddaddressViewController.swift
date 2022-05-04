//
//  AddaddressViewController.swift
//  Neostore_Chaitanya
//
//  Created by Neosoft on 16/01/22.
//

import UIKit

class AddaddressViewController: UIViewController {

    
    @IBOutlet weak var address_textfield: UITextField!
    @IBOutlet weak var landmark_textfield: UITextField!
    @IBOutlet weak var city_textfield: UITextField!
    @IBOutlet weak var state_textfield: UITextField!
    @IBOutlet weak var zipcode_textfield: UITextField!
    @IBOutlet weak var country_textfield: UITextField!
    
    
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
        self.title = "Add Address"
        
        
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        //navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(imageLiteralResourceName: "search_icon"))
        
    }

    
    @IBAction func Save_Address(_ sender: UIButton) {
        guard let address = address_textfield.text else {return}
        guard let city = city_textfield.text else {return}
        guard let state = state_textfield.text else {return}
        guard let lmark = landmark_textfield.text else {return}
        guard let zip = zipcode_textfield.text else {return}
        guard let country = country_textfield.text else {return}
        
        let FullAddress = address + " , LANDMARK - " + lmark + " , PINCODE - " + zip + " , CITY - " + city + " , " + state + " , " + country
        
        if validateform()
        {
            print(FullAddress)

            CallService(FullAddress) { result in
                print("handler : ",result)
                DispatchQueue.main.async {
                    if result == 1{
                        self.alerterros("Order Placed", "Order placed Successfully.Please Check email to track it.")
                        self.navigationController?.pushViewController(RootHomeViewController(), animated: true)
                    }
                    else {
                        self.alerterros("Something went wrong!", "Order didn't got placed. Please try again!!")
                    }
                }
            }
            //self.navigationController?.popViewController(animated: true)
            //pushViewController(AddresslistTableViewController.loadfromnib(), animated: true)
        }
    }
    
    func validateform() -> Bool {
        if checktextfieldcomplete(address_textfield)
        {
            return true
        }
        else{
            return false
        }
    }
    
    func checktextfieldcomplete(_ TField : UITextField) -> Bool {
        if let text = TField.text, text.isEmpty {
            return false
        }
        else
        {
            return true
        }
    }
    
    func CallService(_ addr : String, onhandleresponse : @escaping((Int) -> Void)){
        APIServiceDude.shared.orderNow(accessToken: KeychainManagement().getAccessToken(), address: addr) { result in
            print("Service call : ",result)
            DispatchQueue.main.async {
                switch result{
                case .success(_):
                    onhandleresponse(1)
                case .failure(_):
                    onhandleresponse(0)
                }
            }
        }
    }
    
    
    func alerterros (_ title:String,_ message : String){
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.navigationController?.pushViewController(RootHomeViewController(), animated: true)
        }))
        //alert.addAction(()
            self.present(alert, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
