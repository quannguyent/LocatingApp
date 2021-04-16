'use strict';

const path = require('path');
const webpack = require('webpack');
const ManifestPlugin = require('webpack-manifest-plugin');
const CaseSensitivePathsPlugin = require('case-sensitive-paths-webpack-plugin');
const WatchMissingNodeModulesPlugin = require('react-dev-utils/WatchMissingNodeModulesPlugin');
const SWPrecacheWebpackPlugin = require('sw-precache-webpack-plugin');
const paths = require('./config/paths');
const getClientEnvironment = require('./config/env');

const withImages = require('next-images');
const withCss = require('@zeit/next-css');
const withSass = require('@zeit/next-sass')
const TerserPlugin = require("terser-webpack-plugin");
const { nextI18NextRewrites } = require('next-i18next/rewrites')
const MiniCssExtractPlugin = require('mini-css-extract-plugin');
const CssMinimizerPlugin = require('css-minimizer-webpack-plugin');

const withBundleAnalyzer = require('@next/bundle-analyzer')({
    enabled: process.env.ANALYZE === 'true',
})

const localeSubpaths = {
    en: 'en',
    vi: 'vi'
}

const nextConfigs = {
    rewrites: async () => nextI18NextRewrites(localeSubpaths),
    publicRuntimeConfig: {
        localeSubpaths,
    },
    env: {},
    useFileSystemPublicRoutes: false,
    sassOptions: {
        includePaths: [path.join(__dirname, 'public')],
    },
    // cssModules: true,
    // cssLoaderOptions: {
    //     importLoaders: 1,
    //     localIdentName: "[local]___[hash:base64:5]",
    // },
    webpack: (config, { isServer, buildId, dev }) => {

        if (!isServer && dev) {

            const publicPath = '/';
            
            const publicUrl = '';
            
            const env = getClientEnvironment(publicUrl);
            
            config.node = {
                dgram: 'empty',
                fs: 'empty',
                net: 'empty',
                tls: 'empty',
                child_process: 'empty'
            };

            process.env.PUBLIC_URL = publicPath;

            config.devtool = 'inline-source-map';
            
            config.performance = {
                hints: false
            };

            config.resolve = {
                modules: ['node_modules', paths.appNodeModules].concat(
                    // It is guaranteed to exist because we tweak it in `env.js`
                    process.env.NODE_PATH.split(path.delimiter).filter(Boolean)
                ),
                extensions: ['.web.js', '.js', '.json', '.web.jsx', '.jsx'],
                alias: {
                    Styles: path.resolve(__dirname, 'src/styles/'),
                    ...(config.resolve.alias || {}),
                   
                },
                plugins: [
                    
                ],
            }

            config.module.rules.push()

            config.plugins.push(
                // if (process.env.NODE_ENV === 'development') { ... }. See `./env.js`.
                new webpack.DefinePlugin(env.stringified),
                
                new CaseSensitivePathsPlugin(),
                
                new WatchMissingNodeModulesPlugin(paths.appNodeModules),
                
                new webpack.IgnorePlugin(/^\.\/locale$/, /moment$/),
            )

            config.optimization.namedModules = true;
        }

        if (!isServer && !dev) {
            
            const publicPath = paths.servedPath;
            
            const shouldUseSourceMap = process.env.GENERATE_SOURCEMAP === 'false';
            
            const publicUrl = publicPath.slice(0, -1);
            // Get environment variables to inject into our app.
            const env = getClientEnvironment(publicUrl);
            
            if (env.stringified['process.env'].NODE_ENV !== '"production"') {
                throw new Error('Production builds must have NODE_ENV=production.');
            }

            config.node = {
                dgram: 'empty',
                fs: 'empty',
                net: 'empty',
                tls: 'empty',
                child_process: 'empty',
            },

            // Don't attempt to continue if there are any errors.
            config.bail = true;
            
            config.devtool = shouldUseSourceMap ? 'source-map' : false;

            // config.entry = [require.resolve('./config/polyfills'), paths.appIndexJs];
            
            config.output = {
                path: paths.appBuild,
                filename: `static/${buildId}/js/[name].[chunkhash:8].js`,
                chunkFilename: `static/${buildId}/js/[name].[chunkhash:8].chunk.js`,
                publicPath: publicPath,
                devtoolModuleFilenameTemplate: info =>
                    path
                        .relative(paths.appSrc, info.absoluteResourcePath)
                        .replace(/\\/g, '/'),
            }

            config.resolve = {
                // mainFields: ['main'],
                modules: ['node_modules', paths.appNodeModules].concat(
                    process.env.NODE_PATH.split(path.delimiter).filter(Boolean)
                ),
                extensions: ['.wasm', '.mjs', '.web.js', '.js', '.json', '.web.jsx', '.jsx'],
                alias: {
                    ...(config.resolve.alias || {}),
                    // Styles: path.resolve(__dirname, 'src/styles/'),
                },
                plugins: [ ],
            }

            config.module.rules.push(
                
            );

            config.plugins.push(
                new webpack.DefinePlugin(env.stringified),
                // Minify the code.
                new TerserPlugin({
                    test: /\.m?js(\?.*)?$/i,
                    // chunkFilter: () => true,
                    // warningsFilter: () => true,
                    extractComments: false,
                    // sourceMap: true,
                    parallel: true,
                    include: undefined,
                    exclude: undefined,
                    minify: undefined,
                    terserOptions: {
                        output: {
                            comments: /^\**!|@preserve|@license|@cc_on/i
                        },
                        compress: {
                            arrows: false,
                            collapse_vars: false,
                            comparisons: false,
                            computed_props: false,
                            hoist_funs: false,
                            hoist_props: false,
                            hoist_vars: false,
                            inline: false,
                            loops: false,
                            negate_iife: false,
                            properties: false,
                            reduce_funcs: false,
                            reduce_vars: false,
                            switches: false,
                            toplevel: false,
                            typeofs: false,
                            booleans: true,
                            if_return: true,
                            sequences: true,
                            unused: true,
                            conditionals: true,
                            dead_code: true,
                            evaluate: true
                        },
                        mangle: {
                            safari10: true
                        }
                    }
                }),
                
                new ManifestPlugin({
                    fileName: 'manifest.json',
                }),
                
                new SWPrecacheWebpackPlugin({
                    
                    dontCacheBustUrlsMatching: /\.\w{8}\./,
                    filename: 'service-worker.js',
                    logger(message) {
                        if (message.indexOf('Total precache size is') === 0) {
                            // This message occurs for every build and is a bit too noisy.
                            return;
                        }
                        if (message.indexOf('Skipping static resource') === 0) {
                            // This message obscures real errors so we ignore it.
                            // https://github.com/facebookincubator/create-react-app/issues/2612
                            return;
                        }
                        console.log(message);
                    },
                    minify: true,
                    
                    navigateFallback: publicUrl + '/index.html',
                    
                    navigateFallbackWhitelist: [/^(?!\/__).*/],
                    
                    staticFileGlobsIgnorePatterns: [/\.map$/, /asset-manifest\.json$/],
                }),
                // Moment.js is an extremely popular library that bundles large locale files
                // by default due to how Webpack interprets its code. This is a practical
                // solution that requires the user to opt into importing specific locales.
                // https://github.com/jmblog/how-to-optimize-momentjs-with-webpack
                // You can remove this if you don't use Moment.js:
                new webpack.IgnorePlugin(/^\.\/locale$/, /moment$/),
            )

            config.optimization.minimizer.push(
                new CssMinimizerPlugin(),
            )
        }

        return config;
    },
    target: 'serverless'
}

module.exports = withBundleAnalyzer(
    withSass(
        withCss(
            withImages(nextConfigs)
        )
    )
);
