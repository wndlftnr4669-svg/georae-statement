# 간편 거래명세서 — 작업 메모

- 사용자: 대전 오정동 농수산물시장 쪽 중도매인용 프로그램. 거래돌이 대체. 반말·부드러운 톤.
- 앱: Neutralinojs 6.4.0 (윈도우 exe). 모든 UI/로직은 `app/resources/index.html` 단일 파일 (vanilla JS).
  - `js/xlsx.mini.min.js` (SheetJS 0.18.5, 엑셀 저장), `js/mdb.min.js` (mdb-reader 3.2.0 + buffer/process/stream 폴리필을 esbuild로 묶은 것, 거래돌이 .mdb 읽기)
  - 자료는 `%APPDATA%`(Neutralino os.getPath('data'))/GeoraeStatement/data.json, backup/날짜.json (10일치)
- 배포 방식: **exe는 공식 neutralino-win_x64.exe를 이름만 바꾼 것(손대지 않음, 백신 오진 줄이려고)** + `resources.neu` 별도 파일.
  - `--embed-resources` 쓰지 말 것. exe는 바뀌지 않고 resources.neu만 업데이트됨.
- 자동 업데이트: 앱이 켜질 때 `https://raw.githubusercontent.com/wndlftnr4669-svg/georae-statement/main/update/manifest.json` 확인
  → version > APP_VER 이면 물어보고 resources.neu 내려받아 sha256/size 검사 후 NL_PATH/resources.neu 덮어쓰고 restartProcess.
- 새 버전 내는 법:
  1. `app/resources/index.html`에서 `APP_VER` 올리고, `NOTICES` 맨 위(공지 다음)에 업데이트 내역 추가. `app/neutralino.config.json`의 version도 맞추기.
  2. `tools/release.sh "변경1" "변경2"` 실행 → update/ 와 download/ 갱신.
  3. commit & push (main). 몇 분 안에 각 컴퓨터에서 업데이트 알림.
- 테스트: playwright로 `app/resources/index.html`을 file:// 로 열어 확인 가능 (IS_APP=false, localStorage 사용). 실제 앱 동작은
  `app/bin/neutralino-linux_x64 --mode=browser --port=8123` (resources.neu 같은 폴더) 로 띄워서 확인.
- 주의: 인쇄는 #print 영역만 보이게 @media print로 숨김 처리. 오버레이(#win-dim, section.win, .modal 등)를 새로 만들면 print 숨김 목록에 꼭 추가.
