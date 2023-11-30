// Copyright © 2023 TDS. All rights reserved. 2023-11-16 목 오전 11:23 꿀꿀🐷

import SwiftUI
import Combine

/// MainDetailViewModel의 비즈니스로직 관리
final class MainDetailUseCase {
    private let repository: SubwayRepositoryFetch
    
    init(repo: SubwayRepositoryFetch) {
        self.repository = repo
    }
    
    /// MyStation 에 값 넣어서 반환.  선택된 역정보.
    func getStationData(subwayID: Int,
                        totalStatInfos: [StationInfo],
                        selectStationName value: String) -> MyStation {
        
        guard !totalStatInfos.isEmpty else { return .emptyData }
        
        // 역명이 같고 호선이 클릭한 호선의 데이터를 찾아온다. -> 1개만 나와야 정상.
        let newDatas = totalStatInfos.filter { st in
            st.statnNm == value && st.subwayId == subwayID
        }.first
        
        if let newDatas {
            // 상행일때 -1
            var upSt = newDatas.statnId - 1
            var downSt = newDatas.statnId + 1
            
            let upStNm = totalStatInfos.filter { $0.statnId == upSt }.first?.statnNm ?? "종착"
            let downStNm = totalStatInfos.filter { $0.statnId == downSt }.first?.statnNm ?? "종착"
            
            if upStNm == "종착" { upSt = -1 }
            if downStNm == "종착" { downSt = -1 }
            
            return .init(nowSt: Int(newDatas.statnId),
                         nowStNm: value,
                         upSt: Int(upSt),
                         upStNm: upStNm,
                         downSt: Int(downSt),
                         downStNm: downStNm)
        }
        
        return .emptyData
    }
    
    func getNearStationLineInfos(totalStation: [StationInfo], statName: String) -> [StationInfo] {
        return totalStation.filter { $0.statnNm == statName }
    }
    
    // Never타입은 못씀. 에러를 발생시키지 않기 때문...!! -> api통신중의 발생한 Error를 생성해주어야함.
    func recievePublisher(subwayLine: String, stationInfo: MyStation) -> AnyPublisher<[RealTimeSubway], Error> {
        let nowStation = stationInfo.nowStNm
        let upLineEnd = stationInfo.upSt // 0 일경우 종착지 -> realTime을 받아오지 않는다.
        let downLineEnd = stationInfo.downSt // 0 일경우 종착지 -> realTime을 받아오지 않는다.
        
//        print("👊 upLine \(upLineEnd) downLine \(downLineEnd)")
        
        return repository.receivePublisher(type: Arrived.self, urlType: .subwayArrive, whereData: nowStation)
            .flatMap { rdata -> AnyPublisher<[RealTimeSubway], Error> in
                var realDatas = rdata.realtimeArrivalList
                
                // 해당 호선에 맞는 데이터로 필터
                realDatas = realDatas.filter { $0.subwayID == subwayLine }
//                print("🐹필터된 RealDatas \(realDatas)")
                var stations: [RealTimeSubway] = []
                
                for data in realDatas {
                    let firstSort: Int = self.trainFirstSortKey(ordkey: data.ordkey)
                    let secondSort: Int = self.trainSecondSortKey(ordkey: data.ordkey)
                    
                    let message: String = self.trainMessage(barvlDt: data.barvlDt,
                                                            arvlMsg2: data.arvlMsg2,
                                                            arvlMsg3: data.arvlMsg3,
                                                            arvlCd: data.arvlCD,
                                                            nowStationName: nowStation)
                    
                    let trainLocation: CGFloat = self.trainLocation(arvlCd: data.arvlCD)
                    if (data.updnLine == "상행" && upLineEnd == -1) || (data.updnLine == "하행" && downLineEnd == -1) {
                    } else {
                        stations.append(.init(updnLine: data.updnLine,
                                              trainNo: data.btrainNo,
                                              trainType: data.btrainSttus,
                                              stCnt: firstSort,
                                              sortOrder: secondSort,
                                              message: message,
                                              trainDestiStation: "\(data.bstatnNm)행",
                                              trainLocation: trainLocation))
                    }
                }
                
                if !stations.isEmpty {
                    return Just(stations).setFailureType(to: Error.self).eraseToAnyPublisher()
                } else {
                    return Fail(error: StatusError.ERR100).eraseToAnyPublisher()
                }

            }
            .eraseToAnyPublisher()
    }
    
}

extension MainDetailUseCase {
    private func calculateLocation() {
        
    }
    
    // TODO: 추후 변경 해야함. 23.11.27
    private func trainMessage(barvlDt: String,
                              arvlMsg2: String,
                              arvlMsg3: String,
                              arvlCd: String,
                              nowStationName: String) -> String {
        if barvlDt != "0" {
            return "\(barvlDt)초전"
        }
        
        if !arvlMsg2.isEmpty || !arvlMsg3.isEmpty {
            return nowStationName == arvlMsg3 ? "당역 도착" : arvlMsg2
        }
        
        if !arvlCd.isEmpty {
            return ArvlCD(rawValue: arvlCd)?.name ?? ""
        }
        
        return ""
    }
   
    private func trainLocation(arvlCd: String) -> CGFloat {
        if !arvlCd.isEmpty {
            return ArvlCD(rawValue: arvlCd)?.subwayShowing ?? -3.0
        }
        
        return -3.0
    }
    
    private func trainTimer(arvlCd: String, recptnDt: String) -> String {
        if ArvlCD(rawValue: arvlCd)?.name == "전역 도착" {
            return recptnDt
        }
        return ""
    }
    /// 현재역 도착까지 몇정거장 남았는지를 반환.
    private func trainFirstSortKey(ordkey: String) -> Int {
        let startIndex = ordkey.index(ordkey.startIndex, offsetBy: 2)
        let endIndex = ordkey.index(startIndex, offsetBy: 3)
        let slicedString = String(ordkey[startIndex..<endIndex])
        
        return Int(slicedString) ?? 0
    }
    
    /// 첫번재 도착인지 두번째 도착인지 반환
    private func trainSecondSortKey(ordkey: String) -> Int {
        let startIndex = ordkey.index(ordkey.startIndex, offsetBy: 1)
        let endIndex = ordkey.index(startIndex, offsetBy: 1)
        let slicedString = String(ordkey[startIndex..<endIndex])
        
        return Int(slicedString) ?? 0
    }
    
    private enum ArvlCD: String {
        case zero = "0"
        case one = "1"
        case two = "2"
        case three = "3"
        case four = "4"
        case five = "5"
        case ninetynine = "99"
        
        var name: String {
            switch self {
            case .zero:
                return "당역 진입"
            case .one:
                return "당역 도착"
            case .two:
                return "출발"
            case .three:
                return "전역 출발"
            case .four:
                return "전역 진입"
            case .five:
                return "전역 도착"
            case .ninetynine:
                return "운행중"
            }
        }
        
        var subwayShowing: CGFloat {
            switch self {
            case .zero:
                return 0.35
            case .one:
                return 0.45
            case .two:
                return 0.55
            case .three:
                return 0.1
            case .four:
                return -0.1
            case .five:
                return -0.05
            case .ninetynine:
                return -3.0
            }
        }
    }
    
}
