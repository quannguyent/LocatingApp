import { values } from 'lodash';
import { combineEpics } from 'redux-observable';
import { catchError } from 'rxjs/operators';

import * as userEpics from './user/epic';

export const rootEpic = (action$, store$, dependencies) =>
    combineEpics(
        ...values(userEpics), 
    )(action$, store$, dependencies).pipe(
        catchError((error, source) => {
            console.log(error);
            return source;
        }
    )
);
