//
//  MainChatTableViewCell.swift
//  ElecCoin
//
//  Created by 张艺哲 on 2020/5/4.
//  Copyright © 2020 Elecoxy. All rights reserved.
//

import UIKit
import SnapKit
import Charts

class MainChatTableViewCell: UITableViewCell, ChartViewDelegate {
    
    // 图标
    let lineChart = LineChartView()
    
    // 副标题
    let subDescLabel = UILabel()
    
    var values = [MainModel.Value]() {
        didSet {
            
            lineChart.highlightValue(nil)
            
            var valueArr = [ChartDataEntry]()
            for value in values {
                valueArr.append(ChartDataEntry(x: value.x, y: value.y))
            }
            
            let set = LineChartDataSet(entries: valueArr, label: "USD")
            
            set.mode = .cubicBezier
            set.setColor(.init(hexString: "0C6CF2"))
            set.drawCirclesEnabled = false
            set.lineWidth = 1.8
            set.circleRadius = 4
            set.fillColor = .clear
            set.drawFilledEnabled = true
            
            // 高亮线
            set.highlightColor = .init(hexString: "0C6CF2")
            set.highlightLineWidth = 1
            set.highlightLineDashLengths = [4, 4]
            set.drawHorizontalHighlightIndicatorEnabled = false
            
            let data = LineChartData(dataSet: set)
            data.setValueFont(UIFont(name: "HelveticaNeue-Light", size: 9)!)
            data.setDrawValues(false)
            
            lineChart.data = data
            
            lineChart.animate(xAxisDuration: 0.5)
        
        }
    }
    
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
        
        subDescLabel.font = .systemFont(ofSize: 12)
        subDescLabel.textColor = UIColor.lightGray
        subDescLabel.text = "You can get detial infomation by tap the chart."
        self.addSubview(subDescLabel)
        
        lineChart.delegate = self
        lineChart.dragEnabled = true
        lineChart.setScaleEnabled(false)
        lineChart.pinchZoomEnabled = false
        
        // y轴
        lineChart.rightAxis.enabled = false
        lineChart.leftAxis.valueFormatter = NumberIAxisValueFormatter()
        lineChart.leftAxis.axisLineColor = .clear
        lineChart.leftAxis.gridColor = .init(hexString: "F1F2F6")
        
        // x轴
        lineChart.xAxis.labelPosition = .bottom
        lineChart.xAxis.valueFormatter = DateIAxisValueFormatter()
        lineChart.xAxis.drawGridLinesEnabled = false
        lineChart.xAxis.axisLineColor = .clear
        
        lineChart.legend.enabled = false
        lineChart.chartDescription?.text = "Market Price"
        
        self.addSubview(lineChart)
        
        initSnap()
    }
    
    private func initSnap()
    {
        lineChart.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.top.equalToSuperview()
            make.height.equalTo(200).priority(900)
        }
        
        subDescLabel.snp.makeConstraints { (make) in
            make.left.equalTo(lineChart)
            make.right.equalTo(lineChart)
            make.top.equalTo(lineChart.snp.bottom).offset(5)
            make.bottom.equalToSuperview().offset(-5)
        }
    }
    
    // MARK: - delegate
    // 折线上的点选中回调
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry,
                            highlight: Highlight) {
        // 显示该点的MarkerView标签
        self.showMarkerView(entry: entry)
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        self.lineChart.marker = nil
    }
     
    // MarkerView标签
    func showMarkerView(entry: ChartDataEntry){
        let marker = MarkerView(frame: .zero)
        marker.chartView = self.lineChart
        let label = UILabel()
        label.numberOfLines = 2
        label.layer.cornerRadius = 4
        label.layer.masksToBounds = true
        label.text = String(format: "%.3fk\n\(entry.x.unixToString())", entry.y / 1000.0)
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 12)
        label.backgroundColor = UIColor.init(hexString: "0C6CF2")
        label.textAlignment = .center
        label.sizeToFit()
        label.frame = CGRect(origin: .zero, size: CGSize(width: label.frame.width + 10, height: label.frame.height + 5))
        marker.offset = CGPoint(x: -label.frame.width / 2, y: -label.frame.height - 5)
        marker.addSubview(label)
        self.lineChart.marker = marker
    }
}
