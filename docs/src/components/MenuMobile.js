import React, { Component, Fragment } from "react"
import { Link } from "gatsby"

const styles = {
  root: {
    fontWeight: 300,
    height: "100%",
    display: "flex",
    flexDirection: "column",
  },
  menu: {
    overflowY: "auto",
    background: "rgba(0,0,0,.4)",
    padding: '1rem 0',
    '& > nav > ul > li': {
      margin: '1rem 0'
    },
    '& a': {
      margin: ".2rem 0",
      padding: '0 1rem',
      display: 'block'
    },
    '& li li a': {
      padding: '0 1.5rem',
    },
    '& .active, & :hover.active': {
      // fontWeight: 'bold',
      // color: 'rgba(255,255,255,.8)',
      // color: 'rgba(0,0,0,.8)',
      // backgroundColor: "#947EFF",
      backgroundColor: 'rgba(255,255,255,.1)',
      color: "#947EFF",
      fontWeight: 'normal',
    },
    '& a:hover': {
      color: "#947EFF",
    },
  },
  footer: {
    boxShadow: '0 0 .4rem rgba(255,255,255,.1)',
    borderTop: '1px solid rgba(255,255,255,.3)',
    padding: "1rem",
    fontSize: ".8rem",
    bottom: "0",
    background: "rgba(0,0,0,.6)",
    "& a": {
      textDecoration: "underline",
    },
  },
}

class Menu extends Component {
  render() {
    const { menus } = this.props
    return (
        <aside css={styles.root}>
          <div css={styles.menu}>
            <nav>
              <ul>
                <li>
                  <Link to={"/"} activeClassName="active">
                    Home
                  </Link>
                </li>
                {menus.children.map((menu, i) => {
                  return (
                    <Fragment key={i}>
                      <li>
                        <Link to={menu.data.slug} activeClassName="active">
                          {menu.data.navtitle || menu.data.title}
                        </Link>
                        {menu.children != null &&
                          <ul>
                            {menu.children.map((subMenu, j) => {
                              return (
                                <li key={`${i}-${j}`}>
                                  <Link to={subMenu.data.slug} activeClassName="active">
                                    {subMenu.data.navtitle || subMenu.data.title}
                                  </Link>
                                </li>
                              )
                            })}
                          </ul>
                        }
                        </li>
                    </Fragment>
                  )
                })}
              </ul>
            </nav>
          </div>
          <div css={styles.footer}>
            Help us{" "}
            <a
              href="https://github.com/adaltas/node-shell/issues"
              target="_blank"
              rel="noreferrer"
            >
              improve the docs
            </a>{" "}
            by proposing enhancements and fixing typos.
          </div>
        </aside>
    )
  }
}

export default Menu
