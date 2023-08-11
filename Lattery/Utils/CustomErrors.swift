//
//  CustomErrors.swift
//  Lattery
//
//  Created by dodor on 2023/08/02.
//

import Foundation

enum FetchError: Error {
    case badURL
    case badRequest
    case badResponse
    case badJSON
}

enum LastestError: String {
    case userDefaultsError = "최신 정보를 가져오는 중 오류가 발생했습니다. 앱을 재실행 후 설정으로 이동하여 데이터 다운로드를 다시 시도하세요."
    case coreDataError = "데이터 처리 중 오류가 발생했습니다. 설정으로 이동하여 데이터 다운로드를 다시 시도하세요."
    case requestError = "잘못된 요청에 의한 오류입니다. 개발자에게 문의하세요."
    case serverError = "데이터를 가져오는 중 오류가 발생했습니다. 설정으로 이동하여 데이터 다운로드를 다시 시도하세요."
    case responseError = "데이터 응답에 오류가 발생했습니디. 설정으로 이동하여 데이터 다운로드를 다시 시도하세요."
    case unknownError = "알 수 없는 오류가 발생했습니다. 설정으로 이동하여 데이터 다운로드를 다시 시도하세요."
}
