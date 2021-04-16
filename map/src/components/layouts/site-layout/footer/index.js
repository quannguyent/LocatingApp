import './style.scss';

import React from 'react';
import { Row, Col, Typography } from 'antd';
import { withTranslation, Link } from '../../../../translate/init';

function Footer(props) {
    const { t } = props;

    return (
        <React.Fragment>
            <div className='footer-container'>
                <Row>
                    <Col sm={ 12 }>
                        <div className='footer-left-side'>
                            <Link href='/'>
                                <img
                                    className='logo-img'
                                    src='/images/logo-red.svg'
                                />
                            </Link>

                            <div className='footer-title-container'>
                                <span className='footer-title'>
                                    { t('footer.title') }
                                </span>
                            </div>

                            <div className='footer-description-container'>
                                <span className='footer-description'>
                                    { t('footer.description') }
                                </span>
                            </div>

                            <div className='social-connect'>
                                <Link href='/'>
                                    <img
                                        className='logo-social'
                                        src='/images/logo-facebook.svg'
                                    />
                                </Link>

                                <Link href='/'>
                                    <img
                                        className='logo-social'
                                        src='/images/logo-instagram.svg'
                                    />
                                </Link>

                                <Link href='/'>
                                    <img
                                        className='logo-social'
                                        src='/images/logo-twitter.svg'
                                    />
                                </Link>
                            </div>
                        </div>
                    </Col>

                    <Col sm={ 12 }>
                        <div className='footer-right-side'>
                            <div className='footer-menu'>
                                <div className='footer-menu-item footer-menu-item-text'>
                                    <Link href='/'>
                                        <a className='footer-menu-item-text'>
                                            { t('footer.farmNFT') }
                                        </a>
                                    </Link>
                                </div>

                                <div className='footer-menu-item'>
                                    <a className='footer-menu-item-text'>
                                        { t('footer.market') }
                                    </a>
                                </div>

                                <div className='footer-menu-item'>
                                    <a className='footer-menu-item-text'>
                                        { t('footer.activity') }
                                    </a>
                                </div>

                                <div className='footer-menu-item'>
                                    <a className='footer-menu-item-text'>
                                        { t('footer.FAQ') }
                                    </a>
                                </div>
                            </div>

                            <div className='footer-info'>
                                <div className='footer-info-container'>
                                    <div className='footer-info-text email'>
                                        { t('footer.email') }
                                    </div>

                                    <div className='footer-info-text'>
                                        { t('footer.phoneNumber') }
                                    </div>

                                    <div className='footer-info-text address'>
                                        { t('footer.address') }
                                    </div>
                                </div>
                            </div>
                        </div>
                    </Col>
                </Row>

                <div className='footer-end'>
                    <span className='footer-copyright-text'>
                        { t('footer.copyright') }
                    </span>
                </div>
            </div>
        </React.Fragment>
    );
}

export default withTranslation('common')(Footer);
