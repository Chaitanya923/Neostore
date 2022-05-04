//
//  ProductListViewController.swift
//  Neostore_Chaitanya
//
//  Created by neosoft on 22/02/22.
//

import UIKit

var cat_id :  Int = 0
var p_category_id = [0,1,3,2,4]

class ProductListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var ProductListingTableView: UITableView!
    
    lazy var viewmodel : ProductListViewModel = ProductListViewModel()
    
    static func loadfromnib(_ id : Int) -> UIViewController {
        cat_id = p_category_id[id]
     return ProductListViewController(nibName: "ProductListViewController", bundle:nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.showSpinner(onView: self.view)
        viewmodel.CallService(cat_id)
        
        viewmodel.productlist.bindAndFire { _ in
            DispatchQueue.main.async {
                print("IN Vc")
                self.ProductListingTableView.reloadData()
                self.removeSpinner()
            }
        }
        
        ProductListingTableView.delegate = self
        ProductListingTableView.dataSource = self
        
        ProductListingTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        ProductListingTableView.register(UINib(nibName: "ProductlistcellTableViewCell", bundle: nil), forCellReuseIdentifier: "ProductlistCell")
        ProductListingTableView.tableFooterView = UIView(frame: .zero)
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.backgroundColor = UIColor(hexFromString: "E91C1A")
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.isOpaque = true
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white,NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 25)] //,NSAttributedString.Key.font: UIFont(name: "GOTHAM", size: 14)]
        self.title = p_category[cat_id]
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(imageLiteralResourceName: "search_icon"))
        
        // Do any additional setup after loading the view.
    }


    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print("Table View Count - \(viewmodel.productlist.value.count)")
        return viewmodel.productlist.value.count//pro_list.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("CELL",indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductlistCell", for: indexPath) as! ProductlistcellTableViewCell
        cell.Product_name.text = viewmodel.productlist.value[indexPath.row].name
        cell.Product_Price.text = "Rs. " + String( viewmodel.productlist.value[indexPath.row].cost)
        cell.Product_center.text = viewmodel.productlist.value[indexPath.row].producer

            DispatchQueue.global().async {
                // Fetch Image Data
                if let data = try? Data(contentsOf: URL(string: self.viewmodel.productlist.value[indexPath.row].productImages)!) {
                    DispatchQueue.main.async {
                        // Create Image and Update Image View
                        cell.Product_img.image = UIImage(data: data)
                        //self.imageView.image = UIImage(data: data)
                    }
                }
            }
        
        cell.star1.image = viewmodel.productlist.value[indexPath.row].rating > 0 ? stargold : starw
        cell.star2.image = viewmodel.productlist.value[indexPath.row].rating > 1 ? stargold : starw
        cell.star3.image = viewmodel.productlist.value[indexPath.row].rating > 2 ? stargold : starw
        cell.star4.image = viewmodel.productlist.value[indexPath.row].rating > 3 ? stargold : starw
        cell.star5.image = viewmodel.productlist.value[indexPath.row].rating > 4 ? stargold : starw
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print()
        self.navigationController?.pushViewController(ProductDetailsViewController.loadfromnib(viewmodel.productlist.value[indexPath.row].id), animated: true)
    }
    
}

