# md2html
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
	md2html [-t 2] [-l zh] [-s] -i /path/to/markdown.md
options:
	-t N: toc-depth, N must >= 1, default: 2.
	-l en: lang, default: en.
	-s: create self contained html, inline all resources.
	-h: display this infomation.
example:
	md2html -i ./markdown.md
	md2html -i ./markdown.md -t 2
	md2html -i ./markdown.md -t 2 -l zh
	md2html -i ./markdown.md -s
```

## Docker

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

if [ ${TOC_DEPTH} -lt 1 ];then
  echo "[ERROR] toc-depth \033[0;32m${TOC_DEPTH}\033[0m, must >= 1."
  print_usage_and_exit
fi

WORK_DIR=${INPUT:a:h}
FILE=${INPUT:a:t}

echo "workdir: ${WORK_DIR}"
echo "file: ${FILE}"

docker run -i -v "${WORK_DIR}:/data" --rm cntrump/md2html -i "${FILE}" -t ${TOC_DEPTH} -l ${LANG} ${SELF_CONTAINED}

echo Output: "\033[0;32mfile://${INPUT:a:r}.html\033[0m"
echo Done.
```

usage:

```
md2html -i /path/to/markdown.md
```