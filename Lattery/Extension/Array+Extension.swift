//
//  Array+Extension.swift
//  Lattery
//
//  Created by dodor on 12/10/23.
//

import Foundation

extension Array<Int> {
    var toLottoNumberString: String {
        self.sorted().map { String($0) }.joined(separator: ",")
    }
}
