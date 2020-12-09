import React, { Component } from "react"
import PropTypes from "prop-types"
import { css } from "glamor"

const riple_styles = {
  ripple: {
    top: 0,
    left: 0,
    width: "100%",
    height: "100%",
    display: "block",
    position: "absolute",
    overflow: "hidden",
    zIndex: 0,
    pointerEvents: "none",
  },
  child: {
    transform: "scale(.0)",
    opacity: 0.5,
    display: "block",
    width: "100%",
    height: "100%",
    borderRadius: "50%",
    backgroundColor: "#000",
  },
  active: {
    transform: "scale(1)",
    transition: "transform 150ms cubic-bezier(0.4, 0, 0.2, 1)",
  },
}

class Ripple extends Component {
  state = {
    active: false,
  }
  start(event) {
    this.child.current.classList.add(css(riple_styles.active).toString())
    this.startTimer = setTimeout(() => {
      this.child.current.classList.remove(css(riple_styles.active).toString())
    }, 200)
  }
  stop(event, callback) {
    this.child.current.classList.remove(css(riple_styles.active).toString())
    if (callback) callback()
  }
  constructor(props) {
    super(props)
    this.child = React.createRef()
    this.start = this.start.bind(this)
    this.stop = this.stop.bind(this)
  }
  render() {
    const styles = riple_styles
    return (
      <span css={[styles.ripple, this.state.active && styles.active]}>
        <span ref={this.child} css={styles.child} />
      </span>
    )
  }
}

const styles = {
  base: {
    display: "inline-flex",
    position: "relative",
    alignItems: "center",
    verticalAlign: "middle",
    justifyContent: "center",
    flex: "0 0 auto",
    padding: 0,
    fontSize: "1.5rem",
    textAlign: "center",
    textDecoration: "none",
    backgroundColor: "transparent",
  },
  button: {
    cursor: "pointer",
    ":disabled": {
      cursor: "default",
    },
    border: 0,
    margin: 0,
    ":focus": {
      outline: "none",
    },
  },
  link: {},
  label: {
    width: "100%",
    display: "flex",
    alignItems: "inherit",
    justifyContent: "inherit",
  },
}

class Button extends Component {
  handleBlur(event) {}
  handleFocus(event) {}
  handleKeyDown(event) {}
  handleKeyUp(event) {
    const key = event.key
    if (key === "space" || key === "enter") {
      event.persist()
      const { ripple } = this.props
      if (ripple) {
        this.ripple.current.stop(event, () => {
          this.ripple.current.start(event)
        })
      }
    }
  }
  handleMouseDown(event) {
    event.persist()
    const { ripple } = this.props
    if (ripple) {
      this.ripple.current.stop(event, () => {
        this.ripple.current.start(event)
      })
    }
  }
  handleMouseLeave(event) {}
  handleMouseUp(event) {}
  handleTouchMove(event) {}
  handleTouchEnd(event) {}
  handleTouchStart(event) {
    event.persist()
    const { ripple } = this.props
    if (ripple) {
      this.ripple.current.stop(event, () => {
        this.ripple.current.start(event)
      })
    }
  }
  constructor(props) {
    super(props)
    this.state = { isMobile: false }
    this.ripple = React.createRef()
  }
  componentDidMount() {
    if (window.innerWidth < this.props.breakpoint) {
      this.setState({ isMobile: true })
    }
  }
  render() {
    const {
      children,
      disabled,
      title,
      tabIndex,
      href,
      role,
      className,
      ripple,
      userStyles,
      ...props
    } = this.props
    userStyles.base = { ...styles.base, ...userStyles.base }
    userStyles.button = { ...styles.button, ...userStyles.button }
    userStyles.link = { ...styles.link, ...userStyles.link }
    userStyles.label = { ...styles.label, ...userStyles.label }
    const Component = href ? "a" : "button"
    const componentProps = {
      title: title,
      tabIndex: tabIndex,
    }
    if (href) {
      componentProps.href = href
      componentProps.role = role
    } else {
      componentProps.type = "button"
      componentProps.disabled = disabled
    }
    return (
      <Component
        onBlur={this.handleBlur.bind(this)}
        onFocus={this.handleFocus.bind(this)}
        onKeyDown={this.handleKeyDown.bind(this)}
        onKeyUp={this.handleKeyUp.bind(this)}
        onMouseDown={this.handleMouseDown.bind(this)}
        onMouseLeave={this.handleMouseLeave.bind(this)}
        onMouseUp={this.handleMouseUp.bind(this)}
        onTouchEnd={this.handleTouchEnd.bind(this)}
        onTouchMove={this.handleTouchMove.bind(this)}
        onTouchStart={this.handleTouchStart.bind(this)}
        css={[userStyles.base, href ? userStyles.link : userStyles.button]}
        className={className}
        {...componentProps}
        {...props}
      >
        <span css={userStyles.label}>{children}</span>
        {ripple && <Ripple ref={this.ripple} />}
      </Component>
    )
  }
}

Button.propTypes = {
  // disabled: PropTypes.boolean,
  role: PropTypes.string,
  tabIndex: PropTypes.number,
}

Button.defaultProps = {
  role: "button",
  tabIndex: 0,
  userStyles: {},
  // disabled: false,
}

export default Button
