import {LightningElement, api} from 'lwc';

export default class WeatherToday extends LightningElement {

    @api weatherData;
    @api humidityIcon;
    @api windIcon;
}