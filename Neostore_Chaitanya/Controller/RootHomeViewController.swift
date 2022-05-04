//
//  RootHomeViewController.swift
//  Neostore_Chaitanya
//
//  Created by Neosoft on 23/01/22.
//

import UIKit

class RootHomeViewController: UIViewController {

    static func loadfromnib() -> UIViewController{
        return RootHomeViewController(nibName: "RootHomeViewController", bundle: nil)
    }
    
    enum Menustate {
        case opened
        case closed
    }
    
    private var menustate : Menustate = .closed
    
    let menuVC = SideMenuViewController()
    let homeVC = HomeableViewController()
    var navVC: UINavigationController?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        addChildVCs()
        //  self.navigationController?.navigationBar.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func addChildVCs()
    {
        addChild(menuVC)
        view.addSubview(menuVC.view)
        menuVC.didMove(toParent: self)
        
        homeVC.delegate = self
        let  navVC = UINavigationController(rootViewController: homeVC)
        addChild(navVC)
        view.addSubview(navVC.view)
        navVC.didMove(toParent: self)
        self.navVC = navVC
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

extension RootHomeViewController : HomeControllerDelegate {
    func didtapmenu() {
        switch menustate {
        case .closed:
            //open it
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut) {
                self.navVC?.view.frame.origin.x = self.homeVC.view.frame.size.width * 0.7
            } completion: { [weak self] done in
                if done{
                    self?.menustate = .opened
                }
            }

        case .opened:
            //close it
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut) {
                    self.navVC?.view.frame.origin.x = 0
                } completion: { [weak self] done in
                    if done{
                        self?.menustate = .closed
                    }
                }
        }
    }
}
