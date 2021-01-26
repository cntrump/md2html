#!/usr/bin/env zsh

set -e

print_usage_and_exit() {
  echo "useage:"
  echo "\tmd2html [-t 2] [-l zh] [-s] -i /path/to/markdown.md"
  echo "options:"
  echo "\t-t N: toc-depth, N must >= 1, default: 2."
  echo "\t-l en: lang, default: en."
  echo "\t-s: create self contained html, inline all resources."
  echo "\t-h: display this infomation."
  echo "example:"
  echo "\tmd2html -i ./markdown.md"
  echo "\tmd2html -i ./markdown.md -t 2"
  echo "\tmd2html -i ./markdown.md -t 2 -l zh"
  echo "\tmd2html -i ./markdown.md -s"
  exit -1
}

LANG="en"
TOC_DEPTH=2
SELF_CONTAINED=
INPUT=

while getopts "t:l:i:hs" arg; do
  case "${arg}" in
    "t")
        TOC_DEPTH=${OPTARG} 
        ;;
    "l")
        LANG=${OPTARG}
        ;;
    "i")
        INPUT=${OPTARG:a}
        ;;
    "h")
        print_usage_and_exit
        ;;
    "s")
        echo "[INFO] create self contained html."
        SELF_CONTAINED="--self-contained"
        ;;
    "?")  
        echo "[WARNING] unkonw argument"
        ;;
    esac
done

if [ "${INPUT}" = "" ];then
  echo "[ERROR] no input file."
  print_usage_and_exit
fi

if [ ${TOC_DEPTH} -lt 1 ];then
  echo "[ERROR] toc-depth \033[0;32m${TOC_DEPTH}\033[0m, must >= 1."
  print_usage_and_exit
fi

OUTPUT=${INPUT:a:r}.html

echo "toc-depth=\033[0;32m${TOC_DEPTH}\033[0m"
echo "lang=\033[0;32m${LANG}\033[0m"

APP_DIR=${0:a:h}

STYLE_HEADER=`mktemp`
echo "<style>" > "${STYLE_HEADER}"
cat "${APP_DIR}/style.css" >> "${STYLE_HEADER}"
echo "</style>" >> "${STYLE_HEADER}"

pushd "${APP_DIR}"

pandoc -f markdown -t html \
      --highlight-style=syntax.theme \
      --template=template.html \
      -H "${STYLE_HEADER}" \
      --toc --toc-depth=${TOC_DEPTH} \
      --variable=lang:"${LANG}" \
      --standalone ${SELF_CONTAINED} -o "${OUTPUT}" \
      "${INPUT}"

rm -f "${STYLE_HEADER}"

echo Output: "\033[0;32mfile://${OUTPUT}\033[0m"
echo Done.
