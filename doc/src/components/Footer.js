import { Link } from "gatsby"
import PropTypes from "prop-types"
import React from "react"
import Section from "../components/Section"
import {
  TABLET_MEDIA_QUERY,
} from 'typography-breakpoint-constants'

const styles = {
  root: {
    background: `#101319`,
  },
  children: {
    display: 'flex',
    flexWrap: "wrap",
    "& ul, & p": {
      margin: 0,
    },
    "& li": {
      margin: 0,
      textIndent: 0,
      listStyleType: 'none',
      '& a:hover': {
        color: '#7ec699',
      }
    },
  },
  navigate: {
    flex: "1",
    [TABLET_MEDIA_QUERY]: {
      flex: "0 0 50%",
    },
  },
  contribute: {
    flex: "1",
    [TABLET_MEDIA_QUERY]: {
      flex: "0 0 50%",
    },
  },
  about: {
    flex: "2",
    [TABLET_MEDIA_QUERY]: {
      flex: "0 0 100%",
    },
  },
}

const Footer = () => (
  <Section
    tag="footer"
    classes={{
      children: styles.children,
      root: styles.root,
    }}
  >
    <div css={styles.navigate}>
      <h2>Navigate</h2>
      <ul>
        <li>
          <Link to="/usage/tutorial/">Getting started</Link>
        </li>
        <li>
          <Link to="/api/">API</Link>
        </li>
        <li>
          <Link to="/config/">Configuration</Link>
        </li>
      </ul>
    </div>
    <div css={styles.contribute}>
      <h2>Contribute</h2>
      <ul>
        <li>
          <a href="https://github.com/adaltas/node-parameters/">
            GitHub
          </a>
        </li>
        <li>
          <a href="https://github.com/adaltas/node-parameters/issues/">
            Issue Tracker
          </a>
        </li>
        <li>
          <Link to="/project/license/">MIT License</Link>
        </li>
      </ul>
    </div>
    <div css={styles.about}>
      <h2>About</h2>
      <p>
        Node.js Parameters is&nbsp;the tool for building CLI applications with Node.js.
      </p>
    </div>
  </Section>
)

Footer.propTypes = {
  siteTitle: PropTypes.string,
}

Footer.defaultProps = {
  siteTitle: ``,
}

export default Footer
