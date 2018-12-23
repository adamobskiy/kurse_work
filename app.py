from datetime import datetime, timedelta

from flask import Flask, render_template, request, session, redirect, url_for, make_response

from forms import LoginForm, RegistrationForm
from db import UserPackage

app = Flask(__name__)
app.secret_key = 'My_key'


@app.route('/')
def index():
    user_login = session.get('login') or request.cookies.get('login')
    print('Session: {}| Cookie: {}'.format(session.get('login'), request.cookies.get('login')))
    if user_login:
        return 'you are login as {} <a href=\'/logout\'>Logout</a>'.format(user_login)
    return redirect(url_for('login'))


@app.route('/login', methods=['GET', 'POST'])
def login():
    form = LoginForm()
    if request.method == 'GET':
        user_login = session.get('login') or request.cookies.get('login')
        if user_login:
            return redirect('/')
        return render_template('login.html', form=form)
    if request.method == 'POST':
        if not form.validate():
            return render_template('login.html', form=form)
        else:
            user = UserPackage()
            login_res = user.login_user(request.form['login'], request.form['password']).values[0, 0]
            if login_res == 1:
                response = make_response(redirect('/'))
                session['login'] = request.form['login']
                if request.form.get('remember_me'):
                    expires = datetime.now() + timedelta(days=60)
                    response.set_cookie('login', request.form['login'], expires=expires)
                session['login'] = request.form['login']
                return response
            elif login_res == 0:
                return render_template('login.html', form=form, problem='Невірний пароль або логін')
            else:
                return render_template('login.html', form=form, problem='А вто тут прям помилка')


@app.route('/logout')
def logout():
    if request.method == 'GET':
        response = make_response(redirect('/login'))
        response.set_cookie('login', '', expires=0)
        session['login'] = None
        return response


@app.route('/registration', methods=['GET', 'POST'])
def registration():
    form = RegistrationForm()

    if request.method == 'POST':
        print('Helooo')
        if not form.validate():
            return render_template('registration.html', form=form)
        else:
            user = UserPackage()
            print(request.form['login'],
                  request.form['first_name'],
                  request.form['last_name'],
                  datetime.strptime(request.form['birth_day'] + ' 00:00:00', '%Y-%m-%d %H:%M:%S'),
                  request.form['sex'],
                  request.form['password'],
                  request.form['doctor'])
            if request.form['password'] == request.form['password_repeat']:
                res = user.add_user(
                    request.form['login'],
                    request.form['first_name'],
                    request.form['last_name'],
                    datetime.strptime(request.form['birth_day'] + ' 00:00:00', '%Y-%m-%d %H:%M:%S'),
                    request.form['sex'],
                    request.form['password'],
                    request.form['doctor']
                )
                print(res)
                if res:
                    return redirect('/')
                else:
                    print(res)
            else:
                return render_template('registration.html', form=form)
    return render_template('registration.html', form=form)


@app.route('/subscription')
def subscription():
    return 'Subscription'


@app.route('/my_page')
def my_page():
    return 'My Page'


@app.route('/my_symptoms')
def my_symptoms():
    return 'My symptoms'


@app.route('/medication_advice')
def medication_advice():
    return 'Medication advice'


@app.route('/possible_illnesses')
def possible_illnesses():
    return 'Possible illnesses'


@app.route('/select/<table_name>')
def select(table_name):
    return table_name.capitalize()


@app.route('/add/<table_name>')
def add(table_name):
    return table_name.capitalize()


@app.route('/update/<table_name>')
def update(table_name):
    return table_name.capitalize()


@app.route('/delete/<table_name>')
def delete(table_name):
    return table_name.capitalize()


if __name__ == '__main__':
    app.run()
