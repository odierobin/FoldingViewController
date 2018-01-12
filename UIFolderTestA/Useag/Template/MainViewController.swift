//
//  MainViewController.swift
//  UIFolderTestA
//
//  Created by Odie Robin on 2018/1/10.
//  Copyright © 2018年 Odie Robin. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    public var delegate : FoldingUserAction?
    
    private var count : Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        testButtonCount.text = "Button Click Count : \(count)"
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?){
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func onTestButton(_ sender: Any) {
        delegate?.onUserAction(to: .Show, with: .Top)
        count += 1
        testButtonCount.text = "Button Click Count : \(count)"
    }
    
    @IBOutlet weak var testButtonCount: UILabel!
    

}
