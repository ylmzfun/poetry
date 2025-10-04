#!/bin/bash

echo "=== 检查索引文件链接有效性 ==="
echo ""

# 检查所有索引文件
index_files=("readme.md" "诗词类索引.md" "序记类索引.md" "表疏类索引.md" "赋辞类索引.md" "铭碑类索引.md")

broken_links=0
total_links=0

for file in "${index_files[@]}"; do
    if [[ -f "$file" ]]; then
        echo "检查文件: $file"
        
        # 提取所有 .md 链接
        links=$(grep -o '\[.*\](\./[^)]*\.md)' "$file" | sed 's/.*(\.\///' | sed 's/).*//')
        
        for link in $links; do
            total_links=$((total_links + 1))
            if [[ ! -f "$link" ]]; then
                echo "  ❌ 断链: $link"
                broken_links=$((broken_links + 1))
            fi
        done
        
        echo "  ✅ 完成检查"
        echo ""
    else
        echo "❌ 索引文件不存在: $file"
        echo ""
    fi
done

echo "=== 链接检查总结 ==="
echo "总链接数: $total_links"
echo "断链数: $broken_links"
if [[ $broken_links -eq 0 ]]; then
    echo "✅ 所有链接都有效！"
else
    echo "❌ 发现 $broken_links 个断链"
fi
