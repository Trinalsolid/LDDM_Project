import os

def buscar_arquivo(diretorio, nome_arquivo):
  """
  Busca um arquivo específico em um diretório e seus subdiretórios.

  Args:
    diretorio: O diretório inicial da busca.
    nome_arquivo: O nome do arquivo a ser procurado.

  Returns:
    Uma lista com os caminhos completos dos arquivos encontrados, ou uma lista vazia se nenhum arquivo for encontrado.
  """

  arquivos_encontrados = []
  for raiz, diretorios, arquivos in os.walk(diretorio):
      for arquivo in arquivos:
          if arquivo == nome_arquivo:
              caminho_completo = os.path.join(raiz, arquivo)
              arquivos_encontrados.append(caminho_completo)
  return arquivos_encontrados

# Exemplo de uso:
diretorio_inicial = r"C:\Meu projetos\LDDM\lddm_project"
arquivo_procurado = "user_database.db"

resultados = buscar_arquivo(diretorio_inicial, arquivo_procurado)

if resultados:
    print("Arquivos encontrados:")
    for arquivo in resultados:
        print(arquivo)
else:
    print("Arquivo não encontrado.")