#!/bin/bash
# 웹 버전 만들기: app/resources/index.html → docs/ (GitHub Pages가 docs/ 폴더를 보여줌)
set -e
cd "$(dirname "$0")/.."
rm -rf docs && mkdir -p docs/js docs/icons
python3 - <<'PY'
s=open('app/resources/index.html',encoding='utf-8').read()
a='<script src="js/neutralino.js"></script>'
assert s.count(a)==1
s=s.replace(a,'<script src="js/supabase.js"></script>\n<script src="config.js?v=%d"></script>'%__import__('time').time())
open('docs/index.html','w',encoding='utf-8').write(s)
PY
cp app/resources/js/xlsx.mini.min.js app/resources/js/mdb.min.js web/js/supabase.js docs/js/
cp app/resources/icons/appIcon.png docs/icons/
cp web/config.js docs/config.js
touch docs/.nojekyll
echo "docs/ 만들었어요"
