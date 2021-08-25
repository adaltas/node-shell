import { Link } from "gatsby"
import React from "react"
import { css } from "glamor"
import {
  DEFAULT_WIDTH,
} from 'typography-breakpoint-constants'
import Button from "./Button"
import Menu from "./Menu"
import MenuIcon from "../images/menu.svg"
import BugIcon from "../images/bug.svg"
import GitIcon from "../images/git.svg"
import LogoIcon from "../images/logo-icon.svg"

const styles = {
  root: {
    background: "#1F2735",
    boxShadow: '0 0 2px #ffffff',
    width: "100%",
    position: "sticky",
    top: 0,
    zIndex: 100,
    "> div": {
      padding: ".5rem 1rem",
      maxWidth: `${DEFAULT_WIDTH}`,
      margin: "0 auto",
      boxSizing: "content-box",
      display: "flex",
      alignItems: "center",
    },
    "& *": {
      verticalAlign: "middle",
    },
  },
  icons: {
    display: "contents",
    "& a": {
      color: "white",
      marginLeft: "1rem",
      "@media (max-width: 400px)": {
        padding: "0rem .5rem",
      },
    },
  },
  logo: {
    flex: "1 1 auto",
    // paddingLeft: ".7rem",
    '& a': {
      color: "white",
      textDecoration: "none",
      fontSize: "1.8rem",
    },
    '& span': {
      paddingLeft: ".7rem",
    },
    '& img': {
      width: '2rem',
    },
    "@media (max-width: 769px)": {
      textAlign: "center",
    },
    "@media (max-width: 400px)": {
      fontSize: "1.3rem",
    },
  },
  menu: {
    padding: ".7rem",
    // width: "1.5rem",
    "@media (min-width: 769px)": {
      display: "none",
    },
  },
}

const Header = ({
  isHome,
  menus,
  onMenuClick,
  siteTitle, 
}) => {
  return (
    <header css={styles.root}>
      <div>
        <div css={styles.menu}>
          <Button
            onClick={onMenuClick}
            aria-label="Toggle the menu"
            data-for="header-tooltip"
            data-tip="Toggle the menu"
            ripple={true}
          >
            <img src={MenuIcon} alt="Bug tool" />
          </Button>
        </div>
        <div css={styles.logo}>
          <Link to="/">
            <img
              src={LogoIcon}
              alt="Shell.js Parameters"
              className={css(styles.logoIcon)}
            />
            <span>{siteTitle}</span>
          </Link>
        </div>
        <Menu
          isHome={isHome}
          menus={menus}
        />
        <div className={css(styles.icons)}>
          <a
            href="https://github.com/adaltas/node-shell/issues"
          >
            <img src={BugIcon} alt="Bug tool" />
          </a>
          <a
            href="https://github.com/adaltas/node-shell"
          >
            <img src={GitIcon} alt="GitHub" />
          </a>
        </div>
      </div>
    </header>
  )
}

export default Header
