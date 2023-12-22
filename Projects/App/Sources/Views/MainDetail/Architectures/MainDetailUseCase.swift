// Copyright © 2023 TDS. All rights reserved. 2023-11-16 목 오전 11:23 꿀꿀🐷

import SwiftUI
import Combine

/// MainDetailViewModel의 비즈니스로직 관리
final class MainDetailUseCase {
    private let repository: SubwayRepositoryFetch
    /// 단방향 상행역명 배열
    private let onewayUpStationNames: [String]
    
    init(repo: SubwayRepositoryFetch) {
        self.repository = repo
        self.onewayUpStationNames = ["구산", "연신내", "독바위", "불광", "역촌"]
    }
    
    deinit {
        self.beforeArvlCase.removeAll()
    }
    
    /// 이전 Fetch 역명.
    private var beforeStatnNm: String = ""
    private var beforeSubwayId: String = ""
    private var beforeArvlCase = [String: String]()
    
    /// MyStation 에 값 넣어서 반환.  선택된 역정보.
    func getStationData(subwayID: Int,
                        totalStatInfos: [StationInfo],
                        relateStatInfos: [RelateStationInfo],
                        selectStationName value: String) -> MyStation {
        
        guard !totalStatInfos.isEmpty else { return .emptyData }
        
        // 역명이 같고 호선이 클릭한 호선의 데이터를 찾아온다. -> 1개만 나와야 정상.
        let newDatas = totalStatInfos.filter { st in
            st.statnNm == value && st.subwayId == subwayID
        }.first
        
        if let newDatas {
            var upStCodes: [Int64] = []
            var downStCodes: [Int64] = []
            var upStNms: [String] = []
            var downStNms: [String] = []

            // 상행일때 -1 ==> 2호선만 반대로 적용해준다.
            var upSt = subwayID == 1002 ? newDatas.statnId + 1 : newDatas.statnId - 1
            var downSt = subwayID == 1002 ? newDatas.statnId - 1 : newDatas.statnId + 1
            
            var upStNm = totalStatInfos.filter { $0.statnId == upSt }.first?.statnNm ?? "종착"
            var downStNm = totalStatInfos.filter { $0.statnId == downSt }.first?.statnNm ?? "종착"
            
            // 6호선의 상행역이 단방향일경우 상행역은 종착으로 본다.
            if subwayID == 1006 && onewayUpStationNames.contains(where: { $0 == value }) {
                upStNm = "종착"
            }
            
            let relateInfos = relateStatInfos.filter { $0.statnId == newDatas.statnId }.first ?? .emptyData
            
            // 연관 역명이 존재함. -> ex) 구로: 가산디지털단지, 구일 /  신도림: 도림천, 문래
            if !relateInfos.relateIds.isEmpty {
                // upSt, downSt코드가 relateInfos의 relateStcode랑 같은게 있는지 비교한다.
                // 같은게 있으면 relateInfos에 있는 relateStCode를 같은게 있는 쪽( upSt이거나 downSt )의 배열변수에 전부 다 담는다.
                // 같은게 없다면 그냥 기존코드 그대로 실행.
                if upStNm != "종착" {
                    if relateInfos.relateIds.contains(where: { $0 == upSt }) {
                        upStCodes = relateInfos.relateIds
                        upStNms = relateInfos.relateNms
                    }
                }
                
                if downStNm != "종착" {
                    if relateInfos.relateIds.contains(where: { $0 == downSt }) {
                        downStCodes = relateInfos.relateIds
                        downStNms = relateInfos.relateNms
                    }
                }
            }
            
            // 경춘선 광운대는 하행에 상봉역이 나타나야함으로 추가. 23.12.17
            if upStNm == "종착" && value != "광운대",
               let relateUpSt = relateStatInfos.first(where: { $0.relateIds.contains(newDatas.statnId) }) {
                if !relateUpSt.statnNm.isEmpty {
                    upSt = relateUpSt.statnId
                    upStNm = relateUpSt.statnNm
                } else {
                    upSt = -1
                }
            } else if upStNm == "구산" {
                upStNm = "역촌"
            }
            
            if downStNm == "종착",
               ["광운대", "문래", "도림천", "시청"].contains(value),
               let relateDownSt = relateStatInfos.first(where: { $0.relateIds.contains(newDatas.statnId) }) {
                
                if !relateDownSt.statnNm.isEmpty {
                    downSt = relateDownSt.statnId
                    downStNm = relateDownSt.statnNm
                } else {
                    downSt = -1
                }
            }
            
            if upStNms.isEmpty {
                upStCodes = [upSt]
                upStNms = [upStNm]
            }
            if downStNms.isEmpty {
                downStCodes = [downSt]
                downStNms = [downStNm]
            }
            
            return .init(nowSt: Int(newDatas.statnId),
                         nowStNm: value,
                         upSt: upStCodes.map { Int($0) },
                         upStNm: upStNms,
                         downSt: downStCodes.map { Int($0) },
                         downStNm: downStNms)
        }
        
        return .emptyData
    }
    
