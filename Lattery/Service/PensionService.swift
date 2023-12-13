//
//  PensionService.swift
//  Lattery
//
//  Created by dodor on 12/9/23.
//

import Foundation
import CoreData

protocol PensionServiceProtocol {
    // 연금복권 번호추첨
    func drawLot(contain fixedNumbers: [Int?]) -> PensionNumbers
    
    // 추첨번호 조회/추가/삭제
    func getPensionDrawingLotResults() -> [PensionDrawingLotResult]
    func add(drawingLotNumbers: [[Int?]]) throws -> String
    func delete(drawingLotNumbersById id: String) throws
    
    // Core Data에서 지난 연금복권 정보 조회
    func getPensionEntity(round: Int) -> PensionEntity?
    func getPensionEntities(ascending: Bool) -> [PensionEntity]
    func addPensionEntity(by result: PensionResult) throws
    func addPensionEntities(by results: [PensionResult]) throws
    
    // 동행복권에서 지난 연금복권 결과 가져오기 -> CoreData에 저장
    func getPensionObject(round: Int) async throws -> PensionResult
}

class PensionService: PensionServiceProtocol {
    
    let container: NSPersistentContainer
    let apiClient = APIClient<LotteryEndpoint>()
    
    init() {
        container = NSPersistentContainer(name: "PensionModel")
        container.loadPersistentStores { description, error in
            if let error {
                print("ERROR LOADING CORE DATA")
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: - 연금복권 번호추첨
    func drawLot(contain fixedNumbers: [Int?]) -> PensionNumbers {
        var numbers: [Int] = []
        for i in 0..<7 {
            if fixedNumbers.count > i {
                if fixedNumbers[i] == nil { numbers.append(Int.random(in: i == 0 ? 1...5 : 0...9)) }
                else { numbers.append(fixedNumbers[i]!) }
            } else {
                numbers.append(Int.random(in: 0...9))
            }
        }
        
        return PensionNumbers(numbers: numbers,
                              fixedNumbers: fixedNumbers)
    }
    
    // MARK: - 추첨번호 조회/추가/삭제
    func getPensionDrawingLotResults() -> [PensionDrawingLotResult] {
        var result: [PensionDrawingLotResult] = []
        let request = NSFetchRequest<PensionDrawingLotResultEntity>(entityName: "PensionDrawingLotResultEntity")
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        do {
            let fetched = try container.viewContext.fetch(request)
            result = fetched.map {
                PensionDrawingLotResult(id: $0.id,
                                        date: $0.date,
                                        numbers: $0.data.map { PensionNumbers(numbers: $0.toPensionNumbers) })
            }
        } catch {
            print(error.localizedDescription)
        }
        
        return result
    }
    
    func add(drawingLotNumbers: [[Int?]]) throws -> String {
        let drawingLotResult = PensionDrawingLotResultEntity(context: container.viewContext)
        drawingLotResult.id = UUID().uuidString
        drawingLotResult.date = Date()
        drawingLotResult.data = drawingLotNumbers.map { $0.toPensionNumberString }
        try saveCoreData()
        return drawingLotResult.id
    }
    
    func delete(drawingLotNumbersById id: String) throws {
        let request = NSFetchRequest<PensionDrawingLotResultEntity>(entityName: "PensionDrawingLotResultEntity")
        request.predicate = NSPredicate(format: "id = %@", id)
        let temp = try container.viewContext.fetch(request)
        let objectToDelete = temp[0] as NSManagedObject
        container.viewContext.delete(objectToDelete)
        try saveCoreData()
    }
    
    // MARK: - Core Data에서 지난 연금복권 정보 조회
    func getPensionEntity(round: Int) -> PensionEntity? {
        let request = NSFetchRequest<PensionEntity>(entityName: "PensionEntity")
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
    
    func getPensionEntities(ascending: Bool) -> [PensionEntity] {
        var result: [PensionEntity] = []
        let request = NSFetchRequest<PensionEntity>(entityName: "PensionEntity")
        request.sortDescriptors = [NSSortDescriptor(key: "round", ascending: ascending)]
        do {
            result = try container.viewContext.fetch(request)
        } catch {
            print(error.localizedDescription)
        }
        return result
    }
    
    func addPensionEntity(by result: PensionResult) throws {
        let entity = PensionEntity(context: container.viewContext)
        entity.round = Int16(result.round)
        entity.date = result.date
        entity.numbers = result.numbers.numbers.toPensionNumberString
        entity.bonus = result.bonus.numbers.toPensionNumberString
        
        try saveCoreData()
    }
    
    func addPensionEntities(by results: [PensionResult]) throws {
        for result in results {
            let entity = PensionEntity(context: container.viewContext)
            entity.round = Int16(result.round)
            entity.date = result.date
            entity.numbers = result.numbers.numbers.toPensionNumberString
            entity.bonus = result.bonus.numbers.toPensionNumberString
        }
        
        try saveCoreData()
    }
    
    // MARK: - 동행복권에서 지난 연금복권 결과 가져오기 -> CoreData에 저장
    func getPensionObject(round: Int) async throws -> PensionResult {
        let pensionObject: PensionObject = try await apiClient.request(.getPension(round))
        guard let pension = pensionObject.toModel()
        else { throw ServiceError.error(APIError.invalidData) }
        return pension
    }
    
    private func saveCoreData() throws {
        try container.viewContext.save()
    }
}

class StubPensionService: PensionServiceProtocol {
    func drawLot(contain fixedNumbers: [Int?]) -> PensionNumbers {
        var numbers: [Int] = []
        for i in 0..<7 {
            if fixedNumbers.count > i {
                if fixedNumbers[i] == nil {
                    numbers.append(Int.random(in: 0...9))
                } else {
                    numbers.append(fixedNumbers[i]!)
                }
            } else {
                numbers.append(Int.random(in: 0...9))
            }
        }
        
        return PensionNumbers(numbers: numbers,
                              fixedNumbers: fixedNumbers)
    }
    
    // MARK: - 추첨번호 조회/추가/삭제
    func getPensionDrawingLotResults() -> [PensionDrawingLotResult] { [] }
    func add(drawingLotNumbers: [[Int?]]) throws -> String { "" }
    func delete(drawingLotNumbersById id: String) throws { }
    
    // MARK: - Core Data에서 지난 연금복권 정보 조회
    func getPensionEntity(round: Int) -> PensionEntity? { nil }
    func getPensionEntities(ascending: Bool) -> [PensionEntity] { [] }
    func addPensionEntity(by result: PensionResult) throws { }
    func addPensionEntities(by results: [PensionResult]) throws { }
    
    // MARK: - 동행복권에서 지난 연금복권 결과 가져오기 -> CoreData에 저장
    func getPensionObject(round: Int) async throws -> PensionResult { PensionResult.stub1 }
}
