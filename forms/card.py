from flask_wtf import FlaskForm
from wtforms import (StringField,
                     FieldList,
                     SubmitField,
                     BooleanField,
                     RadioField,
                     SelectField,
                     validators)


# class SelectCardForm(FlaskForm):
#     def get_dynamic(self, cards):
#         class DynamicForm(FlaskForm):
#             card = RadioField('Карта: ',
#                               choices=[(str(inx), card_name) for inx, card_name in enumerate(cards)],
#                               default='0')
#         setattr(DynamicForm, 'submit', SubmitField('Підписатися'))
#         return DynamicForm()

class SelectCardForm(FlaskForm):
    def get_dynamic(self, names):
        class DynamicForm(FlaskForm):
            card = SelectField('Карта: ', choices=[(name_field, name_field) for name_field in names])
        setattr(DynamicForm, 'submit', SubmitField('Підписатися'))
        return DynamicForm()
