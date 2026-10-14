NOVA ERA MOTORS — FLASK + MYSQL

1. Requisitos
- Python 3.10 ou superior
- MySQL Server e MySQL Workbench (ou outro cliente SQL)

2. Preparar o banco
- Abra o arquivo schema.sql no MySQL Workbench.
- Execute o script inteiro. Ele cria o banco nova_era_motors e as tabelas que ainda não existirem.
- Se você já tem dados no banco, CREATE TABLE IF NOT EXISTS não apaga esses dados.

3. Preparar o Python
Abra o terminal dentro da pasta nova_era_motors e execute:
  python -m venv .venv

No Windows:
  .venv\Scripts\activate

Instale as dependências:
  pip install -r requirements.txt

4. Configurar o acesso ao MySQL
O app.py usa por padrão host 127.0.0.1, usuário root, senha senai105 e banco nova_era_motors.
Se sua senha for diferente, configure a variável MYSQL_PASSWORD antes de iniciar ou altere o valor padrão no app.py.
Exemplo no PowerShell:
  $env:MYSQL_PASSWORD="SUA_SENHA_MYSQL"

Opcionalmente, configure MYSQL_USER, MYSQL_HOST e MYSQL_DATABASE. O arquivo .env.example é um modelo de referência; o Python não carrega esse arquivo automaticamente.

5. Iniciar o site
  python app.py
Abra no navegador:
  http://127.0.0.1:5000

6. Funções implementadas
- Cadastro e consulta de clientes
- Cadastro e consulta de veículos
- Cadastro e consulta de funcionários
- Registro e consulta de vendas, com seleção dos registros relacionados
- Formulário de contato gravado na tabela contatos
- Consulta das mensagens recebidas em /contatos

Observações
- O CPF de clientes e funcionários e a placa do veículo são únicos no banco.
- O status inicial de veículo usa Disponivel (sem acento), conforme o SQL; a tela exibe “Disponível”.
- Para registrar uma venda, cadastre primeiro um cliente, um funcionário e um veículo disponível.
- Este projeto é para desenvolvimento local/aula. Antes de publicar, configure uma chave secreta forte, desative debug e não deixe senhas fixas no código.
