class CustomError(Exception):
    """Base class for other exceptions"""
    def __init__(self, message : str = "An error occurred" , status_code : int = 400):
        super().__init__(message)
        self.message : str = message
        self.status_code : int = status_code

    def to_dict(self) -> dict:
        """
        This function will return the error message as a dictionary
        Returns:
            dict : The error message as a dictionary
        """
        return {"message" : self.message , "status_code" : self.status_code}