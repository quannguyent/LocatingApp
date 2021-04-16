import { UserReducer } from './user/reducer';

import { combineReducers } from 'redux';

export const rootReducer = combineReducers({
    User: UserReducer, 
});
