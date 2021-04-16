import React, { useState, useEffect } from "react";
import { useDispatch } from "react-redux";
import { Router } from "../../translate/init";

import { reduxStore } from '../../store';
import { useMountedState } from 'react-use';
import { asyncDispatch } from '../../store';

import {
    userGetProfile,
    userLogout
} from '../../store/user/action';

import watch from 'redux-watch';

function AuthGuard({ children }) {

    const [loading, setLoading] = useState(true);

    const dispatch = useDispatch();

    const isMounted = useMountedState();

    const userProfileWatcher = watch(reduxStore.getState, 'User.profile');

    const [userProfile, setUserProfile] = useState(reduxStore?.getState().User.profile)

    useEffect(async () => {

        userProfileWatcher((newVal, oldVal, objectPath) => {
            if (isMounted()) setUserProfile(newVal)
        })

        if (isMounted()) {
            try {

                await asyncDispatch(dispatch, userGetProfile());

                setLoading(false)
            } catch (err) {
                await asyncDispatch(dispatch, userLogout())
            }
        }        
    }, []);

    useEffect(() => {
        
        if (!loading && !userProfile?.id) {
            Router.push('/login');
        }

    }, [loading, userProfile]);

    return <>{!loading && userProfile?.id ? children : <></>}</>;
}

export default AuthGuard;
