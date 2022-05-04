//
//  ProductRateDialogueViewController.swift
//  Neostore_Chaitanya
//
//  Created by neosoft on 10/02/22.
//

import UIKit

var prrrate_id : Int = 0
var prate_title  : String = ""
var prate_img : String = ""
var ratingvalue : Int = 1
class ProductRateDialogueViewController: UIViewController {

    
    @IBOutlet weak var Prod_title: UILabel!
    @IBOutlet weak var Prod_img: UIImageView!
    @IBOutlet weak var Star1: UIButton!
    @IBOutlet weak var Star2: UIButton!
    @IBOutlet weak var Star3: UIButton!
    @IBOutlet weak var Star4: UIButton!
    @IBOutlet weak var Star5: UIButton!
    
    static func loadfromnib(_ pid : Int) -> ProductRateDialogueViewController {
        prrrate_id = pid
        return ProductRateDialogueViewController(nibName: "ProductRateDialogueViewController", bundle: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        CallService_fetch(prr_id, onhandlersponse: {
            result in
            DispatchQueue.main.async { [self] in
                if result == 1 {
                    Prod_title.text = prate_title
                    DispatchQueue.global().async {
                        // Fetch Image Data
                        if let data = try? Data(contentsOf: URL(string: prate_img)!) {
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
        // Do any additional setup after loading the view.
    }

    @IBAction func star1click(_ sender: UIButton) {
        setimg(1)
    }
    @IBAction func star2click(_ sender: UIButton) {
        setimg(2)
    }
    @IBAction func star3click(_ sender: UIButton) {
        setimg(3)
    }
    @IBAction func star4click(_ sender: UIButton) {
        setimg(4)
    }
    @IBAction func star5click(_ sender: UIButton) {
        setimg(5)
    }
    
    
    func setimg(_ n : Int){
        ratingvalue = n
        Star1.setImage((n>=1 ? stargold : starw), for: .normal)
        Star2.setImage((n>=2 ? stargold : starw), for: .normal)
        Star3.setImage((n>=3 ? stargold : starw), for: .normal)
        Star4.setImage((n>=4 ? stargold : starw), for: .normal)
        Star5.setImage((n>=5 ? stargold : starw), for: .normal)
    }

    
    @IBAction func onsubmit(_ sender: UIButton) {
        CallService_Rate(ratingvalue)
        self.dismiss(animated: true, completion: nil)
    }
    
    func CallService_fetch(_ pid : Int, onhandlersponse: @escaping((Int) -> Void)){
        APIServiceDude.shared.getProductDetails(of: pro_id) { resut in
            DispatchQueue.main.async {
                switch resut {
                case .success(let resps):
                    print("success")
                    prate_title = resps.data.name
                    prate_img = resps.data.productImages[0].image
                    
                    onhandlersponse(1)
                case .failure(_):
                    print("Error")
                    onhandlersponse(0)
                }
            }
        }
    }
    
    func CallService_Rate(_ ratemo : Int) {
        APIServiceDude.shared.setRating(for: prrrate_id, rating: ratemo) { result in
            print(result)
        }
    }

}
