
const fs = require('fs').promises
const mm = require('micromatch')
const toText = require('hast-util-to-text')

module.exports = async (
  { markdownNode, markdownAST, reporter },
  { include = [] }
) => {
  if(include.length > 0){
    const filePath = markdownNode.fileAbsolutePath
      .split(process.cwd())
      .pop()
      .replace(/^\//, '')
    // Skip node if not included
    if (!mm.isMatch(filePath, include)) { return }
  }
  if(!markdownNode.frontmatter.noTitleToFrontmatter){
    if(markdownAST.children.length && markdownAST.children[0].type === 'heading' && markdownAST.children[0].depth === 1){
      if(!markdownNode.frontmatter.title){
        markdownNode.frontmatter.title = toText(markdownAST.children[0])
      }
      markdownAST.children.shift()
    }
  }
}

const countFrontMatterLines = async (node) => {
  const content = await fs.readFile(node.fileAbsolutePath, 'utf8')
  const lines = content.split(/\r\n|[\n\r\u0085\u2028\u2029]/g)
  let count = 0
  if(lines[0].trim().substr(0, 3) === '---'){
    for(let i=0; i<lines.length; i++){
      if(i === 0){
        continue
      }else if(lines[i].trim() === '---'){
        count = i + 1
        break
      }
    }
  }
  return count
}
