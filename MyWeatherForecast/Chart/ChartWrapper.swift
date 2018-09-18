//
//  ChartWrapper.swift
//  MyWeatherForecast
//
//  Created by vasadulin on 17.09.2018.
//  Copyright © 2018 Asadulinz Software. All rights reserved.
//

import Foundation
import SwiftChart

protocol ChartWrapperDataSource {
    
    func getPointsArray() -> [Double]
}
protocol ChartWrapperDelegate {
    
    func chartTapAction(_ chart: ChartWrapper, indexOfPoint: Int)
}


class ChartWrapper {
    
    var dataSource: ChartWrapperDataSource? = nil
    var delegate: ChartWrapperDelegate? = nil
    
    var chart: Chart
    
    fileprivate var lastActiveIndex: Int? = nil
    
    init(chart: Chart,
         dataSource: ChartWrapperDataSource? = nil,
         delegate: ChartWrapperDelegate? = nil) {
        
        self.chart = chart
        self.dataSource = dataSource
        self.delegate = delegate
        
        self.chart.delegate = self
    }
    
    func reloadData() {
        chart.removeAllSeries()
        
        guard let data: [Double] = dataSource?.getPointsArray() else { return }
        
        let series = ChartSeries(data)
        series.area = true
        
        chart.add(series)
        
        // Set minimum and maximum values for y-axis
        chart.minY = 0
        //chart.maxY = 18
        
        // Format y-axis, e.g. with units
        chart.yLabelsFormatter = { String(Int($1)) +  "ºC" }
    }
 }

// MARK: - ChartDelegate
extension ChartWrapper: ChartDelegate {
    func didTouchChart(_ chart: Chart, indexes: Array<Int?>, x: Double, left: CGFloat) {
        
        if let index = indexes.first ?? nil {
            lastActiveIndex = index
        }
        else {
            lastActiveIndex = nil
        }
    }
    
    func didFinishTouchingChart(_ chart: Chart) {
    
    }
    
    func didEndTouchingChart(_ chart: Chart) {
        
        if let index = lastActiveIndex {
            delegate?.chartTapAction(self, indexOfPoint: index)
        }
    }
}

