#!/bin/bash

echo "=========================================="
echo "        古文辞章项目综合检查"
echo "=========================================="
echo ""
echo "检查时间: $(date '+%Y-%m-%d %H:%M:%S')"
echo ""

# 项目概览
echo "📊 项目概览"
echo "----------------------------------------"
total_files=$(find . -name "*.md" -not -path "./.git/*" | wc -l)
echo "总文件数: $total_files 个Markdown文件"
echo ""

# 目录结构统计
echo "📁 目录结构统计"
echo "----------------------------------------"
categories=("诗词" "序记" "表疏" "赋辞" "铭碑")
for category in "${categories[@]}"; do
    if [ -d "$category" ]; then
        count=$(find "$category" -name "*.md" | wc -l)
        echo "  - $category: $count 个文件"
    fi
done
echo ""

# 1. 检查重复文件
echo "🔍 1. 检查重复文件"
echo "----------------------------------------"
duplicate_count=0
find . -name "*.md" -not -path "./.git/*" -exec basename {} \; | sort | uniq -d | while read duplicate; do
    echo "  ⚠️  重复文件名: $duplicate"
    find . -name "$duplicate" -not -path "./.git/*"
    duplicate_count=$((duplicate_count + 1))
done

if [ $duplicate_count -eq 0 ]; then
    echo "  ✅ 未发现重复文件"
fi
echo ""

# 2. 检查空文件
echo "📄 2. 检查空文件"
echo "----------------------------------------"
empty_count=0
find . -name "*.md" -not -path "./.git/*" -empty | while read empty_file; do
    echo "  ⚠️  空文件: $empty_file"
    empty_count=$((empty_count + 1))
done

if [ $empty_count -eq 0 ]; then
    echo "  ✅ 未发现空文件"
fi
echo ""

# 3. 检查文件命名规范
echo "📝 3. 检查文件命名规范"
echo "----------------------------------------"
naming_issues=0
find . -name "*.md" -not -path "./.git/*" | while read file; do
    filename=$(basename "$file")
    
    # 检查文件名是否包含空格
    if [[ "$filename" == *" "* ]]; then
        echo "  ⚠️  包含空格: $file"
        naming_issues=$((naming_issues + 1))
    fi
    
    # 检查文件名长度是否过长（超过80字符）
    if [ ${#filename} -gt 80 ]; then
        echo "  ⚠️  文件名过长 (${#filename}字符): $file"
        naming_issues=$((naming_issues + 1))
    fi
    
    # 检查是否包含特殊字符
    if [[ "$filename" =~ [^a-zA-Z0-9\u4e00-\u9fa5._-] ]]; then
        echo "  ⚠️  包含特殊字符: $file"
        naming_issues=$((naming_issues + 1))
    fi
done

if [ $naming_issues -eq 0 ]; then
    echo "  ✅ 文件命名规范"
fi
echo ""

# 4. 检查标题格式一致性
echo "📋 4. 检查标题格式一致性"
echo "----------------------------------------"
title_issues=0

# 定义标准的二级标题
standard_titles=("## 简介" "## 推荐版本" "## 版本索引" "## 原文" "## 注释" "## 译文" "## 赏析" "## 备注" "## 作者" "## 体裁" "## 选摘" "## 版本与推荐")

# 排除文档文件，只检查内容文件
find . -name "*.md" -not -path "./.git/*" -not -name "readme.md" -not -name "*索引.md" -not -name "title_format_*.md" | while read file; do
    # 检查是否有一级标题
    if ! grep -q "^# " "$file"; then
        echo "  ⚠️  缺少一级标题: $file"
        title_issues=$((title_issues + 1))
    fi
    
    # 检查二级标题是否符合标准
    grep "^## " "$file" | while read line; do
        is_standard=false
        for standard in "${standard_titles[@]}"; do
            if [ "$line" = "$standard" ]; then
                is_standard=true
                break
            fi
        done
        
        if [ "$is_standard" = false ]; then
            echo "  ⚠️  非标准二级标题 '$line' 在文件: $file"
            title_issues=$((title_issues + 1))
        fi
    done
done

if [ $title_issues -eq 0 ]; then
    echo "  ✅ 标题格式规范"
fi
echo ""

# 5. 统计标题分布
echo "📊 5. 标题分布统计"
echo "----------------------------------------"
echo "二级标题使用频率:"
grep -h "^## " $(find . -name "*.md" -not -path "./.git/*") | sort | uniq -c | sort -nr | head -10
echo ""

echo "=========================================="
echo "检查完成！"
echo "=========================================="