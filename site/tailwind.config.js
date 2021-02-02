module.exports = {
  future: {
    removeDeprecatedGapUtilities: true,
    purgeLayersByDefault: true,
  },
  purge: {
    // Specify the paths to all of the template files in your project
    content: [
      './components/**/*.res',
      './pages/**/*.res',
      './layouts/**/*.res',
      './res_pages/**/*.res',
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
        orangedarker: '#dd6705'
      },
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
  plugins: []
}
