import React from "react"
import {
  DEFAULT_WIDTH,
} from 'typography-breakpoint-constants'

const styles = {
  root: {
    padding: '2rem',
    '& > div': {
      maxWidth: `${DEFAULT_WIDTH}`,
      margin: "0 auto",
    },
  },
  full: {
    '& > div': {
      maxWidth: 'inherit',
    },
  },
}

export default ({
  classes={},
  children,
  full,
}) => (
  <section css={[styles.root, full && styles.full, classes.root]}>
    <div css={classes.children}>{children}</div>
  </section>
)
