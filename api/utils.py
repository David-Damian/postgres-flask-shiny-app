import numpy as np
from sklearn.linear_model import Lasso
from sklearn.preprocessing import StandardScaler
from sklearn.ensemble import GradientBoostingRegressor


def train_model(trainset):
    """
    Esta función entrena un modelo Gradient Boost
    trainset: Conjunto de entrnamiento
    
    trainset es un array que tiene:
    columna 1, x1: 'volatile_acidity'
    columna 2, x2: 'density'
    columna 3, x3: 'alcohol'
    columna 4, y: 'quality' (Objetivo)    
    """
    X = trainset[:,0:-1]
    y = trainset[:,-1]
    
    #Columnas de interacciones
    x1_x2 = trainset[:,0] * trainset[:,1]
    x2_x3 = trainset[:,1] * trainset[:,2]
    x3_x1 = trainset[:,2] * trainset[:,0]
    interactions = np.stack((x1_x2, x2_x3, x3_x1), axis=1)
    xtrain = np.append(X, interactions, axis=1)
    
    #Escalador
    scaler = StandardScaler()
    xtrain_scaled = scaler.fit_transform(xtrain)

    #Entrenamiento
    model = GradientBoostingRegressor(learning_rate=0.1,
                                      max_features=3,
                                      n_estimators=175)
    model.fit(xtrain_scaled, y)
    
    return model