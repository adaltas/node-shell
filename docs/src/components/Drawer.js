import React, { PureComponent } from "react"
import Modal from "react-modal"
import { css } from "glamor"

/*
Breakpoints
Based on [typography-breakpoint-constants](https://github.com/KyleAMathews/typography.js/blob/master/packages/typography-breakpoint-constants/src/index.js)
*/

const breakpoints = {
  LARGER_DISPLAY: 1600,
  LARGE_DISPLAY: 1280,
  DEFAULT: 980,
  TABLET: 768,
  MOBILE: 480,
}

/*

* breakpoint: window size when to switch between the temporary and permanent display

* userStyles.main
* userStyles.body
* userStyles.overlay

*/

class Drawer extends PureComponent {
  styles = {
    body: {
      width: "100%",
      overflowY: "hidden",
    },
    main: {
      position: "relative",
      margin: 0,
      paddingLeft: 250,
      [`@media (max-width: ${breakpoints.DEFAULT}px)`]: {
        paddingLeft: 0,
      },
    },
    mainClose: {
      paddingLeft: 0,
      left: 0,
    },
    mainOpen: {
      [`@media (min-width: ${breakpoints.DEFAULT}px)`]: {
        paddingLeft: "250px",
        transition: "padding-left 225ms cubic-bezier(0.0, 0, 0.2, 1)",
      },
      [`@media (max-width: ${breakpoints.DEFAULT}px)`]: {
        left: 250,
        transition: "left 225ms cubic-bezier(0.0, 0, 0.2, 1)",
      },
    },
    drawer: {
      position: "fixed",
      top: 0,
      height: "100vh",
      left: 0,
      width: 250,
      overflow: "auto",
      "> *": {
        overflow: "auto",
      },
      [`@media (max-width: ${breakpoints.DEFAULT}px)`]: {
        left: "-250px",
      },
    },
    drawerClose: {
      left: "-250px",
    },
    drawerOpen: {
      left: 0,
      transition: "left 225ms cubic-bezier(0.0, 0, 0.2, 1)",
      ".ReactModal__Content--after-open": {
        left: 0,
        transition: "left 225ms cubic-bezier(0.0, 0, 0.2, 1)",
      },
    },
    drawerOpenModal: {},
    overlay: {
      position: "fixed",
      top: 0,
      left: 0,
      right: 0,
      bottom: 0,
      backgroundColor: "rgba(0, 0, 0, .6)",
    },
  }

  constructor(props) {
    super(props)
    this.state = { isMobile: false }
    this.mainRef = React.createRef()
  }
  componentDidMount() {
    if (window.innerWidth < this.props.breakpoint) {
      this.setState({ isMobile: true })
    }
  }
  render() {
    const { styles } = this
    const { isMobile } = this.state
    const isWindow = typeof window !== `undefined`
    const { drawer, main, open, width } = this.props
    const userStyles = this.props.styles || {}
    const getWidth = function(width) {
      let w = width
      if (typeof w === "number") w = w + "px"
      if (typeof w === "undefined") w = "250px"
      if (isMobile) w = 250
      return w
    }
    const w = getWidth(width)
    this.styles.main.paddingLeft = open ? w : 0
    this.styles.mainOpen[
      `@media (min-width: ${breakpoints.DEFAULT}px)`
    ].paddingLeft = w
    this.styles.mainOpen[
      `@media (max-width: ${breakpoints.DEFAULT}px)`
    ].left = w
    this.styles.drawer.left = open ? 0 : "-" + w
    this.styles.drawer.width = w
    this.styles.drawer[`@media (max-width: ${breakpoints.DEFAULT}px)`].left =
      "-" + w
    this.styles.drawerClose.left = "-" + w
    return (
      <>
        <div
          ref={this.mainRef}
          className={css([
            styles.main,
            userStyles.main,
            isWindow && open && styles.mainOpen,
            isWindow && !open && styles.mainClose,
          ]).toString()}
        >
          {main}
        </div>
        {isWindow && isMobile ? (
          <Modal
            isOpen={open}
            onRequestClose={this.props.onClickModal}
            aria={{
              labelledby: "Menu",
              describedby: "Navigate through the site",
            }}
            appElement={this.mainRef.current}
            className={css([
              styles.drawer,
              userStyles.drawer,
              isWindow && open && styles.drawerOpen,
              isWindow && !open && styles.drawerClose,
            ]).toString()}
            overlayClassName={css([
              styles.overlay,
              userStyles.overlay,
            ]).toString()}
            bodyOpenClassName={css([styles.body, userStyles.body]).toString()}
          >
            {drawer}
          </Modal>
        ) : (
          <div
            className={css([
              styles.drawer,
              isWindow && open && styles.drawerOpen,
              isWindow && !open && styles.drawerClose,
            ]).toString()}
          >
            {drawer}
          </div>
        )}
      </>
    )
  }
}

Drawer.defaultProps = {
  breakpoint: 980,
}

export default Drawer
