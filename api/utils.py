import numpy as np
from sklearn.linear_model import Lasso
from sklearn.preprocessing import MinMaxScaler


def predict_quality(trainset, X):
    lasso = Lasso()
    scaler = MinMaxScaler()
    
    X = scaler.fit_transform(X)
    xtrain = scaler.fit_transform(trainset[:, 0:-1])
    ytrain = trainset[:,-1]

    model = lasso.fit(xtrain, ytrain)
    quality = model.predict(X).round()

    return quality[0]