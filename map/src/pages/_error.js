/**
 * Creating a page named _error.js lets you override HTTP error messages
 */
import React from 'react';
import Head from 'next/head';
import Link from 'next/link';
// import Styles from '../css/index.scss'
import { withRouter } from 'next/router';

class ErrorPage extends React.Component {

    static propTypes() {
        return {
            errorCode: React.PropTypes.number.isRequired,
            url: React.PropTypes.string.isRequired
        }
    }

    static getInitialProps({res, xhr}) {

        const errorCode = res ? res.statusCode : (xhr ? xhr.status : null);

        return { errorCode };
    }

    render() {
        var response
        switch (this.props.errorCode) {
            case 200: // Also display a 404 if someone requests /_error explicitly
            case 404:
                response = (
                    <div>
                        <Head>
                            {/* <style dangerouslySetInnerHTML={{__html: Styles}}/> */}
                        </Head>
                        
                    </div>
                )
                break
            case 500:
                response = (
                    <div>
                        <Head>
                            {/* <style dangerouslySetInnerHTML={{__html: Styles}}/> */}
                        </Head>
                        
                    </div>
                )
                break
            default:
                response = (
                    <div>
                        <Head>
                            {/* <style dangerouslySetInnerHTML={{__html: Styles}}/> */}
                        </Head>
    
                    </div>
                )
        }

        return response
    }

}

export default withRouter(ErrorPage);
