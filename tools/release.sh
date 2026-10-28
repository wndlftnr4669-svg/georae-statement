#!/usr/bin/env bash
# 사용법: tools/release.sh "변경내용1" "변경내용2" ...
# app/resources/index.html 의 APP_VER 와 app/neutralino.config.json 의 version 을 먼저 올려두고 실행.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT/app"
command -v neu >/dev/null || npm i -g @neutralinojs/neu
[ -f bin/neutralino-win_x64.exe ] || neu update
VER=$(grep -o "const APP_VER='[^']*'" resources/index.html | cut -d"'" -f2)
neu build --release >/dev/null
cp dist/*/resources.neu "$ROOT/update/resources.neu"
python3 - "$ROOT" "$VER" "$@" <<'PY'
import hashlib,json,sys,os
root,ver,*notes=sys.argv[1:]
b=open(os.path.join(root,'update/resources.neu'),'rb').read()
m={"version":ver,"url":"https://raw.githubusercontent.com/wndlftnr4669-svg/georae-statement/main/update/resources.neu",
   "sha256":hashlib.sha256(b).hexdigest(),"size":len(b),"notes":notes,"minExe":"6.4.0",
   "download":"https://github.com/wndlftnr4669-svg/georae-statement/raw/main/download/간편거래명세서.zip"}
json.dump(m,open(os.path.join(root,'update/manifest.json'),'w',encoding='utf-8'),ensure_ascii=False,indent=1)
print('manifest',ver,len(b))
PY
# 새로 까는 사람용 zip (exe는 손대지 않은 공식 Neutralino 파일 그대로 — 백신 오진 줄이려고)
TMP=$(mktemp -d); mkdir "$TMP/간편거래명세서"
cp bin/neutralino-win_x64.exe "$TMP/간편거래명세서/간편거래명세서.exe"
cp "$ROOT/update/resources.neu" "$TMP/간편거래명세서/resources.neu"
cp "$ROOT/tools/사용법.txt" "$TMP/간편거래명세서/사용법.txt"
(cd "$TMP" && python3 -c "
import zipfile,os
z=zipfile.ZipFile('pkg.zip','w',zipfile.ZIP_DEFLATED)
for f in sorted(os.listdir('간편거래명세서')):z.write('간편거래명세서/'+f)
z.close()")
cp "$TMP/pkg.zip" "$ROOT/download/간편거래명세서.zip"; rm -rf "$TMP"
echo "done: commit & push update/ and download/"
