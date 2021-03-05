#!/usr/bin/env zsh

set -e

target=/usr/local/md2html

if [ -f ${target} ]; then
  sudo rm -f ${target}
fi

if [ -d ${target} ]; then
  sudo rm -rf ${target}
fi

sudo mkdir ${target}

install_file() {
  src=${1}
  if [ -f ${src} ]; then
    sudo cp ${src} ${target}
  else
    echo "missing file: ${src}"
  fi   
}

install_file ./colors.css
install_file ./style.css
install_file ./syntax.theme
install_file ./template.html
install_file ./md2html.sh

sudo chmod u+x ${target}/md2html.sh

sudo ln -sf ${target}/md2html.sh /usr/local/bin/md2html

echo "Installed at /usr/local/bin/md2html"