import { Link } from "gatsby"
import React, { Component } from "react"
import {
  TABLET_MEDIA_QUERY,
  MOBILE_MEDIA_QUERY,
} from 'typography-breakpoint-constants'
import LogoIcon from "../images/logo-icon.svg"
import GitIcon from "../images/git.svg"
import IconLicense from "../images/icon-license.svg"
import IconDocs from "../images/icon-docs.svg"
import IconSupport from "../images/icon-support.svg"

const styles = {
  root: {
    padding: '5rem 0 3rem',
    // marginLeft: 'calc(-50vw + 50%)',
    // marginRight: 'calc(-50vw + 50%)',
    position: "relative",
    textAlign: "center",
    background: "#1F2735",
    color: "#fff",
  },
  title: {
    '& span': {
      whiteSpace: 'nowrap',
      display: 'block',
    }
  },
  info: {
    display: 'flex',
    [TABLET_MEDIA_QUERY]: {
      display: 'block',
    },
    '& > div:first-child': {
      width: '40%',
      [TABLET_MEDIA_QUERY]: {
        width: '100%',
      },
    },
    '& > div:last-child': {
      width: '60%',
      [TABLET_MEDIA_QUERY]: {
        width: '100%',
      },
    }
  },
  logo: {
    textAlign: 'right',
    [TABLET_MEDIA_QUERY]: {
      textAlign: 'center',
    },
    '& img': {
      width: '40%',
      marginRight: '5rem',
      [TABLET_MEDIA_QUERY]: {
        marginRight: '0',
      },
    },
  },
  content: {
    textAlign: 'left',
    [TABLET_MEDIA_QUERY]: {
      textAlign: 'center',
    },
  },
  buttons: {
    marginBottom: '2rem',
  },
  button: {
    padding: '.5rem 2rem',
    lineHeight: '30px',
    textTransform: 'uppercase',
    textDecoration: 'none',
    borderRadius: '2rem',
    marginRight: '2rem',
    [TABLET_MEDIA_QUERY]: {
      margin: '0 .5rem',
    },
    [MOBILE_MEDIA_QUERY]: {
      padding: '.5rem 1rem',
    },
  },
  getstarted: {
    border: '2px solid #947EFF',
    background: '#947EFF',
    color: '#fff',
    '&:hover': {
      background: '#42367D',
      // background: 'rgba(255,255,255,.6)',
    },
  },
  github: {
    paddingLeft: '.5rem',
    border: '2px solid #fff',
    color: '#fff',
    '&:hover': {
      background: 'rgba(0,0,0,.3)',
    },
    '& img': {
      margin: '0 1rem 4px 0',
      width: '24px',
      verticalAlign: 'middle',
    }
  },
  badges: {
    '& a': {
      marginRight: '2rem',
    },
  },
  keys: {
    ' div': {
      display: 'inline-block',
      padding: '1rem 2rem',
      "> img": {
        width: "1.7rem",
        verticalAlign: "middle",
        margin: "0 .5rem",
      },
    },
  }
}

class Banner extends Component {
  render() {
    return (
      <div css={styles.root}>
        <div css={styles.info}>
          <div css={styles.logo}>
            <img
              src={LogoIcon}
              alt="Node.js Parameters"
            />
          </div>
          <div css={styles.content}>
            <h1 css={styles.title}>
              <span>The tool for building</span>
              {' '}
              <span>CLI applications with Node.js</span>
            </h1>
            <div css={styles.buttons}>
              <Link css={[styles.button, styles.getstarted]} to="/usage/tutorial/">
                Get started
              </Link>
              <a
                css={[styles.button, styles.github]}
                href="https://github.com/adaltas/node-parameters/"
              >
                <img src={GitIcon} alt="Github Node.js Parameters" />
                Github
              </a>
            </div>
            <div css={styles.badges}>
                <a
                  alt={"View this project on NPM"}
                  href={"https://www.npmjs.com/package/shell"}
                >
                  <img
                    alt={"NPM version"}
                    src={"https://img.shields.io/npm/v/shell.svg?style=flat"}
                  />
                </a>
                <a
                  alt={"GitHub actions"}
                  href={"https://github.com/adaltas/node-shell/actions"}
                >
                  <img
                    alt={"Travis build status"}
                    src={
                      "https://img.shields.io/github/checks-status/adaltas/node-shell/master?style=flat"
                    }
                  />
                </a>
            </div>
          </div>
        </div>
        <div css={styles.keys}>
          <div>
            <img src={IconSupport} alt="Supported"/>
            Supported
            </div>
          <div>
            <img src={IconDocs} alt="Documented"/>
            Documented
          </div>
          <div>
            <img src={IconLicense} alt="MIT License"/>
            MIT License
          </div>
        </div>
      </div>
    )
  }
}

export default Banner
