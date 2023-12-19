#Obtain Data Exchange Rate of AutoChek Presence Country

'''Writing a scheduling function script that pull the data and save in this format, timestamp, 
which is the datetime in which the record was pulled, currency_from, which is the currency you are 
converting from (should always be USD), USD_to_currency_rate for Nigeria, Ghana,
Kenya, Uganda, Morocco, Côte d'Ivoire and Egypt.'''

#Import the package necessary to carry out the data analysis
import requests
import datetime
import pandas as pd
import schedule
import time

#Writing fetching exchange rate function that pull the 7 currencies from https://www.xe.com/xecurrencydata/ 
def fetch_exchange_rates():
    api_url = "https://xecdapi.xe.com/v1/convert_from.json/"
    headers = {"Authorization": "Basic [Your-API-Key]"}
    params = {
        "from": "USD",
        "to": "NGN,GHS,KES,UGX,MAD,XOF,EGP",
        "amount": 1
    }

    response = requests.get(api_url, headers=headers, params=params)
    data = response.json()

    rates = []
    for rate in data['to']:
        timestamp = datetime.datetime.now()
        currency_from = "USD"
        USD_to_currency_rate = rate['mid']
        currency_to = rate['quotecurrency']
        currency_to_USD_rate = 1 / rate['mid'] if rate['mid'] != 0 else None

        rates.append([timestamp, currency_from, USD_to_currency_rate, currency_to_USD_rate, currency_to])

    df = pd.DataFrame(rates, columns=['timestamp', 'currency_from', 'USD_to_currency_rate', 'currency_to_USD_rate', 'currency_to'])
    df.to_csv('exchange_rates.csv', mode='a', header=False, index=False)


# Schedule to run at 1 AM and 11 PM every day
schedule.every().day.at("01:00").do(fetch_exchange_rates)
schedule.every().day.at("23:00").do(fetch_exchange_rates)

while True:
    schedule.run_pending()
    time.sleep(1)