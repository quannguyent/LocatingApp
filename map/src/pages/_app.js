import 'antd/dist/antd.css';
import 'swiper/swiper.scss';
import '../styles/globals.scss'

import { PersistGate } from 'redux-persist/lib/integration/react';
import { persistStore } from 'redux-persist';
import { useEffect, useState, useContext } from 'react';

import React from 'react';
import Head from 'next/head';

import { appWithTranslation, withTranslation } from '../translate/init';
import { useStore } from '../store';
import { Provider as ReduxProvider } from 'react-redux';
// import { cloneStore } from '../utils/customAxios';
import { cloneStore } from '../store';
import { useRouter } from 'next/router';

import { I18nContext } from 'next-i18next';
import { cloneI18nContext } from '../translate';

import $ from 'jquery'

function MyApp(props) {

    const { t } = props;
    const { Component, pageProps } = props;
    const [isPersistorLoaded, setPersistorLoaded] = useState(false);
    const router = useRouter()
    const { i18n } = useContext(I18nContext)

    const store = useStore(pageProps.initialReduxState);

    const persistor = persistStore(store, {}, function () {

        persistor.persist();

        cloneStore(store);

        setPersistorLoaded(true);

        cloneI18nContext(i18n)
    });

    const getLayout = Component.getLayout || (page => page);

    useEffect(async () => {

        if (process.env.NODE_ENV !== 'production') {

            let cacheURL = [];

            const handleLoadStyle = (url) => {

                if (cacheURL.includes(url)) return

                const els = $('link[href*="/_next/static/css/styles.chunk.css"]').toArray()
                const timestamp = new Date().valueOf();

                for (let i = 0; i < els.length; i++) {

                    if (els[i].rel === 'stylesheet') {

                        els[i].href = '/_next/static/css/styles.chunk.css?v=' + timestamp

                        cacheURL.push(url)

                        break
                    }
                }
            }

            router.events.on('routeChangeComplete', handleLoadStyle)

            return () => {
                router.events.off('routeChangeComplete', handleLoadStyle)
            }
        }
    }, [])

    return (
        <>
            <Head>
                <meta charSet="utf-8" />
                <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
                <meta name="theme-color" content="#000000" />
                <link rel="manifest" href={`${process.env.NEXT_PUBLIC_CLIENT_ENDPOINT}/manifest.json`} />
                <link rel="shortcut icon" href={`${process.env.NEXT_PUBLIC_CLIENT_ENDPOINT}/images/Logo.svg`} />
            </Head>

            <ReduxProvider store={store}>
                <PersistGate
                    loading={
                        <div className="loader-container">
                            <div className="loader-container-inner">
                                <h6 className="mt-5">
                                    {t('loadingMessage')}
                                </h6>
                            </div>
                        </div>
                    }
                    persistor={persistor}>
                    {
                        isPersistorLoaded ?
                            getLayout(<Component {...pageProps} />) : <></>
                    }
                </PersistGate>
            </ReduxProvider>

        </>
    );
};

export default appWithTranslation(withTranslation('common')(MyApp));
