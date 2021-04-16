import { Router, Link, withTranslation } from '../../../translate/init';
import React, { useEffect } from 'react';
import {
    GoogleMap,
    LoadScript,
    Marker,
} from '@react-google-maps/api';

const ggMapApiKey = process.env.NEXT_PUBLIC_GOOGLE_MAP_KEY;

const mapContainerStyle = {
    width: '1000px',
    height: '1000px',
};

const zoom = 10;

const placeLocation = {
    lat: 22.13812490291521,
    lng: 103.73138357573791,
}

const MapTemplate = (props) => {

    return (
        <React.Fragment>
            <LoadScript googleMapsApiKey={ ggMapApiKey }>
                <GoogleMap
                    id='marker-example'
                    mapContainerStyle={ mapContainerStyle }
                    zoom={ zoom }
                    center={ placeLocation }
                    options={{
                        mapTypeControl: false,
                        scrollwheel: true,
                    }}
                >
                    <Marker position={ placeLocation } />
                </GoogleMap>
            </LoadScript>
        </React.Fragment>
    );
};

export default withTranslation('common')(MapTemplate);
