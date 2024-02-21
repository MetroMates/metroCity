// Copyright © 2024 TDS. All rights reserved. 2024-02-13 화 오후 02:46 꿀꿀🐷

import SwiftUI
import Gzip
import Combine

final class StationTableListVM: ObservableObject {
    @Published var selection: String = ""
    @Published var upStationInfo: StationTable = []
    @Published var downStationInfo: StationTable = []
    @Published var hourTime: String = ""
    @Published var currentTime: String = ""
    
    private var upBaseInfo: StationTable = []
    private var downBaseInfo: StationTable = []
    private var anyCancellable: Set<AnyCancellable> = []
    let timeFormatter = DateFormatter()
    let currentFormatter = DateFormatter()
    
    func selectionSubscribe() {
       $selection.sink { newData in
            self.upStationInfo = self.upBaseInfo.filter({
                $0.weekAt == newData
            })
           self.downStationInfo = self.downBaseInfo.filter({
               $0.weekAt == newData
           })
        }.store(in: &anyCancellable)
        
    }
    
    init() {
        self.selectionSubscribe()
        timeFormatter.dateFormat = "HH"
        self.hourTime = timeFormatter.string(from: Date())
        
        currentFormatter.dateFormat = "HH:mm"
        self.currentTime = currentFormatter.string(from: Date())
    }
    
    deinit {
        anyCancellable.removeAll()
    }
    
    /*
         hosun = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '경강선', '경의선', '경춘선', '공항철도', '김포도시철도', '서해선',
        '수인분당선', '신분당선', '용인경전철', '우이신설선', '의정부경전철', '인천1', '인천2']
     */
    
    public func fetchStationTableInfo(hosun: String, statName: String) {
        guard let jsonData = jsonLoad(fileName: hosun) else { return }
        
        Log.trace("😇 jsonData = \(jsonData)")
        
        DispatchQueue.global().async {
            do {
                // 이 부분이 시간이 오래 걸림.
                // JSON 디코딩
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    if let jsonData = jsonString.data(using: .utf8) {
                        
                        let userList = try JSONDecoder().decode(StationTable.self, from: jsonData)
//                        Log.trace("😇 userList = \(userList)")
                        
                        let upTable = userList.filter { data in
                           data.direction == "up" && data.statNm == statName
                        }.sorted { $0.arriveTime < $1.arriveTime }
                        
                        let downTable = userList.filter { data in
                            data.direction == "down" && data.statNm == statName
                        }.sorted { $0.arriveTime < $1.arriveTime }
                        

                        self.upBaseInfo = upTable
                        self.downBaseInfo = downTable

                    }
                }
            } catch {
                Log.error("😇 \(error.localizedDescription)")
            }
        }
    }
    
    private func jsonLoad(fileName: String) -> Data? {
        // 압축된 json 파일 경로
        let filePath = Bundle.main.path(forResource: fileName, ofType: "json.gz") ?? ""
        
        // 압축된 파일 읽어오기
        if let compressedData = FileManager.default.contents(atPath: filePath) {
            do {
                // 압축 해제
                let uncompressedData = try compressedData.gunzipped()
                
                return uncompressedData
            } catch {
                print("😇Error: \(error)")
            }
        } else {
            print("😇Failed to read compressed file.")
        }
        return nil
    }
    
}
