import './style.scss';

import React from 'react';
import { withTranslation } from '../../../translate/init';
import SwiperCore, { Autoplay } from 'swiper';
import { Swiper, SwiperSlide } from 'swiper/react';
import 'swiper/swiper.scss';
import AustronautImg from '../../../../public/images/hand.png';
import WaveImg from '../../../../public/images/Wave.png';
import DogImg from '../../../../public/images/Dog.png';
import SkyImg from '../../../../public/images/sky.png';

SwiperCore.use([Autoplay]);

const Slide = (props) => {
    const { t } = props;

    return (
        <React.Fragment>
            <div className="slide-block">
                <Swiper
                    autoplay={{ delay: 1000, disableOnInteraction: false }}
                    loop={ true }
                    slidesPerView="auto"
                    spaceBetween={ 8 }>
                    <SwiperSlide>
                        <div className="img-slide">
                            <img src={ DogImg }></img>
                        </div>
                    </SwiperSlide>

                    <SwiperSlide>
                        <div className="img-slide">
                            <img src={ AustronautImg }></img>
                        </div>
                    </SwiperSlide>

                    <SwiperSlide>
                        <div className="img-slide">
                            <img src={ WaveImg }></img>
                        </div>
                    </SwiperSlide>

                    <SwiperSlide>
                        <div className="img-slide">
                            <img src={ SkyImg }></img>
                        </div>
                    </SwiperSlide>
                </Swiper>
            </div>
        </React.Fragment>
    );
};

export default withTranslation('common')(Slide);
