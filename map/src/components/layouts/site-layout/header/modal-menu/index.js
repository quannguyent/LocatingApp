import { Modal, Menu, Dropdown } from 'antd';
import Link from 'next/link';
import React, { useState } from 'react';
import './style.scss';
import { withTranslation } from '../../../../../translate/init';
import CustomButton from '../../../../elements/button';
import { useRouter } from 'next/router';
import SubMenu from 'antd/lib/menu/SubMenu';

const ModalMenu = (props) => {
    const {
        isVisible,
        handleCancel,
        _isAuthenticatedUser,
        currentActiveMenuItem,
        t
    } = props;

    const router = useRouter();

    const handleChangeToCreateNft = () => {
        router.push('/create-nft');
    };

    return (
        <Modal
            className='modal-menu'
            closable={ false }
            footer={ null }
            visible={ isVisible }
            onCancel={ handleCancel }>
            <Menu
                defaultSelectedKeys={ [currentActiveMenuItem] }
                mode='inline'
                triggerSubMenuAction='hover'>
                <div className='d-flex justify-content-space-between align-items-center logo'>
                    <Link href='/'>
                        <img className='logo-img' src='/images/Logo.svg' />
                    </Link>

                    <img className='close-icon' src='/images/close-icon.svg' onClick={ handleCancel } />
                </div>

                <Menu.Item
                    className='menu-item-custom'
                    key='farm-nft'>
                    <Link href='/farm-nft'>
                        { t('farmNFT') }
                    </Link>
                </Menu.Item>

                <SubMenu key='market' title={ t('market') }>
                    <Menu.Item
                        key='top-creation'
                        className='menu-item-custom market-submenu'>
                        <Link href='/market/top-creation'>
                            <span className='market-submenu__text'>
                                { t('header.topCreation') }
                            </span>
                        </Link>
                    </Menu.Item>

                    <Menu.Item
                        key='popular-market'
                        className='menu-item-custom market-submenu'>
                        <Link
                            href='/market/popular-market'
                            className='menu-item-custom'>
                            <span className='market-submenu__text'>
                                { t('header.popularMarket') }
                            </span>
                        </Link>
                    </Menu.Item>
                </SubMenu>

                <Menu.Item
                    className='menu-item-custom'
                    key='activity'>
                    <Link href='/activity'>{ t('activity') }</Link>
                </Menu.Item>

                <Menu.Item className='menu-item-custom' key='faq'>
                    <Link href='/faq'>{ t('faq') }</Link>
                </Menu.Item>

                <CustomButton
                    classNames={ ['w-100', 'create-collective'] }
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
                    onClick={ handleChangeToCreateNft }
                />

                { _isAuthenticatedUser ? (
                    <>
                    </>
                ) : (
                    <div className='d-flex justify-content-center align-items-center'>
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
                    </div>
                )}
            </Menu>
        </Modal>
    )
}

export default withTranslation('common')(ModalMenu);
