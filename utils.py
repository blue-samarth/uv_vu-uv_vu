import yfinance as yf
import json

save_path : str = "stocks.json"

def get_stock_data(ticker : str) -> dict:
    """
    This function will get the stock data for a given ticker

    Args:
        ticker : str : The ticker of the stock to get data for
    
    Returns:
        dict : The stock data
    
    Raises:
        Exception : If the stock data could not be found
    """
    try:
        stock = yf.Ticker(ticker)
        data = stock.info
        return data
    except Exception as e:
        raise e


def add_stocklist(tickers : list) -> None:
    """
    This function will add a list of tickers to the json file

    Args:
        tickers : list : The list of tickers to add
    
    Returns:
    
    Raises:
    """
    try:
        with open(save_path , 'w') as file:
            json.dump(tickers , file)
    except FileNotFoundError as e:
        raise 