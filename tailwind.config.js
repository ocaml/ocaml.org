const defaultTheme = require("tailwindcss/defaultTheme");
const colors = require('tailwindcss/colors')

module.exports = {
  mode: "jit",
  purge: ["**/*.eml", "lib/odoc_thtml/*.ml"],
  darkMode: false,
  theme: {
    extend: {
      typography: theme => ({
        DEFAULT: {
          css: {
            pre: {
              color: theme("colors.grey.900"),
              backgroundColor: theme("colors.grey.100")
            },
            // "pre code::before": {
            //   "padding-left": "unset"
            // },
            // "pre code::after": {
            //   "padding-right": "unset"
            // },
            code: {
              backgroundColor: theme("colors.grey.100"),
              "border-radius": "0.25rem"
            },
            ".spec": {
              "code::before": {
                content: '""',
                "padding-left": "0.25rem"
              },
              "code::after": {
                content: '""',
                "padding-right": "0.25rem"
              },
              'tbody td': {
                paddingTop: 0,
                paddingRight: 0,
                paddingBottom: 0,
                paddingLeft: 0,
              },
              'tbody tr': {
                borderBottomWidth: '0',
              },
            }
          },
        },
      }),
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
