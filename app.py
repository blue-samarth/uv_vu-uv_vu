from flask import Flask , render_template , request , redirect , url_for , flash

app : callable = Flask(__name__)
app.secret_key : str = "mysecretkey"

@app.route('/' , methods = ['GET' , 'POST'])
def index():
    """
    This function will render the main page of the application
    The main page will have a form to add a new stock
    The main page will have a list of all the stocks that have been added

    Returns:

    Raises:


    """
    return render_template('index.html')

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
    pass


if __name__ == '__main__':
    app.run(debug = True)