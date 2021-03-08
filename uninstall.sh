#!/usr/bin/env zsh

set -e

target=/usr/local/md2html

if [ -d ${target} ]; then
  sudo rm -rf ${target}
  echo "${target} removed."
fi

md2html=/usr/local/bin/md2html
if [ -L ${md2html} ]; then
  sudo rm -f ${md2html}
  echo "${md2html} removed."
fi

echo "Uninstall finished."