import requests

url = 'http://127.0.0.1:5000/itens'

user_data = {
    "nome": "João",
    "email": "joao@example.com",
    "senha": "senha123",
    "data_nasc": "1990-01-01"
}

#response = requests.post(url, json=user_data)
#response = requests.delete(f'{url}/{user_data["email"]}')
response = requests.get(f'{url}/{user_data["email"]}')

if response.status_code == 201:
    print("Usuário criado com sucesso:", response.json())
elif response.status_code == 400:
    print("Erro ao criar usuário:", response.json())
else:
    print("Erro inesperado:", response.status_code, response.text)