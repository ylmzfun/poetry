import { defaultTheme } from '@vuepress/theme-default'
import { defineUserConfig } from 'vuepress'
import { viteBundler } from '@vuepress/bundler-vite'

export default defineUserConfig({
  lang: 'zh-CN',
  title: '古文辞章汇编',
  description: '传承中华文化经典',
  
  bundler: viteBundler(),
  
  theme: defaultTheme({
    // 导航栏
    navbar: [
      {
        text: '首页',
        link: '/',
      },
      {
        text: '🌸 诗词',
        children: [
          '/诗词/先秦两汉/',
          '/诗词/魏晋南北朝/',
          '/诗词/唐诗/',
          '/诗词/词/',
          '/诗词/宋诗/',
          '/诗词/元曲/',
          '/诗词/明清/',
          '/诗词/箴言家训/',
        ],
      },
      {
        text: '📝 序记',
        link: '/序记/',
      },
      {
        text: '📜 表疏',
        link: '/表疏/',
      },
      {
        text: '🎭 赋辞',
        link: '/赋辞/',
      },
      {
        text: '🏛️ 铭碑',
        link: '/铭碑/',
      },
      {
        text: '📚 国学',
        children: [
          '/国学/四书/',
          '/国学/五经/',
          '/国学/诸子百家/',
          '/国学/史学典籍/',
          '/国学/蒙学读物/',
        ],
      },
    ],

    // 侧边栏
    sidebar: {
      '/诗词/': [
        {
          text: '🌸 诗词类',
          children: [
            '/诗词/先秦两汉/',
            '/诗词/魏晋南北朝/',
            '/诗词/唐诗/',
            '/诗词/词/',
            '/诗词/宋诗/',
            '/诗词/元曲/',
            '/诗词/明清/',
            '/诗词/箴言家训/',
          ],
        },
      ],
      '/序记/': [
        {
          text: '📝 序记类',
          children: [
            '/序记/兰亭集序.md',
            '/序记/滕王阁序.md',
            '/序记/岳阳楼记.md',
            '/序记/醉翁亭记.md',
            '/序记/小石潭记.md',
            '/序记/游褒禅山记.md',
            '/序记/石钟山记.md',
            '/序记/师说.md',
            '/序记/马说.md',
            '/序记/捕蛇者说.md',
            '/序记/六国论.md',
            '/序记/朋党论.md',
            '/序记/权书（选）.md',
            '/序记/永州八记（选）.md',
            '/序记/北山移文.md',
            '/序记/吊古战场文.md',
            '/序记/墨池记.md',
            '/序记/祭十二郎文.md',
            '/序记/送董邵南序.md',
          ],
        },
      ],
      '/表疏/': [
        {
          text: '📜 表疏类',
          children: [
            '/表疏/前出师表.md',
            '/表疏/后出师表.md',
            '/表疏/陈情表.md',
            '/表疏/谏太宗十思疏.md',
            '/表疏/答司马谏议书.md',
            '/表疏/与陈伯之书.md',
          ],
        },
      ],
      '/赋辞/': [
        {
          text: '🎭 赋辞类',
          children: [
            '/赋辞/前赤壁赋.md',
            '/赋辞/后赤壁赋.md',
            '/赋辞/洛神赋.md',
            '/赋辞/归田赋.md',
            '/赋辞/子虚赋.md',
            '/赋辞/上林赋.md',
            '/赋辞/两都赋.md',
            '/赋辞/二京赋.md',
            '/赋辞/别赋.md',
            '/赋辞/哀江南赋.md',
            '/赋辞/枯树赋.md',
            '/赋辞/秋声赋.md',
          ],
        },
      ],
      '/铭碑/': [
        {
          text: '🏛️ 铭碑类',
          children: [
            '/铭碑/陋室铭.md',
            '/铭碑/潮州韩文公庙碑.md',
          ],
        },
      ],
      '/国学/': [
        {
          text: '📚 国学经典',
          children: [
            {
              text: '📜 四书',
              children: [
                '/国学/四书/大学.md',
                '/国学/四书/中庸.md',
                '/国学/四书/论语.md',
                '/国学/四书/孟子.md',
              ],
            },
            {
              text: '📋 五经',
              children: [
                '/国学/五经/诗经.md',
                '/国学/五经/尚书.md',
                '/国学/五经/礼记.md',
                '/国学/五经/周易.md',
                '/国学/五经/春秋.md',
              ],
            },
            {
              text: '🌿 诸子百家',
              children: [
                '/国学/诸子百家/老子.md',
                '/国学/诸子百家/庄子.md',
              ],
            },
            {
              text: '📚 史学典籍',
              children: [
                '/国学/史学典籍/史记.md',
              ],
            },
            {
              text: '🎓 蒙学读物',
              children: [
                '/国学/蒙学读物/三字经.md',
                '/国学/蒙学读物/千字文.md',
                '/国学/蒙学读物/百家姓.md',
              ],
            },
          ],
        },
      ],
    },

    // 仓库
    repo: 'https://github.com/ylmzfun/poetry',
    
    // 编辑链接
    editLink: false,
    
    // 最后更新时间
    lastUpdated: true,
    lastUpdatedText: '最后更新',
    
    // 贡献者
    contributors: false,
  }),
})