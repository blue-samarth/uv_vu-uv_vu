# 📈 Stock Tracker Pro

> Real-time market intelligence at your fingertips

A powerful, elegant stock tracking application that combines the speed of Flask with the reliability of UV package management. Built for investors who demand accuracy and performance, this tool delivers real-time market data through an intuitive interface. Track your favorite stocks, monitor price changes, and analyze historical trends with ease. Stock Tracker Pro is the ultimate solution for investors who value precision and efficiency.

---

## ✨ Highlights

Experience professional-grade market monitoring with features designed for both novice and experienced investors:

- **Real-Time Data**: Live market updates powered by Yahoo Finance
- **Smart Watchlist**: Intelligent portfolio tracking with key metrics
- **Type-Safe**: Leveraging Python's type system for reliability
- **Modern Stack**: Built on UV, the cutting-edge Rust-based package manager
- **Responsive Design**: Seamless experience across all devices

## 🚀 Quick Start

Transform your investment monitoring in minutes:

```bash
# Install UV - The Next-Gen Package Manager
curl -LsSf https://astral.sh/uv/install.sh | sh

# Clone and Enter Project
git clone <repository-url>
cd uv_vu-uv_vu

# Run the Application
uv run python3 app.py
```

That's it! UV will automatically handle all dependencies defined in pyproject.toml. Visit `http://localhost:5000` to start tracking stocks.

## 📦 Dependencies

All project dependencies are automatically managed through UV using our pyproject.toml configuration. This ensures consistent environments and eliminates manual dependency installation. Key packages include:

- Flask: Web application framework
- yfinance: Real-time market data integration
- Type hints: Built-in Python typing support

[Rest of the README remains the same...]

## 🏗️ Architecture

Our thoughtfully structured codebase ensures maintainability and scalability:

```
stock-tracker/
├── 📱 app.py              # Application core
├── 🛠️ utils.py            # Data utilities
├── 📚 libs/
    ├──exepctions.py       # Error handling
│   └── assertions.py     # Validation layer
├── 🎨 templates/
│   └── index.html        # User interface
└── 📋 stocks.json        # Data persistence
```

## 💡 Core Features

### Market Intelligence
- Real-time price tracking
- Historical data analysis
- Volume monitoring
- Price change calculations
- Trend visualization

### Portfolio Management
- Custom watchlist creation
- One-click stock addition
- Instant removal capability
- Persistent storage
- Error-proof data validation

### Technical Integration
- REST API endpoints
- Type-safe operations
- Comprehensive error handling
- Real-time data synchronization
- Clean architecture patterns

## 🔧 API Reference

### Application Layer (app.py)

```python
@app.route('/', methods=['GET', 'POST'])
def index():
    """
    Main dashboard controller handling stock operations
    Returns: Dashboard view with real-time market data
    """
```

```python
@app.route('/remove/<ticker>')
def remove(ticker: str):
    """
    Stock removal controller
    Args: ticker (str): Target stock identifier
    """
```

### Utility Layer (utils.py)

```python
def get_stock_data(ticker: str) -> dict:
    """
    Real-time market data retrieval
    Returns: Comprehensive stock metrics
    """
```

```python
def save_stocklist(tickers: list) -> None:
    """
    Watchlist persistence handler
    Args: tickers (list): Active stock collection
    """
```

## 🛠️ Development

Enhance your development workflow:

```bash
# Development Mode
flask run --debug

# Type Checking
mypy app.py utils.py

# Testing
pytest tests/
```

## 🤝 Contributing

We welcome contributions that improve Stock Tracker Pro:

1. 🍴 Fork the repository
2. 🌿 Create your feature branch
3. 💻 Implement your changes
4. ✅ Add comprehensive tests
5. 📊 Submit a detailed pull request

## 📜 License

Released under the MIT License. See `LICENSE` for details.

## 🙏 Acknowledgments

Built with excellence using:
- UV: Next-generation Python package management
- Flask: Lightweight WSGI web application framework
- Yahoo Finance API: Real-time market data provider
- Python Type Hints: Enhanced code reliability

---

<div align="center">

**[Documentation](docs/) • [Report Bug](issues/) • [Request Feature](issues/)**

Made with ❤️ by Samarth 

</div>