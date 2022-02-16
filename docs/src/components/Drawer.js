import React, { Fragment, useEffect, useRef, useState } from 'react'
import Modal from 'react-modal'
import { ClassNames } from '@emotion/react'

/*
* breakpoint: window size when to switch between the temporary and permanent display

* userStyles.main
* userStyles.body
* userStyles.overlay

*/

const getStyles = (breakpoint) => {return {
  body: {
    position: 'relative',
    width: '100vw',
    height: '100vh',
    overflowY: 'hidden',
  },
  main: {
    position: 'relative',
    margin: 0,
  },
  mainClose: {
    paddingLeft: 0,
    left: 0,
  },
  mainOpen: {
    position: 'absolute',
    width: '100%',
    // overflow: 'hidden',
    [`@media (min-width: ${breakpoint}px)`]: {
      paddingLeft: '250px',
      transition: 'padding-left 225ms cubic-bezier(0.0, 0, 0.2, 1)',
    },
    [`@media (max-width: ${breakpoint}px)`]: {
      left: 250,
      transition: 'left 225ms cubic-bezier(0.0, 0, 0.2, 1)',
    },
  },
  drawer: {
    // position: 'fixed',
    position: 'absolute',
    outline: 'none',
    top: 0,
    height: '100vh',
    width: 250,
    display: 'none',
    overflow: 'auto',
    backgroundColor: '#262839',
    borderRight: '1px solid #ffffff80',
    '> *': {
      overflow: 'auto',
    },
    [`@media (max-width: ${breakpoint}px)`]: {
      left: '-250px' /* to preserve animation */,
      display: 'initial',
    },
  },
  drawerClose: {
    left: '-250px',
  },
  drawerOpen: {
    left: 0,
    transition: 'left 225ms cubic-bezier(0.0, 0, 0.2, 1)',
    '.ReactModal__Content--after-open': {
      left: 0,
      transition: 'left 225ms cubic-bezier(0.0, 0, 0.2, 1)',
    },
  },
  drawerOpenModal: {},
  overlay: {
    zIndex: 200,
    position: 'fixed',
    top: 0,
    left: 0,
    right: 0,
    bottom: 0,
    backgroundColor: 'rgba(0, 0, 0, .6)',
  },
}}

const Drawer = ({
  breakpoint,
  drawer,
  main,
  onClickModal,
  open,
  styles: userStyles = {},
  width,
}) => {
  const [isMobile, setIsMobile] = useState(false)
  const mainRef = useRef()
  const isWindow = typeof window !== `undefined`
  // const userStyles = styles || {}
  const styles = getStyles(breakpoint)
  useEffect(() => {
    function handleResize() {
      const newIsMobile = window.innerWidth < breakpoint
      if (isMobile !== newIsMobile) {
        setIsMobile(newIsMobile)
      }
    }
    window.addEventListener('resize', handleResize);
    handleResize()
    return () => window.removeEventListener('resize', handleResize);
  }, [breakpoint, isMobile]);
  const getWidth = function(width) {
    let w = width
    if (typeof w === 'number') w = w + 'px'
    if (typeof w === 'undefined') w = '250px'
    if (isMobile) w = 250
    return w
  }
  const w = getWidth(width)
  if (w) {
    styles.mainOpen[`@media (min-width: ${breakpoint}px)`].paddingLeft = w
    styles.mainOpen[`@media (max-width: ${breakpoint}px)`].left = w
    styles.drawer.width = w
    styles.drawer[`@media (max-width: ${breakpoint}px)`].left = '-' + w
    styles.drawerClose.left = '-' + w
  }
  return (
    <ClassNames>
      {({ css, cx }) => (
        <Fragment>
          <div
            ref={mainRef}
            className={cx(css([
              styles.main,
              userStyles.main,
              isWindow && open && styles.mainOpen,
              isWindow && !open && styles.mainClose,
            ]))}
          >
            {main}
          </div>
          {isWindow && isMobile ? (
            <Modal
              isOpen={open}
              onRequestClose={onClickModal}
              aria={{
                labelledby: 'Menu',
                describedby: 'Navigate through the site',
              }}
              appElement={mainRef.current}
              className={cx(css([
                styles.drawer,
                userStyles.drawer,
                isWindow && open && styles.drawerOpen,
                isWindow && !open && styles.drawerClose,
              ]))}
              overlayClassName={cx(css([
                styles.overlay,
                userStyles.overlay,
              ]))}
              bodyOpenClassName={cx(css([styles.body, userStyles.body]))}
            >
              {drawer}
            </Modal>
          ) : (
            <div
              className={cx(css([
                styles.drawer,
                isWindow && open && styles.drawerOpen,
                isWindow && !open && styles.drawerClose,
              ]))}
            >
              {drawer}
            </div>
          )}
        </Fragment>
      )}
    </ClassNames>
  )
}

Drawer.defaultProps = {
  breakpoint: 980,
}

export default Drawer
