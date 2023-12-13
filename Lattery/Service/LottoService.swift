//
//  LottoService.swift
//  Lattery
//
//  Created by dodor on 12/8/23.
//

import Foundation
import CoreData

protocol LottoServiceProtocol {
    // 로또 번호추첨
    func drawLot(contain fixedNumbers: [Int]) -> LottoNumbers
    
    // 추첨번호 조회/추가/삭제
    func getLottoDrawingLotResults() -> [LottoDrawingLotResult]
    func add(drawingLotNumbers: [[Int]]) throws -> String
    func delete(drawingLotNumbersById id: String) throws
    
    // 즐겨찾기 번호 조회/추가/삭제
    func getFavoriteNumbers() -> [LottoFavorite]
    func add(favoriteNumbers: [Int]) throws
    func delete(favoriteNumbers: [Int]) throws
    
    // Core Data에서 지난 로또 정보 조회
    func getLottoEntity(round: Int) -> LottoEntity?
    func getLottoEntities(ascending: Bool) -> [LottoEntity]
    func addLottoEntity(by result: LottoResult) throws
    func addLottoEntities(by result: [LottoResult]) throws
    
    // 동행복권에서 지난 로또 결과 가져오기 -> CoreData에 저장
    func getLottoObject(round: Int) async throws -> LottoResult
}

class LottoService: LottoServiceProtocol {

    let container: NSPersistentContainer
    let apiClient = APIClient<LotteryEndpoint>()
    
