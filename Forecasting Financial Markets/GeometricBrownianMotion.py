# -*- coding: utf-8 -*-
"""
Created on Fri Aug 23 21:17:16 2024

@author: Lakksan
"""

import pandas as pd
import datetime
import numpy as np
import matplotlib.pyplot as plt
import yfinance as yf

start = "2017-01-01"
end = '2018-01-01'
apple = yf.download('AAPL', start, end, auto_adjust=False)
apple_stockPrices = apple['Adj Close']
apple_stockPrices.plot(figsize=(15, 7))
plt.ylabel("Apple stock prices")
plt.title("Apple stock prices from period 01/01/2017 - 01/01/2018)")
plt.show()

start2 = "2018-01-01"
end2 = '2019-01-01'
apple2 = yf.download('AAPL', start2, end2, auto_adjust=False)
apple_stockPrices2 = apple2['Adj Close']
apple_stockPrices2.plot(figsize=(15, 7))
plt.ylabel("True Apple stock prices")
plt.title("Apple stock prices from period 01/01/2018 - 01/01/2019)")
plt.show()

# Number of steps
n = 100
# Time in years
T = 1
# Number of simulations
M = 100000
# Initial stock price
np.random.seed(1)

# Calculate log returns
log_returns = np.log(apple_stockPrices / apple_stockPrices.shift(1)).dropna()
log_returns.plot(figsize = (10,5))
plt.title("Log returns Apple Stock (2017-2018)")
plt.show()

# Calculate drift coefficients -> Volatility
rolling_windows = 28
trading_days = 252
mu = np.mean(log_returns) * trading_days # Drift coefficient
print("Drift coefficent: ", mu)
volatility = log_returns.rolling(window=rolling_windows).std() * np.sqrt(trading_days)
volatility.plot(figsize=(10, 5))
plt.show()

# Geometric Brownian Motion Simulation
S0 = apple_stockPrices.iloc[-1]  # Initial stock price
r = 0.05  # Risk-free rate
V0 = volatility.iloc[-1] # Initial volatility
delta_t = T / n
S_fwd = np.zeros((n + 1, M)) # Prepopulate the forecasted values with zeros
S_fwd[0] = S0 # Initialise first value for forecasting

for t in range(1, n + 1):
    S_fwd[t] = S_fwd[t - 1] * np.exp((r - 0.5 * V0 ** 2) * delta_t + V0 * np.sqrt(delta_t) * np.random.standard_normal(M))
    # Implementation of the final equation
    
plt.figure(figsize = (10,5))
plt.plot(S_fwd[:,0:100])
plt.xlabel("Days in Future")
plt.ylabel("Projected Stock Price")
plt.title("Forecasted Stock Price Evolution (Apple Stock from period 01/01/2018 - 01/01/2019)")
plt.show()

plt.figure()
plt.hist(S_fwd[-1], bins = 100)
plt.xlabel("Final Stock Price")
plt.ylabel("Frequency")
plt.title("Histogram of Final Stock Prices")
plt.show()

# Calculate the median of the final stock prices
median_stock_price = np.median(S_fwd[-1])
print("Median of final forecasted stock prices:", median_stock_price)
print("True value of apple stocks at the end of the forecasted period: ", apple_stockPrices2[-1])