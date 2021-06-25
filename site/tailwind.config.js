module.exports = {
  mode: "jit",
  purge: {
    // Specify the paths to all of the template files in your project
    content: [
      './pages/**/*.res',
      './src/*.res'
    ],
    options: {
      whitelist: ["html", "body"],
    }
  },
  theme: {
    extend: {
      colors: {
        'ocamlorange': '#c15540',
        graylight: '#f5f5f5',
        orangedark: '#ed7109',
        orangedarker: '#dd6705',
        yellowdark: '#ffb800',
        // TODO: remove these after highlighting is improved
        grayforty: '#979AAD',
        graytwenty: '#CDCDD6',
        graysixty: '#727489',
        berry: '#B151DD',
        turtle: '#02A875',
        turtledark: '#388B72',
        water: '#5E5EDE',
        orange: '#DD8C1B',
        berryforty: '#A766D0',
        waterdark: '#637CC1',
      },
      backgroundImage: (theme) => ({
        'news-bg': "url('/static/news-bg.jpeg')",
      }),
      fontFamily: {
        // TODO: define more fallback fonts and possibly rename to "serif"
        'roboto': ['"Roboto Slab"', 'serif']
      },
      spacing: {
        // Note: this was introduced to accommodate a large image height
        '160': '40rem',
      }
    },
    /* We override the default font-families with our own default prefs
    fontFamily: {
      'sans':['-apple-system', 'BlinkMacSystemFont', 'Helvetica Neue', 'Arial', 'sans-serif'],
      'serif': ['Georgia', '-apple-system', 'BlinkMacSystemFont', 'Helvetica Neue', 'Arial', 'sans-serif'],
      'mono': [ 'Menlo', 'Monaco', 'Consolas', 'Roboto Mono', 'SFMono-Regular', 'Segoe UI', 'Courier', 'monospace']
    }, */
  },
  variants: {
    // width: ['responsive']
  },
  plugins: [
    require('@tailwindcss/typography')
  ]
}
