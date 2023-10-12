import {LightningElement} from 'lwc';
import weatherIconsResource from "@salesforce/resourceUrl/WeatherIcons";
import getForecast from '@salesforce/apex/WeatherWidgetController.getForecast';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';

export default class WeatherWidget extends LightningElement {
    rainIcon = weatherIconsResource + '/rain_icon.png'
    windIcon = weatherIconsResource + '/wind_icon.png'
    humidityIcon = weatherIconsResource + '/humidity_icon.png'

    isLoading;

    weatherData;

    async handleSearch(event) {
        const isEnterKey = event.keyCode === 13;
        if (!isEnterKey) return;
        this.showSpinner();

        let zipCode = event.target.value;

        try {
            let responseString = await getForecast({zipCode: zipCode});
            this.weatherData = JSON.parse(responseString);
            this.hideSpinner();
        } catch (error) {
            this.hideSpinner();
            this.showToast(error?.body?.message);
        }
    }

    showToast(message, variant = 'error') {
        const event = new ShowToastEvent({
            message: message,
            variant: variant
        });
        this.dispatchEvent(event);
    }

    showSpinner() {
        this.isLoading = true;
    }

    hideSpinner() {
        this.isLoading = false;
    }
}