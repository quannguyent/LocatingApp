const Koa = require('koa');
const router = require('koa-route');
const next = require('next');
const LRUCache = require('lru-cache');
const port = parseInt(process.env.PORT, 10) || 3001;
const dev = process.env.NODE_ENV !== 'production';
const app = next({ dev })
const handle = app.getRequestHandler()
const bodyParser = require('koa-bodyparser');
const { forEach, forIn } = require('lodash');
const axios = require('axios');
const qs = require('querystring')
// const session = require('koa-session');
// This is where we cache our rendered HTML pages
const ssrCache = new LRUCache({
    max: 100,
    maxAge: 1000 * 60 * 60 // 1hour
})

app.prepare()
    .then(() => {

        const server = new Koa();

        const NEXT_PUBLIC_SERVER_ENDPOINT = process.env.NEXT_PUBLIC_SERVER_ENDPOINT;

        server.use(bodyParser())

        server.keys = [process.env.SESSION_SECRET || 'secret'];

        server.use(router.get('/', async (ctx) => renderAndCache(ctx, '/')))

        server.use(router.post('/auth/login', async (ctx, next) => {
            try {
                const { email, password } = ctx.request.body;

                const res = await axios({
                    method: 'post',
                    url: `${NEXT_PUBLIC_SERVER_ENDPOINT}/auth/login`,
                    data: {
                        email,
                        password
                    }
                });

                ctx.status = res.status;

                const { data: responseData } = res.data;

                const { access_token } = responseData;

                ctx.body = responseData;
            
                next();
            } catch (err) {
                ctx.response.status = err.response.status;

                ctx.body = err.response.data;
            }
        }))

        server.use(router.get('/auth/callback/', async (ctx, next) => {

            try {
                const { code, state } = ctx.request.query;

                if (state === '1') {
                    const res = await axios({
                        method: 'get',
                        url: `${NEXT_PUBLIC_SERVER_ENDPOINT}/auth/google-callback?code=${encodeURIComponent(code)}`,
                    });

                    ctx.redirect(`/callback-handler?${qs.stringify(res.data.data)}`);
                }

                if ( state === '2') {
                    const res = await axios({
                        method: 'get',
                        url: `${NEXT_PUBLIC_SERVER_ENDPOINT}/auth/facebook-callback?code=${encodeURIComponent(code)}`,
                    });

                    ctx.redirect(`/callback-handler?${qs.stringify(res.data.data)}`);
                }

                return;
            } catch (err) {

                ctx.redirect(`/login`);

                ctx.status = err.response.status;
                ctx.body = err.response.data;
            }
        }))

        server.use(async (ctx) => {
            await handle(ctx.req, ctx.res)
            ctx.respond = false
        });

        server.use(async (ctx, next) => {
            ctx.res.statusCode = 200
            await next()
        });

        server.listen(port, (err) => {
            if (err) { throw err }
            console.log(`> Ready on http://localhost:${port}`)
        });
    })

/*
 * NB: make sure to modify this to take into account anything that should trigger
 * an immediate page change (e.g a locale stored in req.session)
 */
function getCacheKey(ctx) { return ctx.url }

function renderAndCache(ctx, pagePath, queryParams) {

    const key = getCacheKey(ctx.req)

    // If we have a page in the cache, let's serve it
    if (ssrCache.has(key)) {
        console.log(`CACHE HIT: ${key}`)
        ctx.body = ssrCache.get(key)
        return Promise.resolve()
    }

    // If not let's render the page into HTML
    return app.renderToHTML(ctx.req, ctx.res, pagePath, queryParams)
        .then((html) => {
            // Let's cache this page
            console.log(`CACHE MISS: ${key}`)
            ssrCache.set(key, html)
            ctx.body = html
        })
        .catch((err) => {
            console.log('ERRR', err)
            return app.renderError(err, ctx.req, ctx.res, pagePath, queryParams)
        })
}
