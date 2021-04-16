import watch from 'redux-watch'

import { reduxStore } from './';

const addNewWatcherToStore = (subscribedPath, callback = (newVal, oldVal, objectPath) => {}) => {

    let checkStoreExist = setInterval(() => {
        
        if (!!reduxStore) {

            let newWatcher = watch(reduxStore.getState, subscribedPath);

            reduxStore.subscribe(newWatcher(callback))

            clearInterval(checkStoreExist)
        }
    }, 100)
    
}

export { addNewWatcherToStore }
