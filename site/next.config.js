const bsconfig = require('./bsconfig.json');

const transpileModules = ["bs-platform"].concat(bsconfig["bs-dependencies"]);
const withTM = require("next-transpile-modules")(transpileModules);

const config = {
  target: "serverless",
  pageExtensions: ["jsx", "js"],
  transpileModules: ["bs-platform"].concat(bsconfig["bs-dependencies"]),
  env: {
    ENV: process.env.NODE_ENV,
  },
  webpack: (config, options) => {
    const { isServer } = options;
    if (!isServer) {
      // We shim fs for things like the blog slugs component
      // where we need fs access in the server-side part
      config.node = {
        fs: 'empty'
      }
    }
    return config
  },
  // Might need to move this to nginx or other config,
  // if deployment moves from Vercel to Netlify
  async redirects() {
    return [
      // Temporary redirects

      {
        source: '/play/homeround',
        destination: 'https://play.tailwindcss.com/LGDZzOzegQ?layout=preview',
        permanent: false,
      },


      {
        source: '/play/community/aroundweb',
        destination: 'https://play.tailwindcss.com/BxXxU2gs9A?layout=preview',
        permanent: false,
      },
      {
        source: '/play/community/blogarchive',
        destination: 'https://play.tailwindcss.com/NIX2Uw9VXX?layout=preview',
        permanent: false,
      },
      {
        source: '/play/community/mailinglists',
        destination: 'https://play.tailwindcss.com/LUUSP3fDwB?layout=preview',
        permanent: false,
      },
      {
        source: '/play/community/meetings',
        destination: 'https://play.tailwindcss.com/ERceV8Ryxv?layout=preview',
        permanent: false,
      },
      {
        source: '/play/community/ocamlworkshop',
        destination: 'https://play.tailwindcss.com/QWDWzrqLCw?layout=preview',
        permanent: false,
      },
      {
        source: '/play/community/ocamlworkshoparchive',
        destination: 'https://play.tailwindcss.com/OdONb93XWX?layout=preview',
        permanent: false,
      },
      {
        source: '/play/community/opportunities',
        destination: 'https://play.tailwindcss.com/66ITkwvaJN?layout=preview',
        permanent: false,
      },
      {
        source: '/play/community/news',
        destination: 'https://play.tailwindcss.com/86WOUMz2SR?layout=preview',
        permanent: false,
      },
      {
        source: '/play/community/newsarchive',
        destination: 'https://play.tailwindcss.com/DAVx1bUei3?layout=preview',
        permanent: false,
      },


      {
        source: '/play/industry/users',
        destination: 'https://play.tailwindcss.com/fnsSlFX517?layout=preview',
        permanent: false,
      },
      {
        source: '/play/industry/whatisocaml',
        destination: 'https://play.tailwindcss.com/X?layout=preview',
        permanent: false,
      },
      {
        source: '/play/industry/successstories',
        destination: 'https://play.tailwindcss.com/X?layout=preview',
        permanent: false,
      },


      {
        source: '/play/resource/mediaarchive',
        destination: 'https://play.tailwindcss.com/SaRPEIdpPS?layout=preview',
        permanent: false,
      },
      {
        source: '/play/resource/tutorials',
        destination: 'https://play.tailwindcss.com/TZiQsbetpO?layout=preview',
        permanent: false,
      },
      {
        source: '/play/resource/books',
        destination: 'https://play.tailwindcss.com/tSiJwFvjEn?layout=preview',
        permanent: false,
      },
      {
        source: '/play/resource/archive',
        destination: 'https://play.tailwindcss.com/Y1ABhSzyna?layout=preview',
        permanent: false,
      },
      {
        source: '/play/resource/cheatsheets',
        destination: 'https://play.tailwindcss.com/CjMUTbKXO7?layout=preview',
        permanent: false,
      },
      {
        source: '/play/resource/paperarchive',
        destination: 'https://play.tailwindcss.com/wngTIsLJL2?layout=preview',
        permanent: false,
      },
      {
        source: '/play/resource/releases',
        destination: 'https://play.tailwindcss.com/8wOb8r1ICV?layout=preview',
        permanent: false,
      },
      {
        source: '/play/resource/releases/4.11.1',
        destination: 'https://play.tailwindcss.com/X?layout=preview',
        permanent: false,
      },
      {
        source: '/play/resource/releases/4.11.0',
        destination: 'https://play.tailwindcss.com/X?layout=preview',
        permanent: false,
      },
      {
        source: '/play/resource/applications',
        destination: 'https://play.tailwindcss.com/b4yHGsAz3s?layout=preview',
        permanent: false,
      },
      {
        source: '/play/resource/installocaml',
        destination: 'https://play.tailwindcss.com/Lh6y69JyIN?layout=preview',
        permanent: false,
      },


      {
        source: '/play/privacypolicy',
        destination: 'https://play.tailwindcss.com/QJdesMclar?layout=preview',
        permanent: false,
      },
      {
        source: '/play/about',
        destination: 'https://play.tailwindcss.com/FIney8bfu3?layout=preview',
        permanent: false,
      },
      {
        source: '/play/governance',
        destination: 'https://play.tailwindcss.com/3zJkikgEgR?layout=preview',
        permanent: false,
      },
      {
        source: '/play/compiler/license',
        destination: 'https://play.tailwindcss.com/eFSxVyoq4r?layout=preview',
        permanent: false,
      },
      {
        source: '/play/consortium',
        destination: 'https://play.tailwindcss.com/oiGQaNMMKP?layout=preview',
        permanent: false,
      },


      /* page sub-components */
      {
        source: '/play/header',
        destination: 'https://play.tailwindcss.com/n8u5qc7Ax7?layout=preview',
        permanent: false,
      },

      /* awaiting next version
      {
        source: '/play/footer',
        destination: 'https://play.tailwindcss.com/sDvt5fPLI1?layout=preview',
        permanent: false,
      }, 
      */



      // Permanent redirects
      {
        source: '/releases/latest',
        destination: '/releases/4.11.1',
        permanent: false,
      }
    ]
  }
};

module.exports = withTM(config);

