#!/bin/bash

THIS_DIR=${0%/*}

while [[ ${#} -gt 0 ]]; do
    case ${1} in
        -d|--dry-run)
            dry_run=x
            shift
            ;;
        -k|--keep-wd)
            keep_wd=x
            shift
            ;;
        -l|--list-langs)
            list_langs=x
            shift
            ;;
        --)
            shift
            break
            ;;
        -*)
            echo "Unknown flag ${1}" >&2
            exit 1
            ;;
        *)
            break
            ;;
    esac
done

if [[ -n ${dry_run} ]]; then
    function call {
        echo "${@}"
    }
else
    function call {
        "${@}"
    }
fi

call mkdir -p "${HOME}/.emacs.d/tree-sitter"
call cp -a "${THIS_DIR}/init.el" "${HOME}/.emacs.d/init.el"

l1=$(grep -nF 'GRAMMARS BEGIN' "${THIS_DIR}/init.el")
l1=${l1%%:*}
l1=$((l1 + 1))

l2=$(grep -nF 'GRAMMARS END' "${THIS_DIR}/init.el")
l2=${l2%%:*}

l=$((l2 - l1))

mapfile -t lines < <(tail -n "+${l1}" init.el | head -n "${l}")

if [[ -n ${dry_run} ]]; then
    wd=/some/tmp/dir
else
    wd=$(mktemp --directory)
    if [[ -z ${keep_wd} ]]; then
        trap 'call rm -rf "${wd}"' EXIT
    fi
fi

declare -A lang_name_map
declare -A failed_langs
declare -A selected_langs

for arg; do
    selected_langs[${arg}]=x
done

for line in "${lines[@]}"; do
    read -r -a fields <<<"${line}"
    if [[ ${fields[0]} = ';'* ]]; then
        fields=( "${fields[@]:1}" )
    fi
    lang=${fields[0]#'('}
    if [[ -n ${list_langs} ]]; then
        echo "${lang}"
        continue
    fi
    url=${fields[2]#'('}
    url=${url#'"'}
    url=${url%'"'}
    ref=${fields[3]%'))'}
    ref=${ref#'"'}
    ref=${ref%'"'}
    echo "Cloning ${url} at ${ref} for ${lang}"
    call mkdir -p "${wd}/${lang}"
    call pushd "${wd}/${lang}"
    call git init
    call git remote add origin "${url}"
    if ! call git fetch --depth 1 origin "${ref}"; then
        failed_langs["${lang}"]="Failed to fetch ${ref} from ${url} for ${lang}"
        continue
    fi
    call git reset --hard FETCH_HEAD
    call popd
    name=${url##*/}
    lang_name_map["${lang}"]=${name}
done

if [[ -n ${list_langs} ]]; then
    exit 0
fi

for line in "${lines[@]}"; do
    read -r -a fields <<<"${line}"
    if [[ ${fields[0]} = ';'* ]]; then
        fields=( "${fields[@]:1}" )
    fi
    lang=${fields[0]#'('}
    if [[ ${#selected_langs[@]} -gt 0 && -z ${selected_langs["${lang}"]} ]]; then
        continue
    fi
    if [[ -n ${failed_langs["${lang}"]} ]]; then
        continue
    fi
    url=${fields[2]#'('}
    url=${url#'"'}
    url=${url%'"'}
    ref=${fields[3]%'))'}
    ref=${ref#'"'}
    ref=${ref%'"'}
    call pushd "${wd}/${lang}"
    if [[ ${#fields[@]} -gt 5 ]]; then
        name=${url##*/}
        deps=( "${fields[@]:5}" )
        call mkdir -p node_modules
        call pushd node_modules
        dep_failed=''
        for d in "${deps[@]}"; do
            if [[ -n ${failed_langs["${d}"]} ]]; then
                failed_langs[${lang}]="Can't build for ${lang} because it's dep ${d} failed too"
                dep_failed=x
                break
            fi
            name=${lang_name_map["${d}"]}
            call ln -s "../../${d}" "${name}"
        done
        if [[ -n ${dep_failed} ]]; then
            continue
        fi
        call popd
    fi
    echo "Regenerating and building tree-sitter stuff for ${lang}"
    if ! call tree-sitter generate; then
        failed_langs[${lang}]="tree-sitter generate failed for ${lang}"
        continue
    fi
    if ! call make; then
        failed_langs[${lang}]="make failed for ${lang}"
        continue
    fi
    call cp -a "libtree-sitter-${lang}.so" "${HOME}/.emacs.d/tree-sitter/libtree-sitter-${lang}.so"
    call popd
done

if [[ ${#failed_langs[@]} -gt 0 ]]; then
    echo "Errors:"
    for lang in "${!failed_langs[@]}"; do
        error=${failed_langs["${lang}"]}
        echo "${error}"
    done
    exit 1
fi
