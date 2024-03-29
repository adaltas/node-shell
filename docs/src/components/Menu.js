import { Link } from "gatsby"
import React from "react"

const styles = {
  menu: {
    marginRight: '2rem',
    zIndex: 100,
    '& a': {
      color: "#fff",
      ':hover': {
        color: '#58CC85',
      },
    },
    '& a.active': {
      color: "#947EFF !important",
    },
    "& > ul": {
      maxWidth: "800",
      margin: "auto",
      "& > li": {
        '> a:after': {
          content: '" "',
          display: 'inline-block',
          verticalAlign: 'middle',
          marginLeft: '6px',
          marginRight: '-14px',
          width: 0,
          height: 0,
          borderLeft: '4px solid transparent',
          borderRight: '4px solid transparent',
          borderTop: '5px solid #fff',
        },
        '> a': {
          padding: '0.1rem 0',
          ':hover': {
            color: '#58CC85',
          },
        },
        '&:hover ul': {
          display: 'block',
          '& li': {
            display: "block",
            '& a': {
              '&:hover': {
                background: '#323C4F',
              },
            },
            padding: "0",
          },
        },
        position: "relative",
        display: "inline-block",
        "& a": {
          display: 'block',
          padding: ".3rem 1.2rem",
          whiteSpace: 'nowrap',
          fontSize: '1rem',
          textDecoration: "none",
        },
      },
    },
    "@media (max-width: 768px)": {
      display: "none",
    },
  },
  dropdownMenu: {
    display: "none",
    position: "absolute",
    background: "#1f2735",
    // padding: "1rem 1.5rem", 
    paddign: 0,
    border: "1px solid #ffffff",
    borderRadius: '2px',
    right: 0,
    top: '100%',
    zIndex: 200,
  },
}

const Menu = ({
  menus
}) => {
  return (
    <div css={styles.menu}>
      <ul>
        {menus.children.map((menu, i) => {
          return (
            <li key={i}>
              <Link
                key={menu.data.slug}
                to={menu.data.slug}
                activeClassName='active'
              >
                {menu.data.navtitle || menu.data.title}
              </Link>
              {menu.children != null &&
                <ul css={styles.dropdownMenu}>
                  {menu.children.map((subMenu, j) => {
                    return (
                      <li key={`${i}-${j}`}>
                        <Link
                          key={subMenu.data.slug}
                          to={subMenu.data.slug}
                          activeClassName='active'
                        >
                          {subMenu.data.navtitle || subMenu.data.title}
                        </Link>
                      </li>
                    )
                  })}
                </ul>
              }
            </li>
          )
        })}
      </ul>
    </div>
  )
}

export default Menu
