from flask import Flask, request, jsonify
from pymongo import MongoClient
from bson.objectid import ObjectId
import bcrypt

app = Flask(__name__)

client = MongoClient("mongodb://localhost:27017/")
db = client["gameSample"] # create or connect to a database
account = db["accounts"] # creating or accessing a collection
characters = db["characters"]
items = db["items"]

# Sample Delete
# account.delete_many({})

@app.route('/')
def hello_world():
    return "<p>Hello, World!</p>"

@app.route('/login', methods = ['POST'])
def login():
    if request.method == 'POST':
        data = request.form
        username = data.get('username')
        password = data.get('password', '')

        user = account.find_one({"username": username})

        print(user)

        if user and bcrypt.checkpw(password.encode(), user['password']):
            user_id = str(user['_id'])
            return jsonify({"status": "success", "user_id": user_id}), 200

    return "failed", 401 

@app.route('/checkChars', methods = ['POST'])
def checkChars():
    if request.method == 'POST':
        data = request.form
        _id = data.get('_id')

        characterCount = characters.count_documents({"user_id": ObjectId(_id)})

        if characterCount > 0:
            return jsonify ({"characterCount": characterCount}), 200
        else:
            return "noChar", 201
    return "failed", 401 

@app.route('/getCharacter', methods = ['POST'])
def getCharacter():
    if request.method == 'POST':
        data = request.get_json()
        print(data)
        _id = data.get('_id')

        allUserChars = characters.find({"_id": ObjectId(_id)})

        result = []

        for character in allUserChars:
            character['_id'] = str(character['_id'])
            character['user_id'] = str(character['user_id'])

            if isinstance(character.get("items"), list):
                character["items"] = [str(item) for item in character["items"]]

            result.append(character)

        return jsonify(result), 200

    return jsonify({"status" : "failed"}), 401 

# Read
@app.route('/getChars', methods = ['POST'])
def getChars():
    if request.method == 'POST':
        data = request.get_json()
        print(data)
        _id = data.get('_id')

        allUserChars = characters.find({"user_id": ObjectId(_id)})

        result = []

        for character in allUserChars:
            character['_id'] = str(character['_id'])
            character['user_id'] = str(character['user_id'])

            if isinstance(character.get("items"), list):
                character["items"] = [str(item) for item in character["items"]]

            result.append(character)
        print(result)

        return jsonify(result), 200
    return jsonify({"status" : "failed"}), 401 

# Update
@app.route('/modifyStat', methods = ['POST'])
def modifyStat():
    if request.method == 'POST':
        data = request.get_json()
        _id = data.get('_id')
        char_id = data.get('char_id')
        stat = data.get('stat')
        points = data.get('points')

        characters.update_one({ "_id": ObjectId(char_id) },{"$inc": { "stats." + stat: points } })

        return jsonify({"status": "success"}), 200

    return jsonify({"status" : "failed"}), 401 

@app.route('/addChar', methods = ['POST'])
def addChar():
    if request.method == 'POST':
        data = request.form
        _id = data.get('_id')
        charname = data.get('charname') 

        insertedCharacter = characters.insert_one({"user_id": ObjectId(_id), "characterName" : charname, "stats": {"attack" : 1, "speed": 1, "defense": 1}, "items": {}, "points": 0, "gold": 0})

        print(insertedCharacter)

        if insertedCharacter:
            return "success", 200

    return "failed", 401 

# Create
@app.route('/register', methods = ['POST'])
def register():
    if request.method == 'POST':
        data = request.form
        username= data.get('username')
        password = data.get('password', '')

        password_hashed = bcrypt.hashpw(password.encode(),bcrypt.gensalt())

        if account.find_one({"username" : username}):
            return "exists", 200

        # start transaction
        result = account.insert_one({"username": username, "password": password_hashed})

        print(result)
    return "success", 200

@app.route('/setHighScore', methods = ['POST'])
def setHighScore():
    if request.method == 'POST':
        data = request.get_json()

        print("Raw data:", request.data)
        print("Parsed JSON:", data)

        char_id = data.get("char_id")
        score = data.get("score")

        char_score = characters.find_one({"_id": ObjectId(char_id)},{"_id": 0, "points": 1})
        print(char_id)
        print(char_score)

        if not char_score or char_score['points'] < score:
            characters.update_one({"_id": ObjectId(char_id)}, {"$set": {"points" : score}})

        return jsonify({"status": "success"}), 200

    return jsonify({"status" : "failed"}), 401 

@app.route('/getShopItems', methods=['POST'])
def getShopItems():
    data = request.get_json()
    char_id = data.get('char_id')
    owned_item_ids = []

    character = characters.find_one({"_id": ObjectId(char_id)})
    if character:
        owned_item_ids = character.get('items', [])
    
    # Convert all to ObjectId
    owned_item_ids = [ObjectId(item_id) for item_id in owned_item_ids]

    # Find items NOT in the owned list
    shopItems = items.find({"_id": {"$nin": owned_item_ids}})

    result = []
    for shopItem in shopItems:
        shopItem['_id'] = str(shopItem['_id'])
        shopItem['name'] = str(shopItem['name'])
        shopItem['type'] = str(shopItem['type'])
        shopItem['stat'] = str(shopItem['stat'])
        shopItem['tier'] = str(shopItem['tier'])
        shopItem['bonus'] = str(shopItem['bonus'])
        shopItem['cost'] = str(shopItem['cost'])
        result.append(shopItem)

    return jsonify(result), 200

@app.route('/addGold', methods = ['POST'])
def addGold():
    if request.method == 'POST':
        data = request.get_json()
        _id = data.get('_id')
        gold = data.get('gold')

        characters.update_one({ "_id": ObjectId(_id) },{"$inc": { "gold" : gold} })

        return jsonify({"status": "success"}), 200

    return jsonify({"status" : "failed"}), 401 

@app.route('/reduceGold', methods = ['POST'])
def reduceGold():
    if request.method == 'POST':
        data = request.get_json()

        print("Data: ")
        print(data)

        _id = data.get('_id')
        gold = data.get('gold')

        gold = -1 * int(gold)

        characters.update_one({ "_id": ObjectId(_id) },{"$inc": { "gold" : gold} })

        return jsonify({"status": "success"}), 200

    return jsonify({"status" : "failed"}), 401 

@app.route('/addItem', methods = ['POST'])
def addItem():
    if request.method == 'POST':
        data = request.get_json()
        _id = data.get('_id')
        itemId = data.get('itemId')

        characters.update_one({"_id": ObjectId(_id)}, {"$addToSet": {"items": ObjectId(itemId)}})

        return jsonify({"status": "success"}), 200


    return jsonify({"status" : "failed"}), 401 

@app.route('/getItems', methods=['POST'])
def getItems():
    data = request.get_json()
    char_id = data.get('char_id')
    owned_item_ids = []

    character = characters.find_one({"_id": ObjectId(char_id)})

    if character:
        owned_item_ids = character.get('items', [])

    # Make sure item IDs are ObjectId
    owned_item_ids = [ObjectId(item_id) for item_id in owned_item_ids]

    owned_items = items.find({"_id": {"$in": owned_item_ids}})

    result = []
    for item in owned_items:
        result.append({
            '_id': str(item['_id']),
            'name': str(item['name']),
            'type': str(item['type']),
            'stat': str(item['stat']),
            'tier': str(item['tier']),
            'bonus': str(item['bonus']),
            'cost': str(item['cost'])
        })

    return jsonify(result), 200
