
import Typography from 'typography'
import color from 'color'
import {
  // MIN_TABLET_MEDIA_QUERY,
  // MOBILE_MEDIA_QUERY,
} from 'typography-breakpoint-constants'

// Notes
// The standard line height is 1.5 (https://every-layout.dev/layouts/stack/)
// The standard spacing between blocks (marginTop) is 1.5rem (https://every-layout.dev/layouts/stack/)

const theme = {
  baseFontSize: '18px',
  linkColor: '#947EFF',
  linkHoverColor: '#BDB1F7',
  baseLineHeight: 1.666,
  bodyColor: 'rgba(0,0,0,0.84)',
  bodyFontFamily: ['Inter', 'sans-serif'],
  // headerColor: 'rgba(255,255,255,0.95)',
  headerColor: 'rgba(0,0,0,1)',
  headerWeight: 'normal',
  headerFontFamily: ['Inter', 'sans-serif'],
  overrideStyles: ({ adjustFontSizeTo, rhythm, scale }, options, rules) => {
    for(const k of Object.keys(rules)){
      if(!/^\w/.test(k) || ['html', 'body'].includes(k)){
        continue
      }
      rules[`main ${k}`] = rules[k]
      rules[k] = {}
    }
    console.log('===', color(options.linkColor).whiten(0.5).rgb().toString())
    return {
      'body': {
        background: '#171B24',
        color: '#E2E4F0',
      },
      'ul, li': {
        margin: '0',
        padding: '0',
      },
      'a': {
        color: '#fff',
        textDecoration: 'none',
      },
      'main h1, main h2, main h3': {
        color: '#E2E4F0',
      },
      'main pre': {
        boxShadow: '0 0 2px #ffffff',
      },
      'main a': {
        color: `${options.linkColor}`,
        textDecoration: 'none',
      },
      'main a:hover': {
        color: `${options.linkHoverColor}`,
      },
      'main a code[class*="language-"]': {
        color: `${color(options.linkColor).whiten(0.5).rgb().toString()}`,
      },
      'main a:hover code[class*="language-"]': {
        color: `${color(options.linkColor).whiten(0.8).rgb().toString()}`,
      },
      'main code[class*="language-"], main pre[class*="language-"]': {
        fontFamily: 'Fira Mono !important',
      },
      'main :not(pre) > code[class*="language-"]': {
        padding: '.2em .3em .2em .3em',
        backgroundColor: 'rgba(0,0,0,.2)',
        wordWrap: 'inherit',
      },
      'main pre[class*="language-"]': {
        marginBottom: `${rhythm(1)}`
      }
    }
  },
}

const typography = new Typography(theme)

export default typography
