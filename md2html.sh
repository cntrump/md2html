#!/usr/bin/env zsh

set -e

print_usage_and_exit() {
  echo "useage:"
  echo "\tmd2html [-t 2] [-l zh] [-s] [-f markdown] -i /path/to/markdown.md"
  echo "options:"
  echo "\t-f FORMAT: specify input format, default: markdown."
  echo "\t-t N: toc-depth, N less than or equal to 0 means disable toc, default: 2."
  echo "\t-l en: language tags, default: en."
  echo "\t-s: create self contained html, inline all resources."
  echo "\t-h: display this infomation."
  echo "example:"
  echo "\tmd2html -i ./markdown.md"
  echo "\tmd2html -t 2 -i ./markdown.md"
  echo "\tmd2html -t 2 -l zh -i ./markdown.md"
  echo "\tmd2html -s -i ./markdown.md"
  echo "\tmd2html -f docx -i ./document.docx"
  exit -1
}

INPUT_FORMAT="markdown"
LANG="en"
TOC_DEPTH=2
TOC="--toc"
SELF_CONTAINED=
INPUT=

while getopts "f:t:l:i:hs" arg; do
  case "${arg}" in
    "f")
        INPUT_FORMAT=${OPTARG}
        ;;
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

echo "input-format=\033[0;32m${INPUT_FORMAT}\033[0m"
echo "lang=\033[0;32m${LANG}\033[0m"

if [ ${TOC_DEPTH} -gt 0 ];then
  echo "toc-depth=\033[0;32m${TOC_DEPTH}\033[0m"
  TOC_DEPTH="--toc-depth=${TOC_DEPTH}"
else
  echo "[INFO] toc disabled."
  TOC=
  TOC_DEPTH=
fi

OUTPUT=${INPUT:a:r}.html
APP_DIR=${0:a:h}

STYLE_HEADER=`mktemp`
echo "<style>" > "${STYLE_HEADER}"
cat "${APP_DIR}/style.css" >> "${STYLE_HEADER}"
echo "</style>" >> "${STYLE_HEADER}"

pushd "${APP_DIR}"

pandoc -f ${INPUT_FORMAT} -t html \
      --highlight-style=syntax.theme \
      --template=template.html \
      -H "${STYLE_HEADER}" ${TOC} ${TOC_DEPTH} \
      --variable=lang:"${LANG}" \
      --standalone ${SELF_CONTAINED} -o "${OUTPUT}" \
      "${INPUT}"

rm -f "${STYLE_HEADER}"

echo Output: "\033[0;32mfile://${OUTPUT}\033[0m"
echo Done.
