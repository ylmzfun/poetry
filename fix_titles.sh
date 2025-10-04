#!/bin/bash

# 标题格式统一修复脚本
# 用于统一古文辞章汇编项目的标题格式

echo "开始标题格式统一修复..."

# 统计变量
total_files=0
fixed_files=0
issues_found=0

# 创建临时文件记录修复日志
log_file="/tmp/title_fix_log.txt"
echo "标题格式修复日志 - $(date)" > "$log_file"
echo "================================" >> "$log_file"

# 定义标题替换函数
replace_title() {
    local line="$1"
    
    # 替换各种标题格式
    if [[ "$line" == "## 正文" ]] || [[ "$line" == "## 正文（节选）" ]]; then
        echo "## 原文"
    elif [[ "$line" == "## 文本" ]]; then
        echo "## 原文"
    elif [[ "$line" == "## 篇目与文本" ]]; then
        echo "## 原文"
    elif [[ "$line" == "## 注释与译文" ]]; then
        echo "## 注释"
    elif [[ "$line" == "## 注释与译" ]]; then
        echo "## 注释"
    elif [[ "$line" == "## 注疏与译" ]]; then
        echo "## 注释"
    elif [[ "$line" == "## 翻译" ]]; then
        echo "## 译文"
    elif [[ "$line" == "## 译文（节选）" ]]; then
        echo "## 译文"
    elif [[ "$line" == "## 赏析要点" ]]; then
        echo "## 赏析"
    elif [[ "$line" == "## 要点提炼" ]]; then
        echo "## 赏析"
    elif [[ "$line" == "## 解读" ]]; then
        echo "## 赏析"
    elif [[ "$line" == "## 分析" ]]; then
        echo "## 赏析"
    elif [[ "$line" == "## 作者简介" ]]; then
        echo "## 简介"
    elif [[ "$line" == "## 作品简介" ]]; then
        echo "## 简介"
    elif [[ "$line" == "## 导言" ]]; then
        echo "## 简介"
    else
        echo "$line"
    fi
}

# 修复单个文件的标题格式
fix_file_titles() {
    local file="$1"
    local temp_file="/tmp/$(basename "$file").tmp"
    local file_changed=false
    
    echo "检查文件: $file" >> "$log_file"
    
    # 读取文件内容并修复标题
    while IFS= read -r line; do
        original_line="$line"
        
        # 使用替换函数处理标题
        new_line=$(replace_title "$line")
        
        if [[ "$original_line" != "$new_line" ]]; then
            echo "  替换: '$original_line' -> '$new_line'" >> "$log_file"
            file_changed=true
            # 读取并更新统计
            read -r total_files fixed_files issues_found < "$stats_file"
            ((issues_found++))
            echo "$total_files $fixed_files $issues_found" > "$stats_file"
        fi
        
        echo "$new_line" >> "$temp_file"
    done < "$file"
    
    # 如果文件有变化，则替换原文件
    if [[ "$file_changed" == true ]]; then
        mv "$temp_file" "$file"
        # 读取并更新统计
        read -r total_files fixed_files issues_found < "$stats_file"
        ((fixed_files++))
        echo "$total_files $fixed_files $issues_found" > "$stats_file"
        echo "  文件已修复" >> "$log_file"
    else
        rm -f "$temp_file"
        echo "  无需修复" >> "$log_file"
    fi
    
    echo "" >> "$log_file"
}

# 检查标题格式一致性
check_title_consistency() {
    local file="$1"
    local inconsistencies=0
    
    # 检查是否有一级标题
    if ! grep -q "^# " "$file"; then
        echo "警告: $file 缺少一级标题" >> "$log_file"
        ((inconsistencies++))
    fi
    
    # 检查二级标题格式
    while IFS= read -r line; do
        if [[ "$line" =~ ^##[[:space:]]+ ]]; then
            # 检查是否有多余的空格
            if [[ "$line" =~ ^##[[:space:]]{2,} ]]; then
                echo "警告: $file 二级标题有多余空格: $line" >> "$log_file"
                ((inconsistencies++))
            fi
        fi
    done < "$file"
    
    return $inconsistencies
}

# 创建临时文件记录统计
stats_file="/tmp/title_fix_stats.txt"
echo "0 0 0" > "$stats_file"  # total_files fixed_files issues_found

# 遍历所有markdown文件
find . -name "*.md" -type f | while read -r file; do
    # 跳过特殊文件
    if [[ "$(basename "$file")" == "readme.md" ]] || [[ "$(basename "$file")" == "title_format_standard.md" ]]; then
        continue
    fi
    
    # 读取当前统计
    read -r total_files fixed_files issues_found < "$stats_file"
    ((total_files++))
    
    # 修复标题格式
    fix_file_titles "$file"
    
    # 检查标题一致性
    check_title_consistency "$file"
    
    # 更新统计
    echo "$total_files $fixed_files $issues_found" > "$stats_file"
done

# 读取最终统计
read -r total_files fixed_files issues_found < "$stats_file"

# 输出统计结果
echo "" >> "$log_file"
echo "修复统计:" >> "$log_file"
echo "总文件数: $total_files" >> "$log_file"
echo "修复文件数: $fixed_files" >> "$log_file"
echo "发现问题数: $issues_found" >> "$log_file"

# 显示结果
echo "标题格式修复完成！"
echo "总文件数: $total_files"
echo "修复文件数: $fixed_files"
echo "发现问题数: $issues_found"
echo ""
echo "详细日志请查看: $log_file"

# 生成修复后的标题格式检查报告
echo ""
echo "生成标题格式检查报告..."

# 创建临时文件记录合规率统计
compliance_file="/tmp/title_compliance_stats.txt"
echo "0 0" > "$compliance_file"  # compliant_files total_checked

find . -name "*.md" -type f | while read -r file; do
    if [[ "$(basename "$file")" == "readme.md" ]] || [[ "$(basename "$file")" == "title_format_standard.md" ]]; then
        continue
    fi
    
    # 读取当前统计
    read -r compliant_files total_checked < "$compliance_file"
    ((total_checked++))
    
    # 检查是否符合标准格式
    has_issues=false
    
    # 检查是否有旧的标题格式
    if grep -q "^## 正文" "$file" || \
       grep -q "^## 正文（节选）" "$file" || \
       grep -q "^## 文本" "$file" || \
       grep -q "^## 篇目与文本" "$file" || \
       grep -q "^## 注释与译文" "$file" || \
       grep -q "^## 注释与译" "$file" || \
       grep -q "^## 注疏与译" "$file" || \
       grep -q "^## 翻译" "$file" || \
       grep -q "^## 译文（节选）" "$file" || \
       grep -q "^## 赏析要点" "$file" || \
       grep -q "^## 要点提炼" "$file" || \
       grep -q "^## 解读" "$file" || \
       grep -q "^## 分析" "$file" || \
       grep -q "^## 作者简介" "$file" || \
       grep -q "^## 作品简介" "$file" || \
       grep -q "^## 导言" "$file"; then
        has_issues=true
    fi
    
    if [[ "$has_issues" == false ]]; then
        ((compliant_files++))
    fi
    
    # 更新统计
    echo "$compliant_files $total_checked" > "$compliance_file"
done

# 读取最终合规率统计
read -r compliant_files total_checked < "$compliance_file"

# 计算合规率
if [[ $total_checked -gt 0 ]]; then
    compliance_rate=$((compliant_files * 100 / total_checked))
    echo "标题格式合规率: $compliance_rate% ($compliant_files/$total_checked)"
else
    echo "标题格式合规率: 0% (0/0)"
fi

echo "标题格式统一修复已完成！"