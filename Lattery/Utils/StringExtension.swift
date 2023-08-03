//
//  StringExtension.swift
//  Lattery
//
//  Created by dodor on 2023/08/03.
//

import Foundation

extension String {
    func at(_ offset: Int) -> String {
        let index = self.index(self.startIndex, offsetBy: offset)
        return String(self[index])
    }
}
