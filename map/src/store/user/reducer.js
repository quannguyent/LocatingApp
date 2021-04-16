import {
    USER_LOGIN_SUCCESS,
    USER_LOGIN_FAILURE,
    USER_LOGOUT_SUCCESS,
    USER_SAVE_WALLET_ADDRESS,
    USER_SAVE_PROFILE,
} from './type';

export const UserReducer = (state = {}, action = {}) => {

    switch (action.type) {
        case USER_LOGIN_SUCCESS:
            return {
                ...state,
                authInfo: {
                    accessToken: action.payload.access_token,
                },
            };
        case USER_SAVE_PROFILE:
            return {
                ...state,
                profile: action.payload.profile,
            };
        case USER_LOGIN_FAILURE:
            return {};
        case USER_LOGOUT_SUCCESS:
            return {};
        case USER_SAVE_WALLET_ADDRESS:
            return {
                ...state,
                walletInfo: {
                    walletAddress: action.payload.walletAddress,
                },
            };
        default:
            return state;
    }
};
