import React from "react"

import Layout from "../components/Layout"
import Seo from "../components/Seo"

const styles = {
  notfoundContainer: {
    textAlign: "center",
    height: "80vh",
  },
}

const IndexPage = () => (
  <Layout
    page={{
      title: "Page not found",
      description: "The requested page does not exist",
      keywords: "parameters, node.js, 404, not found",
    }}
  >
    <Seo title="NOT FOUND" keywords={[`gatsby`, `application`, `react`]} />
    <div>
      <section>
        <div css={styles.notfoundContainer}>
          <h2>NOT FOUND</h2>
          <p>You just hit a route that doesn't exist... the sadness.</p>
        </div>
      </section>
    </div>
  </Layout>
)

export default IndexPage
