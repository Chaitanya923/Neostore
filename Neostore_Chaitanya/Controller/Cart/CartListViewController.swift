//
//  CartListViewController.swift
//  Neostore_Chaitanya
//
//  Created by neosoft on 23/02/22.
//

import UIKit

class CartListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var selectedRow = 0
    let screenWidth = UIScreen.main.bounds.width - 60
    let screenHeight = UIScreen.main.bounds.height / 6
    let quantity = [1,2,3,4,5,6,7]
    
    @IBOutlet weak var CartListTableView: UITableView!
    
    var cartproducts : [CartProduct] = []
    var cartrespo: CartResponse?
    var total : Int = 0
    static func loadFromNib() -> CartListViewController {
        CartListViewController(nibName: "CartListViewController", bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CallService()

        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.backgroundColor = UIColor(hexFromString: "E91C1A")
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.isOpaque = true
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white,NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 25)] //,NSAttributedString.Key.font: UIFont(name: "GOTHAM", size: 14)]
        self.title = "My Cart"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        //navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(imageLiteralResourceName: "search_icon"))
        
        CartListTableView.delegate = self
        CartListTableView.dataSource = self
        CartListTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        CartListTableView.register(UINib(nibName: "CartTVCell", bundle: nil), forCellReuseIdentifier: "cartTVCell")
        CartListTableView.register(UINib(nibName: "AmountTVCell", bundle: nil), forCellReuseIdentifier: "amountTVCell")
        CartListTableView.register(UINib(nibName: "OrderNowbtnTableViewCell", bundle: nil), forCellReuseIdentifier: "orderTVCell")
        
        CartListTableView.tableFooterView = UIView(frame: .zero)
        // Do any additional setup after loading the view.
    }

    
    func CallService() {
        APIServiceDude.shared.getMyCartDetails(accessToken: KeychainManagement().getAccessToken()) { result in
            
            DispatchQueue.main.async { [self] in
                switch result{
                case .success(let resps):
                    cartrespo = resps
                    cartproducts = resps.data
                    total = Int(resps.total)
                    CartListTableView.reloadData()
                case .failure(_):
                    print("error")
                }
            }
        }
    }
    
    func CallService_Edit(_ id : Int, _ q :Int){
        APIServiceDude.shared.updateProductFromCart(of: id, qty: q, accessToken: KeychainManagement().getAccessToken()) { _ in
            DispatchQueue.main.async { [self] in
                CallService()
            }
        }
    }
    
    func CallService_Delete(_ id : Int){
        APIServiceDude.shared.deleteProductFromCart(of: id, accessToken: KeychainManagement().getAccessToken()) { _ in
            DispatchQueue.main.async { [self] in
                CallService()
            }        }
    }

    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 110
        case 1:
            return 90
        case 2:
            return 80
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return cartproducts.count
        case 1:
            return 1
        case 2:
            return 1
        default:
            return 0
        }
    }
    

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cartTVCell", for: indexPath) as! CartTVCell
            cell.Producttitle.text = cartproducts[indexPath.row].product.name
            cell.Category.text = cartproducts[indexPath.row].product.productCategory
            cell.cost.text = "Rs "+String(cartproducts[indexPath.row].product.cost)
            cell.qty.text = String(cartproducts[indexPath.row].quantity)
            cell.id = cartproducts[indexPath.row].product.id
            cell.delegate = self
            
            DispatchQueue.global().async {
                // Fetch Image Data
                if let data = try? Data(contentsOf: URL(string: self.cartproducts[indexPath.row].product.productImages)!) {
                    DispatchQueue.main.async {
                        // Create Image and Update Image View
                        cell.cartimg.image = UIImage(data: data)
                        //self.imageView.image = UIImage(data: data)
                    }
                }
            }
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "amountTVCell", for: indexPath) as! AmountTVCell
            cell.totalcosting.text = "Rs " + String(total)
            //cell.totalcosting.text = String(cartrespo?.total)
            
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "orderTVCell", for: indexPath) as! OrderNowbtnTableViewCell
            cell.ondelegate = self
            return cell
            
        default:
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        // Configure the cell...

        return cell
        }
    }

    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.section == 0 {
            let deleteAction = UIContextualAction(style: .normal, title: "Delete") { (action, view, completion) in
                self.CallService_Delete(self.cartproducts[indexPath.row].productID)
                completion(true)
            }
            
            
            let img = UIImage(systemName: "trash.circle.fill")!.withTintColor(.systemRed, renderingMode: .automatic)
            deleteAction.image = img
            deleteAction.backgroundColor = .systemRed
            return UISwipeActionsConfiguration(actions: [deleteAction])
        }
        return nil
    }
}

extension CartListViewController : OrderNowDelegate {
    func ontapOrder() {
        //self.navigationController?.pushViewController(AddresslistTableViewController.loadfromnib(), animated: true)
        self.navigationController?.pushViewController(AddaddressViewController(), animated: true)
    }
    
    
}

extension CartListViewController : CartEditButtonDelegate, UIPickerViewDelegate,UIPickerViewDataSource {
    
    func didTapEditBtn(id: Int) {
        let vc = UIViewController()

        vc.preferredContentSize = CGSize(width: screenWidth, height: screenHeight)
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: screenWidth, height:screenHeight))
        pickerView.dataSource = self
        pickerView.delegate = self
        
        pickerView.selectRow(selectedRow, inComponent: 0, animated: false)
        
        vc.view.addSubview(pickerView)
        
        let alert = UIAlertController(title: "Update Quantity", message: "", preferredStyle: .actionSheet)
        
        alert.setValue(vc, forKey: "contentViewController")
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction) in
        }))
        
        alert.addAction(UIAlertAction(title: "Select", style: .default, handler: { [weak self] (UIAlertAction) in
            if let updatedQuantityNum = self?.selectedRow {
                // Call API
                //self?.viewModel.editCart(productId: "\(id)", quantity: updatedQuantityNum)
                print("updatedQuantityNum :",updatedQuantityNum)
                self?.CallService_Edit(id, updatedQuantityNum)
            }
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return quantity.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(quantity[row])"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedRow = row + 1
    }
}
