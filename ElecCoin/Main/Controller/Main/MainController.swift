//
//  MainController.swift
//  ElecCoin
//
//  Created by 张艺哲 on 2020/5/4.
//  Copyright © 2020 Elecoxy. All rights reserved.
//

import UIKit
import SnapKit
import MJRefresh

class MainController: UIViewController {
    
    let mainModel = MainModel()
    
    let tableView = UITableView()
    
    // 顶部刷新
    let headerRefresh = MJRefreshNormalHeader()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        
        reloadData(reloadTableView: true)
    }
    
    func initView() {
        
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MainChatTableViewCell.self, forCellReuseIdentifier: "MainChatTableViewCell")
        tableView.register(MainSelectTableViewCell.self, forCellReuseIdentifier: "MainSelectTableViewCell")
        tableView.tableFooterView = UIView()
        self.view.addSubview(tableView)
        
        //下拉刷新相关设置
        headerRefresh.setRefreshingTarget(self, refreshingAction: #selector(reloadData(reloadTableView:)))
        self.tableView.mj_header = headerRefresh
        
        initSnap()
    }
    
    // 布局
    func initSnap() {
        tableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right)
        }
    }
    
    // 数据请求
    @objc func reloadData(reloadTableView:  Bool) {
        FTIndicator.showProgress(withMessage: "", userInteractionEnable: false)
        
        let userDefaults = UserDefaults.standard
        let timespanInt = userDefaults.integer(forKey: UserDefaultsKey.timeChoose)
        let daysAverageInt = userDefaults.integer(forKey: UserDefaultsKey.averageChoose)

        mainModel.MarketPriceRequest(timespan: timespan(rawValue: timespanInt) ?? timespan.thirtyDays, daysAverage: daysAverage(rawValue: daysAverageInt) ?? daysAverage.rawValues) { [weak self] (result) in
            FTIndicator.dismissProgress()
            guard let self = self else {return}
            self.tableView.mj_header?.endRefreshing()
            switch result {
            case .success(_):
                if reloadTableView {
                    self.tableView.reloadData()
                } else {
                    if let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? MainChatTableViewCell {
                        cell.values = self.mainModel.values
                    }
                }
                break
            case let .failure(error):
                FTIndicator.showToastMessage(error.localizedDescription)
            }
        }
    }


}

// MARK: - tableview delegate
extension MainController: UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MainChatTableViewCell", for: indexPath) as? MainChatTableViewCell
            cell?.selectionStyle = .none
            cell?.values = mainModel.values
            return cell ?? UITableViewCell()
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MainSelectTableViewCell", for: indexPath) as? MainSelectTableViewCell
            cell?.selectionStyle = .none
            if indexPath.row - 1 == 0 {
                cell?.type = .time
            } else {
                cell?.type = .average
            }
            cell?.selectBlock = { [weak self] in
                self?.reloadData(reloadTableView: false)
            }
            return cell ?? UITableViewCell()
        }
    }
}
