//
//  SearchViewController.swift
//  BS
//
//  Created by 姚驷旭 on 16/1/13.
//  Copyright © 2016年 姚驷旭. All rights reserved.
//

import UIKit
import FMDB
import Toast

class SearchViewController: UIViewController {
    
    let tableView = UITableView()
    let cellIdentifier = "SearchTableViewCellTableViewCell"
    var searchBarPress = false
    var numberRowOfTableView = 1
    var userid = ""
    var userLeave : [Dictionary<String,String>] = []
    
    init(userid :String) {
        super.init(nibName: nil, bundle: nil)
        self.userid = userid
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        let tapView = UITapGestureRecognizer(target: self, action: "tapView")
        tapView.delegate = self
        self.view.addGestureRecognizer(tapView)
        self.view.backgroundColor = UIColor.whiteColor()
        self.navigationItem.title = "查询"
        let backButton = UIBarButtonItem()
        backButton.title = ""
        self.navigationItem.backBarButtonItem = backButton
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        initTableView()
        getUserLeaveInfo()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLayoutSubviews() {
        tableView.layoutMargins = UIEdgeInsetsZero
        tableView.separatorInset = UIEdgeInsetsZero
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        getUserLeaveInfo()
    }
    
    func initTableView() {
        self.view.addSubview(tableView)
        tableView.snp_makeConstraints(closure: { (make) in
            make.top.equalTo(64)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(-49)
        })
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.clearColor()
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableViewAutomaticDimension
        let cellNib = UINib(nibName: "SearchTableViewCellTableViewCell", bundle: nil)
        tableView.registerNib(cellNib, forCellReuseIdentifier: cellIdentifier)
    }
    
    func getUserLeaveInfo() {
        let database = FMDatabase(path: path().path)
        userLeave.removeAll()
        if database.open() {
            do {
                let rs = try database.executeQuery( "select id, name, starttime, endtime, numberDays, type, typeInfo, photo, status from leavetable where id=? order by starttime desc", values: [userid])
                while rs.next() {
                    let id = rs.stringForColumn("id")
                    let name = rs.stringForColumn("name")
                    let starttime = rs.stringForColumn("starttime")
                    let endtime = rs.stringForColumn("endtime")
                    let numberDays = rs.stringForColumn("numberDays")
                    let type = rs.stringForColumn("type")
                    let typeInfo = rs.stringForColumn("typeInfo")
                    let photo = rs.stringForColumn("photo")
                    let status = rs.stringForColumn("status")
                    var dic = Dictionary<String,String>()
                    dic["id"] = id
                    dic["name"] = name
                    dic["starttime"] = starttime
                    dic["endtime"] = endtime
                    dic["numberDays"] = numberDays
                    dic["type"] = type
                    dic["typeInfo"] = typeInfo
                    dic["photo"] = photo
                    dic["status"] = status
                    userLeave.append(dic)
                }
                tableView.reloadData()
                print("userLeave = \(userLeave)")
            } catch {
                print("查询失败!")
            }
        } else {
            print("打开失败!")
        }
        print("userLeave = \(userLeave)")
        database.close()
    }
}

extension SearchViewController : UITableViewDataSource,UITableViewDelegate {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! SearchTableViewCellTableViewCell
        
        if indexPath.row == 0 {
            cell.startTime.text = "开始时间"
            cell.startTime.font = LHFont(15)
            cell.startTime.textColor = UIColor.blackColor()
            cell.endTime.text = "结束时间"
            cell.endTime.font = LHFont(15)
            cell.endTime.textColor = UIColor.blackColor()
            cell.reson.text = "请假原因"
            cell.reson.font = LHFont(15)
            cell.reson.textColor = UIColor.blackColor()
            cell.status.text = "审批状态"
            cell.status.font = LHFont(15)
            cell.status.textColor = UIColor.blackColor()
        } else {
            cell.startTime.text = userLeave[indexPath.row - 1]["starttime"]
            cell.startTime.textAlignment = NSTextAlignment.Left
            cell.endTime.text = userLeave[indexPath.row - 1]["endtime"]
            cell.endTime.textAlignment = NSTextAlignment.Left
            cell.reson.text = userLeave[indexPath.row - 1]["type"]
            let status = userLeave[indexPath.row - 1]["status"]
            
            if status == "0" {
                cell.status.text = "未审核"
            } else if status == "1" {
                cell.status.text = "审核通过"
            } else {
                cell.status.text = "审核未通过"
            }
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userLeave.count + 1
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.layoutMargins = UIEdgeInsetsZero
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row == 0 {
            return
        }
        let resonInfo = SearchResonInfoViewController()
        resonInfo.userLeave = self.userLeave[indexPath.row - 1]
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(resonInfo, animated: true)
        self.hidesBottomBarWhenPushed = false
    }
}

extension SearchViewController : UIGestureRecognizerDelegate {
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        return false
    }
    
}

