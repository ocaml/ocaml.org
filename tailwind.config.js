const defaultTheme = require("tailwindcss/defaultTheme");
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
        ocamlorange: '#c15540',
        graylight: '#f5f5f5',
        orangedark: '#ed7109',
        orangedarker: '#dd6705',
        yellowdark: '#ffb800',
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
