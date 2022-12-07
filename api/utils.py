import numpy as np
from sklearn.linear_model import Lasso
from sklearn.preprocessing import MinMaxScaler


def predict_quality(trainset, X):
    lasso = Lasso(alpha=0.01)
    scaler = MinMaxScaler()
    
    scale_set = np.vstack((trainset[:, 0:-1], X))
    scale_set = scaler.fit_transform(scale_set)

    X = np.array([scale_set[-1,:]])
    xtrain = scale_set[:-1, :]

    ytrain = trainset[:,-1]
    model = lasso.fit(xtrain, ytrain)
    quality = model.predict(X).round()

    return (quality[0], X, model.coef_)