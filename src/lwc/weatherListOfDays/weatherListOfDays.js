import {LightningElement, api} from 'lwc';

export default class WeatherListOfDays extends LightningElement {

    @api weatherData;
    @api rainIcon;
    @api windIcon;
}