from typing import List , Dict , Union
import yfinance as yf
import json
from libs.assertions import assert_not_found , assert_not_none

save_path : str = "stocks.json"

def get_stock_data(ticker : str) -> dict:
    """
    This function will get the stock data for a given ticker

    Args:
        ticker : str : The ticker of the stock to get data for
    
    Returns:
        dict : Dictionary containing stock data metrics
    
    Raises:
        Exception : If the stock data could not be found
    """
    try:
        stock = yf.Ticker(ticker)
        data = stock.history(period = "1d")
        assert_not_none(data ,"Data not found" , 404)
            # return None
        row = data.iloc[-1]
        return {
            "ticker" : ticker,
            "price" : row['Close'],
            "high" : row['High'],
            "low" : row['Low'],
            "volume" : row['Volume'],
            "open" : row['Open'],
            "previous_close" : stock.info.get('previousClose', row['Close']),
            "change" : row['Close'] - stock.info.get('previousClose', row['Close']),
            "percent_change" : (row['Close'] - stock.info.get('previousClose', row['Close'])) / stock.info.get('previousClose', row['Close']) * 100,
            "date_time" : row.name.strftime("%Y-%m-%d %H:%M:%S")

        }
    except AssertionError as e:
        raise e

    except Exception as e:
        raise e


def save_stocklist(tickers : list) -> None:
    """
    This function will add a list of tickers to the json file

    Args:
        tickers : list : The list of tickers to add
    Raises:
        Exception: If the file operation fails
    """
    try:
        with open(save_path , 'w') as file:
            json.dump(tickers , file)
    except FileNotFoundError:
        raise assert_not_found("File not found" , 404)
    except Exception as e:
        raise e
        

def get_stocklist() -> list:
    """
    This function will get the list of tickers from the json file
    
    Returns:
        list : The list of tickers
    Raises:
        Exception : If the file could not be found
    """
    try:
        with open(save_path , 'r') as file:
            data : List  = json.load(file)
            return data
    except FileNotFoundError:
        raise assert_not_found("File not found" , 404)
    except Exception as e:
        raise e