import React from 'react';
import Document, { Html, Head, Main, NextScript } from 'next/document';

export default class extends Document {
    
    render() {
        /**
        * Here we use _document.js to add a "lang" propery to the HTML object if
        * one is set on the page.
        **/
        return (
            <Html lang={ this.props.__NEXT_DATA__.props.pageProps.lang || 'en' }>
                <Head>
                </Head>

                <body style={{ overflowX: 'hidden' }}>
                    <Main/>
                    <NextScript/>
                    
                    <script src="https://www.google.com/recaptcha/api.js?onload=onloadCallback&render=explicit" async defer></script>
                    {/* <script id="ze-snippet" src="https://static.zdassets.com/ekr/snippet.js?key=dab3be4d-0728-406d-8743-dca2736f2cd1"> </script> */}
                </body>
            </Html>
        )
    }
}
