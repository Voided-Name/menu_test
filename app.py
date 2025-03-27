from flask import Flask, request
from pymongo import MongoClient

app = Flask(__name__)
client = MongoClient("mongodb://localhost:27017/")
db = client["gameSample"]
account = db["accounts"]

@app.route('/')
def hello_world():
    return "<p>Hello, World!</p>"

@app.route('/register', methods = ['POST'])
def register():
    if request.method == 'POST':
        data = request.form
        username= data.get('username')
        password = data.get('password')

        if account.find_one({"username" : username}):
            return "exists", 200

        account.insert_one({"username": username, "password": password})

        print("key 1: ", username)
        print("key 2: ", password)
    return "success", 200
