const defaultTheme = require("tailwindcss/defaultTheme")
const colors = require('tailwindcss/colors')

module.exports = {
  mode: "jit",
  purge: ["**/*.eml"],
  darkMode: false,
  theme: {
    extend: {
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
        ...colors,
        primary: {
          800: "#CD4E00",
          700: "#DC5402",
          600: "#EE6A1A",
          300: "rgba(238, 106, 26, 0.48)",
          100: "rgba(238, 106, 26, 0.1)",
        },
        background: {
          default: "#FAF8F3",
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
      },
    },
  },
  variants: {
    backgroundColor: ['hover, active'],
    extend: {},
  },
  plugins: [
    require("@tailwindcss/forms"),
    require("@tailwindcss/typography"),
    require("@tailwindcss/aspect-ratio"),
  ],
};
