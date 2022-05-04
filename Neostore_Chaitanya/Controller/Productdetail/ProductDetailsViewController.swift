//
//  ProductDetailsViewController.swift
//  Neostore_Chaitanya
//
//  Created by neosoft on 23/02/22.
//

import UIKit

var pro_id : Int = 0

var p_det = ProductDetails(id: 3, productCategoryID: 1, name: "Vishwakarma Solid Table", producer: "Lelo", description: "Vishwakarma Furniture Solid Wood Coffee Table (Finish Color - Dark Black)", cost: 3333, rating: 3, viewCount: 10670, created: "2015-09-07T09:43:15+0000", modified: "2022-02-02T11:17:43+0000", productImages: [ProductImage(id: 4, productID: 3, image: "http://staging.php-dev.in:8844/trainingapp/uploads/prod_img/thumb/medium/3d4007c74793ff2564de15d71.jpeg", created: "2015-09-07T09:43:45+0000", modified: "2015-09-07T09:43:45+0000")])
var p_category = ["","Tables","Chair","Sofas",""]

let stargold = #imageLiteral(resourceName: "star_check")
let starw = #imageLiteral(resourceName: "star_unchek")

class ProductDetailsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var ProductDetailTableView: UITableView!
    var productQuantityDialog = ProductQuantityDialog()
    
    static func loadfromnib(_ pr_id : Int) -> UIViewController {
        pro_id = pr_id
        return ProductDetailsViewController(nibName: "ProductDetailsViewController", bundle:nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        CallService()
        
        ProductDetailTableView.delegate = self
        ProductDetailTableView.dataSource = self
        
        productQuantityDialog.delegate = self
        
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.backgroundColor = UIColor(hexFromString: "E91C1A")
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.isOpaque = true
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white,NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 25)] //,NSAttributedString.Key.font: UIFont(name: "GOTHAM", size: 14)]
        self.title = "Product"
        
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        
        self.ProductDetailTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.ProductDetailTableView.register(UINib(nibName: "ProducttitleTableViewCell", bundle: nil), forCellReuseIdentifier: "ProducttitleCell")
        self.ProductDetailTableView.register(UINib(nibName: "ProductDescriptionTableViewCell", bundle: nil), forCellReuseIdentifier: "ProductdescCell")
        self.ProductDetailTableView.register(UINib(nibName: "ProductbuybtnTableViewCell", bundle: nil), forCellReuseIdentifier: "ProductbuybtnCell")
        self.ProductDetailTableView.tableFooterView = UIView(frame: .zero)
        // Do any additional setup after loading the view.
    }

    //Mark: - API Data Fetching
    func CallService()
    {
        APIServiceDude.shared.getProductDetails (of: pro_id) {
            result in
            switch result {
            case .success(let fetchedProducts):
                
                p_det = fetchedProducts.data                
                DispatchQueue.main.async {
                    self.ProductDetailTableView.reloadData()
                    self.title = p_det.name
                }
                
            case .failure(let error):
                print("Error in getting Products: \(error)")
            }
        }
    }
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProducttitleCell", for: indexPath) as! ProducttitleTableViewCell
            cell.name.text = p_det.name
            cell.category.text = "Category - " + p_category[p_det.productCategoryID]
            cell.producer.text = p_det.producer
            
            cell.star1.image = p_det.rating > 0 ? stargold : starw
            cell.star2.image = p_det.rating > 1 ? stargold : starw
            cell.star3.image = p_det.rating > 2 ? stargold : starw
            cell.star4.image = p_det.rating > 3 ? stargold : starw
            cell.star5.image = p_det.rating > 4 ? stargold : starw
            
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductdescCell" , for: indexPath) as! ProductDescriptionTableViewCell
            cell.Cost.text = "Rs. " + String(p_det.cost)
            cell.descriptrion.text = p_det.description
            DispatchQueue.global().async {
                // Fetch Image Data
                if let data = try? Data(contentsOf: URL(string: p_det.productImages[0].image)!) {
                    DispatchQueue.main.async {
                        // Create Image and Update Image View
                        cell.mainimage.image = UIImage(data: data)
                        //self.imageView.image = UIImage(data: data)
                    }
                }
            }
            
            var ProductDescriptionCVimages = ProductDescriptionTableViewCell.loadfromnib(p_det.productImages)
            cell.imgcollectionview.reloadData()
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductbuybtnCell" , for: indexPath) as! ProductbuybtnTableViewCell
            cell.delegate = self
            return cell
        default:
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        // Configure the cell...

        return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row{
        case 0:
            return 80
        //case 1:
          //  return 700
        case 2 :
            return 80
        default:
            return UITableView.automaticDimension
        }
    }
}

extension ProductDetailsViewController: ProductQuantityDialogDelegate{
    func tempfunc() {
        print("tempff")
    }
    
    func ontapSubmit(_ p_qty : Int) {
        print(" p = ",p_qty)
    }
    
    func onBgViewTap() {
        debugPrint("Removing... Dialo")
        }
    
}
extension ProductDetailsViewController : ProductbuybtnDelegate{
    func ontaprate() {
        let vc = ProductRateDialogueViewController.loadfromnib(pro_id)
        //vc.delegate = self
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    func ontapbuy()  {
        self.definesPresentationContext = true
        self.modalTransitionStyle = .crossDissolve
        let vc = ProductQuantityDialog.loadFromNib(pro_id)
        vc.delegate = self
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
}

