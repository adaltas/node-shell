import React from "react"
import { Link } from "gatsby"
import {
  MIN_TABLET_MEDIA_QUERY,
  TABLET_MEDIA_QUERY,
} from 'typography-breakpoint-constants'
import Layout from "../components/Layout"
import Seo from "../components/Seo"
import Banner from "../components/Banner"
import Section from "../components/Section"

// Syntax
import { PrismLight as SyntaxHighlighter } from 'react-syntax-highlighter'
import js from 'react-syntax-highlighter/dist/esm/languages/prism/javascript'
import bash from 'react-syntax-highlighter/dist/esm/languages/prism/coffeescript'
import tomorrow from 'react-syntax-highlighter/dist/esm/styles/prism/tomorrow'
SyntaxHighlighter.registerLanguage('javascript', js);
SyntaxHighlighter.registerLanguage('bash', bash);


const codeString1 = `
npm install shell
`.trim()

const codeString2 = `
git clone http://github.com/adaltas/node-shell.git
`.trim()

const feature1 = `
const shell = require("shell")
const app = shell({
  name: "myapp",
  description: "My CLI application",
  options: {
    "config": {
      shortcut: "c",
      description: "Some option"
    }
  },
  commands: {
    "start": {
      description: "Start something"
    }
  }
})
`.trim()

const feature2 = `
/* ... */
const args = app.parse()
console.log(args)

// Run \`node myapp -c value start\`
{ command: [ 'start' ], config: 'value' }
`.trim()

const feature3 = `
const shell = require("shell")
const app = shell({
  /* ... */
  commands: { "start":
    {
      /* ... */
      route: './routes/start.js'
    }
  }
})
app.route()

/* The project structure:
|-- /node-modules
|-- /routes
    |-- start.js
|-- myapp.js
|-- package.json
|-- package-lock.json
*/
`.trim()

const feature4 = `
// Run \`node myapp help\` 
NAME
    myapp - My CLI application

SYNOPSIS
    myapp [myapp options] <command>

OPTIONS
    -c --config             Some option
    -h --help               Display help information

COMMANDS
    start                   Start something
    help                    Display help information

EXAMPLES
    myapp --help            Show this message
    myapp help              Show this message
`.trim()


const styles = {
  descContainer: {
    maxWidth: '800px',
    margin: '0 auto',
    textAlign: 'center',
    marginBottom: '2rem',
  },
  section: {
    '& h2': {
      textAlign: "center",
    },
    '> div > div': {
      display: 'flex',
      justifyContent: 'space-between',
      marginBottom: '2rem',
      '& p': {
        margin: '1.2rem 0',
        '&:last-child': {
          textAlign: 'center',
        }
      },
      [TABLET_MEDIA_QUERY]: {
        flexDirection: 'column',
        marginBottom: '3rem',
        '& h3': {
          textAlign: 'center',
        },
      },
      [MIN_TABLET_MEDIA_QUERY]: {
        'h3': {
          marginTop: '.5rem',
        },
        '&:nth-of-type(odd)': {
          '& > div:nth-of-type(odd)': {
            width: "43%",
            order: 2,
          },
          '& > div:nth-of-type(even)': {
            width: "53%",
            order: 1,
          },
        },
      }
    },
  },
  button: {
    border: '1px solid #fff',
    color: '#fff',
    padding: '10px 30px',
    borderRadius: '3px',
    textDecoration: 'none',
    '&:hover': {
      background: 'rgba(255,255,255,.05)',
    }
  }
}

const IndexPage = () => (
  <Layout isHome={true}>
    <Seo
      title="Shell.js - argument parsing for Node.js CLI applications"
      keywords={[
        'shell', 'cli', 'arguments', 'parameters',
        'router', 'parse', 'stringify',
      ]}
    />
    <Banner />
    <div css={styles.homePage}>
      <Section classes={{root: styles.section}}>
        <h2>Why Shell.js?</h2>
        <div>
          <div>
            <h3>Configure your CLI app</h3>
            <div>
              <p>
                Shell.js is simple to configure. All it takes is a declarative
                object describing your application. Consider it like the model
                of your application. It is enriched by plugins such as to route
                commands and to generate help screens.
              </p>
              <p>
                <Link to='/config/' css={styles.button}>
                  Read more
                </Link>
              </p>
            </div>
          </div>
          <div>
            <SyntaxHighlighter language="javascript" style={tomorrow}>
              {feature1}
            </SyntaxHighlighter>
          </div>
        </div>
        <div>
          <div>
            <h3>Parse arguments</h3>
            <div>
              <p>For the handling and adding the functionality to the application operate with the `args` object returned with the method `parse`.</p>
              <p>
                <Link to='/api/parse/' css={styles.button}>
                  Read more
                </Link>
              </p>
            </div>
          </div>
          <div>
            <SyntaxHighlighter language="javascript" style={tomorrow}>
              {feature2}
            </SyntaxHighlighter>
          </div>
        </div>
        <div>
          <div>
            <h3>Organize the code with routing</h3>
            <div>
              <p>Load and configure the router in a separate top-level module.</p>
              <p>
                <Link to='/usage/routing/' css={styles.button}>
                  Read more
                </Link>
              </p>
            </div>
          </div>
          <div>
            <SyntaxHighlighter language="javascript" style={tomorrow}>
              {feature3}
            </SyntaxHighlighter>
          </div>
        </div>
        <div>
          <div>
            <h3>Auto generate help</h3>
            <div>
              <p>Shell.js convert the configuration object into a readable documentation string about how to use the CLI application or one of its commands.</p>
              <p>
                <Link to='/api/help/' css={styles.button}>
                  Read more
                </Link>
              </p>
            </div>
          </div>
          <div>
            <SyntaxHighlighter language="javascript" style={tomorrow}>
              {feature4}
            </SyntaxHighlighter>
          </div>
        </div>
      </Section>
      <Section>
        <div>
          <h2>Installing</h2>
          <p>
            The latest version of Shell.js is tested with Node.js 12, 14 and 16.
            New versions of Node.js shall work as well.
          </p>
          <p>Via npm:</p>
          <SyntaxHighlighter language="bash" style={tomorrow}>
            {codeString1}
          </SyntaxHighlighter>
          <p>
            Via git (or downloaded tarball), copy or link the project from a
            discoverable Node.js directory:
          </p>
          <SyntaxHighlighter language="bash" style={tomorrow}>
            {codeString2}
          </SyntaxHighlighter>
        </div>
      </Section>
    </div>
  </Layout>
)

export default IndexPage
