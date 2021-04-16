import { customAxios } from '../../utils/custom-axios';
import axios from 'axios';

const endpoint = process.env.NEXT_PUBLIC_SERVER_ENDPOINT;
const client_endpoint = process.env.NEXT_PUBLIC_CLIENT_ENDPOINT;

export default {

    login: credentials => axios({
        method: 'post',
        url: `${endpoint}/auth/login`,
        data: {
            email: credentials.email,
            password: credentials.password
        }
    })
    .then(res => { return res.data }),

    register: async credentials => {

        let _new_user_data = {
            userName: credentials.userName,
            email: credentials.emailAddress,
            password: credentials.password,
            confirmedPassword: credentials.confirmedPassword,
            inviteCode: credentials.inviteCode,
        }

        if (credentials.inviteCode) {
            _new_user_data['inviteCode'] = credentials.inviteCode
        }

        const response = await customAxios({
            method: 'post',
            url: `${endpoint}/users/register`,
            data: _new_user_data
        })

        return response
    },

    facebookLogin: async code => {

        const response = await axios({
            method: 'get',
            url: `${endpoint}/auth/facebook-callback?code=${encodeURIComponent(code)}`,
        })

        return response.data
    },

    resetPassword: email => customAxios
        .post(`${endpoint}/api/users/reset_password/`, email),

    getUserProfile: () => customAxios({
        method: 'get',
        url: `${endpoint}/auth/profile`,
    })
    .then(res => { return res.data }),

    putUserProfile: async (data) => {
        const response = await customAxios({
            method: 'put',
            url: `${endpoint}/users`,
            data: data
        })

        return response.data
    },

    requestResetPassword: async (email) => {
        const data = {
            email: email
        }
        
        const response = await customAxios({
            method: 'post',
            url: `${endpoint}/auth/request-forgot-password`,
            data: data
        })
        return response
    },

    changePassword: async (data) => {
        
        const response = await customAxios({
            method: 'post',
            url: `${endpoint}/users/change-password`,
            data: data
        })

        return response
    },

    verifyUser: async (data) => {
        
        const response = await customAxios({
            method: 'get',
            url: `${endpoint}/auth/verify?user_id=${data.user_id}&activate_code=${data.activate_code}`,
        })

        return response.data
    },
}
