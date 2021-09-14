const defaultTheme = require("tailwindcss/defaultTheme");

module.exports = {
  mode: "jit",
  purge: ["**/*.eml"],
  darkMode: false, // or 'media' or 'class'
  theme: {
    extend: {
      colors: {
        'ocamlorange': '#c15540',
        graylight: '#f5f5f5',
        orangedark: '#ed7109',
        orangedarker: '#dd6705',
        yellowdark: '#ffb800',
      },
      fontFamily: {
        sans: ["Inter var", ...defaultTheme.fontFamily.sans],
      },
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