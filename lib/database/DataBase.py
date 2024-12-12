from flask import Flask, request, jsonify
import os
from dotenv import load_dotenv
import firebase_admin
from firebase_admin import credentials, firestore

# Carregar variáveis do .env
load_dotenv()

# Configuração do Firebase
firebaseConfig = {
    "type": "service_account",
    "project_id": os.getenv("FIREBASE_PROJECT_ID"),
    "private_key_id": os.getenv("FIREBASE_PRIVATE_KEY_ID"),
    "private_key": os.getenv("FIREBASE_PRIVATE_KEY").replace("\\n", "\n"),
    "client_email": os.getenv("FIREBASE_CLIENT_EMAIL"),
    "client_id": os.getenv("FIREBASE_CLIENT_ID"),
    "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    "token_uri": "https://oauth2.googleapis.com/token",
    "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
    "client_x509_cert_url": os.getenv("FIREBASE_CLIENT_CERT_URL"),
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
