import pytest

from libs.assertions import assert_not_found , assert_not_none , base_assertion
from libs.exceptions import CustomError

def test_base_assertion():
    with pytest.raises(CustomError) as e:
        base_assertion(False , "Assertion failed" , 400)
    assert e.value.message == "Assertion failed"
    assert e.value.status_code == 400

def test_assert_not_none():
    with pytest.raises(CustomError) as e:
        assert_not_none(None , "Value is None" , 400)
    assert e.value.message == "Value is None"
    assert e.value.status_code == 400

def test_assert_not_found():
    with pytest.raises(CustomError) as e:
        assert_not_found(None , "Resource not found" , 404)
    assert e.value.message == "Resource not found"
    assert e.value.status_code == 404

