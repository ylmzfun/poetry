import comp from "/Users/ylmzfun/Documents/study/note/poetry/docs/.vuepress/.temp/pages/国学/index.html.vue"
const data = JSON.parse("{\"path\":\"/%E5%9B%BD%E5%AD%A6/\",\"title\":\"📚 国学经典汇编\",\"lang\":\"zh-CN\",\"frontmatter\":{},\"git\":{},\"filePathRelative\":\"国学/README.md\"}")
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
