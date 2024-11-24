module.exports = {
  siteMetadata: {
    title: "Shell.js",
    description:
      "A powerful and expressive tool for building CLI applications with Node.js.",
    author: "@adaltas",
  },
  plugins: [
    "gatsby-transformer-sharp",
    "gatsby-plugin-sharp",
    {
      resolve: "gatsby-plugin-manifest",
      options: {
        name: "gatsby-starter-default",
        short_name: "starter",
        start_url: "/",
        background_color: "#1F2735",
        theme_color: "#1F2735",
        display: "minimal-ui",
        icon: "src/images/logo-icon.png", // This path is relative to the root of the site.
      },
    },
    {
      resolve: "gatsby-plugin-emotion",
      options: {
        // Accepts the following options, all of which are defined by `@emotion/babel-plugin` plugin.
        // The values for each key in this example are the defaults the plugin uses.
        sourceMap: process.env.NODE_ENV === "production" ? false : true,
        autoLabel: "never", // 'dev-only' ∣ 'always' ∣ 'never'
        labelFormat: "[local]",
        cssPropOptimization: true,
      },
    },
    // this (optional) plugin enables Progressive Web App + Offline functionality
    // To learn more, visit: https://gatsby.dev/offline
    // 'gatsby-plugin-offline',
    {
      resolve: "gatsby-source-filesystem",
      options: {
        path: `${__dirname}/content`,
        name: "markdown-pages",
      },
    },
    {
      resolve: "gatsby-transformer-remark",
      options: {
        gfm: true,
        plugins: [
          {
            resolve: "gatsby-remark-snippet-url-prepare",
            options: {},
          },
          {
            resolve: "gatsby-remark-embed-snippet",
            options: {
              directory: `${__dirname}/../samples/`,
            },
          },
          {
            resolve: "gatsby-remark-prismjs",
            options: {
              classPrefix: "language-",
              aliases: {},
              showLineNumbers: false,
              inlineCodeMarker: "±",
              prompt: {
                user: "whoami",
                host: "localhost",
                global: false,
              },
            },
          },
          {
            resolve: "gatsby-remark-snippet-url",
            options: {
              message: "View source file: {{FILE}}",
              url: "https://github.com/adaltas/node-shell/blob/master/samples/{{FILE}}",
            },
          },
          {
            resolve: "gatsby-remark-autolink-headers",
            options: {
              offsetY: "24", // <600: 48; >600:64
              icon: `<svg aria-hidden="true" height="20" version="1.1" viewBox="0 0 16 16" width="20"><path fill-rule="evenodd" fill="#fff" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg>`,
            },
          },
          {
            resolve: "gatsby-remark-title-to-frontmatter",
          },
        ],
      },
    },
    {
      resolve: "gatsby-plugin-typography",
      options: {
        pathToConfigModule: "src/utils/typography.js",
        omitGoogleFont: true,
      },
    },
  ],
};
