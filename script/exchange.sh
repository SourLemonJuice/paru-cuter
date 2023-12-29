#!/bin/bash

# 配置们
# Source: 原始翻译文件(仅关键信息)
Source=./string-source
# Processed: 风格化处理后的翻译文件(仅关键信息)
Processed=./string-out
# 语言
Lang=zh_CN
# Target: 最后要替换的完整翻译文件(可以包含更多没用的内容，行数也可以不对等)
# 该脚本不会修改这个文件
Target=../po-s/${Lang}.po

escape_quotes() {
    # 由 ChatGPT3.5 制作，这东西谁看的懂
    local input="$1"
    local escaped
    escaped="${input//\'/\'\\\'\'}"  # 替换单引号
    escaped="${escaped//\"/\\\"}"    # 替换双引号
    escaped="${escaped//\//\\/}"      # 替换斜杠
    # 反斜杠本身就是转译用的，不能再转译了，如果要的话emm,到时候再说吧
    # escaped="${escaped//\\/\\\\}"     # 替换反斜杠
    echo "$escaped"
}

make-sed-rules(){
    # 生成前先清空旧规则
    > ./sed-rules
    # 循环将修改后的每一行对应的源文件和处理后的文件写成sed规则的样子
    for i in $(seq 1 $(cat $Source | wc -l)); do
        # 打印行号，用来标记每次循环的开始，debug时能知道在干活
        echo "$i"
        # sed -n 输出文件指定行的信息
        # escape_quotes 用来替换 ' " / 为 '\'' \" \/
        # 最后输出到变量里
        Source_OneLine=$(escape_quotes "$(sed -n "${i}p" $Source)")
        Processed_OneLine=$(escape_quotes "$(sed -n "${i}p" $Processed)")
        # 输出变量的内容做提示
        echo $Source_OneLine
        echo $Processed_OneLine
        # 按照规则的模板输出到文件里
        echo "s/$Source_OneLine/$Processed_OneLine/" >> ./sed-rules
    done
}

exchange(){
    # 使用文件里的规则处理 $Target
    # 为了防bug和手残，这里并没有输出到文件只会在终端上打印
    sed -f ./sed-rules $Target
}

main(){
    # 处理参数
    case $1 in
    help)
        echo "help | make-sed-rules | exchange | exchange-to-file"
    ;;
    make-sed-rules)
        make-sed-rules
    ;;
    exchange)
        exchange
    ;;
    exchange-to-file)
        exchange > ./${Lang}.po
    ;;
    *)
        main help
    ;;
    esac
}

main $@

exit 0
