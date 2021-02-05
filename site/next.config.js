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
        source: '/play/community/aroundweb',
        destination: 'https://play.tailwindcss.com/982oYEIzGZ?layout=preview',
        permanent: false,
      },
      {
        source: '/play/industry/users',
        destination: 'https://play.tailwindcss.com/THm4jFAMbz?layout=preview',
        permanent: false,
      },
      {
        source: '/play/homeround',
        destination: 'https://play.tailwindcss.com/LGDZzOzegQ?layout=preview',
        permanent: false,
      },
      {
        source: '/play/media',
        destination: 'https://play.tailwindcss.com/SaRPEIdpPS?layout=preview',
        permanent: false,
      },
      {
        source: '/play/paperarchive',
        destination: 'https://play.tailwindcss.com/wngTIsLJL2?layout=preview',
        permanent: false,
      },
      {
        source: '/play/header',
        destination: 'https://play.tailwindcss.com/n8u5qc7Ax7?layout=preview',
        permanent: false,
      },
      /* awaiting next version
      {
        source: '/play/home',
        destination: 'https://play.tailwindcss.com/WKH4f4k0L2?layout=preview',
        permanent: false,
      }, 
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

