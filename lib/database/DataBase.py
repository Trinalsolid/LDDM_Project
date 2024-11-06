import sqlite3
from flask import Flask, jsonify, request, g

app = Flask(__name__)

# Configuração do nome do banco de dados
DATABASE = 'itens.db'

# Função para conectar ao banco de dados
def get_db():
    db = getattr(g, '_database', None)
    if db is None:
        db = g._database = sqlite3.connect(DATABASE)
    return db

# Função para inicializar o banco de dados
def init_db():
    with app.app_context():
        db = get_db()
        cursor = db.cursor()
        cursor.execute('''
            CREATE TABLE IF NOT EXISTS user (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                nome TEXT NOT NULL,
                email TEXT UNIQUE NOT NULL,
                senha TEXT NOT NULL,
                data_nasc TEXT NOT NULL,
                tipo_sanguineo TEXT,
                alergias TEXT
            );
        ''')
        db.commit()

# Fechar a conexão do banco de dados ao final da requisição
@app.teardown_appcontext
def close_connection(exception):
    db = getattr(g, '_database', None)
    if db is not None:
        db.close()

# Endpoint para obter todos os usuários
@app.route('/itens', methods=['GET'])
def get_itens():
    cursor = get_db().cursor()
    cursor.execute("SELECT * FROM user")
    itens = cursor.fetchall()
    itens_list = [{'id': row[0], 'nome': row[1], 'email': row[2], 'senha': row[3], 'data_nasc': row[4]} for row in itens]
    return jsonify(itens_list), 200

# Endpoint para obter um item específico pelo email
@app.route('/itens/<string:item_email>', methods=['GET'])
def get_item(item_email):
    cursor = get_db().cursor()
    cursor.execute("SELECT * FROM user WHERE email = ?", (item_email,))
    item = cursor.fetchone()
    if item:
        return jsonify({'id': item[0], 'nome': item[1], 'email': item[2], 'senha': item[3], 'data_nasc': item[4]}), 200
    return jsonify({'error': 'Item não encontrado'}), 404

# Endpoint para criar um novo usuário
@app.route('/itens', methods=['POST'])
def create_item():
    novo_item = request.json
    nome = novo_item.get('nome')
    email = novo_item.get('email')
    senha = novo_item.get('senha')
    data_nasc = novo_item.get('data_nasc')

    if not nome or not email or not senha or not data_nasc:
        return jsonify({'error': 'Campos "nome", "email", "senha" e "data_nasc" são obrigatórios'}), 400

    db = get_db()
    cursor = db.cursor()
    try:
        cursor.execute("INSERT INTO user (nome, email, senha, data_nasc) VALUES (?, ?, ?, ?)", 
                       (nome, email, senha, data_nasc))
        db.commit()
        item_id = cursor.lastrowid
        return jsonify({'id': item_id, 'nome': nome, 'email': email, 'senha': senha, 'data_nasc': data_nasc}), 201
    except sqlite3.IntegrityError:
        return jsonify({'error': 'Email já está em uso'}), 400

# Endpoint para deletar um usuário pelo email
@app.route('/itens/<string:item_email>', methods=['DELETE'])
def delete_item(item_email):
    db = get_db()
    cursor = db.cursor()
    cursor.execute("SELECT * FROM user WHERE email = ?", (item_email,))
    item = cursor.fetchone()

    if not item:
        return jsonify({'error': 'Item não encontrado'}), 404

    cursor.execute("DELETE FROM user WHERE email = ?", (item_email,))
    db.commit()
    return jsonify({'message': 'Item deletado', 'user': {'id': item[0], 'nome': item[1], 'email': item[2], 'senha': item[3], 'data_nasc': item[4]}}), 200

if __name__ == '__main__':
    init_db()  # Inicializa o banco de dados na primeira execução
    app.run(debug=True)
