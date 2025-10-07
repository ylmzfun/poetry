import comp from "/Users/ylmzfun/Documents/study/note/poetry/docs/.vuepress/.temp/pages/序记/醉翁亭记.html.vue"
const data = JSON.parse("{\"path\":\"/%E5%BA%8F%E8%AE%B0/%E9%86%89%E7%BF%81%E4%BA%AD%E8%AE%B0.html\",\"title\":\"醉翁亭记\",\"lang\":\"zh-CN\",\"frontmatter\":{},\"git\":{},\"filePathRelative\":\"序记/醉翁亭记.md\"}")
export { comp, data }

if (import.meta.webpackHot) {
  import.meta.webpackHot.accept()
  if (__VUE_HMR_RUNTIME__.updatePageData) {
    __VUE_HMR_RUNTIME__.updatePageData(data)
  }
}

if (import.meta.hot) {
  import.meta.hot.accept(({ data }) => {
    __VUE_HMR_RUNTIME__.updatePageData(data)
  })
}
