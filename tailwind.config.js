const defaultTheme = require("tailwindcss/defaultTheme")

// From Figma https://www.figma.com/file/bSwyo5pUnarg1lquxQxWAE/Design-Systen-Draft?type=design&node-id=180-470&t=h3IswxPLyvXGSsMl-0
const figma_colors = {
    // Primary Light
    primary: "#D54000",
    primary_40: "#D5400066",
    primary_25: "#D5400040",
    primary_dark: "#842800",

    // Secondary Light
    secondary: "#067065",
    secondary_25: "#06706540",
    secondary_bt_hover: "#004039",

    // Tertiary Light
    tertiary: "#2B7866",
    tertiary_lighter: "#D3D5F9",
    tertiary_25: "#0E2A4940",
    tertiary_bt_hover: "#111827",

    // Text Light
    text_title: "#111827",
    text_content: "#555659",
    white: "#FFFFFF",
    separator_30: "#0000004D",

    dark: {
      primary: "#C24F1E",
      primary_40: "#D5400066",
      primary_20: "#D5400033",

      secondary: "#067065",
      secondary_bt_hover: "#004039",
      secondary_bt_pressed: "#00231F",

      tertiary: "#0E2A49",
      tertiary_lighter: "#007BC7",
      tertiary_bt_hover: "#111827",
      tertiary_bt_pressed: "#020C22",

      text: "#FFFFFF",
      grey_navigation: "#868686",

      separator_30: "#0000004D",
      background: "#222222",
      background_light: "#333232",
    }
}

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
            a: {
              color: "#EE6A1A",
              textDecoration: "none",
            },
            'a:hover': {
              textDecoration: "underline",
            }
          }]
        },
      },
      boxShadow:{
        '3xl':'rgba(0, 0, 0, 0.35) 0px 5px 15px',
      },
      maxWidth: {
        '8xl': '90rem',
      },
      fontFamily: {
        sans: ["Inter var", ...defaultTheme.fontFamily.sans],
        mono: ["Roboto Mono", ...defaultTheme.fontFamily.mono]
      },
      outline: {
        primary: "2px solid #EE6A1A"
      },
      colors: {
        legacy: {
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
        ...figma_colors,
      },
      textColor: {
        legacy: {
          // FIXME: remove everything in this section when it is no longer used
          default: "#1A202C",
          "lighter": "#4b5563",

          dark: {
            "default": "#666",
          },
        }
      },
      backgroundColor: {
        legacy: {
          // FIXME: remove everything in this section when it is no longer used
          default: "white",
          "mild-contrast": "#FAF8F3",
          "contrast": "#14294b", // one of the colors from the dark blue contrast patterned background used in various parts of the site

          "search-keyboard-cursor": "#0C3B8C", // background for cursor highlighting in keyboard navigable areas (e.g. package search dropdown)
          "search-term-highlight": "rgb(221, 232, 251)",
          "learn-area-orange": "#C34711",

          "text-title": "#111827",
          "search-result-background-blue":"#00308F",

          body: {
            600: "#1A202C",
          },

          dark: {
            default: "#222",
            "mild-contrast": "#171717",
          },
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
        },

        code: {
          background: "rgba(30, 30, 30, 1)",
        },
      },
      boxShadow: {
        'custom': '0 4px 8px rgba(213, 64, 0, 0.5)'
      }
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
