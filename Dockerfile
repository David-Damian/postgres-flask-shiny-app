# syntax=docker/dockerfile:1
FROM python:3
WORKDIR /code
ENV FLASK_APP=load_data.py
ENV FLASK_RUN_HOST=0.0.0.0
COPY requirements.txt datos/winequality-red-raw.csv ./
RUN pip install --no-cache-dir -r requirements.txt
EXPOSE 5000
COPY . .
CMD [ "python", "load_data.py" ]