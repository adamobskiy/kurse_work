from datetime import datetime, timedelta

import numpy as np
import pandas as pd
from flask import Flask, render_template, request, session, redirect, url_for, make_response

from forms.user import LoginForm, RegistrationForm, UpdateUserForm
from forms.symptom import SelectSymptomForm
from forms.card import SelectCardForm
from forms.disease import SelectDiseaseForm
from db import UserPackage, SymptomPackage, MdsPackage, CardPackage


app = Flask(__name__)
app.secret_key = 'My_key'
app.jinja_env.globals.update(zip=zip, type=type, list=list, str=str)

@app.route('/')
def index():
    user_login = session.get('login') or request.cookies.get('login')
    user = UserPackage()
    print('Session: {}| Cookie: {}'.format(session.get('login'), request.cookies.get('login')))
    if user_login:
        return render_template('index.html', user_login=user_login,  user=user)
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
        if not form.validate():
            return render_template('registration.html', form=form)
        else:
            user = UserPackage()
            if request.form['password'] == request.form['password_repeat']:
                user_login, status = user.add_user(
                    request.form['login'],
                    request.form['first_name'],
                    request.form['last_name'],
                    datetime.strptime(request.form['birth_day'] + ' 00:00:00', '%Y-%m-%d %H:%M:%S'),
                    request.form['sex'],
                    request.form['password'],
                    request.form['doctor']
                )
                if status == 'ok':
                    session['login'] = user_login
                    return redirect('/')
                else:
                    problem = 'Користувач з таким іменем уже існує'
                    problem = problem if status == problem else 'Поля можуть містити лиш букви, числа та симовол "_"'
                    return render_template('registration.html', form=form, problem=problem)
            else:
                return render_template('registration.html', form=form, problem='Повторний пароль невірний')
    return render_template('registration.html', form=form)


@app.route('/my_page', methods=['GET', 'POST'])
def my_page():
    user_login = session.get('login') or request.cookies.get('login')
    user = UserPackage()
    table = user.get_user_info(user_login)
    form = UpdateUserForm()
    if request.method == 'POST':
        if not form.validate():
            return render_template('my_page.html', table=table, form=form, user_login=user_login,  user=user)
        status = user.update_user_info(
            user_login,
            request.form['first_name'],
            request.form['last_name'],
            datetime.strptime(request.form['birth_day'] + ' 00:00:00', '%Y-%m-%d %H:%M:%S'),
            request.form['sex'],
            request.form['doctor']
        )
        if status == 'ok':
            table = user.get_user_info(user_login)
        else:
            return render_template('my_page.html', table=table, form=form,
                                   problem='Поля можуть містити лиш букви, числа та симовол "_"',
                                   user_login=user_login, user=user)
    return render_template('my_page.html', table=table, form=form,  user_login=user_login,  user=user)


@app.route('/<next_page>/my_symptoms', methods=['GET', 'POST'])
def my_symptoms(next_page):
    user_login = session.get('login') or request.cookies.get('login')
    user = UserPackage()
    symptom = SymptomPackage()
    table = symptom.get_number_symptoms()
    form = SelectSymptomForm().get_dynamic(table.SYMANME)
    return render_template('my_symptoms.html',  form=form, next_page=next_page, user_login=user_login,  user=user)


@app.route('/medication_advice', methods=['GET', 'POST'])
def medication_advice():
    user_login = session.get('login') or request.cookies.get('login')
    user = UserPackage()
    symptoms = list(filter(lambda x: x not in ('csrf_token', 'submit'), request.form))
    mds = MdsPackage()
    medication = []
    symptom_map = []
    for symptom in symptoms:
        med_from_sym = list(mds.get_medication_list(symptom).TYPE_MDS_MED_NAME)
        medication += med_from_sym
        symptom_map += [symptom for i in range(len(med_from_sym))]
    med_res = pd.DataFrame({'symptom': symptom_map, 'medication': medication})
    return render_template('medication_advice.html', med_res=med_res,  user_login=user_login,  user=user)


@app.route('/subscription', methods=['GET', 'POST'])
def subscription():
    user_login = session.get('login') or request.cookies.get('login')
    user = UserPackage()
    card = CardPackage()
    card_numbers = list(card.get_all_user_card(user_login).CARDNUMBER)
    form = SelectCardForm().get_dynamic(card_numbers) if card_numbers else None
    if request.method == 'POST':
        status = user.update_user_submit(user_login, '1' if request.form['card'] else '0')
        if status == 'ok':
            return redirect('/possible_illnesses/my_symptoms')
    return render_template('subscription.html', user_login=user_login, user=user, form=form)


@app.route('/possible_illnesses', methods=['GET', 'POST'])
def possible_illnesses():
    user_login = session.get('login') or request.cookies.get('login')
    user = UserPackage()
    symptoms = list(filter(lambda x: x not in ('csrf_token', 'submit'), request.form))

    mds = MdsPackage()
    disease = []
    symptom_map = []
    for symptom in symptoms:
        dis_from_sym = list(mds.get_disease_list(symptom).TYPE_MDS_DIS_NAME)
        disease += dis_from_sym
        symptom_map += [symptom for i in range(len(dis_from_sym))]
    dis_res = pd.DataFrame({'symptom': symptom_map, 'disease': disease})

    return render_template('possible_illnesses.html', user_login=user_login, user=user, dis_res=dis_res)


@app.route('/individual/<dis_name>', methods=['GET', 'POST'])
def individual(dis_name):
    user_login = session.get('login') or request.cookies.get('login')
    user = UserPackage()
    mds = MdsPackage()

    medication = mds.get_medication_list_by_dis(dis_name).TYPE_MDS_MED_NAME
    return render_template('individual.html', user_login=user_login, user=user, medication=medication)

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
    app.run(debug=True)
