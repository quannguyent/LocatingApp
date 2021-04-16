import axios from 'axios';
import FileType from 'file-type';

// import got from 'got';

const FILE_TYPE_TO_PREFIX_MIME = {
    png: 'image',

}

const getBase64FromUrl = async (data) => {
    let result = await axios({
        url: data.url,
        method: 'GET',
        encoding: null // This is actually important, or the image string will be encoded to the default encoding
    })

    let base64Str = result.data;

    // const stream = got.stream(data.url);

    // let fileMetaDate = await FileType.fromStream(stream);

    let _urlArr = data.url.split('/')

    let defaultDataUrlPrefix = `data:image/${_urlArr[_urlArr.length - 1]};base64`

    let imageDataUrl = `${data.dataUrlPrefix || defaultDataUrlPrefix}, ${base64Str}`;
    
    return imageDataUrl;
}


export {
    getBase64FromUrl
}
