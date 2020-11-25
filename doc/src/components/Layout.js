import React, { Component, Fragment } from "react"
import PropTypes from "prop-types"
import { StaticQuery, graphql } from "gatsby"
import Header from "./Header"
import Footer from "./Footer"
import Drawer from "./Drawer"
import MenuMobile from "./MenuMobile"
require("prismjs/themes/prism-tomorrow.css")
require("typeface-roboto")

const styles = {
  main: {
    // boxSizing: "content-box",
    // paddingTop: "0px !important",
    // "& .toc": {
    //   display: "none",
    //   "& h2": {
    //     marginTop: 0,
    //   },
    //   "& ul": {
    //     marginTop: 0,
    //     marginBottom: 0,
    //   },
    // },
    // "& h1": {
    //   maxWidth: "80%",
    // },
    '& section:nth-child(odd)': {
      background: '#323C4F',
    },
    '& section:nth-child(even)': {
      background: '#1F2735',
    },
  },
}

class Layout extends Component {
  constructor(props) {
    super(props)
    this.toggle = this.toggle.bind(this)
    this.state = {
      open: false,
      breakpoint: 769,
    }
  }
  componentDidMount() {
    if (this.props.intro) {
      this.setState({ open: false })
    } else if (window.innerWidth < this.state.breakpoint) {
      this.setState({ open: false })
    }
  }
  toggle() {
    this.setState({ open: !this.state.open })
  }
  render() {
    const { props } = this
    const toggle = this.toggle
    const { children, isHome, data } = props
    const pages = data.pages.edges.map(page => {
      return { ...page.node.fields, ...page.node.frontmatter }
    })
    const menus = { children: {} }
    pages.forEach(page => {
      const slugs = page.slug.split('/').filter(part => part)
      let parentMenu = menus
      slugs.forEach(slug => {
        if (!parentMenu.children[slug])
          parentMenu.children[slug] = { data: {}, children: {} }
        parentMenu = parentMenu.children[slug]
      })
      parentMenu.data = {
        id: slugs.join('/'),
        title: page.title,
        navtitle: page.navtitle,
        slug: page.slug,
        sort: page.sort || 99,
      }
    })
    return (
      <Drawer
        breakpoint={this.state.breakpoint}
        open={this.state.open}
        onClickModal={() => this.setState({ open: false })}
        width={"23%"}
        main={
          <Fragment>
            <Header
              onMenuClick={toggle}
              siteTitle={data.site.siteMetadata.title}
              isHome={isHome}
              menus={menus}
            />
            <main css={ styles.main }>
              {children}
            </main>
            <Footer />
          </Fragment>
        }
        drawer={<MenuMobile menus={menus} />}
      />
    )
  }
}

Layout.propTypes = {
  children: PropTypes.node.isRequired,
}

const WrappedLayout = props => (
  <StaticQuery
    query={graphql`
      query SiteTitleQuery {
        site: site {
          siteMetadata {
            title
          }
        }
        pages: allMarkdownRemark(
          sort: { order: ASC, fields: [frontmatter___sort] }
          limit: 1000
        ) {
          edges {
            node {
              frontmatter {
                title
                sort
                navtitle
              }
              fields {
                edit_url
                slug
              }
            }
          }
        }
      }
    `}
    render={data => <Layout data={data} {...props} />}
  />
)

export default WrappedLayout
