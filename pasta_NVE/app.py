import os
from decimal import Decimal, InvalidOperation

import mysql.connector
from mysql.connector import Error, IntegrityError
from flask import Flask, render_template, request, redirect, url_for, flash

app = Flask(__name__)
app.secret_key = os.getenv("FLASK_SECRET_KEY", "nova-era-motors-local-dev")


def conectar_mysql():
    """Abre a conexão com o banco Nova Era Motors."""
    return mysql.connector.connect(
        host=os.getenv("MYSQL_HOST", "127.0.0.1"),
        user=os.getenv("MYSQL_USER", "root"),
        password=os.getenv("MYSQL_PASSWORD", "senai105"),
        database=os.getenv("MYSQL_DATABASE", "nova_era_motors"),
        autocommit=False,
    )


def consultar(sql, parametros=(), uma_linha=False):
    conexao = conectar_mysql()
    cursor = conexao.cursor(dictionary=True)
    try:
        cursor.execute(sql, parametros)
        return cursor.fetchone() if uma_linha else cursor.fetchall()
    finally:
        cursor.close()
        conexao.close()


def executar(sql, parametros=()):
    conexao = conectar_mysql()
    cursor = conexao.cursor()
    try:
        cursor.execute(sql, parametros)
        conexao.commit()
        return cursor.lastrowid
    except Exception:
        conexao.rollback()
        raise
    finally:
        cursor.close()
        conexao.close()


def erro_banco(mensagem_padrao="Não foi possível concluir a operação."):
    flash(mensagem_padrao, "erro")


@app.route("/")
def inicio():
    return render_template("index.html")


@app.route("/clientes")
def consultar_clientes():
    try:
        clientes = consultar("SELECT id_cliente, nome, cpf, telefone, email, endereco FROM clientes ORDER BY id_cliente DESC")
        return render_template("consulta.html", clientes=clientes)
    except Error:
        return render_template("consulta.html", clientes=[], erro="Não foi possível consultar os clientes. Confira a conexão e a tabela clientes."), 500


@app.route("/clientes/cadastrar", methods=["GET", "POST"])
def cadastrar_cliente():
    if request.method == "GET":
        return render_template("cadastro_cliente.html")
    dados = {campo: request.form.get(campo, "").strip() for campo in ("nome", "cpf", "telefone", "email", "endereco")}
    if not dados["nome"] or not dados["cpf"] or not dados["email"]:
        flash("Preencha nome, CPF e e-mail.", "erro")
        return render_template("cadastro_cliente.html", dados=dados), 400
    try:
        executar("INSERT INTO clientes (nome, cpf, telefone, email, endereco) VALUES (%s, %s, %s, %s, %s)",
                 (dados["nome"], dados["cpf"], dados["telefone"] or None, dados["email"], dados["endereco"] or None))
        flash("Cliente cadastrado com sucesso!", "sucesso")
        return redirect(url_for("consultar_clientes"))
    except IntegrityError:
        flash("Esse CPF já está cadastrado. Confira o número informado.", "erro")
    except Error:
        flash("Erro ao salvar o cliente. Verifique o banco de dados.", "erro")
    return render_template("cadastro_cliente.html", dados=dados), 400


@app.route("/veiculos")
def consultar_veiculos():
    try:
        veiculos = consultar("SELECT id_veiculo, marca, modelo, ano, cor, placa, quilometragem, status, preco FROM veiculos ORDER BY id_veiculo DESC")
        return render_template("veiculos.html", veiculos=veiculos)
    except Error:
        return render_template("veiculos.html", veiculos=[], erro="Não foi possível consultar os veículos."), 500


@app.route("/veiculos/cadastrar", methods=["GET", "POST"])
def cadastrar_veiculo():
    if request.method == "GET":
        return render_template("cadastro_veiculo.html")
    dados = {campo: request.form.get(campo, "").strip() for campo in ("marca", "modelo", "ano", "cor", "placa", "quilometragem", "status", "preco")}
    try:
        ano = int(dados["ano"])
        km = int(dados["quilometragem"] or 0)
        preco = Decimal(dados["preco"].replace(",", "."))
        if not dados["marca"] or not dados["modelo"] or not dados["placa"] or ano < 1900 or km < 0 or preco <= 0:
            raise ValueError
        status = dados["status"] or "Disponivel"
        if status not in ("Disponivel", "Vendido", "Reservado"):
            raise ValueError
        executar("INSERT INTO veiculos (marca, modelo, ano, cor, placa, quilometragem, status, preco) VALUES (%s,%s,%s,%s,%s,%s,%s,%s)",
                 (dados["marca"], dados["modelo"], ano, dados["cor"] or None, dados["placa"].upper(), km, status, preco))
        flash("Veículo cadastrado com sucesso!", "sucesso")
        return redirect(url_for("consultar_veiculos"))
    except (ValueError, InvalidOperation):
        flash("Confira ano, quilometragem, preço e os campos obrigatórios.", "erro")
    except IntegrityError:
        flash("Essa placa já está cadastrada.", "erro")
    except Error:
        flash("Erro ao salvar o veículo. Verifique a conexão com o MySQL.", "erro")
    return render_template("cadastro_veiculo.html", dados=dados), 400


