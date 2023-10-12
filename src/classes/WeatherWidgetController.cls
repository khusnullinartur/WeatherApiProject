public with sharing class WeatherWidgetController {

    @AuraEnabled
    public static String getForecast(String zipCode) {
        try {
            return WeatherAPIService.sendRequestToWeatherAPI(zipCode);
        } catch (Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }
}