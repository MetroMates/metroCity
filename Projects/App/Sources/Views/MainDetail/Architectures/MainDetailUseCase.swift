// Copyright © 2023 TDS. All rights reserved. 2023-11-16 목 오전 11:23 꿀꿀🐷

import SwiftUI
import Combine

/// MainDetailViewModel의 비즈니스로직 관리
final class MainDetailUseCase {
    private let repository: SubwayRepositoryFetch
    
    init(repo: SubwayRepositoryFetch) {
        self.repository = repo
    }
    
    /// 이전 Fetch 역명.
    private var beforeStatnNm: String = ""
    private var beforeArvlCase: ArvlCase = .none
    
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
            
            if upStNm == "종착" {
                upSt = -1
                // 종착일경우 value를 SubStationInfo 객체에서 찾는다.
                
                /*
                    RelateStationInfo
                    statnId: Int
                    statnNm: String
                    relateIds: [Int]
                    relateNms: [String]
                 */
            }
            if downStNm == "종착" { downSt = -1 }
            
            var upStNms: [String] = [upStNm]
            
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
        let upLineEnd = stationInfo.upSt // -1 일경우 종착지 -> realTime을 받아오지 않는다.
        let downLineEnd = stationInfo.downSt // -1 일경우 종착지 -> realTime을 받아오지 않는다.
        
