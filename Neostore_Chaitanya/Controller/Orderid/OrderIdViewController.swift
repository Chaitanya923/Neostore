//
//  OrderIdViewController.swift
//  Neostore_Chaitanya
//
//  Created by neosoft on 24/02/22.
//

import UIKit

var id : Int = 0

class OrderIdViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var OrderIdtableview: UITableView!
    
    
   var Odetail : [OrderDetail] = []
   var totalcost : Int = 0
   static func loadfromnib(_ idd : Int) -> UIViewController {
       id = idd
       return OrderIdViewController(nibName: "OrderIdViewController", bundle:nil)
   }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        OrderIdtableview.delegate = self
        OrderIdtableview.dataSource = self
        
        OrderIdtableview.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        OrderIdtableview.register(UINib(nibName: "OrderidTableViewCell", bundle: nil), forCellReuseIdentifier: "OrderidCell")
        OrderIdtableview.register(UINib(nibName: "AmountTVCell", bundle: nil), forCellReuseIdentifier: "amountTVCell")
        
        CallService()
        
        
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.backgroundColor = UIColor(hexFromString: "E91C1A")
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.isOpaque = true
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white,NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 25)]
        
        self.title = "Order ID : " + String(id)
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(imageLiteralResourceName: "search_icon"))
        
        // Do any additional setup after loading the view.
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section{
        case 0:
            return Odetail.count
        default:
            return 1
        }
        
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)-> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderidCell", for: indexPath) as! OrderidTableViewCell
            cell.name.text = Odetail[indexPath.row].prodName
            cell.category.text = Odetail[indexPath.row].prodCatName
            cell.qty.text = "QTY : " + String(Odetail[indexPath.row].quantity)
            cell.cost.text = "Rs. " + String(Odetail[indexPath.row].total)
            DispatchQueue.global().async { [self] in
                // Fetch Image Data
                if let data = try? Data(contentsOf: URL(string: Odetail[indexPath.row].prodImage)!) {
                    DispatchQueue.main.async {
                        // Create Image and Update Image View
                        cell.img.image = UIImage(data: data)
                        //self.imageView.image = UIImage(data: data)
                    }
                }
            }
            
            return cell
        case 1 :
            let cell = tableView.dequeueReusableCell(withIdentifier: "amountTVCell", for: indexPath) as! AmountTVCell
            cell.totalcosting.text = "Rs. " + String(totalcost)
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
            return cell
        }
    }
   
    
    func CallService(){
        APIServiceDude.shared.orderDetails(accessToken: KeychainManagement().getAccessToken(), orderID: id) { result in
            DispatchQueue.main.async { [self] in
                switch result {
                case .success(let resps):
                    Odetail = resps.data.orderDetails
                    totalcost = resps.data.cost
                    OrderIdtableview.reloadData()
                case .failure(_):
                    break
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

}
