const defaultTheme = require("tailwindcss/defaultTheme")
const colors = require('tailwindcss/colors')

module.exports = {
  mode: "jit",
  purge: ["**/*.eml", "lib/odoc_thtml/*.ml"],
  darkMode: false,
  theme: {
    extend: {
      fontFamily: {
        sans: ["Inter var", ...defaultTheme.fontFamily.sans],
      },
      colors: {
        orangedark: '#ed7109',
        orangedarker: '#dd6705',
        orange: colors.orange,
      }
    },
  },
  variants: {
    extend: {},
  },
  plugins: [
    require("@tailwindcss/forms"),
    require("@tailwindcss/typography"),
    require("@tailwindcss/aspect-ratio"),
  ],
};
