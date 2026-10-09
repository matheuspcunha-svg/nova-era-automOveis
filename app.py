import os
import mysql.connector
from mysql.connector import Error, IntegrityError
from flask import Flask, render_template, request

app = Flask(__name__)


def conectar_mysql():
    return mysql.connector.connect(
        host=os.getenv("MYSQL_HOST", "127.0.0.1"),
        user=os.getenv("MYSQL_USER", "root"),
        password=os.getenv("MYSQL_PASSWORD", "senai105"),
        database=os.getenv("MYSQL_DATABASE", "Nova_Era_Motors"),
        autocommit=False,
    )


@app.route("/")
def inicio():
    return render_template("index.html")


@app.route("/consulta")
@app.route("/clientes")
def consultar_clientes():
    clientes = []
    erro = None
    conexao = None
    cursor = None

    try:
        conexao = conectar_mysql()
        cursor = conexao.cursor(dictionary=True)

        cursor.execute("""
            SELECT id_cliente, nome, cpf, telefone, email, endereco
            FROM clientes
            ORDER BY id_cliente DESC
        """)

        clientes = cursor.fetchall()

    except Error:
        erro = "Não foi possível consultar os clientes. Confira a conexão com o MySQL."

    finally:
        if cursor is not None:
            cursor.close()

        if conexao is not None and conexao.is_connected():
            conexao.close()

    return render_template(
        "consulta.html",
        clientes=clientes,
        erro=erro
    )


@app.route("/Perfil")
def formulario():
    return render_template(
        "forms.html",
        mensagem=None,
        erro=None,
        dados={}
    )


@app.route("/enviar", methods=["POST"])
def enviar():
    nome = request.form.get("nome", "").strip()
    email = request.form.get("email", "").strip()
    telefone = request.form.get("telefone", "").strip()
    mensagem = request.form.get("mensagem", "").strip()

    dados = {
        "nome": nome,
        "email": email,
        "telefone": telefone,
        "mensagem": mensagem
    }

    if not nome or not email or not mensagem:
        return render_template(
            "forms.html",
            mensagem=None,
            erro="Preencha nome, e-mail e mensagem.",
            dados=dados
        ), 400

    conexao = None
    cursor = None

    try:
        conexao = conectar_mysql()
        cursor = conexao.cursor()

        cursor.execute("""
            INSERT INTO contatos (nome, email, telefone, mensagem)
            VALUES (%s, %s, %s, %s)
        """, (nome, email, telefone or None, mensagem))

        conexao.commit()

    except IntegrityError:
        if conexao is not None:
            conexao.rollback()

        return render_template(
            "forms.html",
            mensagem=None,
            erro="Não foi possível registrar o contato. Confira os dados.",
            dados=dados
        ), 400

    except Error:
        if conexao is not None:
            conexao.rollback()

        return render_template(
            "forms.html",
            mensagem=None,
            erro="Não foi possível salvar a mensagem no banco de dados.",
            dados=dados
        ), 500

    finally:
        if cursor is not None:
            cursor.close()

        if conexao is not None and conexao.is_connected():
            conexao.close()

    return render_template(
        "forms.html",
        mensagem="Mensagem enviada com sucesso!",
        erro=None,
        dados={}
    )


if __name__ == "__main__":
    app.run(debug=True)