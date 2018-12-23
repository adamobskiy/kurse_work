from flask_wtf import FlaskForm
from wtforms import (StringField,
                     PasswordField,
                     DateField,
                     RadioField,
                     SubmitField,
                     BooleanField,
                     validators)


class LoginForm(FlaskForm):
    login = StringField('Логін: ', validators=[
        validators.DataRequired('Введіть Ваш логін')])
    password = PasswordField('Пароль: ', validators=[
        validators.DataRequired('Введіть Ваш пароль')])
    remember_me = BooleanField("Запам'ятай мене")
    submit = SubmitField('Увійти')


class RegistrationForm(FlaskForm):
    login = StringField('Логін:', validators=[
        validators.DataRequired('Введіть Ваш логін'),
        validators.Length(min=5, max=30, message='Допустима кількість символів між 5 та 30')])
    password = PasswordField('Пароль: ', validators=[
        validators.DataRequired('Введіть Ваш пароль'),
        validators.Length(min=5, max=30, message='Допустима кількість символів між 5 та 30')])
    password_repeat = PasswordField('Повторіть пароль: ', validators=[
        validators.DataRequired('Повторіть Ваш пароль'),
        validators.Length(min=5, max=30, message='Допустима кількість символів між 5 та 30')])
    first_name = StringField('Ім\'я: ', validators=[
        validators.DataRequired('Введіть Ваше Ім\'я'),
        validators.Length(min=5, max=30, message='Допустима кількість символів між 5 та 30')])
    last_name = StringField('Прізвище: ', validators=[
        validators.DataRequired('Введіть Ваше Прізвище'),
        validators.Length(min=5, max=30, message='Допустима кількість символів між 5 та 30')])
    birth_day = DateField('Дата народження: ', format='%Y-%m-%d', validators=[
        validators.DataRequired('Введіть Вашу Дату народження')
    ])
    sex = RadioField('Стать: ', choices=[
        ('1', 'Чоловік'),
        ('0', 'Жінка')
    ], default='1')
    doctor = RadioField('Оберіть вашу роль: ', choices=[
        ('0', 'Пацієнт'),
        ('1', 'Доктор')
    ], default='0')
    registration = SubmitField('Зареєструватися')