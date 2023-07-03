const defaultTheme = require("tailwindcss/defaultTheme")

const colors = require('tailwindcss/colors') // FIXME: remove when finally obsolete


module.exports = {
  content: ["**/*.eml"],
  darkMode: 'class',
  theme: {
    screens: {
      'sm': '40em',
      'md': '48em',
      'lg': '64em',
      'xl': '80em',
    },
    textColor: {
      // Light mode

      default: "#1A202C",
      "lighter": colors.gray["600"],

      /* FIXME: these should be inlined on home.eml
         since they only occur there */
      code: {
        blue: "rgba(86, 156, 214, 1)",
        yellow: "rgba(220, 220, 170, 1)",
        comment: "rgba(255, 255, 255, 0.6)",
        red: "rgba(252, 129, 129, 1)",
      },

      // Dark mode
      dark: {
        "default": "#666",

        /* TODO: add dark mode colors here when new ones are needed, should
           usually correspond closely to the light mode color names, but not
           necessarily always */
      },

      // FIXME: remove everything below here when it has been replaced

      white: "white",
      primary: {
        700: "#DC5402",
        600: "#EE6A1A",
      },

      gray: {
        400: colors.gray["400"],
      },
      blue: {
        500: colors.blue["500"],
      }
    },
    backgroundColor: {
      default: "white",
      "mild-contrast": "#FAF8F3",
      "contrast": "#14294b", // one of the colors from the dark blue contrash patterned background used in various parts of the site

      "search-keyboard-cursor": "#0C3B8C", // background for cursor highlighting in keyboard navigable areas (e.g. package search dropdown)
      "search-term-highlight": "rgb(221, 232, 251)",

      transparent: "transparent",

      avatar: {
        0: "#bb452a",
        1: "#a35829",
        2: "#926229",
        3: "#746e29",
        4: "#367a28",
        5: "#2a7a54",
        6: "#2c786d",
        7: "#2e7587",
        8: "#336db7",
        9: "#6855e3",
        10: "#ad35bc",
        11: "#c62d69"
      },

      code: {
        background: "rgba(30, 30, 30, 1)",
      },

      // Dark mode

      dark: {
        default: "#222",
        "mild-contrast": "#171717",

        /* TODO: add dark mode colors here when new ones are needed, should
           usually correspond closely to the light mode color names, but not
           necessarily always */
      },

      // FIXME: remove everything below here when it has been replaced
      body: {
        600: "#1A202C",
      },

      primary: {
        800: "#CD4E00",
        700: "#DC5402",
        600: "#EE6A1A",
        100: "rgba(238, 106, 26, 0.1)",
      },

      ...colors,
    },
    extend: {
      typography: {
        DEFAULT: {
          css: [{
            'code::before': {
              content: '""',
            },
            'code::after': {
              content: '""',
            },
          },{
            h1: {
              fontWeight: 700,
            },
            code: {
              fontSize: "1em",
            },
            'h2 code': {
              fontSize: "1em",
            },
            'h3 code': {
              fontSize: "1em",
            },
          }]
        },
      },
      maxWidth: {
        '8xl': '90rem',
      },
      fontFamily: {
        sans: ["Inter var", ...defaultTheme.fontFamily.sans],
        mono: ["Roboto Mono", ...defaultTheme.fontFamily.mono],
      },
      outline: {
        primary: "2px solid #EE6A1A"
      },
      colors: {
        primary: {
          800: "#CD4E00",
          700: "#DC5402",
          600: "#EE6A1A",
          300: "rgba(238, 106, 26, 0.48)",
          200: "rgba(238, 106, 26, 0.15)",
          100: "rgba(238, 106, 26, 0.1)",
        },
        code: {
          blue: "rgba(86, 156, 214, 1)",
          yellow: "rgba(220, 220, 170, 1)",
          comment: "rgba(255, 255, 255, 0.6)",
          red: "rgba(252, 129, 129, 1)",
          background: "rgba(30, 30, 30, 1)",
        },
        sucess: {
          100: "rgba(142, 233, 60, 0.1)",
          600: "rgba(142, 233, 60, 1)",
        },
        global: {
          default: "rgba(250, 248, 243, 1)",
        },
        divider: {
          8: "rgba(26, 32, 44, 0.08)",
          12: "rgba(26, 32, 44, 0.12)",
          16: "rgba(26, 32, 44, 0.16)",
        },
      },
    },
  },
  plugins: [
    require("@tailwindcss/forms"),
    require("@tailwindcss/typography"),
    require("@tailwindcss/aspect-ratio"),
  ],
  safelist: [
    'bg-avatar-0',
    'bg-avatar-1',
    'bg-avatar-2',
    'bg-avatar-3',
    'bg-avatar-4',
    'bg-avatar-5',
    'bg-avatar-6',
    'bg-avatar-7',
    'bg-avatar-8',
    'bg-avatar-9',
    'bg-avatar-10',
    'bg-avatar-11',
  ]
};