    init() {
        container = NSPersistentContainer(name: "LottoModel")
        container.loadPersistentStores { description, error in
            if let error {
                print("ERROR LOADING CORE DATA")
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: - 로또 번호추첨
    func drawLot(contain fixedNumbers: [Int] = []) -> LottoNumbers {
        var numbers: [Int] = fixedNumbers
        while numbers.count < 6 {
            let number = Int.random(in: 1...45)
            if !numbers.contains(number) {
                numbers.append(number)
            }
        }
        
        return LottoNumbers(numbers: numbers,
                            fixedNumbers: fixedNumbers)
    }
    
    // MARK: - 추첨번호 조회/저장/삭제
    func getLottoDrawingLotResults() -> [LottoDrawingLotResult] {
        var result: [LottoDrawingLotResult] = []
        let request = NSFetchRequest<LottoDrawingLotResultEntity>(entityName: "LottoDrawingLotResultEntity")
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        do {
            let fetched = try container.viewContext.fetch(request)
            result = fetched.map {
                LottoDrawingLotResult(id: $0.id,
                                      date: $0.date,
                                      numbers: $0.data.map { LottoNumbers(numbers: $0.toLottoNumbers) })
            }
        } catch {
            print(error.localizedDescription)
        }
        
        return result
    }
    
    func add(drawingLotNumbers: [[Int]]) throws -> String {
        let drawingLotResult = LottoDrawingLotResultEntity(context: container.viewContext)
        drawingLotResult.id = UUID().uuidString
        drawingLotResult.date = Date()
        drawingLotResult.data = drawingLotNumbers.map { $0.toLottoNumberString }
        try saveCoreData()
        return drawingLotResult.id
    }
    
    func delete(drawingLotNumbersById id: String) throws {
        let request = NSFetchRequest<LottoDrawingLotResultEntity>(entityName: "LottoDrawingLotResultEntity")
        request.predicate = NSPredicate(format: "id = %@", id)
        let temp = try container.viewContext.fetch(request)
        let objectToDelete = temp[0] as NSManagedObject
        container.viewContext.delete(objectToDelete)
        try saveCoreData()
    }
    
    // MARK: - 즐겨찾기 번호 조회/추가/삭제
    func getFavoriteNumbers() -> [LottoFavorite] {
        var result: [LottoFavorite] = []
        let request = NSFetchRequest<LottoFavorite>(entityName: "LottoFavorite")
        do {
            result = try container.viewContext.fetch(request)
        } catch {
            print(error.localizedDescription)
        }
        
        return result
    }
    
    func add(favoriteNumbers: [Int]) throws {
        let favorite = LottoFavorite(context: container.viewContext)
        favorite.numbers = favoriteNumbers.toLottoNumberString
        try saveCoreData()
    }
    
    func delete(favoriteNumbers: [Int]) throws {
        let joined = favoriteNumbers.toLottoNumberString
        let request = NSFetchRequest<LottoFavorite>(entityName: "LottoFavorite")
        request.predicate = NSPredicate(format: "numbers = %@", joined)
        let temp = try container.viewContext.fetch(request)
        let objectToDelete = temp[0] as NSManagedObject
        container.viewContext.delete(objectToDelete)
        try saveCoreData()
    }
    
    // MARK: - Core Data에서 지난 로또 정보 조회/추가
    func getLottoEntity(round: Int) -> LottoEntity? {
        let request = NSFetchRequest<LottoEntity>(entityName: "LottoEntity")
        request.predicate = NSPredicate(format: "round = %@", String(round))
        do {
            let entities = try container.viewContext.fetch(request)
            if entities.isEmpty {
                return nil
            } else {
                return entities[0]
            }
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func getLottoEntities(ascending: Bool = false) -> [LottoEntity] {
        var result: [LottoEntity] = []
        let request = NSFetchRequest<LottoEntity>(entityName: "LottoEntity")
        request.sortDescriptors = [NSSortDescriptor(key: "round", ascending: ascending)]
        do {
            result = try container.viewContext.fetch(request)
        } catch {
            print(error.localizedDescription)
        }
        return result
    }
    
    func addLottoEntity(by result: LottoResult) throws {
        let entity = LottoEntity(context: container.viewContext)
        entity.round = Int16(result.round)
        entity.date = result.date
        entity.numbers = result.numbers.numbers
        entity.bonus = Int16(result.numbers.bonus ?? 0)
        entity.winnings = result.winnings
        entity.winnerCount = Int16(result.winnerCount)
        entity.totalSalePrice = Int64(result.totalSalePrice ?? 0)
        
        try saveCoreData()
    }
    
    func addLottoEntities(by results: [LottoResult]) throws {
        for result in results {
            let entity = LottoEntity(context: container.viewContext)
            entity.round = Int16(result.round)
            entity.date = result.date
            entity.numbers = result.numbers.numbers
            entity.bonus = Int16(result.numbers.bonus ?? 0)
            entity.winnings = result.winnings
            entity.winnerCount = Int16(result.winnerCount)
            entity.totalSalePrice = Int64(result.totalSalePrice ?? 0)
        }
        
        try saveCoreData()
    }
    
    
    // MARK: - 동행복권에서 지난 로또 결과 가져오기
    func getLottoObject(round: Int) async throws -> LottoResult {
        let lottoObject: LottoObject = try await apiClient.request(.getLotto(round))
        guard lottoObject.returnValue == "success"
        else { throw ServiceError.error(APIError.invalidData) }
        guard let lotto = lottoObject.toModel()
        else { throw ServiceError.error(APIError.invalidData) }
        return lotto
    }
    
    private func saveCoreData() throws {
        try container.viewContext.save()
    }
}

class StubLottoService: LottoServiceProtocol {
    
    // MARK: - 로또 번호추첨
    func drawLot(contain fixedNumbers: [Int]) -> LottoNumbers {
        var numbers: [Int] = fixedNumbers
        while numbers.count < 6 {
            let number = Int.random(in: 1...45)
            if !numbers.contains(number) {
                numbers.append(number)
            }
        }
        
        return LottoNumbers(numbers: numbers,
                            fixedNumbers: fixedNumbers)
    }
    
    // MARK: - 추첨번호 조회/추가/삭제
    func getLottoDrawingLotResults() -> [LottoDrawingLotResult] { [] }
    func add(drawingLotNumbers: [[Int]]) -> String { UUID().uuidString }
    func delete(drawingLotNumbersById id: String) { }
    
    // MARK: - 즐겨찾기 번호 조회/추가/삭제
    func getFavoriteNumbers() -> [LottoFavorite] { [] }
    func add(favoriteNumbers: [Int]) { }
    func delete(favoriteNumbers: [Int]) { }
    
    // MARK: - Core Data에서 지난 로또 정보 조회/추가
    func getLottoEntity(round: Int) -> LottoEntity? { nil }
    func getLottoEntities(ascending: Bool) -> [LottoEntity] { [] }
    func addLottoEntity(by result: LottoResult) throws { }
    func addLottoEntities(by results: [LottoResult]) throws { }
    
    // MARK: - 동행복권에서 지난 로또 결과 가져오기
    func getLottoObject(round: Int) async throws -> LottoResult { LottoResult.stub1 }
}
