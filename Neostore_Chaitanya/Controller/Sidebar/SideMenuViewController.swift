//
//  SideMenuViewController.swift
//  Neostore_Chaitanya
//
//  Created by neosoft on 31/01/22.
//

import UIKit

let sidelist = ["My Cart","Tables","Sofas","Chairs","Cupboards","My Account","Store Locator","My Orders","Logout"]

let sidelistimage = ["shoppingcart_icon","table","sofa_icon","chair","cupboard","username_icon","storelocator_icon","myorders_icon","logout_icon"]

class SideMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var total : Int = 0
    
    static func loadfromnib() -> UIViewController {
        return SideMenuViewController(nibName: "SideMenuViewController", bundle: nil)
    }
    
    func CallService() {
        APIServiceDude.shared.getMyCartDetails(accessToken: KeychainManagement().getAccessToken()) { result in
            
            DispatchQueue.main.async { [self] in
                switch result{
                case .success(let resps):
                    total = Int(resps.count)
                    menutable.reloadData()
                case .failure(_):
                    print("error")
                }
            }
        }
    }
    
     func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0 :
            let cell = tableView.dequeueReusableCell(withIdentifier: "NavprofileCell", for: indexPath) as! NavprofileTableViewCell
            CallService(KeychainManagement().getAccessToken() ?? "") { name, email in
                DispatchQueue.main.async {
                cell.name.text = name
                cell.email.text = email
                }
            }
            cell.selectionStyle = .none
            return cell
        case 1:
            //print(indexPath.row,indexPath.section)
            let cell = tableView.dequeueReusableCell(withIdentifier: "NavCell", for: indexPath) as! Nav
            cell.Navlabel.text = sidelist[indexPath.row]
            cell.navimg.image = #imageLiteral(resourceName: sidelistimage[indexPath.row])
            if indexPath.row == 0 {
                cell.badgeview.isHidden = false
                cell.badgelabel.text = String(total)
            } else {
                cell.badgeview.isHidden = true
            }
            cell.selectionStyle = .none
            return cell
        default:
            
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

            //cell.backgroundColor = UIColor(red: 44, green: 43, blue: 43, alpha: 1)
            // Configure the cell...

        return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 280
        case 1:
            return 45
        default:
            return 100
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            _ = 1
        case 1:
            switch indexPath.row {
            case 0:
                if total == 0 {
                    
                }
                else {
                    self.navigationController?.pushViewController(CartListViewController.loadFromNib(), animated: true)
                }
            case 1...4:
                self.navigationController?.pushViewController(ProductListViewController.loadfromnib(indexPath.row) , animated: true)
            case 5:
                self.navigationController?.pushViewController(EditProfileViewController.loadfromnib(), animated: true)
            case 7:
                self.navigationController?.pushViewController(MyordersTableViewController.loadfromnib(), animated: true)
            case 8 :
                KeychainManagement().logout()
                UIApplication.shared.windows.first?.rootViewController = UINavigationController(rootViewController: Login.loadfromnib())
                UIApplication.shared.windows.first?.makeKeyAndVisible()
            default:
                break
            }
        default:
        print("NA")
            
        }
    }

    @IBOutlet weak var menutable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menutable.delegate = self
        menutable.dataSource = self
        menutable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        menutable.register(UINib(nibName: "Nav", bundle: nil), forCellReuseIdentifier: "NavCell")
        
        menutable.register(UINib(nibName: "NavprofileTableViewCell", bundle: nil), forCellReuseIdentifier: "NavprofileCell")
            
        
    // Do any additional setup after loading the view.
        CallService()
    }
    override func viewWillAppear(_ animated: Bool) {
        CallService()
    }

    
    func  CallService(_ accesstoken : String,onhandleresponse : @escaping(_ name : String, _ email: String)-> Void) {
        APIServiceDude.shared.getUserDetails(accessToken: accesstoken) { Result in
            
            switch Result {
            case .success(let resps):
                print(resps)
                onhandleresponse(resps.data.userData.firstName + resps.data.userData.lastName,resps.data.userData.email)
            case .failure(let respf):
                print(respf)
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        if animated == true {
            //CallService(KeychainManagement().getAccessToken() ?? "")
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
