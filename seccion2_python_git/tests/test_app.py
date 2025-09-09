import pytest
from app.app import summarize

@pytest.fixture
def sample_data():
    return [1, 2, 3, 4, 5]

def test_summarize_normal(sample_data):
    result = summarize(sample_data)
    assert result["count"] == 5
    assert result["sum"] == 15
    assert result["avg"] == 3

def test_summarize_borde():
    result = summarize([10])
    assert result["count"] == 1
    assert result["sum"] == 10
    assert result["avg"] == 10

def test_summarize_error():
    with pytest.raises(ValueError):
        summarize([])
