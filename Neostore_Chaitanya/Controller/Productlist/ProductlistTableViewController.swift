//
//  ProductlistTableViewController.swift
//  Neos
//

import UIKit

//var cat_id :  Int = 0
//var p_category_id = [0,1,3,2,4]
class ProductlistTableViewController: UITableViewController {
    
    static func loadfromnib(_ id : Int) -> UITableViewController {
        cat_id = p_category_id[id]
     return ProductlistTableViewController(nibName: "ProductlistTableViewController", bundle:nil)
 }
  
    var pro_list :[ProductModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        CallService()
        self.showSpinner(onView: self.view)

        
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
        
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.register(UINib(nibName: "ProductlistcellTableViewCell", bundle: nil), forCellReuseIdentifier: "ProductlistCell")
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    func  CallService() {
        APIServiceDude.shared.getProductList(of: cat_id) {
            result in
            DispatchQueue.main.async {
                switch result {
                case .success(let fetchedProducts):
                    var i = 0
                    for ele in fetchedProducts.data {
                        self.pro_list.append(ele)
                        print("ele ",i," :",ele)
                        i=i+1
                    }
                    //print("Array",self.pro_list)
                    
                    self.tableView.reloadData()
                    self.removeSpinner()
                    
                case .failure(let error):
                    print("Error in getting Products: \(error)")
                }
            }
            
        }
        //print(ProductModel.self)
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return pro_list.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("CELL",indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductlistCell", for: indexPath) as! ProductlistcellTableViewCell
        cell.Product_name.text = pro_list[indexPath.row].name
        cell.Product_Price.text = "Rs. " + String( pro_list[indexPath.row].cost)
        cell.Product_center.text = pro_list[indexPath.row].producer

            DispatchQueue.global().async {
                // Fetch Image Data
                if let data = try? Data(contentsOf: URL(string: self.pro_list[indexPath.row].productImages)!) {
                    DispatchQueue.main.async {
                        // Create Image and Update Image View
                        cell.Product_img.image = UIImage(data: data)
                        //self.imageView.image = UIImage(data: data)
                    }
                }
            }
        switch pro_list[indexPath.row].rating {
        case 1:
            cell.star1.image = stargold
            cell.star2.image = starw
            cell.star3.image = starw
            cell.star4.image = starw
            cell.star5.image = starw
        case 2:
            cell.star1.image = stargold
            cell.star2.image = stargold
            cell.star3.image = starw
            cell.star4.image = starw
            cell.star5.image = starw
        case 3:
            cell.star1.image = stargold
            cell.star2.image = stargold
            cell.star3.image = starw
            cell.star4.image = starw
            cell.star5.image = starw
        case 4:
            cell.star1.image = stargold
            cell.star2.image = stargold
            cell.star3.image = stargold
            cell.star4.image = stargold
            cell.star5.image = starw
        case 5:
            cell.star1.image = stargold
            cell.star2.image = stargold
            cell.star3.image = stargold
            cell.star4.image = stargold
            cell.star5.image = stargold
        default:
                cell.star1.image = stargold
                cell.star2.image = stargold
                cell.star3.image = stargold
                cell.star4.image = stargold
                cell.star5.image = stargold
        }
        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print()
        self.navigationController?.pushViewController(ProductDetailsViewController.loadfromnib(pro_list[indexPath.row].id), animated: true)
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
}
