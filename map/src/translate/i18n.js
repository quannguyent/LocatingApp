import React from "react"
import TimeAgo from 'timeago-react';
import * as timeago from 'timeago.js';
import vi from 'timeago.js/lib/lang/vi';
import en from 'timeago.js/lib/lang/en_US';
import i18next from 'i18next';

timeago.register('vi', vi);
timeago.register('en', en);

var lng 

function changeLanguage(_lng) {

    i18next.changeLanguage(_lng);

    localStorage.lang = _lng;

    lng = _lng;
}

function naturalTime(_time) {
    var time = <TimeAgo datetime={_time} locale={localStorage.lang}/>
    return time;
}

export { changeLanguage, naturalTime }
