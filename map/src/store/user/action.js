import { 
    USER_LOGIN, 
    USER_LOGIN_SUCCESS,
    USER_LOGIN_FAILURE,
    USER_LOGOUT,
    USER_LOGOUT_SUCCESS,
    USER_LOGOUT_FAILURE,
    USER_RESET_PASSWORD,
    USER_RESET_PASSWORD_SUCCESS,
    USER_RESET_PASSWORD_FAILURE,
    USER_SAVE_WALLET_ADDRESS,
    USER_GET_PROFILE,
    USER_SAVE_PROFILE
} from './type';

export const userSaveWalletAddress = ({ walletAddress }) => ({
    type: USER_SAVE_WALLET_ADDRESS,
    payload: { walletAddress }
});

export const userGetProfile = () => ({
    type: USER_GET_PROFILE,
    payload: {}
});

export const userSaveProfile = profile => ({
    type: USER_SAVE_PROFILE,
    payload: { profile }
});

export const userLogin = (credentials, callback) => ({
    type: USER_LOGIN,
    payload: { credentials, callback }
});

export const userFacebookLogin = accessToken => ({
    type: USER_FACEBOOK_LOGIN,
    payload: accessToken,
})

export const userLoginSuccess = accessToken => ({
    type: USER_LOGIN_SUCCESS,
    payload: accessToken,
})
  
export const userLoginFailure = (error) => ({
    type: USER_LOGIN_FAILURE,
    payload: { error },
    error: true
})

export const userLogout = () => ({
    type: USER_LOGOUT
});

export const userLogoutSuccess = () => ({
    type: USER_LOGOUT_SUCCESS
})
  
export const userLogoutFailure = (error) => ({
    type: USER_LOGOUT_FAILURE,
    payload: { error },
})

export const userResetPassword = () => ({
    type: USER_RESET_PASSWORD
});

export const userResetPasswordSuccess = (response) => ({
    type: USER_RESET_PASSWORD_SUCCESS,
    payload: { response },
})
  
export const userResetPasswordFailure = (error) => ({
    type: USER_RESET_PASSWORD_FAILURE,
    payload: { error },
})
