
import React from 'react'
import {
  DEFAULT_WIDTH,
} from 'typography-breakpoint-constants'

const styles = {
  'root': {
    marginLeft: 'calc(-50vw + 50%)',
    marginRight: 'calc(-50vw + 50%)',
    borderTop: '1px solid #4d596d',
    borderBottom: '1px solid #4d596d',
    background: 'rgba(0,0,0,.1)',
    // background: 'rgba(255,255,255,.2)',
    padding: '1.666rem 1rem 0 1rem',
    marginBottom: '1.666rem',
    '> ul': {
      maxWidth: `${DEFAULT_WIDTH}`,
      marginRight: "auto",
      marginLeft: "auto",
      '> li': {
        marginLeft: '1.2rem',
      }
    }
  }
}

const Toc = ({
  classes,
  headings,
}) => (
  <div css={[styles.root, classes.root]}>
    <ul>
    {
      headings.map( (heading) => (
        <li key={heading.id}>
          <a href={`#${heading.id}`}>{heading.value}</a>
        </li>
      ))
    }
    </ul>
  </div>
)

export default Toc
