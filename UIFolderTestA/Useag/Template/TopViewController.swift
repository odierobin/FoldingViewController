//
//  TopViewController.swift
//  UIFolderTestA
//
//  Created by Odie Robin on 2018/1/10.
//  Copyright © 2018年 Odie Robin. All rights reserved.
//

import UIKit

class TopViewController: UIViewController {
    
    public var delegate : FoldingUserAction?

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
    
    public func showSelfInfo(){
        print("Info From TOP VIEWCONTROLLER!")
    }
    @IBAction func onTestButtonClose(_ sender: Any) {
        delegate?.onUserAction(to: .Hide, with: .Top)
    }
    
}
