const bsconfig = require('./bsconfig.json');

const transpileModules = ["bs-platform", "mdast-util-to-string"].concat(bsconfig["bs-dependencies"]);
const withTM = require("next-transpile-modules")(transpileModules);

const config = {
  webpack: (config, options) => {
    const { isServer } = options;
    if (!isServer) {
      // We shim fs for things like the blog slugs component
      // where we need fs access in the server-side part
      config.resolve.fallback = {
        fs: false
      }
    }
    config.experiments = {
      topLevelAwait: true,
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
      /* sub-components */
      {
        source: '/play/header',
        destination: 'https://play.tailwindcss.com/n8u5qc7Ax7?layout=preview',
        permanent: false,
      },



      {
        source: '/play/community/aroundweb',
        destination: 'https://play.tailwindcss.com/acoEG2wmOA?layout=preview',
        permanent: false,
      },
      {
        source: '/play/community/news',
        destination: 'https://play.tailwindcss.com/wu15fDmzPY?layout=preview',
        permanent: false,
      },


      {
        source: '/play/industry/users',
        destination: 'https://play.tailwindcss.com/fnsSlFX517?layout=preview',
        permanent: false,
      },

      {
        source: '/play/resources/mediaarchive',
        destination: 'https://play.tailwindcss.com/SaRPEIdpPS?layout=preview',
        permanent: false,
      },
      {
        source: '/play/resources/paperarchive',
        destination: 'https://play.tailwindcss.com/wngTIsLJL2?layout=preview',
        permanent: false,
      },
      {
        source: '/play/resources/language',
        destination: 'https://play.tailwindcss.com/3nuPDOZsGN?layout=preview',
        permanent: false,
      },
      {
        source: '/play/resources/applications',
        destination: 'https://play.tailwindcss.com/FJtzT7lSkW?layout=preview',
        permanent: false,
      },
      {
        source: '/play/resources/installocaml',
        destination: 'https://play.tailwindcss.com/m88PnynAmq?layout=preview',
        permanent: false,
      },


      // Permanent redirects
      /*
      {
        source: '/releases/latest',
        destination: '/releases/4.11.1',
        permanent: false,
      }
      */
    ]
  },
  future: {
    webpack5: true
  }
};

module.exports = withTM(config);

