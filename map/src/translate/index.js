import { changeLanguage, naturalTime } from './i18n';

let i18nContext = null;

const cloneI18nContext = (context) => {
    i18nContext = context
    
    return i18nContext
}

export {
    naturalTime,
    changeLanguage,
    cloneI18nContext,
    i18nContext
}
