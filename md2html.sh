#!/usr/bin/env zsh

set -e

APP_DIR=${0:a:h}
pushd "${APP_DIR}"

ARGS=$#
if [ ${ARGS} -eq 0 ];then
  echo useage: "md2html file [toc_depth]"
  echo example: md2html ./markdown.md
  echo example: md2html ./markdown.md 2
  exit -1
fi

INPUT=$1
OUTPUT=${1:a:r}.html

TOC_DEPTH=2
if [ ${ARGS} -ge 2 ];then
  TOC_DEPTH=$2
fi

echo "Set toc_depth=${TOC_DEPTH}"

STYLE_HEADER=`mktemp`
echo "<style>" > ${STYLE_HEADER}
cat style.css >> ${STYLE_HEADER}
echo "</style>" >> ${STYLE_HEADER}

pandoc -f gfm -t html \
      --highlight-style=syntax.theme \
      --template=template.html \
      -H ${STYLE_HEADER} \
      --toc --toc-depth=${TOC_DEPTH} \
      --standalone -o ${OUTPUT} ${INPUT}

rm -f ${STYLE_HEADER}

echo Output: "\033[0;32m ${OUTPUT} \033[0m"
echo Done.
