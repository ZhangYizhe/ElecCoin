//
//  MainSelectTableViewCell.swift
//  ElecCoin
//
//  Created by 张艺哲 on 2020/5/4.
//  Copyright © 2020 Elecoxy. All rights reserved.
//

import UIKit

enum MainSelectTableViewCellType
{
    case time
    case average
}

class MainSelectTableViewCell: UITableViewCell {
    
    var selectBlock: (() -> Void)?
    
    var type : MainSelectTableViewCellType = .time {
        didSet {
            switch type {
            case .time:
                titleLabel.text = "Time"
                
                self.initSegmentedControl(items: ["30 D", "60 D", "180 D", "1 Y", "3 Y", "All Time"])
                
                let userDefaults = UserDefaults.standard
                let timeChoose = userDefaults.integer(forKey: UserDefaultsKey.timeChoose)
                segmentedControl.selectedSegmentIndex = timeChoose
                
                initSnap()
            case .average:
                titleLabel.text = "Average"
                
                self.initSegmentedControl(items: ["Raw Values", "7 Day Average", "30 Day Average"])
                
                let userDefaults = UserDefaults.standard
                let averageChoose = userDefaults.integer(forKey: UserDefaultsKey.averageChoose)
                segmentedControl.selectedSegmentIndex = averageChoose
                
                initSnap()
            }
        }
    }
    
    private let titleLabel = UILabel()
    
    private var segmentedControl = UISegmentedControl()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initView() {
        
        titleLabel.text = "Title"
        self.addSubview(titleLabel)
        
        initSegmentedControl(items: nil)
    }
    
    private func initSegmentedControl(items: [String]?)
    {
        segmentedControl.removeFromSuperview()
        segmentedControl = UISegmentedControl(items: items)
        segmentedControl.addTarget(self, action: #selector(segmentDidchange(_:)), for: .valueChanged)
        self.addSubview(segmentedControl)
        
        initSnap()
    }
    
    @objc private func segmentDidchange(_ segmented:UISegmentedControl){
        //获得选项的索引
        if let index = timespan(rawValue: segmented.selectedSegmentIndex) {
            let userDefaults = UserDefaults.standard
            userDefaults.set(index.rawValue, forKey: self.type == .time ? UserDefaultsKey.timeChoose : UserDefaultsKey.averageChoose)
            selectBlock?()
        }
    }
    
    private func initSnap()
    {
        titleLabel.snp.remakeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.bottom.equalTo(segmentedControl.snp.top).offset(-5)
            make.left.equalTo(segmentedControl)
        }
        segmentedControl.snp.remakeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-5)
            make.height.equalTo(40).priority(900)
        }
    }
    
}
