import React, {useState} from "react"
import { graphql } from "gatsby"
import Layout from "../components/Layout"
import Section from "../components/Section"
import Seo from "../components/Seo"
import Toc from "../components/Toc"
import IconToc from "../images/icon-toc.svg"
import IconEdit from "../images/icon-edit.svg"

const styles = {
  content: {
    '& h1': {
      lineHeight: '2.2rem',
      marginRight: '5rem',
      "@media (max-width: 768px)": {
        marginRight: '2.2rem',
      },
    },
  },
  toc: {
    display: 'none',
  },
  tocVisible: {
    display: '',
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
  toolsToc: {
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
  },
  toolsEdit: {
    display: 'inline-block',
    border: 'none',
    padding: 0,
    marginLeft: '1rem',
    width: '30px',
    height: '30px',
    background: `url(${IconEdit})`,
    outline: 'none',
    opacity: 0.5,
    '& span': {
      display: 'none'
    },
    ':hover': {
      opacity: .8,
      cursor: 'pointer',
    },
  }
}

const Page = ({
  data: {
    markdownRemark: {
      fields, frontmatter, headings, html
    }
  }
}) => {
  const [ tocVisible, setTocVisible ] = useState(false)
  const toggleToc = () => {
    setTocVisible(!tocVisible)
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
            css={styles.toolsToc}
          />
          {fields.edit_url && (
            <a
              target="_blank"
              rel="noreferrer"
              href={fields.edit_url}
              aria-label="Edit on GitHub"
              data-for="edit"
              data-tip="Edit the content"
              css={styles.toolsEdit}
            ><span>Edit on GitHub</span></a>
          )}
        </div>
        <h1>{frontmatter.title}</h1>
        <Toc
          headings={headings}
          classes={{root: [styles.toc, tocVisible && styles.tocVisible]}}
        />
        <div
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
      headings {
        value
        depth
        id
      }
    }
  }
`

export default Page