@app.route("/funcionarios")
def consultar_funcionarios():
    try:
        funcionarios = consultar("SELECT id_funcionario, nome, cpf, telefone, email, cargo FROM funcionarios ORDER BY id_funcionario DESC")
        return render_template("funcionarios.html", funcionarios=funcionarios)
    except Error:
        return render_template("funcionarios.html", funcionarios=[], erro="Não foi possível consultar os funcionários."), 500


@app.route("/funcionarios/cadastrar", methods=["GET", "POST"])
def cadastrar_funcionario():
    if request.method == "GET":
        return render_template("cadastro_funcionario.html")
    dados = {campo: request.form.get(campo, "").strip() for campo in ("nome", "cpf", "telefone", "email", "cargo")}
    if not all(dados[c] for c in ("nome", "cpf", "email", "cargo")):
        flash("Preencha nome, CPF, e-mail e cargo.", "erro")
        return render_template("cadastro_funcionario.html", dados=dados), 400
    try:
        executar("INSERT INTO funcionarios (nome, cpf, telefone, email, cargo) VALUES (%s,%s,%s,%s,%s)",
                 (dados["nome"], dados["cpf"], dados["telefone"] or None, dados["email"], dados["cargo"]))
        flash("Funcionário cadastrado com sucesso!", "sucesso")
        return redirect(url_for("consultar_funcionarios"))
    except IntegrityError:
        flash("Esse CPF já está cadastrado para outro funcionário.", "erro")
    except Error:
        flash("Erro ao salvar o funcionário. Verifique o banco de dados.", "erro")
    return render_template("cadastro_funcionario.html", dados=dados), 400


@app.route("/vendas")
def consultar_vendas():
    try:
        vendas = consultar("""SELECT vd.id_venda, c.nome AS cliente, v.marca, v.modelo, v.preco,
                            f.nome AS funcionario FROM vendas vd
                            INNER JOIN clientes c ON c.id_cliente=vd.id_cliente
                            INNER JOIN veiculos v ON v.id_veiculo=vd.id_veiculo
                            INNER JOIN funcionarios f ON f.id_funcionario=vd.id_funcionario
                            ORDER BY vd.id_venda DESC""")
        return render_template("vendas.html", vendas=vendas)
    except Error:
        return render_template("vendas.html", vendas=[], erro="Não foi possível consultar as vendas."), 500


@app.route("/vendas/cadastrar", methods=["GET", "POST"])
def cadastrar_venda():
    if request.method == "GET":
        try:
            clientes = consultar("SELECT id_cliente, nome FROM clientes ORDER BY nome")
            veiculos = consultar("SELECT id_veiculo, marca, modelo, preco FROM veiculos WHERE status='Disponivel' ORDER BY marca, modelo")
            funcionarios = consultar("SELECT id_funcionario, nome FROM funcionarios ORDER BY nome")
            return render_template("cadastro_venda.html", clientes=clientes, veiculos=veiculos, funcionarios=funcionarios)
        except Error:
            flash("Não foi possível carregar as opções para a venda.", "erro")
            return redirect(url_for("inicio"))
    try:
        id_cliente = int(request.form.get("id_cliente", ""))
        id_veiculo = int(request.form.get("id_veiculo", ""))
        id_funcionario = int(request.form.get("id_funcionario", ""))
        executar("INSERT INTO vendas (id_cliente, id_veiculo, id_funcionario) VALUES (%s,%s,%s)", (id_cliente, id_veiculo, id_funcionario))
        executar("UPDATE veiculos SET status='Vendido' WHERE id_veiculo=%s", (id_veiculo,))
        flash("Venda registrada com sucesso!", "sucesso")
        return redirect(url_for("consultar_vendas"))
    except (ValueError, TypeError):
        flash("Selecione cliente, veículo e funcionário.", "erro")
    except Error:
        flash("Não foi possível registrar a venda. Confira se os cadastros existem e se o veículo está disponível.", "erro")
    return redirect(url_for("cadastrar_venda"))


@app.route("/contato", methods=["GET", "POST"])
def formulario():
    if request.method == "GET":
        return render_template("forms.html")
    dados = {campo: request.form.get(campo, "").strip() for campo in ("nome", "email", "telefone", "mensagem")}
    if not dados["nome"] or not dados["email"] or not dados["mensagem"]:
        flash("Preencha nome, e-mail e mensagem.", "erro")
        return render_template("forms.html", dados=dados), 400
    try:
        executar("INSERT INTO contatos (nome, email, telefone, mensagem) VALUES (%s,%s,%s,%s)",
                 (dados["nome"], dados["email"], dados["telefone"] or None, dados["mensagem"]))
        flash("Mensagem enviada com sucesso!", "sucesso")
        return redirect(url_for("formulario"))
    except Error:
        flash("Não foi possível salvar sua mensagem. Tente novamente.", "erro")
        return render_template("forms.html", dados=dados), 500


@app.route("/contatos")
def consultar_contatos():
    try:
        contatos = consultar("SELECT id_contato, nome, email, telefone, mensagem FROM contatos ORDER BY id_contato DESC")
        return render_template("contatos.html", contatos=contatos)
    except Error:
        return render_template("contatos.html", contatos=[], erro="Não foi possível consultar os contatos."), 500


@app.errorhandler(404)
def pagina_nao_encontrada(_erro):
    return render_template("mensagem.html", titulo="Página não encontrada", mensagem="O endereço acessado não existe.", tipo="erro"), 404


if __name__ == "__main__":
    app.run(debug=True)
