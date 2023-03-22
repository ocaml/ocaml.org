const defaultTheme = require("tailwindcss/defaultTheme")

module.exports = {
  content: ["**/*.eml"],
  darkMode: 'class',
  theme: {
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
        background: {
          default: "#FAF8F3",
          beige: "#FAF8F3",
          "mid-blue": "#0C3B8C", // background for cursor highlighting in keyboard navigable areas (e.g. package search dropdown)
          "dark-blue": "#0e1531", // one of the colors from the blue patterned background used in various parts of the site
          "light-blue": "rgb(221, 232, 251)",
        },
        body: {
          700: "#0A0C11",
          600: "#1A202C",
          400: "rgba(26, 32, 44, 0.64);",
          100: "rgba(26, 32, 44, 0.16)",
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
        }
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
