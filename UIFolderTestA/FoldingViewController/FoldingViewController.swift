//
//  HoderViewController.swift
//  UIFolderTestA
//
//  Created by Odie Robin on 2018/1/8.
//  Copyright © 2018年 Odie Robin. All rights reserved.
//

import UIKit

class FoldingViewController: UIViewController {
    
    var zoneSetting : [FoldingLayoutDirection : FoldingZoneSetting] = [:]
    var zoneViews : [FoldingLayoutDirection : UIViewController] = [:]
    var zonePosition : [FoldingLayoutDirection : FoldingLayoutPosition] = [:]
    
    let fullWidth : CGFloat = UIScreen.main.bounds.width
    let fullHeight : CGFloat = UIScreen.main.bounds.height
    
    var delegate : FoldingViewDelegate?
    
    
    required init(_ setting : [FoldingZoneSetting]) {
        super.init(nibName: nil, bundle: nil)
        for info in setting{
            zoneSetting[info.dir] = info
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    
    
    fileprivate var nowStatus : FoldingLayoutDirection = .Center{
        willSet{
            if let setting = zoneSetting[newValue]{
                self.zoneViews[.Center]!.view.isUserInteractionEnabled = setting.isUserInteraction
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for setting  in zoneSetting {
            zonePosition[setting.key] = FoldingLayoutPosition()
            zonePosition[setting.key]!.setValue(setting: setting.value)
            let viewController = setting.value.controller.init(nibName: setting.value.nibName, bundle: nil)
            viewController.view.frame = zonePosition[setting.key]!.frame
            viewController.view.center = zonePosition[setting.key]!.centerOnHidden
            viewController.view.clipsToBounds = true
            view.addSubview(viewController.view)
            self.addChildViewController(viewController)
            zoneViews[setting.key] = viewController
            if setting.key != .Center{
                viewController.view.isHidden = true
            }
        }
        
        
        let swipeDownRecognizer = UISwipeGestureRecognizer(target: self, action:#selector(onSwip))
        swipeDownRecognizer.direction = .down
        view.addGestureRecognizer(swipeDownRecognizer)
        
        let swipeUpRecognizer = UISwipeGestureRecognizer(target: self, action:#selector(onSwip))
        swipeUpRecognizer.direction = .up
        view.addGestureRecognizer(swipeUpRecognizer)
        
        let swipeleftRecognizer = UISwipeGestureRecognizer(target: self, action:#selector(onSwip))
        swipeleftRecognizer.direction = .left
        view.addGestureRecognizer(swipeleftRecognizer)
        
        let swipeRightRecognizer = UISwipeGestureRecognizer(target: self, action:#selector(onSwip))
        swipeRightRecognizer.direction = .right
        view.addGestureRecognizer(swipeRightRecognizer)
    }
    
    func getScale(to showDirction : FoldingLayoutDirection) -> CGFloat{
        if let setting = zoneSetting[showDirction]{
            switch showDirction {
            case .Top:
                return (fullHeight - setting.length) / fullHeight
            case .Bottom:
                return (fullHeight - setting.length) / fullHeight
            case .Left:
                return (fullWidth - setting.length) / fullWidth
            case .Right:
                return (fullWidth - setting.length) / fullWidth
            default:
                return 1
            }
        }else{
            return 1
        }
        
    }
    
    
    @objc func onSwip(gesture:UISwipeGestureRecognizer){
        switch gesture.direction {
        case .down:
            if nowStatus == .Center && zoneSetting[.Top] != nil{
                onZoneAction(to:.Show, with:.Top)
            }else if nowStatus == .Bottom{
                onZoneAction(to:.Hide, with:.Bottom)
            }
        case .up:
            if nowStatus == .Center && zoneSetting[.Bottom] != nil{
                onZoneAction(to: .Show, with:.Bottom)
            }else if nowStatus == .Top {
                onZoneAction(to: .Hide, with: .Top)
            }
        case .left:
            if nowStatus == .Center && zoneSetting[.Right] != nil{
                onZoneAction(to: .Show, with:.Right)
            }else if nowStatus == .Left {
                onZoneAction(to: .Hide, with: .Left)
            }
        case .right:
            if nowStatus == .Center && zoneSetting[.Left] != nil{
                onZoneAction(to: .Show, with:.Left)
            }else if nowStatus == .Right {
                onZoneAction(to: .Hide, with: .Right)
            }
        default:
            break
        }
    }
    
    func onZoneAction(to action : FoldingLayoutAction,with dirction : FoldingLayoutDirection){
        
       delegate?.onZoneActionStart(to: action, with: dirction, on: zoneViews[dirction]!, and: zoneViews[.Center]!)
        if action == .Show{
            zoneViews[dirction]!.view.transform = CGAffineTransform.identity.scaledBy(x: zonePosition[dirction]!.scale.x, y: zonePosition[dirction]!.scale.y)
        }
        
        UIView.animate(withDuration: 0.8, animations: {
            switch action{
            case .Show:
                self.zoneViews[dirction]!.view.isHidden = false
                self.zoneViews[dirction]!.view.transform = CGAffineTransform.identity
                self.zoneViews[dirction]!.view.center = self.zonePosition[dirction]!.center
                if self.zoneSetting[dirction]!.isAutoScale{
                    self.zoneViews[.Center]!.view.transform = CGAffineTransform.identity.scaledBy(x: self.getScale(to: dirction), y: self.getScale(to: dirction))
                    self.zoneViews[.Center]!.view.center = self.zonePosition[dirction]!.centerZoneCenter
                }else{
                    self.zoneViews[.Center]!.view.frame = self.zonePosition[dirction]!.centerZoneFrame
                }
            case .Hide:
                self.zoneViews[dirction]!.view.transform = CGAffineTransform.identity.scaledBy(x: self.zonePosition[dirction]!.scale.x, y: self.zonePosition[dirction]!.scale.y)
                self.zoneViews[dirction]!.view.center = self.zonePosition[dirction]!.centerOnHidden
                self.zoneViews[.Center]!.view.transform = CGAffineTransform.identity
                self.zoneViews[.Center]!.view.center = self.zonePosition[.Center]!.center
            }
        },completion:{
            _ in
            if action == .Show{
                self.nowStatus = dirction
            }else{
                self.zoneViews[dirction]!.view.isHidden = true
                self.nowStatus = .Center
                self.zoneViews[dirction]!.view.transform = CGAffineTransform.identity
            }
            
            self.delegate?.onZoneActionComplete(to: action, with: dirction, on: self.zoneViews[dirction]!, and: self.zoneViews[.Center]!)
        })
        
        
    }
}

protocol FoldingViewDelegate {
    func onZoneActionStart(to action : FoldingLayoutAction,with dirction : FoldingLayoutDirection,on viewController : UIViewController,and centerViewControler : UIViewController)
    func onZoneActionComplete(to action : FoldingLayoutAction,with dirction : FoldingLayoutDirection,on viewController : UIViewController,and centerViewControler : UIViewController)
}

public enum FoldingLayoutDirection : Int{
    case Center = 0
    case Top = 1
    case Bottom = 2
    case Left = 3
    case Right = 4
    
}

public enum FoldingLayoutAction {
    case Show
    case Hide
}

public struct FoldingZoneSetting{
    var dir : FoldingLayoutDirection
    var nibName : String
    var isUserInteraction : Bool
    var length : CGFloat
    var isAutoScale : Bool
    var controller : UIViewController.Type
}

public struct FoldingLayoutPosition{
    var center : CGPoint = CGPoint(x: 0, y: 0)
    var frame : CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
    var scale : CGPoint = CGPoint(x: 0, y: 0)
    var centerOnHidden : CGPoint = CGPoint(x: 0, y: 0)
    var centerZoneCenter : CGPoint = CGPoint(x: 0, y: 0)
    var centerZoneFrame : CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
    
    mutating func setValue(setting : FoldingZoneSetting){
        let fullWidth : CGFloat = UIScreen.main.bounds.width
        let fullHeight : CGFloat = UIScreen.main.bounds.height
        let miniScale : CGFloat = 0.1
        switch setting.dir {
        case .Top:
            center = CGPoint(x: fullWidth / 2, y: setting.length / 2)
            frame = CGRect(x: 0, y: 0, width: fullWidth, height: setting.length)
            scale = CGPoint(x: 1, y: miniScale)
            centerOnHidden = CGPoint(x: fullWidth / 2, y: -setting.length / 2 )
            centerZoneCenter = CGPoint(x: fullWidth / 2, y: (fullHeight + setting.length) / 2)
            centerZoneFrame =  CGRect(x: 0, y: setting.length, width: fullWidth, height: fullHeight)
        case .Bottom:
            center = CGPoint(x: fullWidth / 2, y: fullHeight - setting.length / 2)
            frame = CGRect(x: 0, y: fullHeight - setting.length, width: fullWidth, height:setting.length)
            scale = CGPoint(x: 1, y: miniScale)
            centerOnHidden = CGPoint(x: fullWidth / 2, y: fullHeight + setting.length  / 2)
            centerZoneCenter = CGPoint(x: fullWidth / 2, y: (fullHeight - setting.length) / 2)
            centerZoneFrame =  CGRect(x: 0, y: -setting.length, width: fullWidth, height: fullHeight)
        case .Left:
            center = CGPoint(x: setting.length / 2, y: fullHeight / 2)
            frame = CGRect(x: 0, y: 0, width: setting.length, height: fullHeight)
            scale = CGPoint(x: miniScale, y: 1)
            centerOnHidden = CGPoint(x: -setting.length  / 2 , y: fullHeight / 2)
            centerZoneCenter = CGPoint(x: (fullWidth + setting.length) / 2, y: fullHeight / 2)
            centerZoneFrame =  CGRect(x: setting.length, y: 0, width: fullWidth, height: fullHeight)
        case .Right:
            center = CGPoint(x: fullWidth - setting.length / 2, y: fullHeight / 2)
            frame = CGRect(x: fullWidth - setting.length, y: 0, width: setting.length, height: fullHeight)
            scale = CGPoint(x: miniScale, y: 1)
            centerOnHidden = CGPoint(x: fullWidth + setting.length  / 2 , y: fullHeight / 2)
            centerZoneCenter = CGPoint(x: (fullWidth - setting.length) / 2, y: fullHeight / 2)
            centerZoneFrame =  CGRect(x: -setting.length, y: 0, width: fullWidth, height: fullHeight)
        case .Center:
            center = CGPoint(x: fullWidth / 2, y: fullHeight / 2)
            frame = CGRect(x: 0, y: 0, width: fullWidth, height: fullHeight)
            scale = CGPoint(x: 1, y: 1)
            centerOnHidden = CGPoint(x: fullWidth / 2, y: fullHeight / 2)
            centerZoneCenter = CGPoint(x: fullWidth / 2, y: fullHeight / 2)
            centerZoneFrame =  CGRect(x: 0, y: 0, width: fullWidth, height: fullHeight)
        }
    }
}
