import { of } from 'rxjs';
import { switchMap, catchError, map } from 'rxjs/operators';
import { ofType } from 'redux-observable';
import { from } from 'rxjs';
import apiUser from '../../api/user'
import * as actions from './action';
import * as types from './type';

export const userLoginEpic = (action$, state$) =>
    action$.pipe(
        ofType(types.USER_LOGIN),
        switchMap((action) => 
            from(apiUser.login(action.payload.credentials)).
            pipe(
                map((response) => {
                    console.log(action.payload);
                    const { callback } = action.payload; 
                    callback(response.data, null)
                    return actions.userLoginSuccess(response.data);
                }),
                catchError((error) => {
                    const { callback } = action.payload; 
                    callback(null, error)
                    return of(actions.userLoginFailure(error))
                })
            ) 
        )
    )

export const userGetProfile = (action$, state$) =>
    action$.pipe(
        ofType(types.USER_GET_PROFILE),
        switchMap((action) => 
            from(apiUser.getUserProfile()).
            pipe(
                map((response) => {
                    return actions.userSaveProfile(response.data);
                }),
            ) 
        )
    )

// export const userLogoutEpic = (action$, state$) =>

//     action$.pipe(
//         ofType(types.USER_LOGOUT),
//         switchMap((action) => 
//             from(new Promise()).
//             pipe(
//                 map((response) => {
//                     return actions.userLogoutSuccess();
//                 }),
//                 catchError((error) => of(actions.userLoginFailure(error)) )
//             ) 
//         )
//     )

export const userResetPasswordEpic = (action$, state$) =>

    action$.pipe(
        ofType(types.USER_RESET_PASSWORD),
        switchMap((action) =>
            from(apiUser.resetPassword(action.payload.email)).
                pipe(
                    map((response) => {
                        return actions.userResetPasswordSuccess(response);
                    }),
                    catchError((error) => of(actions.userResetPasswordFailure(error)))
                )
        )
    )
