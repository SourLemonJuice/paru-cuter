#!/bin/bash

# 将没有空行的 $1 输出
remove-blank-line(){
    cat $1 | grep -v '^$'
}

# 将翻译文件的每行真正的翻译拿出来 并输出
# 这么做是为了方便拿来喂给gpt们，不然就要送几千行了，没有原文输出也差不了多少
fetch-key-info(){
    cat $1 | grep 'msgstr'
}

# 主函数
main(){
    case $1 in
    help)
        echo "remove-blank-line [from] | fetch-key-info [from]"
    ;;
    remove-blank-line)
        remove-blank-line $2
    ;;
    fetch-key-info)
        fetch-key-info $2
    ;;
    *)
        main help
    ;;
    esac
}

main $@
exit 0
