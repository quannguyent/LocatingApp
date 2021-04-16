import PropTypes from "prop-types";
import React, { useEffect } from "react";
import { connect } from 'react-redux';
import MapTemplate from '../components/templates/map'
import SiteLayout from '../components/layouts/site-layout';
import { withTranslation } from '../translate/init';

const HomePage = ({ t }) => {

    useEffect(() => {
        document.title = 'Home';
    })

    return (
        <React.Fragment>
            <MapTemplate />
        </React.Fragment>
    );
};

// HomePage.getLayout = page => {
//     return <SiteLayout>{ page }</SiteLayout>;
// }

HomePage.getInitialProps = async () => ({
    namespacesRequired: ['common'],
})

HomePage.propTypes = {
    t: PropTypes.func.isRequired,
}

export default connect()(withTranslation('common')(HomePage));
