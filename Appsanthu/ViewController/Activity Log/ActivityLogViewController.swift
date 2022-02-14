//
//  ActivityLogViewController.swift
//  Appsanthu
//
//  Created by ĐINH HUY PHU on 02/08/2021.
//

import UIKit

class ActivityLogViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func Backmain(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func NextSave(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SaveActivityLogViewController") as! SaveActivityLogViewController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
}
