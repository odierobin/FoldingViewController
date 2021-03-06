//
//  FrontViewController.swift
//  UIFolderTestA
//
//  Created by Odie Robin on 2018/1/11.
//  Copyright © 2018年 Odie Robin. All rights reserved.
//

import UIKit

class FrontViewController: UIViewController,FoldingViewDelegate {
    

    @IBOutlet weak var holderView: UIView!
    
    private var foldingVc : FoldingViewController?
    private var zoneViews : [FoldingLayoutDirection:UIViewController] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        foldingVc = FoldingViewController([
            FoldingZoneSetting(dir: .Center, nibName: "MainViewController", isUserInteraction: true, length: 0, isAutoScale: false, controller : MainViewController.self),
            FoldingZoneSetting(dir: .Top, nibName: "TopViewController", isUserInteraction: false, length: 150, isAutoScale: false,controller : TopViewController.self),
            FoldingZoneSetting(dir: .Bottom, nibName: "BottomViewController", isUserInteraction: false, length: 60, isAutoScale: false,controller : BottomViewController.self),
            FoldingZoneSetting(dir: .Left, nibName: "LeftViewController", isUserInteraction: false, length: 70, isAutoScale: true,controller : LeftViewController.self),
            FoldingZoneSetting(dir: .Right, nibName: "RightViewController", isUserInteraction: false, length: 300, isAutoScale: true,controller : RightViewController.self)
            ])
        foldingVc!.view.frame = holderView.bounds
        holderView.addSubview(foldingVc!.view)
        self.addChildViewController(foldingVc!)
        
        
        
        foldingVc!.delegate = self
        
        zoneViews = foldingVc!.zoneViews
        for item in zoneViews {
            switch item.key{
            case .Top:
                let top = item.value as! TopViewController
                top.delegate = foldingVc
            case .Center:
                let center = item.value as! MainViewController
                center.delegate = foldingVc
            default:
                break
            }
        }
    }
    
    
    //MARK : - FoldingViewDelegate
    func onZoneActionStart(to action : FoldingLayoutAction,with dirction : FoldingLayoutDirection,on viewController : UIViewController,and centerViewControler : UIViewController){
        if dirction == .Top{
            print("Before To \(action) TOP")
            let topvc = viewController as! TopViewController
            topvc.showSelfInfo()
        }
    }
    func onZoneActionComplete(to action : FoldingLayoutAction,with dirction : FoldingLayoutDirection,on viewController : UIViewController,and centerViewControler : UIViewController){
        if dirction == .Top{
            print("Finish \(action) TOP")
            let topvc = viewController as! TopViewController
            topvc.showSelfInfo()
        }
    }

}
