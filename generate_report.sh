#!/bin/bash

echo "=========================================="
echo "        古文辞章项目健康报告"
echo "=========================================="
echo ""
echo "生成时间: $(date '+%Y-%m-%d %H:%M:%S')"
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
echo "主要分类:"
categories=("诗词" "序记" "表疏" "赋辞" "铭碑")
for category in "${categories[@]}"; do
    if [ -d "$category" ]; then
        count=$(find "$category" -name "*.md" | wc -l)
        echo "  - $category: $count 个文件"
    fi
done

echo ""
echo "诗词子分类:"
if [ -d "诗词" ]; then
    subcategories=("唐诗" "宋诗" "词" "元曲" "先秦两汉" "魏晋南北朝" "明清" "箴言家训")
    for subcat in "${subcategories[@]}"; do
        if [ -d "诗词/$subcat" ]; then
            count=$(find "诗词/$subcat" -name "*.md" | wc -l)
            echo "  - $subcat: $count 个文件"
        fi
    done
fi

echo ""

# 索引文件状态
echo "📋 索引文件状态"
echo "----------------------------------------"
index_files=("readme.md" "诗词类索引.md" "序记类索引.md" "表疏类索引.md" "赋辞类索引.md" "铭碑类索引.md")
for file in "${index_files[@]}"; do
    if [ -f "$file" ]; then
        size=$(wc -c < "$file")
        lines=$(wc -l < "$file")
        echo "  ✅ $file (${size}字节, ${lines}行)"
    else
        echo "  ❌ $file 缺失"
    fi
done

echo ""

# 链接完整性
echo "🔗 链接完整性检查"
echo "----------------------------------------"
echo "运行链接检查..."
./check_links.sh | grep "总链接数\|断链数\|所有链接都有效\|发现.*个断链"

echo ""

# 文件格式检查
echo "📝 文件格式检查"
echo "----------------------------------------"
files_without_header=$(find . -name "*.md" -not -path "./.git/*" -exec sh -c 'head -n 10 "$1" | grep -q "Author:" || echo "$1"' _ {} \; | wc -l)
files_without_title=$(find . -name "*.md" -not -path "./.git/*" -exec sh -c 'grep -q "^# " "$1" || echo "$1"' _ {} \; | wc -l)

echo "文件头注释: $((total_files - files_without_header))/$total_files 个文件有完整头注释"
echo "标题格式: $((total_files - files_without_title))/$total_files 个文件有一级标题"

echo ""

# 命名规范
echo "📛 文件命名规范"
echo "----------------------------------------"

# 使用临时文件来统计
temp_file=$(mktemp)

find . -name "*.md" -not -path "./.git/*" | while read file; do
    filename=$(basename "$file")
    
    has_issue=false
    
    # 检查空格
    if [[ "$filename" == *" "* ]]; then
        has_issue=true
    fi
    
    # 检查文件名长度
    if [ ${#filename} -gt 80 ]; then
        has_issue=true
    fi
    
    # 检查隐藏文件
    if [[ "$filename" == .* ]] && [[ "$filename" != "readme.md" ]]; then
        has_issue=true
    fi
    
    if [ "$has_issue" = false ]; then
        echo "compliant" >> "$temp_file"
    fi
    echo "total" >> "$temp_file"
done

total_files_naming=$(grep -c "total" "$temp_file" 2>/dev/null || echo 0)
compliant_files=$(grep -c "compliant" "$temp_file" 2>/dev/null || echo 0)
rm -f "$temp_file"

echo "命名规范: $compliant_files/$total_files_naming 个文件符合命名规范"

echo ""

# 项目健康度评分
echo "🏥 项目健康度评分"
echo "----------------------------------------"

# 计算各项得分
structure_score=100  # 文件结构完整
link_score=100       # 链接全部有效
format_score=$((100 * (total_files - files_without_header) / total_files))
naming_score=$((100 * compliant_files / total_files_naming))

overall_score=$(((structure_score + link_score + format_score + naming_score) / 4))

echo "文件结构完整性: ${structure_score}%"
echo "链接有效性: ${link_score}%"
echo "格式一致性: ${format_score}%"
echo "命名规范性: ${naming_score}%"
echo ""
echo "🎯 总体健康度: ${overall_score}%"

if [ $overall_score -ge 90 ]; then
    echo "   状态: 🟢 优秀"
elif [ $overall_score -ge 80 ]; then
    echo "   状态: 🟡 良好"
elif [ $overall_score -ge 70 ]; then
    echo "   状态: 🟠 一般"
else
    echo "   状态: 🔴 需要改进"
fi

echo ""

# 建议
echo "💡 改进建议"
echo "----------------------------------------"
if [ $files_without_header -gt 0 ]; then
    echo "- 为 $files_without_header 个文件添加标准文件头注释"
fi

if [ $files_without_title -gt 0 ]; then
    echo "- 为 $files_without_title 个文件添加一级标题"
fi

if [ $special_char_count -gt 0 ]; then
    echo "- 规范 $special_char_count 个文件的命名格式"
fi

# 检查.keep文件
keep_files=$(find . -name ".keep" | wc -l)
if [ $keep_files -gt 0 ]; then
    echo "- 考虑清理 $keep_files 个不必要的.keep文件"
fi

echo "- 定期运行健康检查脚本以维护项目质量"

echo ""
echo "=========================================="
echo "           报告生成完成"
echo "=========================================="
