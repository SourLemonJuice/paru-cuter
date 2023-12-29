#!/bin/bash
# 有任何报错就退出
set -e

case $1 in
help)
    echo "help | restore | *"
;;
restore)
    # 恢复备份
    [[ -d ./backup ]] || exit 1
    cp -r ./backup/usr /
;;
*)
    # 生成 .mo 二进制文件
    ./script/mkmo ./locale/
    # 备份所有语言的原始 paru.mo
    find /usr/share/locale -type f -name 'paru.mo' -exec cp --parents {} ./backup \;
    # 复制新文件到系统目录
    cp -r ./locale/ /usr/share/
;;
esac
