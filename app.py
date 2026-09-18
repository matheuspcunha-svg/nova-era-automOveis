from flask import Flask, render_template

app = Flask(__name__)

@app.route('/')
def formulario():
    return render_template('forms.html')

@app.route('/enviar', methods=['POST'])
def enviar():
    return "Formulario enviado com sucesso"

app.run(debug=True)