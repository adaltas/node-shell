import React, { Component, Fragment } from "react"
import { Link } from "gatsby"
import { css } from "glamor"

const styles_nav = {
  root: {
    " ul": {
      marginBottom: 0,
    },
    "> ul": {
      marginLeft: 0,
    }
  },
  link: {
    display: "inline-block",
    margin: ".2rem 0",
  },
  linkActive: {
    fontWeight: 'bold',
    borderBottom: "2px solid #947EFF",
  },
}

const styles = {
  root: {
    fontWeight: 300,
    height: "100%",
    background: "#101319",
    "@media (min-width: 960px)": {
      display: "flex",
      flexDirection: "column",
    },
    " a": {
      color: "#FFFFFF",
    },
  },
  menu: {
    flexGrow: 1,
    overflow: "auto",
    display: "block",
    height: "calc(100% - 80px)",
    padding: "1.5rem 1rem",
    "&:after": {
      content: " ",
      display: "block",
      height: "2rem",
    },
  },
  footer: {
    height: "80px",
    boxShadow: '0 0 2px #a5b7d240',
    padding: "1rem",
    textAlign: "normal",
    fontSize: ".8rem",
    position: "absolute",
    bottom: "0",
    color: "#fff",
    background: "#101319",
    " a": {
      textDecoration: "underline",
    },
  },
}

class Menu extends Component {
  render() {
    const { menus } = this.props
    return (
      <aside className={css(styles.root)}>
        <div className={css(styles.menu)}>
          <nav className={css(styles_nav.root)}>
            <ul>
              <li>
                <Link
                  to={"/"}
                  className={css(styles_nav.link)}
                  activeClassName={css(styles_nav.linkActive).toString()}
                >
                  Home
                </Link>
              </li>
              {Object.keys(menus.children).map(i => {
                const menu = menus.children[i]
                return (
                  <Fragment key={i}>
                    <li>
                      <Link
                        key={menu.data.slug}
                        to={menu.data.slug}
                        className={css(styles_nav.link)}
                        activeClassName={css(styles_nav.linkActive).toString()}
                      >
                        {menu.data.navtitle || menu.data.title}
                      </Link>
                    </li>
                    {menu.children != null &&
                      <li>
                        <ul>
                          {Object.keys(menu.children).map(j => {
                            const subMenu = menu.children[j]
                            return (
                              <li key={`${i}-${j}`}>
                                <Link
                                  key={subMenu.data.slug}
                                  to={subMenu.data.slug}
                                  className={css(styles_nav.link)}
                                  activeClassName={css(styles_nav.linkActive).toString()}
                                >
                                  {subMenu.data.navtitle || subMenu.data.title}
                                </Link>
                              </li>
                            )
                          })}
                        </ul>
                      </li>
                    }
                  </Fragment>
                )
              })}
            </ul>
          </nav>
        </div>
        <div className={css(styles.footer)}>
          Help us{" "}
          <a
            href="https://github.com/adaltas/node-parameters/issues"
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
