import React from "react"
import { graphql } from "gatsby"
import Layout from "../components/Layout"
import Section from "../components/Section"
import Seo from "../components/Seo"
import IconToc from "../images/icon-toc.svg"
import IconEdit from "../images/icon-edit.svg"
import {
  DEFAULT_WIDTH,
} from 'typography-breakpoint-constants'

const styles = {
  content: {
    '& h1': {
      lineHeight: '2.2rem',
      marginRight: '5rem',
      "@media (max-width: 768px)": {
        marginRight: '2.2rem',
      },
    },
    '& .toc': {
      display: 'none',
      marginLeft: 'calc(-50vw + 50%)',
      marginRight: 'calc(-50vw + 50%)',
      borderTop: '1px solid #4d596d',
      borderBottom: '1px solid #4d596d',
      background: 'rgba(0,0,0,.1)',
      // background: 'rgba(255,255,255,.2)',
      paddingTop: '1.666rem',
      marginBottom: '1.666rem',
      '> h2, > ul': {
        maxWidth: `${DEFAULT_WIDTH}`,
        marginRight: "auto",
        marginLeft: "auto",
        '> li': {
          
          marginLeft: '1.666rem',
        }
      }
    }
  },
  tools: {
    float: 'right',
    // position: "relative",
    // "> div": {
    //   position: "absolute",
    //   textAlign: "right",
    //   width: "100%",
    // },
    '> *': {
      verticalAlign: 'middle',
    }
  },
  toc: {
    border: 'none',
    padding: 0,
    width: '30px',
    height: '30px',
    background: `url(${IconToc})`,
    opacity: 0.5,
    ':hover': {
      opacity: .8,
      cursor: 'pointer',
    },
    // "@media (max-width: 768px)": {
    //   display: 'none',
    // },
  },
  edit: {
    display: 'inline-block',
    border: 'none',
    padding: 0,
    marginLeft: '1rem',
    width: '30px',
    height: '30px',
    background: `url(${IconEdit})`,
    outline: 'none',
    opacity: 0.5,
    ':hover': {
      opacity: .8,
      cursor: 'pointer',
    },
  }
}

export default function Template({ data }) {
  const { markdownRemark } = data // data.markdownRemark holds our post data
  const { frontmatter, html, fields } = markdownRemark
  const contentRef = React.createRef()
  const toggleToc = () => {
    const tocNode = contentRef.current.querySelector(".toc")
    if (!tocNode) return
    const display = window.getComputedStyle(tocNode).display
    tocNode.style.display = display === "none" ? "block" : "none"
  }
  return (
    <Layout page={{ ...frontmatter, ...fields }}>
      <Seo
        title={frontmatter.title}
        description={frontmatter.description}
        keywords={frontmatter.keywords}
      />
      <Section>
        <div css={styles.tools}>
          <button
            color="inherit"
            aria-label="Table of content"
            data-for="content-tooltip"
            data-tip="Table of content"
            onClick={toggleToc}
            css={styles.toc}
          />
          {fields.edit_url && (
            <a
              target="_blank"
              rel="noreferrer"
              href={fields.edit_url}
              aria-label="Edit the content"
              data-for="edit"
              data-tip="Edit the content"
              css={styles.edit}
            />
          )}
        </div>
        <div
          ref={contentRef}
          css={styles.content}
          dangerouslySetInnerHTML={{ __html: html }}
        />
      </Section>
    </Layout>
  )
}

export const pageQuery = graphql`
  query($path: String!) {
    markdownRemark(fields: { slug: { eq: $path } }) {
      html
      frontmatter {
        title
        keywords
        description
      }
      fields {
        edit_url
        slug
      }
    }
  }
`
