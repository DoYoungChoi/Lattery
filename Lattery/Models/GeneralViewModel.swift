//
//  GeneralViewModel.swift
//  Lattery
//
//  Created by dodor on 2023/08/11.
//

import Foundation

class GeneralViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var loadingText: String = "최신 복권 정보를\n가져오는 중입니다"
    
    @Published var errorTitle: String = "에러 발생"
    @Published var errorMessage: String? = nil
    @Published var errorAlertPresented: Bool = false
}
