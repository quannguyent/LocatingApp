import './style.scss';
import './responsive-style.scss';

import { Dropdown, Menu } from 'antd';
import { useRouter } from 'next/router';
import { withTranslation, Link } from '../../../../translate/init';
import CustomButton from '../../../elements/button';
import CustomInputSearch from '../../../elements/input-search';
import UserLoggedIn from './user-logged-in';
import expandIcon from '../../../../../public/images/expand-more.svg';
import { useEffect, useState } from 'react';

import watch from 'redux-watch';
import { reduxStore } from '../../../../store';
import { useMountedState } from 'react-use';
import { isAuthenticatedUser } from '../../../../utils/auth';

import AuthGuard from '../../../../guards/auth';
import ModalMenu from './modal-menu';

const Header = (props) => {

    const { t } = props;

    const router = useRouter();
    const isMounted = useMountedState();
    
    const [currentActiveMenuItem, setCurrentActiveMenuItem] = useState('');
    const [_isAuthenticatedUser, setIsAuthenticated] = useState(isAuthenticatedUser());

    const [
        currentActiveSubMenuItem, 
        setCurrentActiveSubMenuItem
    ] = useState('');

    const userAuthInfoWatcher = watch(reduxStore.getState, 'User.authInfo');

    const [showSearchInput, setShowSearchInput] = useState(false);

    const toggleSearchInput = () => {
        setShowSearchInput(!showSearchInput);
    };

    const [showMenuModal, setShowMenuModal] = useState(false);

    const toggleMenuModal = () => {
        setShowMenuModal(!showMenuModal);
    }
    
    const setCurrentActiveMenu = () => {

        if (router.pathname.includes('farm-nft')) {
            setCurrentActiveMenuItem('farm-nft');
        } else if (router.pathname.includes('activity')) {
            setCurrentActiveMenuItem('activity');
        } else if (router.pathname.includes('market')) {

            if (router.pathname.includes('top-creation')) {
                setCurrentActiveSubMenuItem('top-creation');
            } else if (router.pathname.includes('popular-market')) {
                setCurrentActiveSubMenuItem('popular-market');
            } else setCurrentActiveMenuItem('market');

        } else if (router.pathname.includes('faq')) {
            setCurrentActiveMenuItem('faq');
        }
    };

    const menu = (
        <Menu className='market-dropdown-menu' selectedKeys={ [`${ currentActiveSubMenuItem }`] }>
            <Menu.Item key='top-creation'>
                <Link href='/market/top-creation'>
                    <span className='ant-dropdown-menu-item__text'>
                        { t('header.topCreation') }
                    </span>
                </Link>
            </Menu.Item>

            <Menu.Item key='popular-market'>
                <Link href='/market/popular-market'>
                    <span className='ant-dropdown-menu-item__text'>
                        { t('header.popularMarket') }
                    </span>
                </Link>
            </Menu.Item>
        </Menu>
    );

    useEffect(() => {
        reduxStore.subscribe(
            userAuthInfoWatcher((newVal, oldVal, objectPath) => {
                if (isMounted()) setIsAuthenticated(isAuthenticatedUser());
            })
        );
    }, [])

    const onSearch = (value) => {};

    useEffect(() => {
        setCurrentActiveMenu();

        if (showMenuModal) {
            setShowMenuModal(false);
        }
    }, [router.pathname])

    return (
        <>
            {currentActiveMenuItem !== null ? (
                <>
                    <Menu
                        className='page-header'
                        mode='horizontal'
                        defaultSelectedKeys={ [currentActiveMenuItem] }>
                        <Link href='/'>
                            <img className='logo-img' src='/images/Logo.svg' />
                        </Link>

                        <Menu.Item
                            className='menu-item-custom mrc-12px'
                            key='farm-nft'>
                            <Link href='/farm-nft'>{ t('farmNFT') }</Link>
                        </Menu.Item>

                        <Menu.Item
                            className='menu-item-custom mrc-12px'
                            key='market'>
                            <Link href='/market'>
                                <span>{ t('market') }</span>
                            </Link>
                            
                            <Dropdown overlay={ menu } placement='bottomCenter'>
                                <img src={ expandIcon } className='img' />
                            </Dropdown>
                        </Menu.Item>

                        <Menu.Item
                            className='menu-item-custom mrc-12px'
                            key='activity'>
                            <Link href='/activity'>{ t('activity') }</Link>
                        </Menu.Item>

                        <Menu.Item className='menu-item-custom mrc-12px' key='faq'>
                            <Link href='/faq'>{ t('faq') }</Link>
                        </Menu.Item>

                        <Menu.Item className='menu-item-custom search w-inherit'>
                            <CustomInputSearch
                                classNames={ ['mrc-4px', 'w-inherit', 'search-input', `${ showSearchInput && 'search-input-show'}`] }
                                enterButton={ false }
                                placeholder={ t('searchAll') }
                                onSearch={ onSearch }
                            />

                            <img className='search-icon' src='/images/search-icon.svg' onClick={ toggleSearchInput } />
                        </Menu.Item>

                        <Menu.Item className='menu-item-custom mlc-auto-ipt mrc-16px-ipt'>
                            <Link href='/create-nft'>
                                <a>
                                    <CustomButton
                                        color='red'
                                        size='middle-custom'
                                        shape='circle-custom'
                                        children={
                                            <div className='d-flex align-items-center'>
                                                <img
                                                    className='mrc-4px'
                                                    src='/images/collect-icon.svg'
                                                />
                                                { t('createCollective') }
                                            </div>
                                        }
                                    />
                                </a>
                            </Link>
                        </Menu.Item>

                        { _isAuthenticatedUser ? (
                            <Menu.Item className='menu-item-custom user-logged-in'>
                                {/* <AuthGuard> */}
                                <UserLoggedIn />
                                {/* </AuthGuard> */}
                            </Menu.Item>
                        ) : (
                            <>
                                <Menu.Item className='menu-item-custom sign-up-menu'>
                                    <Link href='/login'>
                                        { t('login') }
                                    </Link>
                                </Menu.Item>

                                <Menu.Item className='menu-item-custom m-0-ipt'
                                    >&nbsp;/&nbsp;
                                </Menu.Item>

                                <Menu.Item className='menu-item-custom sign-up-menu'>
                                    <Link href='/signup'>
                                        { t('signUp') }
                                    </Link>
                                </Menu.Item>
                            </>
                        )}

                        <Menu.Item className='menu-item-custom more' onClick={ toggleMenuModal }>
                            <img className='more-menu-icon' src='/images/menu-icon.svg' />
                        </Menu.Item>
                    </Menu>

                    <ModalMenu
                        isVisible={ showMenuModal }
                        handleCancel={ toggleMenuModal }
                        marketDropdown={ menu }
                        _isAuthenticatedUser={ _isAuthenticatedUser }
                        currentActiveMenuItem={ currentActiveMenuItem }
                    />
                </>
            ) : (
                <></>
            )}
        </>
    );
};

export default withTranslation('common')(Header);
