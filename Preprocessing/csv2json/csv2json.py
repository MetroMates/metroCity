import csv
import json
import gzip

# 주중/주말: DAY:주중, SAT:토요일, END:공휴일,일요일
# 방향: IN/OUT:내/외선, UP/DOWN:상/하행
# 급행여부: 급행:1, 일반:0

# csv 파일 경로
csv_file_path = 'csvZip/trainInfo.csv'

# 급행여부 코드로 받아서 명으로 반환
def fast2Name(fastAt: str) -> str:
    if fastAt == "0":
        return "일반"
    else:
        return "급행"

def transDirection(dir: str) -> str:
    if dir in ("IN", "UP"):
        return "up"
    else:
        return "down"

# 호선별 파일 나누기.
hosunList: list[str] = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '경강선', '경의선', '경춘선', '공항철도', '김포도시철도', '서해선',
                        '수인분당선', '신분당선', '용인경전철', '우이신설선', '의정부경전철', '인천1', '인천2']

for hosun in hosunList:
    # csv 파일 읽어오기
    with open(csv_file_path, 'r', encoding='utf-8') as f:
        reader = csv.reader(f)
        next(reader)  # 첫 줄 skip

        print('진행중 : %s' % hosun)
        data = []
        for line in reader:
            if hosun == line[1]:
                d = {
                    'id': line[0],
                    'hosun': line[1],
                    'statNm': line[3],
                    'weekAt': line[4],
                    'direction': transDirection(line[5]),
                    'fastAt': fast2Name(line[6]),
                    'arriveTime': line[8][:-3],
                    'startTime': line[9][:-3],
                    'destination': line[11],
                }
                data.append(d)

        # json string으로 변환
        json_string = json.dumps(data, ensure_ascii=False, indent=4)

        # 압축된 json 파일로 저장할 경로
        compressed_file_path = 'jsonZip/%s.json.gz' % hosun

        # 압축된 json 파일 쓰기
        with gzip.open(compressed_file_path, 'wb') as f:
            f.write(json_string.encode('utf-8'))
