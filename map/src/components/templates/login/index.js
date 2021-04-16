import './style.scss';
import { Router, Link, withTranslation } from '../../../translate/init';
import { Row, Col, Form, Button, Divider, message } from 'antd';
import React, { useEffect } from 'react';
import Slide from './slide';
import { useDispatch } from 'react-redux';
import { userLogin } from '../../../store/user/action';
import { asyncDispatch } from '../../../store';
import { useRouter } from 'next/router';
import watch from 'redux-watch';
import CustomInputField from '../../elements/input';
import { reduxStore } from '../../../store/index'
import { useMountedState } from 'react-use';

const LoginTemplate = (props) => {

    const dispatch = useDispatch();
    
    const GOOGLE_AUTH_URL = process.env.NEXT_PUBLIC_GOOGLE_AUTH_URL;
    const FACEBOOK_AUTH_URL = process.env.NEXT_PUBLIC_FACEBOOK_AUTH_URL;
    
    const initialValues = {
        email: '',
        password: '',
    };

    const { t } = props;
    const router = useRouter()

    const rules = {
        email: [
            {
                required: true,
                message: t('requiredField'),
            },
            {
                type: 'email',
                message: t('validEmailRequired'),
            },
        ],

        password: [
            {
                required: true,
                message: t('requiredField'),
            }
        ],
    };

    const onFinish = async values => { 

        const { email, password } = values
        
        dispatch(userLogin({ email, password }, (res, err) => {
            console.log(res, err);
            if(res) {
                router.push('/')
            }
            if(err) {
                message.error(t('errors.loginFailed'))
            }
        }))

    };

    const onFinishFailed = () => { };

    return (
        <React.Fragment>
            <Row className="login-page">
                {/* <Col sm={ 24 } lg={ 12 }>
                    <div className="app-introduce-content">

                        <Link href='/'>
                            <a>
                                <img
                                    className="logo-img"
                                    src="/images/logo-red.svg"
                                />
                            </a>
                        </Link>

                        <div className="introduce-box">
                            <div className="text-box">
                                <div className="header">
                                    { t('loginContentHeaderText') }
                                </div>

                                <div className="header-2">
                                    { t('loginContentSmallText') }
                                </div>
                            </div>
                        </div>

                        <div className="slide">
                            <Slide />
                        </div>
                    </div>
                </Col> */}

                <Col xs={ 24 } lg={ 24 }>
                    <div className="app-login-content">
                        <Row className='w-100' justify="center">
                            <Col span={ 12 }>
                                <Form
                                    name="login"
                                    initialValues={ initialValues }
                                    onFinish={ onFinish }
                                    onFinishFailed={ onFinishFailed }>
                                        
                                    <div className="form-header">
                                        { t('accountLogin') }
                                    </div>

                                    <Form.Item 
                                        className='m-0' 
                                        name='email'
                                        rules={ rules.email }>
                                        <CustomInputField 
                                            placeholder={ t('emailAddress') } 
                                            customStyle='style#2'
                                        />
                                    </Form.Item>

                                    <Form.Item 
                                        className='m-0' 
                                        name='password'
                                        rules={ rules.password }>
                                        <CustomInputField
                                            placeholder={ t('password') }
                                            customStyle='style#2'
                                            type='password'
                                            
                                        />
                                    </Form.Item>

                                    <Form.Item>
                                        <Link href="/request-new-password">
                                            <a className="forgot-password">
                                                { t('forgotYourPassword') }
                                            </a>
                                        </Link>
                                    </Form.Item>

                                    <Form.Item>
                                        <Button
                                            name="signin"
                                            className="signin-button"
                                            htmlType="submit">
                                            { t('signIn') }
                                        </Button>
                                    </Form.Item>

                                    <Divider>{ t('or') }</Divider>

                                    <div className="app-social">
                                        <div className="app-social-item">                                            
                                            <a href={encodeURI(FACEBOOK_AUTH_URL)}>
                                                <img
                                                    className="logo-img"
                                                    src="/images/logo-facebook.svg"
                                                />
                                            </a>
                                        </div>

                                        <div className='app-social-item'>
                                            <a href={encodeURI(GOOGLE_AUTH_URL)}>
                                                <img
                                                    className="logo-img"
                                                    src="/images/logo-google-plus.svg"
                                                />
                                            </a>
                                        </div>
                                    </div>
                                </Form>

                                <div className="signup-recommend">
                                    <span className="normal-text">
                                        { t('dontHaveAnAccount') }
                                        { '?' }&nbsp;
                                    </span>

                                    <Link href="/">
                                        <a className="sign-up-text">
                                            { t('signup') }
                                        </a>
                                    </Link>
                                </div>
                            </Col>
                        </Row>
                    </div>
                </Col>
            </Row>
        </React.Fragment>
    );
};

export default withTranslation('common')(LoginTemplate);
