import React, { Fragment } from 'react';
import AppFooter from './footer';
import AppHeader from './header';

const SiteLayout = ( props ) => {
    return (
        <Fragment>
            <AppHeader/>
            
            { props.children }

            <AppFooter/>
        </Fragment>
    )
};

export default SiteLayout;

export const getLayout = page => <SiteLayout>{ page }</SiteLayout>
