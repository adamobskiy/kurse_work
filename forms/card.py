from flask_wtf import FlaskForm
from wtforms import (StringField,
                     FieldList,
                     SubmitField,
                     BooleanField,
                     RadioField,
                     validators)


class SelectCardForm(FlaskForm):
    def get_dynamic(self, cards):
        class DynamicForm(FlaskForm):
            card = RadioField('Карта: ',
                              choices=[(str(inx), card_name) for inx, card_name in enumerate(cards)],
                              default='0')
        setattr(DynamicForm, 'submit', SubmitField('Підписатися'))
        return DynamicForm()
