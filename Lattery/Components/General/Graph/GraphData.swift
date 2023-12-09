//
//  GraphData.swift
//  Lattery
//
//  Created by dodor on 12/7/23.
//

import SwiftUI

struct GraphData: Identifiable {
    let id = UUID()
    var name: String
    var value: Double
    var color: Color = .customPink
    var order: Int = 0
}

var barSample: [GraphData] {
    var tempData = [GraphData]()
    
    for i in 1...45 {
        let rand = Double.random(in: 20..<300)
        let data = GraphData(name: "\(i)",
                             value: rand)
        tempData.append(data)
    }
    
    return tempData
}

var ratioSample: [GraphData] {
    var tempData = [GraphData]()
    let colors: [Color] = [.customYellow, .customBlue, .customRed, .customDarkGray, .customGreen]
    
    for (i, color) in colors.enumerated() {
        let rand = Double.random(in: 20..<300)
        let data = GraphData(name: "\(i)",
                             value: rand,
                             color: color,
                             order: i)
        tempData.append(data)
    }
    
    return tempData
}

var pieSample: [GraphData] {
    var tempData = [GraphData]()
    let colors = [Color.customRed, Color.customOrange, Color.customYellow,
                  Color.customGreen, Color.customBlue, Color.customPurple]
    
    for (i, color) in colors.enumerated() {
        let rand = Double.random(in: 1...10)
        let data = GraphData(name: "\(i)",
                             value: rand,
                             color: color)
        tempData.append(data)
    }
    
    return tempData
}