        return repository.receivePublisher(type: Arrived.self, urlType: .subwayArrive, whereData: nowStation)
            .flatMap { rdata -> AnyPublisher<[RealTimeSubway], Error> in
                var realDatas = rdata.realtimeArrivalList
                
                // 해당 호선에 맞는 데이터로 필터
                realDatas = realDatas.filter { $0.subwayID == subwayLine }
                var stations: [RealTimeSubway] = []
                
                for data in realDatas {
                    let firstSort: Int = self.trainFirstSortKey(ordkey: data.ordkey)
//                    let secondSort: Int = self.trainSecondSortKey(ordkey: data.ordkey)
                    
                    let message: String = self.trainMessage(barvlDt: data.barvlDt,
                                                            arvlMsg2: data.arvlMsg2,
                                                            arvlMsg3: data.arvlMsg3,
                                                            arvlCd: data.arvlCD,
                                                            nowStationName: nowStation)
                    
                    let (trainLocation, isChange) = self.trainLocation(statnNm: nowStation,
                                                                       destination: data.bstatnNm,
                                                                       trainNo: data.btrainNo,
                                                                       arvlCd: data.arvlCD)
                    
                    if (data.updnLine == "상행" && upLineEnd == -1) || (data.updnLine == "하행" && downLineEnd == -1) {
                    } else {
                        stations.append(.init(updnLine: data.updnLine,
                                              trainNo: data.btrainNo,
                                              trainType: data.btrainSttus,
                                              stCnt: firstSort,
                                              message: message,
                                              trainDestiStation: "\(data.bstatnNm)행",
                                              trainLocation: trainLocation,
                                              arvlCode: data.arvlCD,
                                              isChange: isChange))
                    }
                }
                
                self.beforeStatnNm = nowStation // Fetch 역명을 가지고 있는다. -> 추후 첫 Fetch인지 n번째 Fetch인지의 여부를 따지기 위함.
                
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
    private func convertSecondsToMinutesAndSeconds(seconds: Int) -> (minutes: Int, remainingSeconds: Int) {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return (minutes, remainingSeconds)
    }
    
    // TODO: 추후 변경 해야함. 23.11.27 -> 12.01 변경중.
    private func trainMessage(barvlDt: String,
                              arvlMsg2: String,
                              arvlMsg3: String,
                              arvlCd: String,
                              nowStationName: String) -> String {
        
        /*
            당역 도착인데 ex: 당역이 수원이면 5초(수원) 이렇게 뜨는 정보도 있음. -> 수정해야함. 23.12.10
         
         */
        
        var times: String = ""
        if barvlDt != "0" {
            let (min, sec) = convertSecondsToMinutesAndSeconds(seconds: Int(barvlDt) ?? 0)
          
            if sec == 0 {
                times = "\(min)분"
            } else {
                if min == 0 {
                    times = "\(sec)초"
                } else {
                    times = "\(min)분 \(sec)초"
                }
            }
        }
        
        var arvlMsg: String = ""
        // ↓ 99가 아닐경우에는 얘를 띄워주기.
        if arvlCd != "99" {
            arvlMsg = ArvlCD(rawValue: arvlCd)?.name ?? ""
        } else {
            // 99: 운행중 일경우에는 메세지 분석해서 띄우기.
            if !arvlMsg2.isEmpty || !arvlMsg3.isEmpty {
                if nowStationName == arvlMsg3 {
                    arvlMsg =  arvlMsg2.replacingOccurrences(of: nowStationName, with: "당역")
                }
                arvlMsg = arvlMsg2
            }
        }
        
        var rtnMsg: String = ""
        if !times.isEmpty {
            rtnMsg = "\(times) (\(arvlMsg3))"
        } else {
            rtnMsg = arvlMsg
        }
        
        return rtnMsg
    }
   
    /// 열차 위치.
    private func trainLocation(statnNm: String, 
                               destination: String,
                               trainNo: String,
                               arvlCd: String) -> (CGFloat, Bool) {
        
        let arvlCode = ArvlCD(rawValue: arvlCd) ?? .ninetynine
        let newarvlCase = ArvlCase.arvlCDConvert(arvlCode)
        
        /*------------------------------------------------
                 전역도착, 당역진입, 당역도착 으로만 판단.
         ------------------------------------------------*/
        
        var distanceRate: CGFloat = 0.00
        var isChange: Bool = false
        
        // 해당 역명으로 fetch한게 첫번째임.
        if statnNm != beforeStatnNm {
            distanceRate = newarvlCase.subwayDistanceRate
            isChange = true
        }
        // 새로고침일때 진입.
        else {
            // 받아온 현재 열차 상태가 이전과 다른경우에만 진입.
            if self.beforeArvlCase != newarvlCase {
                distanceRate = newarvlCase.subwayDistanceRate
                isChange = true
            }
        }
        
        // 추후 재비교를 위해 값을 할당시켜놓는다.
        self.beforeArvlCase = newarvlCase
        
        return (distanceRate, isChange)
    }

    /// 현재역 도착까지 몇정거장 남았는지를 반환.
    private func trainFirstSortKey(ordkey: String) -> Int {
        let startIndex = ordkey.index(ordkey.startIndex, offsetBy: 2)
        let endIndex = ordkey.index(startIndex, offsetBy: 3)
        let slicedString = String(ordkey[startIndex..<endIndex])
        
        return Int(slicedString) ?? 0
    }
    
    /// 첫번재 도착인지 두번째 도착인지 반환 -> 추후 삭제할듯 23.12.01
//    private func trainSecondSortKey(ordkey: String) -> Int {
//        let startIndex = ordkey.index(ordkey.startIndex, offsetBy: 1)
//        let endIndex = ordkey.index(startIndex, offsetBy: 1)
//        let slicedString = String(ordkey[startIndex..<endIndex])
//        
//        return Int(slicedString) ?? 0
//    }
    
    private enum ArvlCase {
        case start
        case middle
        case end
        case none
        
        var subwayDistanceRate: CGFloat {
            switch self {
            case .start:
                return 0.95
            case .middle:
                return 0.75
            case .end:
                return 0.5
            case .none:
                return 0
            }
        }
        
        static func arvlCDConvert(_ code: ArvlCD) -> Self {
            switch code {
            case .five, .three:
                return .start
            case .zero:
                return .middle
            case .one, .two:
                return .end
            default:
                return .none
            }
        }
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
        
//        var subwayShowing: CGFloat {
//            switch self {
//            case .zero:
//                return 0.55
//            case .one:
//                return 0.5
//            case .two:
//                return 0.45
//            case .three:
//                return 0.85
//            case .four:
//                return 0.9
//            case .five:
//                return 0.95
//            case .ninetynine:
//                // 화면에서 안보이게 조정.
//                return -3.0
//            }
//        }
    }
    
}
