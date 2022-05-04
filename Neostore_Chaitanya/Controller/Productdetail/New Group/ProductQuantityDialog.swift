//
//  ProductQuantityDialog.swift
//  NeoSTORE
//
//  Created by Neosoft on 17/12/21.
//

import UIKit

var prr_id : Int = 0
var P_title : String = ""
var P_img : String = ""

protocol ProductQuantityDialogDelegate{
    func onBgViewTap()
    func ontapSubmit(_ p_qty : Int)
    func tempfunc()
}

class ProductQuantityDialog: UIViewController {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var Producttitle: UILabel!
    @IBOutlet weak var quantityField: UITextField!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var Prod_img: UIImageView!
    
    
    @IBAction func submitBtnTap(_ sender: UIButton) {
        let ptemp = quantityField.text!
        guard let pt = Int(ptemp) else { return  }
        
        CallService_AddtoCart(pt, onhandleresponse: {
            reult in
            DispatchQueue.main.async {
                if reult == 1{
                    print("added to cart")
                    
                }
                else{
                    print("not added")
                }
            }
        })
        
        self.dismiss(animated: true, completion: nil)
    }
    
    var delegate : ProductQuantityDialogDelegate?
    
    static func loadFromNib(_ pid : Int) -> ProductQuantityDialog {
        prr_id = pid
        return  ProductQuantityDialog(nibName: "ProductQuantityDialog", bundle: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        quantityField.delegate = self
        
        bgView.isOpaque = true
        
        alertView.layer.cornerRadius = 10
        submitBtn.layer.cornerRadius = 7
        bgView.addGestureRecognizer(UIGestureRecognizer(target: self, action: #selector(onBgViewTap)))
        
        CallService_fetch(prr_id, onhandlersponse: {
            result in
            DispatchQueue.main.async { [self] in
                if result == 1 {
                    Producttitle.text = P_title
                    
                    DispatchQueue.global().async {
                        // Fetch Image Data
                        if let data = try? Data(contentsOf: URL(string: P_img)!) {
                            DispatchQueue.main.async { [self] in
                                // Create Image and Update Image View
                                Prod_img.image = UIImage(data: data)
                                //self.imageView.image = UIImage(data: data)
                            }
                        }
                    }
                }
            }
        })
    }
    
    @objc func onBgViewTap(){
        print("BG View Tapped")
        //delegate?.onBgViewTap()
        self.dismiss(animated: true, completion: nil)
    }

    func CallService_fetch(_ pid : Int, onhandlersponse: @escaping((Int) -> Void)){
        APIServiceDude.shared.getProductDetails(of: pro_id) { resut in
            DispatchQueue.main.async {
                switch resut {
                case .success(let resps):
                    print("success")
                    P_title = resps.data.name
                    P_img = resps.data.productImages[0].image
                    
                    onhandlersponse(1)
                case .failure(_):
                    print("Error")
                    onhandlersponse(0)
                }
            }
        }
    }
    
    func CallService_AddtoCart(_ qtty: Int,onhandleresponse : @escaping((Int) -> Void)) {
        APIServiceDude.shared.addToCart(accessToken: KeychainManagement().getAccessToken(), productId: prr_id, qty: qtty) { result in
            switch result{
            case .success(_):
                onhandleresponse(1)
            case .failure(_):
                onhandleresponse(0)
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

}


extension ProductQuantityDialog : UITextFieldDelegate{
    func textField(_ textField: UITextField,
      shouldChangeCharactersIn range: NSRange,
      replacementString string: String) -> Bool {
      let invalidCharacters =
        CharacterSet(charactersIn: "0123456789").inverted
      return (string.rangeOfCharacter(from: invalidCharacters) == nil)
    }
}
