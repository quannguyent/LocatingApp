import '../style.scss';

import React, { useEffect, useState } from 'react';
import { withTranslation } from '../../../../../translate/init';
import NotificationIcon from '../../../../../../public/images/notification.svg';
import Alert from '../../../../../../public/images/alert.svg';
import ProfilePicture from '../../../../../../public/images/profile-picture.svg';
import ExpandIcon from '../../../../../../public/images/expand-more.svg';
import { Dropdown, Menu } from 'antd';
import { Link } from '../../../../../translate/init';
import {
    userLogoutSuccess,
    userGetProfile,
} from '../../../../../store/user/action';
import { useRouter } from 'next/router';
import { reduxStore } from '../../../../../store/index';
import { useDispatch } from 'react-redux';
import { asyncDispatch } from '../../../../../store';

import { useMountedState } from 'react-use';

import watch from 'redux-watch';

const UserLoggedIn = (props) => {

    const { t } = props;
    const dispatch = useDispatch();
    const router = useRouter();

    const [userProfile, setUserProfile] = useState(reduxStore.getState().User.profile);
    
    const userProfileWatcher = watch(reduxStore.getState, 'User.profile');

    const isMounted = useMountedState();

    useEffect(async () => {
        reduxStore.subscribe(
            userProfileWatcher((newVal, oldVal, objectPath) => {
                if (isMounted()) setUserProfile(newVal);
            })
        );

        await asyncDispatch(dispatch, userGetProfile());
    }, []);

    const logout = async () => {

        await asyncDispatch(dispatch, userLogoutSuccess())

        router.push('/');
    };

    const dropdownMenu = (
        <div className='dropdown-menu'>
            <Menu>
                <Menu.Item key='user' className='user'>
                    <img
                        src={ userProfile?.avatar ? userProfile?.avatar : ProfilePicture }
                        className='user__picture'></img>

                    <div className='user__info'>
                        <div className='username'>{ userProfile?.userName }</div>
                        <div className='email'>{ userProfile?.email }</div>
                    </div>
                </Menu.Item>

                <Menu.Divider></Menu.Divider>

                <Menu.Item key='user-profile'>
                    <Link href='/profile'>
                        <a className='item-text'>{ t('yourProfile') }</a>
                    </Link>
                </Menu.Item>

                <Menu.Item key='help'>
                    <span className='item-text'>{ t('help') }</span>
                </Menu.Item>

                <Menu.Divider></Menu.Divider>

                <Menu.Item key='sign-out'>
                    <span onClick={ logout } className='item-text'>
                        { t('signOut') }
                    </span>
                </Menu.Item>
            </Menu>
        </div>
    );

    const renderCompt = () => {

        if (userProfile?.id) {
            
            return (
                <div className='user-logged-in'>

                    <div className='notification-alert'>
                        <img src={ NotificationIcon } className='noti-icon'></img>
                        <img src={ Alert } className='alert'></img>
                    </div>

                    <Dropdown
                        overlay={ dropdownMenu }
                        placement='bottomRight'
                        trigger={ ['click'] }>
                        <div className='user-profile'>
                            <img
                                src={ userProfile?.avatar ? userProfile.avatar : ProfilePicture }
                                className='profile-picture'
                            />

                            <img src={ ExpandIcon } className='expand-icon' />
                        </div>
                    </Dropdown>
                </div>
            )
        } else {
            return <></>;
        }
    }

    return renderCompt();
};

export default withTranslation('common')(UserLoggedIn);
