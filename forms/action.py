from flask_wtf import FlaskForm
from wtforms import (StringField,
                     DateField,
                     RadioField,
                     SubmitField,
                     BooleanField,
                     validators)


class AddForm(FlaskForm):
    name = StringField('Назва:', validators=[
        validators.DataRequired('Введіть назву'),
        validators.Length(min=5, max=30, message='Допустима кількість символів для назви між 5 та 30')])
    desc = StringField('Опис:', validators=[
        validators.DataRequired('Введіть опис')])
    submit = SubmitField('Додати')


class UpdateForm(FlaskForm):
    pass

