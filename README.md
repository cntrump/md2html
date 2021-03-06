# md2html ![Docker Automated build](https://img.shields.io/docker/automated/cntrump/md2html?style=social)

Convert markdown to HTML using pandoc

- Javascript-free
- Syntax highlight
- TOC
- GitHub Light & Dark (auto mode)

Install `pandoc`

```
brew install pandoc
```

Useage: 

```
git clone --depth=1 https://github.com/cntrump/md2html.git
cd md2html
./md2html.sh -i /path/to/your.md
```

`md2html.sh`

```
useage:
	md2html [-t 2] [-l zh] [-s] [-f markdown] -i /path/to/markdown.md
options:
	-f FORMAT: specify input format, default: markdown.
	-t N: toc-depth, N less than or equal to 0 means disable toc, default: 2.
	-l en: language tags, default: en.
	-s: create self contained html, inline all resources.
	-h: display this infomation.
example:
	md2html -i ./markdown.md
	md2html -t 2 -i ./markdown.md
	md2html -t 2 -l zh -i ./markdown.md
	md2html -s -i ./markdown.md
	md2html -f docx -i ./document.docx
```

## Install to System Path

Run `./install.sh` and input your login password:

```
Password:
Installed at /usr/local/bin/md2html
```

## Docker

[cntrump/md2html](https://hub.docker.com/r/cntrump/md2html)

```
docker pull cntrump/md2html
```

`cd` into your markdown file directory.

```
docker run -i -v "${PWD}:/data" --rm cntrump/md2html -i /path/to/markdown.md
```

Or create a shell script named `md2html`:

```
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
        SELF_CONTAINED="-s"
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

WORK_DIR=${INPUT:a:h}
FILE=${INPUT:a:t}

echo "workdir: ${WORK_DIR}"
echo "file: ${FILE}"

docker run -i -v "${WORK_DIR}:/data" --rm cntrump/md2html \
                                          -t ${TOC_DEPTH} \
                                          -l ${LANG} \
                                          -f ${INPUT_FORMAT} \
                                          ${SELF_CONTAINED} -i "${FILE}"

echo Output: "\033[0;32mfile://${INPUT:a:r}.html\033[0m"
echo Done.
```

usage:

```
md2html -i /path/to/markdown.md
```