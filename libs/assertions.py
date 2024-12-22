from .exceptions import CustomError


def base_assertion(expression : bool , message : str = "Assertion failed" , status_code : int = 400) -> None:
    """
    This function will assert that the given expression is True
    Args:
        expression : bool : The expression to assert
        message : str : The message to return if the assertion fails
        status_code : int : The status code to return if the assertion fails
    Raises:
        CustomError : If the assertion fails
    """
    if not expression:
        raise CustomError(message , status_code)
    

def assert_not_none(value , message : str = "Value is None" , status_code : int = 400) -> None:
    """
    This function will assert that the given value is not None
    Args:
        value : Any : The value to assert
        message : str : The message to return if the assertion fails
        status_code : int : The status code to return if the assertion fails
    Raises:
        CustomError : If the assertion fails
    """
    base_assertion(value is not None , message , status_code)
