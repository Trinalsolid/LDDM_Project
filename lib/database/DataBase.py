from flask import Flask, request, jsonify
import os
from dotenv import load_dotenv
import firebase_admin
from firebase_admin import credentials, firestore

# Carregar variáveis do .env
load_dotenv()

# Configuração do Firebase
firebaseConfig = {
    "apiKey": os.getenv("FIREBASE_API_KEY"),
    "authDomain": os.getenv("FIREBASE_AUTH_DOMAIN"),
    "databaseURL": os.getenv("FIREBASE_DATABASE_URL"),
    "projectId": os.getenv("FIREBASE_PROJECT_ID"),
    "storageBucket": os.getenv("FIREBASE_STORAGE_BUCKET"),
    "messagingSenderId": os.getenv("FIREBASE_MESSAGING_SENDER_ID"),
    "appId": os.getenv("FIREBASE_APP_ID"),
    "measurementId": os.getenv("FIREBASE_MEASUREMENT_ID"),
}

# Inicializar Firebase
cred = credentials.Certificate(firebaseConfig)
firebase_admin.initialize_app(cred)

# Inicializar o Firestore
db = firestore.client()

# Função para adicionar usuário no Firebase
def add_user(nome, email, senha):
    try:
        user_ref = db.collection('users').document()
        user_ref.set({
            'nome': nome,
            'email': email,
            'senha': senha,
        })
        return {"message": f"Usuário {nome} adicionado com sucesso!"}
    except Exception as e:
        return {"error": f"Erro ao adicionar usuário: {e}"}

# Configuração do Flask
app = Flask(__name__)

# Rota para adicionar usuário
@app.route('/add_user', methods=['POST'])
def add_user_route():
    data = request.json
    nome = data.get('nome')
    email = data.get('email')
    senha = data.get('senha')
    
    if not nome or not email or not senha:
        return jsonify({"error": "Nome, email e senha são obrigatórios"}), 400

    result = add_user(nome, email, senha)
    return jsonify(result)

# Rodando o servidor Flask
if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
