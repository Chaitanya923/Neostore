//
//  Sidebar.swift
//  Neostore_Chaitanya
//
//  Created by Neosoft on 05/01/22.
//

import UIKit

class Sidebar: UITableViewController {
    
    let sidelist = ["My Cart","Tables","Sofas","Chairs","Cupboards","My Account","Store Locator","My Orders","Logout"]

    let sidelistimage = ["shoppingcart_icon","table","sofa_icon","chair","cupboard","username_icon","storelocator_icon","myorders_icon","logout_icon"]

static func loadfromnib() -> UITableViewController {
     return Sidebar(nibName: "Sidebar", bundle:nil)
 }
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.register(UINib(nibName: "Nav", bundle: nil), forCellReuseIdentifier: "NavCell")
        self.tableView.register(UINib(nibName: "NavprofileTableViewCell", bundle: nil), forCellReuseIdentifier: "NavprofileCell")
                // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 0:
            return 1
        case 1 :
            return 9
        default:
            return 0
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0 :
            let cell = tableView.dequeueReusableCell(withIdentifier: "NavprofileCell", for: indexPath) as! NavprofileTableViewCell
            
            return cell
        case 1:
            //print(indexPath.row,indexPath.section)
            let cell = tableView.dequeueReusableCell(withIdentifier: "NavCell", for: indexPath) as! Nav
            cell.Navlabel.text = sidelist[indexPath.row]
            cell.navimg.image = #imageLiteral(resourceName: sidelistimage[indexPath.row])
//            cell.Navlabel = sidelist[indexPath.row]
            return cell
        default:
            
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

            //cell.backgroundColor = UIColor(red: 44, green: 43, blue: 43, alpha: 1)
            // Configure the cell...

        return cell
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 250
        case 1:
            return 50
        default:
            return 100
        }
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            let a = 1
        case 1:
            switch indexPath.row {
            case 0:
                self.navigationController?.pushViewController(CartListViewController.loadFromNib(), animated: true)
            case 1...4:
                self.navigationController?.pushViewController(ProductlistTableViewController.loadfromnib(indexPath.row) , animated: true)
            case 5:
                self.navigationController?.pushViewController(EditProfileViewController.loadfromnib(), animated: true)
            case 7:
                self.navigationController?.pushViewController(MyordersTableViewController.loadfromnib(), animated: true)
            default:
                _ = 1
            }
        default:
            _ = 1
            }
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
