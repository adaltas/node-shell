const path = require("path")
const { createFilePath } = require(`gatsby-source-filesystem`)

exports.onCreateNode = ({ node, getNode, actions }) => {
  const { createNodeField } = actions
  if (node.internal.type === `MarkdownRemark`) {
    slug = createFilePath({ node, getNode, basePath: `pages` })
    edit_url =
      "https://github.com/adaltas/node-shell/edit/master/docs/" +
      path.relative(__dirname, node.fileAbsolutePath)
    createNodeField({
      node,
      name: `slug`,
      value: slug,
    })
    createNodeField({
      node,
      name: `edit_url`,
      value: edit_url,
    })
  }
}

exports.createPages = ({ actions, graphql }) => {
  const { createPage } = actions

  const pageTemplate = path.resolve(`src/templates/page.js`)

  return graphql(`
    {
      allMarkdownRemark(sort: {frontmatter: {sort: DESC}}, limit: 1000) {
        edges {
          node {
            frontmatter {
              title
              navtitle
              keywords
            }
            fields {
              edit_url
              slug
            }
          }
        }
      }
    }
  `).then(result => {
    if (result.errors) {
      return Promise.reject(result.errors)
    }

    result.data.allMarkdownRemark.edges.forEach(({ node }) => {
      createPage({
        path: node.fields.slug,
        component: pageTemplate,
        context: {}, // additional data can be passed via context
      })
    })
  })
}
