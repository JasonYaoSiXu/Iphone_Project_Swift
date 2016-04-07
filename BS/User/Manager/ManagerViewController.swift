//
//  ManagerViewController.swift
//  BS
//
//  Created by 姚驷旭 on 16/1/13.
//  Copyright © 2016年 姚驷旭. All rights reserved.
//

class ManagerViewController: SegmentedViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let vc1 = UserDidShowViewController()
        vc1.segmentTitle = "已举办"
        let vc2 = UserReadyShowViewController()
        vc2.segmentTitle = "筹备中"
        myViewControllers = [vc1,vc2]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
