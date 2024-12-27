from typing import Dict
from flask import Flask , render_template , request , redirect , url_for , flash
from utils import save_stocklist , get_stocklist , get_stock_data , save_path
from libs.exceptions import CustomError

app : callable = Flask(__name__)
app.secret_key : str = "mysecretkey"

# we will check if save_path exists if not we will create it
try:
    with open(save_path , 'r') as file:
        pass
except FileNotFoundError:
    with open(save_path , 'w') as file:
        file.write("[]")
except Exception as e:
    raise e

@app.route('/' , methods = ['GET' , 'POST'])
def index():
    """
    This function will render the main page of the application
    The main page will have a form to add a new stock
    The main page will have a list of all the stocks that have been added

    Returns:

    Raises:

    """
    tickers : list = get_stocklist()
    if request.method == 'POST':
        ticker_name : str = ''
        ticker_name = request.form.get('ticker').upper().strip()
        if not ticker_name: flash("Please enter a ticker" , "error")
        else:
            try:
                data : Dict = get_stock_data(ticker_name)
            except CustomError:
                flash(f"Stock : {ticker_name} not found" , "error")
                return redirect(url_for('index'))
            if data:
                if data not in tickers:
                    tickers.append(data)
                    save_stocklist(tickers)
                    flash(f"Stock : {ticker_name} added successfully" , "success")
                else:
                    flash(f"Stock : {ticker_name} already exists" , "info")
        return redirect(url_for('index'))
    
    else:
        stock_list : list = []
        for ticker in tickers:
            stock_list.append(get_stock_data(ticker['ticker']))
        return render_template('index.html' , stock_list = stock_list)

@app.route('/remove/<ticker> : str')
def remove(ticker : str):
    """
    This function will remove a stock from the json file
    This function will redirect to the main page
    Args:
        ticker : str : The ticker of the stock to remove
    
    Returns:

    Raises:
    """
    tickers : list = get_stocklist()
    if any(ticker == stock['ticker'] for stock in tickers):
        tickers = [stock for stock in tickers if stock['ticker'] != ticker]
        save_stocklist(tickers)
        flash(f"Stock : {ticker} removed successfully" , "success")
        return redirect(url_for('index'))
    else:
        flash(f"Stock : {ticker} not found" , "error")
    return redirect(url_for('index'))


# if __name__ == '__main__':
#     # This part would typically be managed by Gunicorn or another WSGI server in production
#     app.run(host='0.0.0.0', port=5000)