    func getNearStationLineInfos(totalStation: [StationInfo], statName: String) -> [StationInfo] {
        return totalStation.filter { $0.statnNm == statName }
    }
    
    // Never타입은 못씀. 에러를 발생시키지 않기 때문...!! -> api통신중의 발생한 Error를 생성해주어야함.
    func recievePublisher(subwayLine: String, stationInfo: MyStation) -> AnyPublisher<[RealTimeSubway], Error> {
        let nowStation = stationInfo.nowStNm
        let upLineEnd = stationInfo.upStationName // 종착 -> realTime을 받아오지 않는다.
        let downLineEnd = stationInfo.downStationName // 종착 -> realTime을 받아오지 않는다.
        
        return repository.receivePublisher(type: Arrived.self, urlType: .subwayArrive, whereData: nowStation)
            .flatMap { rdata -> AnyPublisher<[RealTimeSubway], Error> in
                var realDatas = rdata.realtimeArrivalList
                
                // 해당 호선에 맞는 데이터로 필터
                realDatas = realDatas.filter { $0.subwayID == subwayLine }
                var stations: [RealTimeSubway] = []
                
                for data in realDatas {
                    let firstSort: Int = self.trainFirstSortKey(ordkey: data.ordkey)
                    
                    let message: String = self.trainMessage(barvlDt: data.barvlDt,
                                                            arvlMsg2: data.arvlMsg2,
                                                            arvlMsg3: data.arvlMsg3,
                                                            arvlCd: data.arvlCD,
                                                            nowStationName: nowStation)
                    
                    let trainDestinationName = self.trainDestinationName(destination: data.bstatnNm, updnLine: data.updnLine)
                    
                    let (trainLocation, isChange) = self.trainLocation(statnNm: nowStation, 
                                                                       subwayLineId: subwayLine,
                                                                       destination: data.bstatnNm,
                                                                       trainNo: data.btrainNo,
                                                                       arvlCd: data.arvlCD)
                    
                    if ( (data.updnLine == "상행" || data.updnLine == "내선") && upLineEnd == "종착") || ( (data.updnLine == "하행" || data.updnLine == "외선") && downLineEnd == "종착") {
                    } else {
                        stations.append(.init(updnLine: data.updnLine,
                                              trainNo: data.btrainNo,
                                              trainType: data.btrainSttus,
                                              stCnt: firstSort,
                                              message: message,
                                              trainDestiStation: trainDestinationName,
                                              trainLocation: trainLocation,
                                              arvlCode: data.arvlCD, 
                                              arvlCaseCode: .arvlCDConvert(ArvlCD(rawValue: data.arvlCD) ?? .ninetynine),
                                              isChange: isChange))
                    }
                }
                
                self.beforeStatnNm = nowStation  // Fetch 역명을 가지고 있는다. -> 추후 첫 Fetch인지 n번째 Fetch인지의 여부를 따지기 위함.
                self.beforeSubwayId = subwayLine // 몇 호선인지 여부.
                
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
    
    private func trainDestinationName(destination: String, updnLine: String) -> String {
        return destination == "성수" ? "\(updnLine)순환" : "\(destination)행"
    }
    
    private func trainMessage(barvlDt: String,
                              arvlMsg2: String,
                              arvlMsg3: String,
                              arvlCd: String,
                              nowStationName: String) -> String {
        
        /*
            TODO: 당역 도착인데 ex: 당역이 수원이면 5초(수원) 이렇게 뜨는 정보도 있음. -> 수정해야함. 23.12.10
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
        if !times.isEmpty, arvlCd == "99" {
            rtnMsg = "\(times) (\(arvlMsg3))"
        } else {
            rtnMsg = arvlMsg
        }
        
        return rtnMsg
    }
   
    /// 열차 위치.
    private func trainLocation(statnNm: String, 
                               subwayLineId: String,
                               destination: String,
                               trainNo: String,
                               arvlCd: String) -> (CGFloat, Bool) {
        
        let arvlCode = ArvlCD(rawValue: arvlCd) ?? .ninetynine
        let newarvlCase = ArvlCase.arvlCDConvert(arvlCode)
//        Log.trace("♠️ 상태값:  \(newarvlCase.rawValue)")
        /*------------------------------------------------
                 전역도착, 당역진입, 당역도착 으로만 판단.
         ------------------------------------------------*/
        var distanceRate: CGFloat = 0.00
        var isChange: Bool = false
        
        // 해당 역명으로 fetch한게 첫번째임.
        if (statnNm != beforeStatnNm) || (subwayLineId != beforeSubwayId) {
            distanceRate = newarvlCase.subwayDistanceRate
            isChange = true
            Log.trace("♠️역 \(trainNo) \(destination)  \(statnNm)  \(distanceRate) ARVLCode: \(arvlCode) newarvLCAse: \(newarvlCase) before: \(beforeStatnNm)")
        }
        // 새로고침일때 진입.
        else {
            // 받아온 현재 열차 상태가 이전과 다른경우에만 진입.
            let beforeCase = self.beforeArvlCase["\(trainNo)", default: "[none]"]

            if beforeCase != newarvlCase.rawValue {
                distanceRate = newarvlCase.subwayDistanceRate
                isChange = true
            }
            
            Log.trace("♠️🟢상태 \(trainNo) \(destination) \(newarvlCase.rawValue)  before: \(beforeCase)")
            
        }
        
        // 추후 재비교를 위해 값을 할당시켜놓는다. -> trainNo와 같이 저장해야할듯.
        self.beforeArvlCase.updateValue(newarvlCase.rawValue, forKey: "\(trainNo)")
//        Log.trace("♠️🦷 DiC: \(beforeArvlCase)")
        
        return (distanceRate, isChange)
    }

    /// 현재역 도착까지 몇정거장 남았는지를 반환.
    private func trainFirstSortKey(ordkey: String) -> Int {
        let startIndex = ordkey.index(ordkey.startIndex, offsetBy: 2)
        let endIndex = ordkey.index(startIndex, offsetBy: 3)
        let slicedString = String(ordkey[startIndex..<endIndex])
        
        return Int(slicedString) ?? 0
    }
    
    // 첫번재 도착인지 두번째 도착인지 반환 -> 추후 삭제할듯 23.12.01
//    private func trainSecondSortKey(ordkey: String) -> Int {
//        let startIndex = ordkey.index(ordkey.startIndex, offsetBy: 1)
//        let endIndex = ordkey.index(startIndex, offsetBy: 1)
//        let slicedString = String(ordkey[startIndex..<endIndex])
//        
//        return Int(slicedString) ?? 0
//    }
    
}
