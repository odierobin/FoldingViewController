//
//  MainViewController.swift
//  UIFolderTestA
//
//  Created by Odie Robin on 2018/1/10.
//  Copyright © 2018年 Odie Robin. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?){
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func onTestButton(_ sender: Any) {
        print("on Test Button")
    }
    
    

}
